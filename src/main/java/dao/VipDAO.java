package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import model.VipTier;
import model.UserVipStatus;

import java.util.ArrayList;
import java.util.List;

public class VipDAO extends BaseDAO {

    public List<VipTier> getAllTiers() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT v FROM VipTier v ORDER BY v.tierOrder", VipTier.class)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public VipTier getTierById(int tierId) {
        EntityManager em = getEntityManager();
        try {
            return em.find(VipTier.class, tierId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public UserVipStatus getUserVipStatus(int userId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<UserVipStatus> q = em.createQuery(
                    "SELECT v FROM UserVipStatus v WHERE v.userID = :userId", UserVipStatus.class);
            q.setParameter("userId", userId);
            List<UserVipStatus> results = q.getResultList();
            return results.isEmpty() ? null : results.get(0);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public boolean purchaseVip(int userId, int tierId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            // Check if user already has VIP
            TypedQuery<UserVipStatus> q = em.createQuery(
                    "SELECT v FROM UserVipStatus v WHERE v.userID = :userId", UserVipStatus.class);
            q.setParameter("userId", userId);
            List<UserVipStatus> existing = q.getResultList();

            if (existing.isEmpty()) {
                UserVipStatus vip = new UserVipStatus();
                vip.setUserID(userId);
                vip.setTierID(tierId);
                em.persist(vip);
            } else {
                UserVipStatus vip = existing.get(0);
                vip.setTierID(tierId);
                em.merge(vip);
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
