package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Notification;
import model.User;
import service.NotificationServiceImpl;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet("/NotificationServlet")
public class NotificationServlet extends HttpServlet {

    private NotificationServiceImpl notificationService;
    private final Gson gson = new Gson();

    @Override
    public void init() {
        notificationService = new NotificationServiceImpl();
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

        if ("bell".equals(action)) {
            // For navbar bell dropdown — top 5 + unread count
            Map<String, Object> result = new HashMap<>();
            result.put("notifications", notificationService.getRecentForBell(user.getUserID()));
            result.put("unreadCount", notificationService.getUnreadCount(user.getUserID()));
            sendJson(response, result);

        } else if ("all".equals(action) || action == null) {
            // For notifications.jsp full page
            Map<String, Object> result = new HashMap<>();
            result.put("notifications", notificationService.getAllNotifications(user.getUserID()));
            result.put("unreadCount", notificationService.getUnreadCount(user.getUserID()));
            sendJson(response, result);

        } else if ("count".equals(action)) {
            // Just the unread count (for polling badge number)
            Map<String, Object> result = new HashMap<>();
            result.put("unreadCount", notificationService.getUnreadCount(user.getUserID()));
            sendJson(response, result);
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
            if ("markAllRead".equals(action)) {
                notificationService.markAllRead(user.getUserID());
                result.put("success", true);

            } else if ("markRead".equals(action)) {
                int notifId = Integer.parseInt(request.getParameter("notificationId"));
                notificationService.markRead(notifId);
                result.put("success", true);

            } else {
                result.put("success", false);
                result.put("error", "Unknown action");
            }
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
