package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Course;
import model.User;
import service.CourseService;
import service.CourseServiceImpl;
import service.ValidationException;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet("/CourseServlet")
public class CourseServlet extends HttpServlet {

    private CourseService courseService;
    private final Gson gson = new Gson();

    @Override
    public void init() {
        courseService = new CourseServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        // API calls (AJAX) — return JSON
        if (action != null) {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                sendJsonError(response, "Not logged in");
                return;
            }
            User user = (User) session.getAttribute("user");

            if ("myCourses".equals(action)) {
                List<Course> courses = courseService.getUserCourses(user.getUserID());
                sendJson(response, courses);
            } else if ("public".equals(action)) {
                List<Course> courses = courseService.getPublicCourses();
                sendJson(response, courses);
            } else if ("detail".equals(action)) {
                int courseId = Integer.parseInt(request.getParameter("id"));
                Map<String, Object> result = courseService.getCourseWithMindmaps(courseId);
                sendJson(response, result);
            } else if ("all".equals(action)) {
                List<Course> courses = courseService.getAllCourses();
                sendJson(response, courses);
            } else {
                sendJsonError(response, "Unknown action");
            }
            return;
        }

        // Browser navigation — forward to JSP
        String id = request.getParameter("id");
        if (id != null) {
            // Course detail page
            int courseId = Integer.parseInt(id);
            Course course = courseService.getCourseById(courseId);
            request.setAttribute("course", course);
            request.getRequestDispatcher("course_detail.jsp").forward(request, response);
        } else {
            // Course list page
            List<Course> courses = courseService.getAllCourses();
            request.setAttribute("courses", courses);
            request.getRequestDispatcher("courses.jsp").forward(request, response);
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
                String courseName = request.getParameter("courseName");
                String icon = request.getParameter("icon");
                String description = request.getParameter("description");
                String detailDescription = request.getParameter("detailDescription");
                String duration = request.getParameter("duration");

                int courseId = courseService.createCourse(
                        user.getUserID(), courseName, icon, description, detailDescription, duration);
                result.put("success", courseId > 0);
                result.put("courseId", courseId);
                result.put("message", "Course created!");

            } else if ("update".equals(action)) {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                String courseName = request.getParameter("courseName");
                String icon = request.getParameter("icon");
                String description = request.getParameter("description");
                String detailDescription = request.getParameter("detailDescription");
                String duration = request.getParameter("duration");
                boolean isPublic = !"false".equals(request.getParameter("isPublic"));

                boolean updated = courseService.updateCourse(
                        courseId, user.getUserID(), courseName, icon, description, detailDescription, duration,
                        isPublic);
                result.put("success", updated);
                result.put("message", updated ? "Course updated!" : "Update failed");

            } else if ("delete".equals(action)) {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                boolean deleted = courseService.deleteCourse(courseId, user.getUserID());
                result.put("success", deleted);
                result.put("message", deleted ? "Course deleted!" : "Delete failed");

            } else if ("adopt".equals(action)) {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                boolean adopted = courseService.adoptCourse(courseId);
                result.put("success", adopted);
                result.put("message", "Course adopted!");

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
