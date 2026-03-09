package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.util.ArrayList;
import java.util.List;
import model.Course;

public class CourseDAO extends BaseDAO {

    public List<Course> getAllCourses() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT c FROM Course c ORDER BY c.courseID", Course.class).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public Course getCourseById(int courseId) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Course.class, courseId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    /**
     * Get courses created by a specific user
     */
    public List<Course> getUserCourses(int userId) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT c FROM Course c WHERE c.createdBy = :userId ORDER BY c.createdDate DESC",
                    Course.class)
                    .setParameter("userId", userId)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    /**
     * Get all public courses (for community browsing)
     */
    public List<Course> getPublicCourses() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT c FROM Course c WHERE c.isPublic = true ORDER BY c.learnerCount DESC, c.createdDate DESC",
                    Course.class)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    /**
     * Create a new user-owned course
     */
    public int createCourse(int userId, String courseName, String icon, String description,
            String detailDescription, String duration) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Course c = new Course();
            c.setCreatedBy(userId);
            c.setCourseName(courseName);
            c.setIcon(icon);
            c.setDescription(description);
            c.setDetailDescription(detailDescription);
            c.setDuration(duration);
            c.setIsPublic(true);
            em.persist(c);
            tx.commit();
            return c.getCourseID();
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return -1;
        } finally {
            em.close();
        }
    }

    /**
     * Update an existing course
     */
    public boolean updateCourse(int courseId, String courseName, String icon, String description,
            String detailDescription, String duration, boolean isPublic) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Course c = em.find(Course.class, courseId);
            if (c == null)
                return false;
            c.setCourseName(courseName);
            if (icon != null)
                c.setIcon(icon);
            c.setDescription(description);
            c.setDetailDescription(detailDescription);
            if (duration != null)
                c.setDuration(duration);
            c.setIsPublic(isPublic);
            em.merge(c);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    /**
     * Delete a course (mindmaps FK will cascade or set null depending on DB)
     */
    public boolean deleteCourse(int courseId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Course c = em.find(Course.class, courseId);
            if (c == null)
                return false;
            em.remove(c);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    /**
     * Increment learner count when someone adopts a course
     */
    public boolean incrementLearnerCount(int courseId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Course c = em.find(Course.class, courseId);
            if (c == null)
                return false;
            c.setLearnerCount(c.getLearnerCount() + 1);
            em.merge(c);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }
}
