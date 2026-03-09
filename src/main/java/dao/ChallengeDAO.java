package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import model.Challenge;
import model.UserChallenge;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class ChallengeDAO extends BaseDAO {

    public List<Challenge> getActiveChallenges() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT c FROM Challenge c WHERE c.isActive = true ORDER BY c.challengeID", Challenge.class)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public Challenge getChallengeById(int challengeId) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Challenge.class, challengeId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public List<UserChallenge> getUserChallenges(int userId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<UserChallenge> q = em.createQuery(
                    "SELECT uc FROM UserChallenge uc WHERE uc.userID = :userId ORDER BY uc.startDate DESC",
                    UserChallenge.class);
            q.setParameter("userId", userId);
            return q.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public List<UserChallenge> getActiveUserChallenges(int userId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<UserChallenge> q = em.createQuery(
                    "SELECT uc FROM UserChallenge uc WHERE uc.userID = :userId AND uc.status = 'active'",
                    UserChallenge.class);
            q.setParameter("userId", userId);
            return q.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public boolean joinChallenge(int userId, int challengeId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            Challenge challenge = em.find(Challenge.class, challengeId);
            if (challenge == null)
                return false;

            tx.begin();
            UserChallenge uc = new UserChallenge();
            uc.setUserID(userId);
            uc.setChallengeID(challengeId);
            uc.setStartDate(new Date());

            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.DAY_OF_YEAR, challenge.getDurationDays());
            uc.setEndDate(cal.getTime());

            em.persist(uc);
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

    public boolean updateProgress(int userChallengeId, int daysCompleted, int userId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            UserChallenge uc = em.find(UserChallenge.class, userChallengeId);
            if (uc == null || uc.getUserID() != userId)
                return false;

            uc.setDaysCompleted(daysCompleted);

            // Check if challenge is completed
            Challenge challenge = em.find(Challenge.class, uc.getChallengeID());
            if (challenge != null && daysCompleted >= challenge.getDurationDays()) {
                uc.setStatus("completed");
                uc.setCompletedDate(new Date());
            }

            em.merge(uc);
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

    public boolean abandonChallenge(int userChallengeId, int userId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            UserChallenge uc = em.find(UserChallenge.class, userChallengeId);
            if (uc == null || uc.getUserID() != userId)
                return false;
            uc.setStatus("abandoned");
            em.merge(uc);
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
