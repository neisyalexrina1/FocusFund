package service;

import model.Course;

import java.util.List;
import java.util.Map;

public interface CourseService {
    List<Course> getAllCourses();

    Course getCourseById(int courseId);

    List<Course> getUserCourses(int userId);

    List<Course> getPublicCourses();

    int createCourse(int userId, String courseName, String icon, String description,
            String detailDescription, String duration);

    boolean updateCourse(int courseId, int userId, String courseName, String icon, String description,
            String detailDescription, String duration, boolean isPublic);

    boolean deleteCourse(int courseId, int userId);

    Map<String, Object> getCourseWithMindmaps(int courseId);

    boolean adoptCourse(int courseId);
}
