package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import model.UserGamification;

import java.util.Date;
import java.util.List;

public class UserGamificationDAO extends BaseDAO {

    public UserGamification getByUserId(int userId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<UserGamification> q = em.createQuery(
                    "SELECT g FROM UserGamification g WHERE g.userID = :userId", UserGamification.class);
            q.setParameter("userId", userId);
            List<UserGamification> results = q.getResultList();
            return results.isEmpty() ? null : results.get(0);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public UserGamification getOrCreate(int userId) {
        UserGamification g = getByUserId(userId);
        if (g == null) {
            g = new UserGamification();
            g.setUserID(userId);
            save(g);
            g = getByUserId(userId);
        }
        return g;
    }

    public boolean save(UserGamification gamification) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(gamification);
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

    public boolean addCoins(int userId, int coins) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            TypedQuery<UserGamification> q = em.createQuery(
                    "SELECT g FROM UserGamification g WHERE g.userID = :userId", UserGamification.class);
            q.setParameter("userId", userId);
            UserGamification g = q.getSingleResult();
            g.setFocusCoins(g.getFocusCoins() + coins);
            g.setLastCoinEarnedDate(new Date());
            em.merge(g);
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

    public boolean spendCoins(int userId, int coins) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            TypedQuery<UserGamification> q = em.createQuery(
                    "SELECT g FROM UserGamification g WHERE g.userID = :userId", UserGamification.class);
            q.setParameter("userId", userId);
            UserGamification g = q.getSingleResult();
            if (g.getFocusCoins() < coins)
                return false;
            g.setFocusCoins(g.getFocusCoins() - coins);
            em.merge(g);
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

    public boolean addExp(int userId, int exp) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            TypedQuery<UserGamification> q = em.createQuery(
                    "SELECT g FROM UserGamification g WHERE g.userID = :userId", UserGamification.class);
            q.setParameter("userId", userId);
            UserGamification g = q.getSingleResult();
            g.setTotalExp(g.getTotalExp() + exp);
            em.merge(g);
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

    public boolean addStudyMinutes(int userId, int minutes) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            TypedQuery<UserGamification> q = em.createQuery(
                    "SELECT g FROM UserGamification g WHERE g.userID = :userId", UserGamification.class);
            q.setParameter("userId", userId);
            UserGamification g = q.getSingleResult();
            g.setTotalStudyMinutes(g.getTotalStudyMinutes() + minutes);
            // Auto-update rank
            g.setCurrentRank(g.calculateRank());
            em.merge(g);
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

    public List<UserGamification> getTopByCoins(int limit) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<UserGamification> q = em.createQuery(
                    "SELECT g FROM UserGamification g ORDER BY g.focusCoins DESC", UserGamification.class);
            q.setMaxResults(limit);
            return q.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            em.close();
        }
    }
}
