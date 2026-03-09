package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import model.MicroSession;

import java.util.Date;
import java.util.List;

public class MicroSessionDAO extends BaseDAO {

    public int startMicroSession(int userId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            MicroSession ms = new MicroSession();
            ms.setUserID(userId);
            em.persist(ms);
            tx.commit();
            return ms.getMicroSessionID();
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
     * User chose to continue! Escalate the session (1→5→10→15→25 minutes)
     */
    public int escalate(int microSessionId, int userId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            MicroSession ms = em.find(MicroSession.class, microSessionId);
            if (ms == null || !("active".equals(ms.getStatus())))
                return -1;
            if (ms.getUserID() != userId)
                return -1;

            ms.setEscalations(ms.getEscalations() + 1);

            // Escalation duration pattern: 1→5→10→15→25
            int[] durations = { 1, 5, 10, 15, 25 };
            int nextDuration = ms.getEscalations() < durations.length
                    ? durations[ms.getEscalations()]
                    : 25;

            if (nextDuration >= 25) {
                ms.setConvertedToPomodoro(true);
            }

            em.merge(ms);
            tx.commit();
            return nextDuration;
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    /**
     * Complete the micro session
     */
    public MicroSession complete(int microSessionId, int actualMinutes) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            MicroSession ms = em.find(MicroSession.class, microSessionId);
            if (ms == null)
                return null;

            ms.setActualDuration(actualMinutes);
            ms.setEndTime(new Date());
            ms.setStatus("completed");
            em.merge(ms);
            tx.commit();
            return ms;
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public MicroSession abandon(int microSessionId, int actualMinutes) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            MicroSession ms = em.find(MicroSession.class, microSessionId);
            if (ms == null)
                return null;

            ms.setActualDuration(actualMinutes);
            ms.setEndTime(new Date());
            ms.setStatus("abandoned");
            em.merge(ms);
            tx.commit();
            return ms;
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public List<MicroSession> getUserMicroSessions(int userId, int limit) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<MicroSession> q = em.createQuery(
                    "SELECT ms FROM MicroSession ms WHERE ms.userID = :userId ORDER BY ms.startTime DESC",
                    MicroSession.class);
            q.setParameter("userId", userId);
            q.setMaxResults(limit);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Stats: how many micro sessions converted to pomodoro
     */
    public long getConversionCount(int userId) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT COUNT(ms) FROM MicroSession ms WHERE ms.userID = :userId AND ms.convertedToPomodoro = true",
                    Long.class)
                    .setParameter("userId", userId)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }
}
