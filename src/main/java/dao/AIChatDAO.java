package dao;

import jakarta.persistence.*;
import model.AIChatSession;
import model.AIChatMessage;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class AIChatDAO extends BaseDAO {

    public int createSession(int userId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            AIChatSession session = new AIChatSession();
            session.setUserID(userId);
            em.persist(session);
            tx.commit();
            return session.getSessionID();
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            return -1;
        } finally {
            em.close();
        }
    }

    public boolean saveMessage(int sessionId, String role, String content, String mode) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            AIChatMessage msg = new AIChatMessage();
            msg.setSessionID(sessionId);
            msg.setRole(role);
            msg.setContent(content);
            msg.setMode(mode != null ? mode : "normal");
            em.persist(msg);

            // Update session's updatedAt
            AIChatSession session = em.find(AIChatSession.class, sessionId);
            if (session != null) {
                session.setUpdatedAt(new Date());
                em.merge(session);
            }
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            return false;
        } finally {
            em.close();
        }
    }

    public boolean updateSessionTitle(int sessionId, String title) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            AIChatSession session = em.find(AIChatSession.class, sessionId);
            if (session != null) {
                session.setTitle(title.length() > 200 ? title.substring(0, 197) + "..." : title);
                em.merge(session);
            }
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            return false;
        } finally {
            em.close();
        }
    }

    public List<AIChatSession> getSessionsByUser(int userId) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT s FROM AIChatSession s WHERE s.userID = :uid ORDER BY s.updatedAt DESC",
                    AIChatSession.class)
                    .setParameter("uid", userId)
                    .setMaxResults(50)
                    .getResultList();
        } catch (Exception e) {
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public List<AIChatMessage> getMessagesBySession(int sessionId) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT m FROM AIChatMessage m WHERE m.sessionID = :sid ORDER BY m.createdAt ASC",
                    AIChatMessage.class)
                    .setParameter("sid", sessionId)
                    .getResultList();
        } catch (Exception e) {
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public AIChatSession getSessionById(int sessionId) {
        EntityManager em = getEntityManager();
        try {
            return em.find(AIChatSession.class, sessionId);
        } finally {
            em.close();
        }
    }

    public boolean deleteSession(int sessionId, int userId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            AIChatSession session = em.find(AIChatSession.class, sessionId);
            if (session == null || session.getUserID() != userId) {
                tx.rollback();
                return false;
            }
            // Delete messages first
            em.createQuery("DELETE FROM AIChatMessage m WHERE m.sessionID = :sid")
                    .setParameter("sid", sessionId)
                    .executeUpdate();
            em.remove(session);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            return false;
        } finally {
            em.close();
        }
    }
}
