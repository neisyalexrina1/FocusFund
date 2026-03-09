package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import model.RoomMessage;

import java.util.ArrayList;
import java.util.List;

public class RoomMessageDAO {

    /**
     * Save a new chat message to the database.
     */
    public RoomMessage saveMessage(RoomMessage message) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(message);
            tx.commit();
            return message;
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    /**
     * Get the latest N messages for a room, ordered by sentAt ascending.
     */
    public List<RoomMessage> getRecentMessages(int roomID, int limit) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            // Get the latest messages in descending order, then reverse for display
            List<RoomMessage> messages = em.createQuery(
                    "SELECT m FROM RoomMessage m WHERE m.roomID = :roomID ORDER BY m.sentAt DESC",
                    RoomMessage.class)
                    .setParameter("roomID", roomID)
                    .setMaxResults(limit)
                    .getResultList();
            // Reverse so oldest is first (for chat display order)
            List<RoomMessage> reversed = new ArrayList<>(messages);
            java.util.Collections.reverse(reversed);
            return reversed;
        } finally {
            em.close();
        }
    }

    /**
     * Delete all messages in a room (when room is deleted).
     */
    public void deleteAllByRoom(int roomID) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.createQuery("DELETE FROM RoomMessage m WHERE m.roomID = :roomID")
                    .setParameter("roomID", roomID)
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
     * Delete a specific message, only if it belongs to the requesting user.
     * Returns true if deleted, false if not found or not owned.
     */
    public boolean deleteMessage(int messageId, int requestingUserId) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            int deleted = em.createQuery(
                    "DELETE FROM RoomMessage m WHERE m.messageID = :mid AND m.userID = :uid")
                    .setParameter("mid", messageId)
                    .setParameter("uid", requestingUserId)
                    .executeUpdate();
            tx.commit();
            return deleted > 0;
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
