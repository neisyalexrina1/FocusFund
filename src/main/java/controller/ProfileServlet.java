package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.Part;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Post;
import model.User;
import service.PostService;
import service.PostServiceImpl;
import service.UserService;
import service.UserServiceImpl;
import service.ValidationException;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet("/ProfileServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 5 * 1024 * 1024, // 5 MB
        maxRequestSize = 10 * 1024 * 1024 // 10 MB
)
public class ProfileServlet extends HttpServlet {

    private UserService userService;
    private PostService postService;

    @Override
    public void init() {
        userService = new UserServiceImpl();
        postService = new PostServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("AuthServlet");
            return;
        }

        User loggedInUser = (User) session.getAttribute("user");
        String userIdParam = request.getParameter("userId");

        User profileUser;
        boolean isOwnProfile;

        try {
            if (userIdParam != null && !userIdParam.isEmpty()) {
                // Viewing another user's profile
                int targetUserId = Integer.parseInt(userIdParam);
                profileUser = userService.getUserById(targetUserId);
                if (profileUser == null) {
                    response.sendRedirect("ProfileServlet");
                    return;
                }
                isOwnProfile = (targetUserId == loggedInUser.getUserID());
                // Refresh session user data
                User freshLoggedIn = userService.getUserById(loggedInUser.getUserID());
                if (freshLoggedIn != null)
                    session.setAttribute("user", freshLoggedIn);
            } else {
                // Viewing own profile
                profileUser = userService.getUserById(loggedInUser.getUserID());
                if (profileUser != null) {
                    session.setAttribute("user", profileUser);
                } else {
                    profileUser = loggedInUser;
                }
                isOwnProfile = true;
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("ProfileServlet");
            return;
        }

        List<Post> posts = postService.getPostsByUser(profileUser.getUserID());
        for (Post post : posts) {
            post.setAuthor(profileUser);
        }

        request.setAttribute("profileUser", profileUser);
        request.setAttribute("posts", posts);
        request.setAttribute("isOwnProfile", isOwnProfile);
        request.getRequestDispatcher("profile.jsp").forward(request, response);
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

        if ("updateProfile".equals(action)) {
            String fullName = request.getParameter("fullName");
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String bio = request.getParameter("bio");
            String location = request.getParameter("location");
            String website = request.getParameter("website");
            String websiteName = request.getParameter("websiteName");

            try {
                boolean updated = userService.updateProfile(user.getUserID(), fullName, username, email,
                        bio, location, website, websiteName);
                if (updated) {
                    User freshUser = userService.getUserById(user.getUserID());
                    session.setAttribute("user", freshUser);
                    request.setAttribute("successMessage", "Profile updated successfully!");
                }
            } catch (ValidationException e) {
                request.setAttribute("errorMessage", e.getMessage());
            }
        } else if ("uploadImage".equals(action)) {
            try {
                Part filePart = request.getPart("imageFile");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = getSubmittedFileName(filePart);
                    String ext = fileName.substring(fileName.lastIndexOf('.')).toLowerCase();

                    // Validate file extension
                    if (!ext.equals(".jpg") && !ext.equals(".jpeg") && !ext.equals(".png")
                            && !ext.equals(".gif") && !ext.equals(".webp")) {
                        request.setAttribute("errorMessage", "Only JPG, PNG, GIF, WEBP images allowed");
                        response.sendRedirect("AccountServlet?tab=profile");
                        return;
                    }

                    // Generate unique filename
                    String uniqueName = UUID.randomUUID().toString() + ext;
                    String uploadDir = getServletContext().getRealPath("/uploads");
                    File dir = new File(uploadDir);
                    if (!dir.exists())
                        dir.mkdirs();

                    filePart.write(uploadDir + File.separator + uniqueName);
                    String imageUrl = "uploads/" + uniqueName;

                    boolean updated = userService.updateProfileImage(user.getUserID(), imageUrl);

                    if (updated) {
                        User freshUser = userService.getUserById(user.getUserID());
                        session.setAttribute("user", freshUser);
                    }
                }
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Upload failed: " + e.getMessage());
            }
        }

        response.sendRedirect("ProfileServlet");
    }

    private String getSubmittedFileName(Part part) {
        String header = part.getHeader("content-disposition");
        for (String token : header.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "unknown.jpg";
    }
}
