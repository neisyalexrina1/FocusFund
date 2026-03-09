package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import model.FocusFundContract;
import model.FocusFundPool;
import model.FocusFundTransaction;
import model.User;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class FocusFundDAO extends BaseDAO {

    private String getCurrentMonthYear() {
        return new SimpleDateFormat("yyyy-MM").format(new Date());
    }

    // ===== DEPOSITS & WITHDRAWALS =====

    public boolean deposit(int userId, double amount) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            User user = em.find(User.class, userId);
            if (user == null)
                return false;

            user.setBalance(user.getBalance() + amount);
            em.merge(user);

            // Log transaction
            FocusFundTransaction t = new FocusFundTransaction();
            t.setUserID(userId);
            t.setTransactionType("deposit");
            t.setAmount(amount);
            t.setBalanceAfter(user.getBalance());
            t.setDescription("Deposit to FocusFund");
            em.persist(t);

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

    public boolean withdraw(int userId, double amount) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            User user = em.find(User.class, userId);
            if (user == null || user.getBalance() < amount)
                return false;

            user.setBalance(user.getBalance() - amount);
            em.merge(user);

            FocusFundTransaction t = new FocusFundTransaction();
            t.setUserID(userId);
            t.setTransactionType("withdraw");
            t.setAmount(-amount);
            t.setBalanceAfter(user.getBalance());
            t.setDescription("Withdrawal from FocusFund");
            em.persist(t);

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

    public double getBalance(int userId) {
        EntityManager em = getEntityManager();
        try {
            User user = em.find(User.class, userId);
            return user != null ? user.getBalance() : 0;
        } finally {
            em.close();
        }
    }

    // ===== CONTRACTS (Smart Commitment) =====

    public int createContract(int userId, double stakeAmount, int penaltyPercent,
            String goalType, int goalValue, int durationDays) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            // Deduct stake from balance
            User user = em.find(User.class, userId);
            if (user == null || user.getBalance() < stakeAmount)
                return -1;

            user.setBalance(user.getBalance() - stakeAmount);
            em.merge(user);

            // Create contract
            FocusFundContract contract = new FocusFundContract();
            contract.setUserID(userId);
            contract.setStakeAmount(stakeAmount);
            contract.setPenaltyPercent(penaltyPercent);
            contract.setGoalType(goalType);
            contract.setGoalValue(goalValue);
            contract.setDurationDays(durationDays);

            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.DAY_OF_YEAR, durationDays);
            contract.setEndDate(cal.getTime());

            em.persist(contract);

            // Log transaction
            FocusFundTransaction t = new FocusFundTransaction();
            t.setUserID(userId);
            t.setTransactionType("stake");
            t.setAmount(-stakeAmount);
            t.setBalanceAfter(user.getBalance());
            t.setContractID(contract.getContractID());
            t.setDescription(
                    "Staked " + String.format("%,.0f", stakeAmount) + " VND for " + durationDays + "-day contract");
            em.persist(t);

            tx.commit();
            return contract.getContractID();
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return -1;
        } finally {
            em.close();
        }
    }

    public FocusFundContract getActiveContract(int userId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<FocusFundContract> q = em.createQuery(
                    "SELECT c FROM FocusFundContract c WHERE c.userID = :userId AND c.status = 'active' ORDER BY c.startDate DESC",
                    FocusFundContract.class);
            q.setParameter("userId", userId);
            q.setMaxResults(1);
            List<FocusFundContract> results = q.getResultList();
            return results.isEmpty() ? null : results.get(0);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public List<FocusFundContract> getUserContracts(int userId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<FocusFundContract> q = em.createQuery(
                    "SELECT c FROM FocusFundContract c WHERE c.userID = :userId ORDER BY c.startDate DESC",
                    FocusFundContract.class);
            q.setParameter("userId", userId);
            return q.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    /**
     * Complete a contract day. Returns true if the whole contract is now completed.
     */
    public boolean recordContractDay(int contractId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            FocusFundContract c = em.find(FocusFundContract.class, contractId);
            if (c == null || !"active".equals(c.getStatus()))
                return false;

            c.setDaysCompleted(c.getDaysCompleted() + 1);

            if (c.getDaysCompleted() >= c.getDurationDays()) {
                c.setStatus("completed");
                c.setCompletedDate(new Date());

                // Refund stake + 5% bonus
                double bonus = c.getStakeAmount() * 0.05;
                double refund = c.getStakeAmount() + bonus;
                c.setBonusEarned(bonus);

                User user = em.find(User.class, c.getUserID());
                if (user != null) {
                    user.setBalance(user.getBalance() + refund);
                    em.merge(user);

                    // Log refund
                    FocusFundTransaction t = new FocusFundTransaction();
                    t.setUserID(c.getUserID());
                    t.setTransactionType("refund");
                    t.setAmount(refund);
                    t.setBalanceAfter(user.getBalance());
                    t.setContractID(contractId);
                    t.setDescription("Contract completed! Refund " + String.format("%,.0f", c.getStakeAmount())
                            + " + bonus " + String.format("%,.0f", bonus) + " VND");
                    em.persist(t);
                }
            }

            em.merge(c);
            tx.commit();
            return c.getDaysCompleted() >= c.getDurationDays();
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
     * Apply penalty when user fails (idle/quit session).
     * Splits penalty: 50% leaderboard pool, 30% revenue, 20% VIP bonus
     */
    public double applyPenalty(int contractId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            FocusFundContract c = em.find(FocusFundContract.class, contractId);
            if (c == null || !"active".equals(c.getStatus()))
                return 0;

            double penaltyAmount = c.getStakeAmount() * (c.getPenaltyPercent() / 100.0);

            // Split penalty into pools
            double toLeaderboard = penaltyAmount * 0.50;
            double toRevenue = penaltyAmount * 0.30;
            double toVipBonus = penaltyAmount * 0.20;

            // Update pool
            String monthYear = getCurrentMonthYear();
            TypedQuery<FocusFundPool> poolQuery = em.createQuery(
                    "SELECT p FROM FocusFundPool p WHERE p.monthYear = :month", FocusFundPool.class);
            poolQuery.setParameter("month", monthYear);
            List<FocusFundPool> pools = poolQuery.getResultList();

            FocusFundPool pool;
            if (pools.isEmpty()) {
                pool = new FocusFundPool();
                pool.setMonthYear(monthYear);
                pool.setLeaderboardPool(toLeaderboard);
                pool.setRevenuePool(toRevenue);
                pool.setVipBonusPool(toVipBonus);
                pool.setTotalPenalties(penaltyAmount);
                em.persist(pool);
            } else {
                pool = pools.get(0);
                pool.setLeaderboardPool(pool.getLeaderboardPool() + toLeaderboard);
                pool.setRevenuePool(pool.getRevenuePool() + toRevenue);
                pool.setVipBonusPool(pool.getVipBonusPool() + toVipBonus);
                pool.setTotalPenalties(pool.getTotalPenalties() + penaltyAmount);
                em.merge(pool);
            }

            // Reduce stake
            c.setStakeAmount(c.getStakeAmount() - penaltyAmount);
            if (c.getStakeAmount() <= 0) {
                c.setStatus("failed");
                c.setStakeAmount(0);
            }
            em.merge(c);

            // Log penalty transaction
            FocusFundTransaction t = new FocusFundTransaction();
            t.setUserID(c.getUserID());
            t.setTransactionType("penalty");
            t.setAmount(-penaltyAmount);
            t.setContractID(contractId);
            t.setDescription("Penalty " + c.getPenaltyPercent() + "%: -" + String.format("%,.0f", penaltyAmount)
                    + " VND (50% Leaderboard, 30% Revenue, 20% VIP)");
            em.persist(t);

            tx.commit();
            return penaltyAmount;
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    // ===== COIN EXCHANGE =====

    public boolean exchangeCoinsToVnd(int userId, int coins, double vndAmount) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            User user = em.find(User.class, userId);
            if (user == null)
                return false;

            user.setBalance(user.getBalance() + vndAmount);
            em.merge(user);

            FocusFundTransaction t = new FocusFundTransaction();
            t.setUserID(userId);
            t.setTransactionType("coin_exchange");
            t.setAmount(vndAmount);
            t.setBalanceAfter(user.getBalance());
            t.setDescription("Exchanged " + coins + " Focus Coins → " + String.format("%,.0f", vndAmount) + " VND");
            em.persist(t);

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

    // ===== POOL & LEADERBOARD =====

    public FocusFundPool getPoolByMonth(String monthYear) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<FocusFundPool> q = em.createQuery(
                    "SELECT p FROM FocusFundPool p WHERE p.monthYear = :month", FocusFundPool.class);
            q.setParameter("month", monthYear);
            List<FocusFundPool> results = q.getResultList();
            return results.isEmpty() ? null : results.get(0);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public FocusFundPool getCurrentPool() {
        return getPoolByMonth(getCurrentMonthYear());
    }

    // ===== TRANSACTION HISTORY =====

    public List<FocusFundTransaction> getTransactions(int userId, int limit) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<FocusFundTransaction> q = em.createQuery(
                    "SELECT t FROM FocusFundTransaction t WHERE t.userID = :userId ORDER BY t.createdDate DESC",
                    FocusFundTransaction.class);
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
