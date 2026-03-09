package controller;

import com.google.gson.Gson;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import service.UserService;
import service.UserServiceImpl;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() {
        userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("AuthServlet");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect("DashboardServlet");
            return;
        }

        // Load admin dashboard data
        List<User> allUsers = userService.getAllUsers();
        request.setAttribute("allUsers", allUsers);
        request.setAttribute("totalUsers", allUsers.size());

        long activeCount = allUsers.stream().filter(u -> !"deactivated".equalsIgnoreCase(u.getRole())).count();
        request.setAttribute("activeUsers", activeCount);

        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendJsonError(response, "Not authenticated");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            sendJsonError(response, "Access denied");
            return;
        }

        String action = request.getParameter("action");
        Map<String, Object> result = new HashMap<>();
        Gson gson = new Gson();

        if ("deleteUser".equals(action)) {
            int targetUserId = Integer.parseInt(request.getParameter("userId"));
            if (targetUserId == user.getUserID()) {
                result.put("success", false);
                result.put("message", "Cannot delete yourself");
            } else {
                boolean deleted = userService.deleteUser(targetUserId);
                result.put("success", deleted);
                result.put("message", deleted ? "User deleted" : "Failed to delete");
            }
        } else if ("changeRole".equals(action)) {
            int targetUserId = Integer.parseInt(request.getParameter("userId"));
            String newRole = request.getParameter("role");
            if (targetUserId == user.getUserID()) {
                result.put("success", false);
                result.put("message", "Cannot change your own role");
            } else {
                UserDAO userDAO = new UserDAO();
                boolean updated = userDAO.updateRole(targetUserId, newRole);
                result.put("success", updated);
                result.put("message", updated ? "Role updated" : "Failed to update role");
            }
        } else {
            result.put("success", false);
            result.put("message", "Unknown action");
        }

        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(gson.toJson(result));
    }

    private void sendJsonError(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        response.getWriter().write("{\"success\":false,\"message\":\"" + message + "\"}");
    }
}
