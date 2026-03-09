package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import model.BuddyActivity;
import model.StudyBuddy;
import model.User;

import java.util.ArrayList;
import java.util.List;

public class StudyBuddyDAO extends BaseDAO {

    /**
     * Send buddy request (or auto-pair)
     */
    public int createBuddyPair(int user1Id, int user2Id) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            // Check not already paired
            long existing = em.createQuery(
                    "SELECT COUNT(b) FROM StudyBuddy b WHERE b.status = 'active' AND " +
                            "((b.user1ID = :u1 AND b.user2ID = :u2) OR (b.user1ID = :u2 AND b.user2ID = :u1))",
                    Long.class)
                    .setParameter("u1", user1Id)
                    .setParameter("u2", user2Id)
                    .getSingleResult();

            if (existing > 0)
                return -1;

            StudyBuddy buddy = new StudyBuddy();
            buddy.setUser1ID(user1Id);
            buddy.setUser2ID(user2Id);
            em.persist(buddy);
            tx.commit();
            return buddy.getBuddyPairID();
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
     * Get user's active buddy pair
     */
    public StudyBuddy getActiveBuddy(int userId) {
        EntityManager em = getEntityManager();
        try {
            List<StudyBuddy> results = em.createQuery(
                    "SELECT b FROM StudyBuddy b WHERE b.status = 'active' AND (b.user1ID = :userId OR b.user2ID = :userId)",
                    StudyBuddy.class)
                    .setParameter("userId", userId)
                    .setMaxResults(1)
                    .getResultList();
            return results.isEmpty() ? null : results.get(0);
        } finally {
            em.close();
        }
    }

    /**
     * Get buddy's User info
     */
    public User getBuddyUser(int userId) {
        EntityManager em = getEntityManager();
        try {
            StudyBuddy pair = getActiveBuddy(userId);
            if (pair == null)
                return null;

            int buddyId = pair.getUser1ID() == userId ? pair.getUser2ID() : pair.getUser1ID();
            return em.find(User.class, buddyId);
        } finally {
            em.close();
        }
    }

    /**
     * Log activity and create notification for buddy
     */
    public void logActivity(int userId, String activityType, String message) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            StudyBuddy pair = getActiveBuddyInternal(em, userId);
            if (pair == null) {
                tx.commit();
                return;
            }

            BuddyActivity activity = new BuddyActivity();
            activity.setBuddyPairID(pair.getBuddyPairID());
            activity.setUserID(userId);
            activity.setActivityType(activityType);
            activity.setMessage(message);
            em.persist(activity);

            tx.commit();
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    private StudyBuddy getActiveBuddyInternal(EntityManager em, int userId) {
        List<StudyBuddy> results = em.createQuery(
                "SELECT b FROM StudyBuddy b WHERE b.status = 'active' AND (b.user1ID = :userId OR b.user2ID = :userId)",
                StudyBuddy.class)
                .setParameter("userId", userId)
                .setMaxResults(1)
                .getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    /**
     * Get unread notifications for user from buddy
     */
    public List<BuddyActivity> getUnreadNotifications(int userId) {
        EntityManager em = getEntityManager();
        try {
            StudyBuddy pair = getActiveBuddy(userId);
            if (pair == null)
                return new ArrayList<>();

            // Get activities by the OTHER person
            return em.createQuery(
                    "SELECT a FROM BuddyActivity a WHERE a.buddyPairID = :pairId AND a.userID <> :userId AND a.isRead = false ORDER BY a.createdDate DESC",
                    BuddyActivity.class)
                    .setParameter("pairId", pair.getBuddyPairID())
                    .setParameter("userId", userId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Mark notifications as read
     */
    public void markNotificationsRead(int userId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            StudyBuddy pair = getActiveBuddyInternal(em, userId);
            if (pair == null) {
                tx.commit();
                return;
            }

            em.createQuery(
                    "UPDATE BuddyActivity a SET a.isRead = true WHERE a.buddyPairID = :pairId AND a.userID <> :userId AND a.isRead = false")
                    .setParameter("pairId", pair.getBuddyPairID())
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
     * Increment sessions together count
     */
    public void incrementSessionsTogether(int userId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            StudyBuddy pair = getActiveBuddyInternal(em, userId);
            if (pair != null) {
                pair.setTotalSessionsTogether(pair.getTotalSessionsTogether() + 1);
                em.merge(pair);
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
     * End buddy pair
     */
    public boolean endBuddyPair(int userId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            StudyBuddy pair = getActiveBuddyInternal(em, userId);
            if (pair == null)
                return false;

            pair.setStatus("ended");
            em.merge(pair);
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
