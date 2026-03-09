package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import service.UserService;
import service.UserServiceImpl;
import service.ValidationException;

import java.io.IOException;

@WebServlet("/AccountServlet")
public class AccountServlet extends HttpServlet {

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
        String tab = request.getParameter("tab");
        if (tab != null) {
            request.setAttribute("activeTab", tab);
        }
        request.getRequestDispatcher("account.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("AuthServlet");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("changePassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmNewPassword");

            // Verify current password
            User verified = userService.login(user.getUsername(), currentPassword);
            if (verified == null) {
                request.setAttribute("errorMessage", "Current password is incorrect");
                request.setAttribute("activeTab", "security");
                request.getRequestDispatcher("account.jsp").forward(request, response);
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "New passwords do not match");
                request.setAttribute("activeTab", "security");
                request.getRequestDispatcher("account.jsp").forward(request, response);
                return;
            }

            try {
                userService.updatePassword(user.getUserID(), newPassword);
                request.setAttribute("successMessage", "Password updated successfully!");
                request.setAttribute("activeTab", "security");
            } catch (ValidationException e) {
                request.setAttribute("errorMessage", e.getMessage());
                request.setAttribute("activeTab", "security");
            }
            request.getRequestDispatcher("account.jsp").forward(request, response);

        } else if ("updateProfile".equals(action)) {
            String fullName = request.getParameter("fullName");
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String bio = request.getParameter("bio");
            String location = request.getParameter("location");
            String website = request.getParameter("website");
            String websiteName = request.getParameter("websiteName");

            boolean updated = userService.updateProfile(user.getUserID(), fullName, username, email,
                    bio, location, website, websiteName);
            if (updated) {
                User freshUser = userService.getUserById(user.getUserID());
                session.setAttribute("user", freshUser);
                request.setAttribute("successMessage", "Profile updated successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to update profile");
            }
            request.setAttribute("activeTab", "profile");
            request.getRequestDispatcher("account.jsp").forward(request, response);

        } else if ("deactivate".equals(action)) {
            userService.deleteUser(user.getUserID());
            session.invalidate();
            response.sendRedirect("index.jsp");

        } else {
            response.sendRedirect("AccountServlet");
        }
    }
}
