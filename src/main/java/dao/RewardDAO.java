package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import model.Reward;
import model.UserReward;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class RewardDAO extends BaseDAO {

    private final Random random = new Random();

    public List<Reward> getActiveRewards() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT r FROM Reward r WHERE r.isActive = true", Reward.class)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    /**
     * Get a random reward from the pool.
     * Rarity weights: common=60%, rare=25%, epic=10%, legendary=5%
     */
    public Reward getRandomReward() {
        List<Reward> all = getActiveRewards();
        if (all.isEmpty())
            return null;

        // Weighted random by rarity
        List<Reward> weighted = new ArrayList<>();
        for (Reward r : all) {
            int weight;
            String rarity = r.getRarity();
            if ("legendary".equals(rarity)) {
                weight = 1;
            } else if ("epic".equals(rarity)) {
                weight = 2;
            } else if ("rare".equals(rarity)) {
                weight = 5;
            } else {
                weight = 12; // common
            }
            for (int i = 0; i < weight; i++) {
                weighted.add(r);
            }
        }

        return weighted.get(random.nextInt(weighted.size()));
    }

    public boolean saveUserReward(int userId, int rewardId, Integer sessionId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            UserReward ur = new UserReward();
            ur.setUserID(userId);
            ur.setRewardID(rewardId);
            ur.setSessionID(sessionId);
            em.persist(ur);
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

    public List<UserReward> getUserRewards(int userId, int limit) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<UserReward> q = em.createQuery(
                    "SELECT ur FROM UserReward ur WHERE ur.userID = :userId ORDER BY ur.receivedDate DESC",
                    UserReward.class);
            q.setParameter("userId", userId);
            q.setMaxResults(limit);
            return q.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }
}
