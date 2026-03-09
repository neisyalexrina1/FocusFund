package controller;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import dao.AIChatDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.AIChatMessage;
import model.AIChatSession;
import model.User;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.*;

@WebServlet("/api/ai")
public class GeminiAIServlet extends HttpServlet {

    private static final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent";

    private String apiKey;
    private final HttpClient httpClient = HttpClient.newHttpClient();
    private final Gson gson = new Gson();
    private AIChatDAO chatDAO;

    @Override
    public void init() {
        // Read directly from Environment Variable (Render configuration)
        apiKey = System.getenv("GEMINI_API_KEY");
        chatDAO = new AIChatDAO();
    }

    // ======================== GET — Chat History ========================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendError(response, "Not logged in");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        PrintWriter out = response.getWriter();

        try {
            if ("listSessions".equals(action)) {
                List<AIChatSession> sessions = chatDAO.getSessionsByUser(user.getUserID());
                out.print(gson.toJson(sessions));

            } else if ("loadSession".equals(action)) {
                int sessionId = Integer.parseInt(request.getParameter("sessionId"));
                AIChatSession chatSession = chatDAO.getSessionById(sessionId);
                if (chatSession == null || chatSession.getUserID() != user.getUserID()) {
                    sendError(response, "Session not found");
                    return;
                }
                List<AIChatMessage> messages = chatDAO.getMessagesBySession(sessionId);
                Map<String, Object> result = new HashMap<>();
                result.put("session", chatSession);
                result.put("messages", messages);
                out.print(gson.toJson(result));

            } else {
                sendError(response, "Unknown action");
            }
        } catch (NumberFormatException e) {
            sendError(response, "Invalid data");
        }
        out.flush();
    }

    // ======================== POST — Chat + Session Management
    // ========================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendError(response, "Not logged in");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            JsonObject requestBody = gson.fromJson(request.getReader(), JsonObject.class);
            String action = requestBody.has("action") ? requestBody.get("action").getAsString() : "chat";

            if ("newSession".equals(action)) {
                int sessionId = chatDAO.createSession(user.getUserID());
                Map<String, Object> result = new HashMap<>();
                result.put("success", sessionId > 0);
                result.put("sessionId", sessionId);
                out.print(gson.toJson(result));

            } else if ("deleteSession".equals(action)) {
                int sessionId = requestBody.get("sessionId").getAsInt();
                boolean deleted = chatDAO.deleteSession(sessionId, user.getUserID());
                Map<String, Object> result = new HashMap<>();
                result.put("success", deleted);
                out.print(gson.toJson(result));

            } else {
                // Default: AI chat message
                handleChatMessage(requestBody, user, out);
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"Server error: " + e.getMessage() + "\"}");
        }
        out.flush();
    }

    private void handleChatMessage(JsonObject requestBody, User user, PrintWriter out) {
        try {
            String promptText = requestBody.has("prompt") ? requestBody.get("prompt").getAsString() : "";
            if (promptText.isEmpty()) {
                out.print("{\"error\": \"Prompt is required\"}");
                return;
            }

            // Session management
            int sessionId = requestBody.has("sessionId") ? requestBody.get("sessionId").getAsInt() : -1;
            if (sessionId <= 0) {
                sessionId = chatDAO.createSession(user.getUserID());
            }

            // Save user message
            String mode = requestBody.has("mode") ? requestBody.get("mode").getAsString() : "normal";
            chatDAO.saveMessage(sessionId, "user", promptText, mode);

            // Build Gemini request with conversation history (multi-turn)
            JsonObject geminiRequest = new JsonObject();
            JsonArray contents = new JsonArray();

            // Load previous messages for context (up to 10)
            List<AIChatMessage> history = chatDAO.getMessagesBySession(sessionId);
            int startIdx = Math.max(0, history.size() - 11); // Last 10 + current
            for (int i = startIdx; i < history.size(); i++) {
                AIChatMessage msg = history.get(i);
                JsonObject msgContent = new JsonObject();
                msgContent.addProperty("role", "user".equals(msg.getRole()) ? "user" : "model");
                JsonArray msgParts = new JsonArray();
                JsonObject textPart = new JsonObject();
                textPart.addProperty("text", msg.getContent());
                msgParts.add(textPart);
                msgContent.add("parts", msgParts);
                contents.add(msgContent);
            }

            // Inject persona on the current user message (last one)
            String personaInstruction = "\n\nCRITICAL INSTRUCTION FOR YOUR PERSONA: You are a super fun, brilliant, and slightly mischievous AI Study Assistant. You talk like a friendly, energetic expert, using enthusiastic language, occasional emojis, and a conversational, witty tone. You are very supportive and encouraging. Your goal is to make studying feel like chatting with a super smart, fun friend rather than a boring textbook. Never be robotic. Always show personality and express emotions! Answer the user's prompt naturally in their language, keeping this persona.";

            // Format instruction
            if (requestBody.has("format") && "html".equals(requestBody.get("format").getAsString())) {
                personaInstruction += "\n\nCRITICAL INSTRUCTION: Your response MUST be valid HTML formatted text only. Do NOT wrap the HTML in markdown blocks like ```html. Output raw HTML tags, such as <h2>, <p>, <ul>, <li> directly.";
            }

            // If no history, add a system-like first user message with persona
            if (contents.isEmpty()) {
                JsonObject firstContent = new JsonObject();
                firstContent.addProperty("role", "user");
                JsonArray firstParts = new JsonArray();
                JsonObject firstText = new JsonObject();
                firstText.addProperty("text", promptText + personaInstruction);
                firstParts.add(firstText);
                firstContent.add("parts", firstParts);
                contents.add(firstContent);
            } else {
                // Append persona to the last user message
                JsonObject lastMsg = contents.get(contents.size() - 1).getAsJsonObject();
                if ("user".equals(lastMsg.get("role").getAsString())) {
                    JsonArray parts = lastMsg.getAsJsonArray("parts");
                    String existingText = parts.get(0).getAsJsonObject().get("text").getAsString();
                    parts.get(0).getAsJsonObject().addProperty("text", existingText + personaInstruction);
                }
            }

            // Handle special modes
            if (requestBody.has("mode")) {
                String modeStr = requestBody.get("mode").getAsString();
                if ("thinking".equals(modeStr)) {
                    appendToLastUserMsg(contents,
                            "\n\nCRITICAL INSTRUCTION: Please think deeply, analyze the request step-by-step, and provide a comprehensive, well-reasoned response.");
                } else if ("research".equals(modeStr)) {
                    JsonArray tools = new JsonArray();
                    JsonObject tool = new JsonObject();
                    tool.add("google_search", new JsonObject());
                    tools.add(tool);
                    geminiRequest.add("tools", tools);
                    appendToLastUserMsg(contents,
                            "\n\nCRITICAL INSTRUCTION: Use Google Search to find the most up-to-date and accurate information to answer the user's request. Provide references if possible.");
                } else if ("image".equals(modeStr)) {
                    appendToLastUserMsg(contents, "\n\nCRITICAL INSTRUCTION: The user wants to generate an image. " +
                            "1) Create a highly detailed, descriptive English prompt for an AI image generator based on their request. "
                            +
                            "2) URL-encode THIS English prompt (replace spaces with %20). " +
                            "3) Reply with a friendly greeting in the SAME LANGUAGE as the user's request. " +
                            "4) Explain that as an AI Language Model, you cannot embed images directly, but you have prepared a magic link for them. "
                            +
                            "5) Directly below it, output exactly this HTML anchor tag replacing {URL_ENCODED_PROMPT} with your prompt: "
                            +
                            "<br><br><a href=\"https://pollinations.ai/p/{URL_ENCODED_PROMPT}\" target=\"_blank\" style=\"display: inline-block; padding: 10px 20px; background-color: var(--color-primary); color: white; text-decoration: none; border-radius: 8px; font-weight: bold;\">🪄 Generate & View Image Here</a>");
                }
            }

            // Handle attachments
            if (requestBody.has("attachments")) {
                JsonObject lastUserMsg = null;
                for (int i = contents.size() - 1; i >= 0; i--) {
                    if ("user".equals(contents.get(i).getAsJsonObject().get("role").getAsString())) {
                        lastUserMsg = contents.get(i).getAsJsonObject();
                        break;
                    }
                }
                if (lastUserMsg != null) {
                    JsonArray parts = lastUserMsg.getAsJsonArray("parts");
                    JsonArray attachments = requestBody.getAsJsonArray("attachments");
                    for (int i = 0; i < attachments.size(); i++) {
                        JsonObject attachment = attachments.get(i).getAsJsonObject();
                        String mimeType = attachment.has("mimeType") ? attachment.get("mimeType").getAsString() : "";
                        String base64Data = attachment.has("data") ? attachment.get("data").getAsString() : "";
                        if (!mimeType.isEmpty() && !base64Data.isEmpty()) {
                            JsonObject inlineDataObj = new JsonObject();
                            JsonObject inlineData = new JsonObject();
                            inlineData.addProperty("mime_type", mimeType);
                            inlineData.addProperty("data", base64Data);
                            inlineDataObj.add("inline_data", inlineData);
                            parts.add(inlineDataObj);
                        }
                    }
                }
            }

            geminiRequest.add("contents", contents);

            // Call Gemini API
            HttpRequest geminiHttpRequest = HttpRequest.newBuilder()
                    .uri(URI.create(GEMINI_API_URL + "?key=" + apiKey))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(gson.toJson(geminiRequest)))
                    .build();

            HttpResponse<String> geminiResponse = httpClient.send(geminiHttpRequest,
                    HttpResponse.BodyHandlers.ofString());

            if (geminiResponse.statusCode() == 200) {
                JsonObject responseObj = gson.fromJson(geminiResponse.body(), JsonObject.class);
                JsonArray candidates = responseObj.getAsJsonArray("candidates");

                if (candidates != null && candidates.size() > 0) {
                    JsonObject firstCandidate = candidates.get(0).getAsJsonObject();
                    JsonObject contentObj = firstCandidate.getAsJsonObject("content");
                    JsonArray partsArray = contentObj.getAsJsonArray("parts");

                    if (partsArray != null && partsArray.size() > 0) {
                        String generatedText = partsArray.get(0).getAsJsonObject().get("text").getAsString();

                        // Cleanup markdown blocks
                        String textTrimmed = generatedText.trim();
                        if (textTrimmed.startsWith("```html")) {
                            textTrimmed = textTrimmed.substring(7);
                        } else if (textTrimmed.startsWith("```markdown")) {
                            textTrimmed = textTrimmed.substring(11);
                        } else if (textTrimmed.startsWith("```")) {
                            textTrimmed = textTrimmed.substring(3);
                        }
                        if (textTrimmed.endsWith("```")) {
                            textTrimmed = textTrimmed.substring(0, textTrimmed.length() - 3);
                        }
                        textTrimmed = textTrimmed.trim();
                        textTrimmed = textTrimmed.replaceAll("\\*\\*(.*?)\\*\\*", "<strong>$1</strong>");
                        textTrimmed = textTrimmed.replaceAll("\\*(.*?)\\*", "<em>$1</em>");
                        textTrimmed = textTrimmed.replace("\n", "<br>");

                        // Save AI response to DB
                        chatDAO.saveMessage(sessionId, "assistant", textTrimmed, mode);

                        // Auto-title: if session title is still "New Chat", generate from first message
                        AIChatSession chatSession = chatDAO.getSessionById(sessionId);
                        if (chatSession != null && "New Chat".equals(chatSession.getTitle())) {
                            String autoTitle = promptText.length() > 50 ? promptText.substring(0, 47) + "..."
                                    : promptText;
                            chatDAO.updateSessionTitle(sessionId, autoTitle);
                        }

                        JsonObject result = new JsonObject();
                        result.addProperty("content", textTrimmed);
                        result.addProperty("sessionId", sessionId);
                        out.print(gson.toJson(result));
                        return;
                    }
                }
                out.print("{\"error\": \"No text generated by Gemini\"}");
            } else if (geminiResponse.statusCode() == 429 || geminiResponse.statusCode() == 503
                    || geminiResponse.statusCode() == 400) {
                JsonObject errorResponse = new JsonObject();
                errorResponse.addProperty("error", "RATE_LIMIT_EXCEEDED");
                errorResponse.addProperty("sessionId", sessionId);
                out.print(gson.toJson(errorResponse));
            } else {
                System.err.println("Gemini API error (" + geminiResponse.statusCode() + "): " + geminiResponse.body());
                JsonObject errorResponse = new JsonObject();
                errorResponse.addProperty("error",
                        "AI service error (" + geminiResponse.statusCode() + "): " + geminiResponse.body());
                out.print(gson.toJson(errorResponse));
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"An unexpected error occurred. Please try again.\"}");
        }
    }

    private void appendToLastUserMsg(JsonArray contents, String text) {
        for (int i = contents.size() - 1; i >= 0; i--) {
            JsonObject msg = contents.get(i).getAsJsonObject();
            if ("user".equals(msg.get("role").getAsString())) {
                JsonArray parts = msg.getAsJsonArray("parts");
                String existing = parts.get(0).getAsJsonObject().get("text").getAsString();
                parts.get(0).getAsJsonObject().addProperty("text", existing + text);
                return;
            }
        }
    }

    private void sendError(HttpServletResponse response, String message) throws IOException {
        PrintWriter out = response.getWriter();
        JsonObject error = new JsonObject();
        error.addProperty("error", message);
        out.print(gson.toJson(error));
        out.flush();
    }
}
