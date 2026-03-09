package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Flashcard;
import model.FlashcardDeck;
import model.User;
import service.FlashcardService;
import service.FlashcardServiceImpl;
import service.ValidationException;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet("/FlashcardServlet")
public class FlashcardServlet extends HttpServlet {

    private FlashcardService flashcardService;
    private final Gson gson = new Gson();

    @Override
    public void init() {
        flashcardService = new FlashcardServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendJsonError(response, "Not logged in");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        try {
            if ("myDecks".equals(action)) {
                List<FlashcardDeck> decks = flashcardService.getUserDecks(user.getUserID());
                sendJson(response, decks);

            } else if ("publicDecks".equals(action)) {
                List<FlashcardDeck> decks = flashcardService.getPublicDecks();
                sendJson(response, decks);

            } else if ("cards".equals(action)) {
                int deckId = Integer.parseInt(request.getParameter("deckId"));
                List<Flashcard> cards = flashcardService.getCardsByDeck(deckId);
                sendJson(response, cards);

            } else if ("review".equals(action)) {
                int deckId = Integer.parseInt(request.getParameter("deckId"));
                List<Flashcard> cards = flashcardService.getCardsForReview(user.getUserID(), deckId);
                sendJson(response, cards);

            } else {
                List<FlashcardDeck> decks = flashcardService.getUserDecks(user.getUserID());
                sendJson(response, decks);
            }
        } catch (NumberFormatException e) {
            sendJsonError(response, "Invalid data");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendJsonError(response, "Not logged in");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        Map<String, Object> result = new HashMap<>();

        try {
            if ("createDeck".equals(action)) {
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                String courseIdStr = request.getParameter("courseId");
                Integer courseId = courseIdStr != null && !courseIdStr.isEmpty() ? Integer.parseInt(courseIdStr) : null;
                boolean isPublic = "true".equals(request.getParameter("isPublic"));

                int deckId = flashcardService.createDeck(user.getUserID(), name, description, courseId, isPublic);
                result.put("success", deckId > 0);
                result.put("deckId", deckId);

            } else if ("deleteDeck".equals(action)) {
                int deckId = Integer.parseInt(request.getParameter("deckId"));
                boolean deleted = flashcardService.deleteDeck(deckId, user.getUserID());
                result.put("success", deleted);

            } else if ("addCard".equals(action)) {
                int deckId = Integer.parseInt(request.getParameter("deckId"));
                String front = request.getParameter("front");
                String back = request.getParameter("back");
                String orderStr = request.getParameter("order");
                int order = orderStr != null ? Integer.parseInt(orderStr) : 0;

                boolean added = flashcardService.addCard(deckId, front, back, order);
                result.put("success", added);

            } else if ("deleteCard".equals(action)) {
                int cardId = Integer.parseInt(request.getParameter("cardId"));
                boolean deleted = flashcardService.deleteCard(cardId, user.getUserID());
                result.put("success", deleted);

            } else if ("recordReview".equals(action)) {
                int cardId = Integer.parseInt(request.getParameter("cardId"));
                int difficulty = Integer.parseInt(request.getParameter("difficulty"));
                boolean recorded = flashcardService.recordReview(user.getUserID(), cardId, difficulty);
                result.put("success", recorded);

            } else {
                result.put("success", false);
                result.put("error", "Unknown action");
            }
        } catch (ValidationException e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("error", "Invalid data");
        }

        sendJson(response, result);
    }

    private void sendJson(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(data));
        out.flush();
    }

    private void sendJsonError(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("error", message);
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(error));
        out.flush();
    }
}
