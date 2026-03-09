package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.StudySession;

public class StudySessionDAO extends BaseDAO {

    public boolean createSession(int userId, Integer roomId, String goal) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            StudySession session = new StudySession();
            session.setUserID(userId);
            session.setRoomID(roomId);
            session.setGoal(goal);
            session.setStartTime(new Date());
            session.setStatus("active");
            session.setFocusMinutes(0);
            session.setPomodorosCompleted(0);
            em.persist(session);
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

    public List<StudySession> getSessionsByUser(int userId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<StudySession> q = em.createQuery(
                    "SELECT s FROM StudySession s WHERE s.userID = :uid ORDER BY s.startTime DESC", StudySession.class);
            q.setParameter("uid", userId);
            return q.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public boolean updateSession(int sessionId, int focusMinutes, int pomodorosCompleted, String status) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            StudySession session = em.find(StudySession.class, sessionId);
            if (session == null)
                return false;
            session.setFocusMinutes(focusMinutes);
            session.setPomodorosCompleted(pomodorosCompleted);
            session.setStatus(status);
            if ("completed".equals(status)) {
                session.setEndTime(new Date());
            }
            em.merge(session);
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

    public int getTotalFocusMinutes(int userId) {
        EntityManager em = getEntityManager();
        try {
            Object result = em.createQuery(
                    "SELECT COALESCE(SUM(s.focusMinutes), 0) FROM StudySession s WHERE s.userID = :uid")
                    .setParameter("uid", userId)
                    .getSingleResult();
            return ((Number) result).intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    public int getTotalSessions(int userId) {
        EntityManager em = getEntityManager();
        try {
            Object result = em.createQuery(
                    "SELECT COUNT(s) FROM StudySession s WHERE s.userID = :uid AND s.status = 'completed'")
                    .setParameter("uid", userId)
                    .getSingleResult();
            return ((Number) result).intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }
}
