package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import service.CommentService;
import service.CommentServiceImpl;
import service.PostService;
import service.PostServiceImpl;
import service.ValidationException;

import java.io.IOException;

@WebServlet("/PostServlet")
public class PostServlet extends HttpServlet {

    private PostService postService;
    private CommentService commentService;

    @Override
    public void init() {
        postService = new PostServiceImpl();
        commentService = new CommentServiceImpl();
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

        try {
            if ("createPost".equals(action)) {
                String content = request.getParameter("content");
                try {
                    postService.createPost(user.getUserID(), content, null);
                } catch (ValidationException e) {
                    request.setAttribute("errorMessage", e.getMessage());
                }
                response.sendRedirect("ProfileServlet");

            } else if ("like".equals(action)) {
                int postId = Integer.parseInt(request.getParameter("postId"));
                postService.toggleLike(postId, user.getUserID());
                response.sendRedirect("ProfileServlet");

            } else if ("comment".equals(action)) {
                int postId = Integer.parseInt(request.getParameter("postId"));
                String content = request.getParameter("content");
                try {
                    commentService.createComment(postId, user.getUserID(), content);
                } catch (ValidationException e) {
                    request.setAttribute("errorMessage", e.getMessage());
                }
                response.sendRedirect("ProfileServlet");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("ProfileServlet");
        }
    }
}
