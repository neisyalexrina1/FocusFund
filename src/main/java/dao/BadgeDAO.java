package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import model.Badge;
import model.UserBadge;

import java.util.ArrayList;
import java.util.List;

public class BadgeDAO extends BaseDAO {

    public List<Badge> getAllBadges() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT b FROM Badge b ORDER BY b.badgeID", Badge.class).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public List<Badge> getBadgesByType(String type) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Badge> q = em.createQuery(
                    "SELECT b FROM Badge b WHERE b.badgeType = :type", Badge.class);
            q.setParameter("type", type);
            return q.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public List<UserBadge> getUserBadges(int userId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<UserBadge> q = em.createQuery(
                    "SELECT ub FROM UserBadge ub WHERE ub.userID = :userId ORDER BY ub.earnedDate DESC",
                    UserBadge.class);
            q.setParameter("userId", userId);
            return q.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public boolean hasUserBadge(int userId, int badgeId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Long> q = em.createQuery(
                    "SELECT COUNT(ub) FROM UserBadge ub WHERE ub.userID = :userId AND ub.badgeID = :badgeId",
                    Long.class);
            q.setParameter("userId", userId);
            q.setParameter("badgeId", badgeId);
            return q.getSingleResult() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public boolean awardBadge(int userId, int badgeId) {
        if (hasUserBadge(userId, badgeId))
            return false; // Already has it
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            UserBadge ub = new UserBadge();
            ub.setUserID(userId);
            ub.setBadgeID(badgeId);
            em.persist(ub);
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
