package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import model.UserCourseProgress;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class CourseProgressDAO extends BaseDAO {

    public UserCourseProgress enroll(int userId, int courseId, int totalLessons) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            // Check if already enrolled
            List<UserCourseProgress> existing = em.createQuery(
                    "SELECT p FROM UserCourseProgress p WHERE p.userID = :uid AND p.courseID = :cid",
                    UserCourseProgress.class)
                    .setParameter("uid", userId)
                    .setParameter("cid", courseId)
                    .getResultList();

            if (!existing.isEmpty()) {
                tx.commit();
                return existing.get(0); // Already enrolled
            }

            UserCourseProgress progress = new UserCourseProgress();
            progress.setUserID(userId);
            progress.setCourseID(courseId);
            progress.setTotalLessons(totalLessons > 0 ? totalLessons : 1);
            em.persist(progress);
            tx.commit();
            return progress;
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public boolean updateProgress(int userId, int courseId, int completedLessons) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            List<UserCourseProgress> results = em.createQuery(
                    "SELECT p FROM UserCourseProgress p WHERE p.userID = :uid AND p.courseID = :cid",
                    UserCourseProgress.class)
                    .setParameter("uid", userId)
                    .setParameter("cid", courseId)
                    .getResultList();

            if (results.isEmpty())
                return false;

            UserCourseProgress progress = results.get(0);
            progress.setCompletedLessons(Math.min(completedLessons, progress.getTotalLessons()));

            if (progress.getCompletedLessons() >= progress.getTotalLessons()) {
                progress.setStatus("completed");
                progress.setCompletedDate(new Date());
            }

            em.merge(progress);
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

    public List<UserCourseProgress> getProgressByUser(int userId) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT p FROM UserCourseProgress p WHERE p.userID = :uid ORDER BY p.startedDate DESC",
                    UserCourseProgress.class)
                    .setParameter("uid", userId)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public UserCourseProgress getProgress(int userId, int courseId) {
        EntityManager em = getEntityManager();
        try {
            List<UserCourseProgress> results = em.createQuery(
                    "SELECT p FROM UserCourseProgress p WHERE p.userID = :uid AND p.courseID = :cid",
                    UserCourseProgress.class)
                    .setParameter("uid", userId)
                    .setParameter("cid", courseId)
                    .getResultList();
            return results.isEmpty() ? null : results.get(0);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }
}
