package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Mindmap;
import model.MindmapNode;
import model.User;
import service.MindmapService;
import service.MindmapServiceImpl;
import service.ValidationException;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet("/MindmapServlet")
public class MindmapServlet extends HttpServlet {

    private MindmapService mindmapService;
    private final Gson gson = new Gson();

    @Override
    public void init() {
        mindmapService = new MindmapServiceImpl();
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

        if ("myMindmaps".equals(action)) {
            List<Mindmap> mindmaps = mindmapService.getUserMindmaps(user.getUserID());
            sendJson(response, mindmaps);

        } else if ("public".equals(action)) {
            List<Mindmap> mindmaps = mindmapService.getPublicMindmaps();
            sendJson(response, mindmaps);

        } else if ("detail".equals(action)) {
            int mindmapId = Integer.parseInt(request.getParameter("mindmapId"));
            Mindmap mindmap = mindmapService.getMindmapById(mindmapId);
            if (mindmap == null) {
                sendJsonError(response, "Mindmap not found");
                return;
            }

            List<MindmapNode> nodes = mindmapService.getNodes(mindmapId);
            Map<String, Object> result = new HashMap<>();
            result.put("mindmap", mindmap);
            result.put("nodes", nodes);
            sendJson(response, result);

        } else {
            List<Mindmap> mindmaps = mindmapService.getUserMindmaps(user.getUserID());
            sendJson(response, mindmaps);
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
            if ("create".equals(action)) {
                String title = request.getParameter("title");
                String description = request.getParameter("description");
                String courseIdStr = request.getParameter("courseId");
                Integer courseId = courseIdStr != null && !courseIdStr.isEmpty() ? Integer.parseInt(courseIdStr) : null;
                boolean isPublic = "true".equals(request.getParameter("isPublic"));

                int mindmapId = mindmapService.createMindmap(user.getUserID(), title, description, courseId, isPublic);
                result.put("success", mindmapId > 0);
                result.put("mindmapId", mindmapId);

            } else if ("update".equals(action)) {
                int mindmapId = Integer.parseInt(request.getParameter("mindmapId"));
                String title = request.getParameter("title");
                String description = request.getParameter("description");
                boolean isPublic = "true".equals(request.getParameter("isPublic"));

                boolean updated = mindmapService.updateMindmap(mindmapId, user.getUserID(), title, description,
                        isPublic);
                result.put("success", updated);

            } else if ("delete".equals(action)) {
                int mindmapId = Integer.parseInt(request.getParameter("mindmapId"));
                boolean deleted = mindmapService.deleteMindmap(mindmapId, user.getUserID());
                result.put("success", deleted);

            } else if ("use".equals(action)) {
                int mindmapId = Integer.parseInt(request.getParameter("mindmapId"));
                boolean used = mindmapService.useMindmap(mindmapId);
                result.put("success", used);

            } else if ("addNode".equals(action)) {
                int mindmapId = Integer.parseInt(request.getParameter("mindmapId"));
                String parentStr = request.getParameter("parentNodeId");
                Integer parentNodeId = parentStr != null && !parentStr.isEmpty() ? Integer.parseInt(parentStr) : null;
                String text = request.getParameter("text");
                String color = request.getParameter("color");
                String icon = request.getParameter("icon");
                double posX = Double
                        .parseDouble(request.getParameter("posX") != null ? request.getParameter("posX") : "0");
                double posY = Double
                        .parseDouble(request.getParameter("posY") != null ? request.getParameter("posY") : "0");
                int order = Integer
                        .parseInt(request.getParameter("order") != null ? request.getParameter("order") : "0");

                int nodeId = mindmapService.addNode(mindmapId, parentNodeId, text, color, icon, posX, posY, order);
                result.put("success", nodeId > 0);
                result.put("nodeId", nodeId);

            } else if ("deleteNode".equals(action)) {
                int nodeId = Integer.parseInt(request.getParameter("nodeId"));
                boolean deleted = mindmapService.deleteNode(nodeId);
                result.put("success", deleted);

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
