package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import model.LeaderboardMonthly;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class LeaderboardDAO extends BaseDAO {

    private String getCurrentMonthYear() {
        return new SimpleDateFormat("yyyy-MM").format(new Date());
    }

    public List<LeaderboardMonthly> getMonthlyTop(int limit) {
        return getTopByMonth(getCurrentMonthYear(), limit);
    }

    public List<LeaderboardMonthly> getTopByMonth(String monthYear, int limit) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<LeaderboardMonthly> q = em.createQuery(
                    "SELECT l FROM LeaderboardMonthly l WHERE l.monthYear = :month ORDER BY l.totalCoinsEarned DESC",
                    LeaderboardMonthly.class);
            q.setParameter("month", monthYear);
            q.setMaxResults(limit);
            return q.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public LeaderboardMonthly getUserMonthlyEntry(int userId) {
        return getUserEntryByMonth(userId, getCurrentMonthYear());
    }

    public LeaderboardMonthly getUserEntryByMonth(int userId, String monthYear) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<LeaderboardMonthly> q = em.createQuery(
                    "SELECT l FROM LeaderboardMonthly l WHERE l.userID = :userId AND l.monthYear = :month",
                    LeaderboardMonthly.class);
            q.setParameter("userId", userId);
            q.setParameter("month", monthYear);
            List<LeaderboardMonthly> results = q.getResultList();
            return results.isEmpty() ? null : results.get(0);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public boolean addMonthlyCoins(int userId, int coins) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        String monthYear = getCurrentMonthYear();
        try {
            tx.begin();
            TypedQuery<LeaderboardMonthly> q = em.createQuery(
                    "SELECT l FROM LeaderboardMonthly l WHERE l.userID = :userId AND l.monthYear = :month",
                    LeaderboardMonthly.class);
            q.setParameter("userId", userId);
            q.setParameter("month", monthYear);
            List<LeaderboardMonthly> results = q.getResultList();

            if (results.isEmpty()) {
                LeaderboardMonthly entry = new LeaderboardMonthly();
                entry.setUserID(userId);
                entry.setMonthYear(monthYear);
                entry.setTotalCoinsEarned(coins);
                em.persist(entry);
            } else {
                LeaderboardMonthly entry = results.get(0);
                entry.setTotalCoinsEarned(entry.getTotalCoinsEarned() + coins);
                em.merge(entry);
            }

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

    public boolean addMonthlyStudyMinutes(int userId, int minutes) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        String monthYear = getCurrentMonthYear();
        try {
            tx.begin();
            TypedQuery<LeaderboardMonthly> q = em.createQuery(
                    "SELECT l FROM LeaderboardMonthly l WHERE l.userID = :userId AND l.monthYear = :month",
                    LeaderboardMonthly.class);
            q.setParameter("userId", userId);
            q.setParameter("month", monthYear);
            List<LeaderboardMonthly> results = q.getResultList();

            if (results.isEmpty()) {
                LeaderboardMonthly entry = new LeaderboardMonthly();
                entry.setUserID(userId);
                entry.setMonthYear(monthYear);
                entry.setTotalStudyMinutes(minutes);
                em.persist(entry);
            } else {
                LeaderboardMonthly entry = results.get(0);
                entry.setTotalStudyMinutes(entry.getTotalStudyMinutes() + minutes);
                em.merge(entry);
            }

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
