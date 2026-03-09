package service;

import dao.CourseDAO;
import dao.MindmapDAO;
import model.Course;

import java.util.*;

public class CourseServiceImpl implements CourseService {

    private final CourseDAO courseDAO = new CourseDAO();
    private final MindmapDAO mindmapDAO = new MindmapDAO();

    @Override
    public List<Course> getAllCourses() {
        return courseDAO.getAllCourses();
    }

    @Override
    public Course getCourseById(int courseId) {
        return courseDAO.getCourseById(courseId);
    }

    @Override
    public List<Course> getUserCourses(int userId) {
        return courseDAO.getUserCourses(userId);
    }

    @Override
    public List<Course> getPublicCourses() {
        return courseDAO.getPublicCourses();
    }

    @Override
    public int createCourse(int userId, String courseName, String icon, String description,
            String detailDescription, String duration) {
        if (courseName == null || courseName.trim().isEmpty()) {
            throw new ValidationException("Course name is required");
        }
        return courseDAO.createCourse(userId, courseName.trim(), icon, description, detailDescription, duration);
    }

    @Override
    public boolean updateCourse(int courseId, int userId, String courseName, String icon,
            String description, String detailDescription, String duration, boolean isPublic) {
        // Ownership check
        Course course = courseDAO.getCourseById(courseId);
        if (course == null) {
            throw new ValidationException("Course not found");
        }
        if (course.getCreatedBy() == null || course.getCreatedBy() != userId) {
            throw new ValidationException("You don't have permission to edit this course");
        }
        if (courseName == null || courseName.trim().isEmpty()) {
            throw new ValidationException("Course name is required");
        }
        return courseDAO.updateCourse(courseId, courseName.trim(), icon, description, detailDescription, duration,
                isPublic);
    }

    @Override
    public boolean deleteCourse(int courseId, int userId) {
        // Ownership check
        Course course = courseDAO.getCourseById(courseId);
        if (course == null) {
            throw new ValidationException("Course not found");
        }
        if (course.getCreatedBy() == null || course.getCreatedBy() != userId) {
            throw new ValidationException("You don't have permission to delete this course");
        }
        return courseDAO.deleteCourse(courseId);
    }

    @Override
    public Map<String, Object> getCourseWithMindmaps(int courseId) {
        Map<String, Object> result = new HashMap<>();
        Course course = courseDAO.getCourseById(courseId);
        if (course == null) {
            throw new ValidationException("Course not found");
        }
        result.put("course", course);
        result.put("mindmaps", mindmapDAO.getMindmapsByCourse(courseId));
        return result;
    }

    @Override
    public boolean adoptCourse(int courseId) {
        return courseDAO.incrementLearnerCount(courseId);
    }
}
