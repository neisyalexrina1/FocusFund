package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import model.Notification;

import java.util.ArrayList;
import java.util.List;

public class NotificationDAO extends BaseDAO {

    /**
     * Create a notification for a user
     */
    public void create(int userId, String type, String icon, String title, String message, String actionUrl) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Notification n = new Notification();
            n.setUserID(userId);
            n.setType(type);
            n.setIcon(icon);
            n.setTitle(title);
            n.setMessage(message);
            n.setActionUrl(actionUrl);
            em.persist(n);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    /**
     * Get recent notifications (for navbar dropdown)
     */
    public List<Notification> getRecent(int userId, int limit) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT n FROM Notification n WHERE n.userID = :userId ORDER BY n.createdDate DESC",
                    Notification.class)
                    .setParameter("userId", userId)
                    .setMaxResults(limit)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    /**
     * Get unread count (for badge number on bell icon)
     */
    public int getUnreadCount(int userId) {
        EntityManager em = getEntityManager();
        try {
            Long count = em.createQuery(
                    "SELECT COUNT(n) FROM Notification n WHERE n.userID = :userId AND n.isRead = false",
                    Long.class)
                    .setParameter("userId", userId)
                    .getSingleResult();
            return count.intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    /**
     * Mark all as read
     */
    public void markAllRead(int userId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.createQuery("UPDATE Notification n SET n.isRead = true WHERE n.userID = :userId AND n.isRead = false")
                    .setParameter("userId", userId)
                    .executeUpdate();
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    /**
     * Mark one as read
     */
    public void markRead(int notificationId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Notification n = em.find(Notification.class, notificationId);
            if (n != null) {
                n.setRead(true);
                em.merge(n);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    /**
     * Get all notifications grouped (for notifications.jsp full page)
     */
    public List<Notification> getAll(int userId, int limit) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT n FROM Notification n WHERE n.userID = :userId ORDER BY n.createdDate DESC",
                    Notification.class)
                    .setParameter("userId", userId)
                    .setMaxResults(limit)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    /**
     * Delete old notifications (cleanup)
     */
    public void deleteOlderThan(int userId, int days) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.createQuery(
                    "DELETE FROM Notification n WHERE n.userID = :userId AND n.createdDate < :cutoff")
                    .setParameter("userId", userId)
                    .setParameter("cutoff",
                            new java.util.Date(System.currentTimeMillis() - (long) days * 24 * 60 * 60 * 1000))
                    .executeUpdate();
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
}
