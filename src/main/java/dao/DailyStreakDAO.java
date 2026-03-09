package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import model.DailyStreak;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class DailyStreakDAO extends BaseDAO {

    public DailyStreak getByUserId(int userId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<DailyStreak> q = em.createQuery(
                    "SELECT s FROM DailyStreak s WHERE s.userID = :userId", DailyStreak.class);
            q.setParameter("userId", userId);
            List<DailyStreak> results = q.getResultList();
            return results.isEmpty() ? null : results.get(0);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public DailyStreak getOrCreate(int userId) {
        DailyStreak s = getByUserId(userId);
        if (s == null) {
            s = new DailyStreak();
            s.setUserID(userId);
            save(s);
            s = getByUserId(userId);
        }
        return s;
    }

    public boolean save(DailyStreak streak) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(streak);
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

    /**
     * Record a study day. Returns the updated streak count.
     * Logic: if last study was yesterday → increment streak
     * if last study was today → no change
     * otherwise → reset to 1
     */
    public int recordStudyDay(int userId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            TypedQuery<DailyStreak> q = em.createQuery(
                    "SELECT s FROM DailyStreak s WHERE s.userID = :userId", DailyStreak.class);
            q.setParameter("userId", userId);
            List<DailyStreak> results = q.getResultList();

            DailyStreak streak;
            if (results.isEmpty()) {
                streak = new DailyStreak();
                streak.setUserID(userId);
                streak.setCurrentStreak(1);
                streak.setLongestStreak(1);
                streak.setLastStudyDate(new Date());
                streak.setStreakStartDate(new Date());
                em.persist(streak);
            } else {
                streak = results.get(0);
                Date today = stripTime(new Date());
                Date lastStudy = streak.getLastStudyDate() != null ? stripTime(streak.getLastStudyDate()) : null;

                if (lastStudy != null && today.equals(lastStudy)) {
                    // Already studied today
                    tx.commit();
                    return streak.getCurrentStreak();
                }

                if (lastStudy != null && isYesterday(lastStudy, today)) {
                    streak.setCurrentStreak(streak.getCurrentStreak() + 1);
                } else {
                    streak.setCurrentStreak(1);
                    streak.setStreakStartDate(new Date());
                }

                if (streak.getCurrentStreak() > streak.getLongestStreak()) {
                    streak.setLongestStreak(streak.getCurrentStreak());
                }

                streak.setLastStudyDate(new Date());
                em.merge(streak);
            }

            tx.commit();
            return streak.getCurrentStreak();
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    private Date stripTime(Date date) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        return cal.getTime();
    }

    private boolean isYesterday(Date lastStudy, Date today) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(today);
        cal.add(Calendar.DAY_OF_YEAR, -1);
        return stripTime(cal.getTime()).equals(lastStudy);
    }
}
