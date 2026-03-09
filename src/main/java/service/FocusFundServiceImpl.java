package service;

import dao.FocusFundDAO;
import dao.LeaderboardDAO;
import dao.UserGamificationDAO;
import model.*;

import java.util.*;

public class FocusFundServiceImpl implements FocusFundService {

    private final FocusFundDAO focusFundDAO = new FocusFundDAO();
    private final GamificationService gamificationService = new GamificationServiceImpl();
    private final UserGamificationDAO gamificationDAO = new UserGamificationDAO();
    private final LeaderboardDAO leaderboardDAO = new LeaderboardDAO();

    // Exchange rate: 100 Focus Coins = 10,000 VND
    private static final double VND_PER_COIN = 100.0;
    private static final int MAX_EXCHANGE_COINS_PER_MONTH = 500;

    @Override
    public double getBalance(int userId) {
        return focusFundDAO.getBalance(userId);
    }

    @Override
    public boolean deposit(int userId, double amount) {
        if (amount <= 0)
            return false;
        return focusFundDAO.deposit(userId, amount);
    }

    @Override
    public boolean withdraw(int userId, double amount) {
        if (amount <= 0)
            return false;
        double balance = focusFundDAO.getBalance(userId);
        if (balance < amount) {
            throw new ValidationException("Insufficient balance! Current: " + String.format("%,.0f", balance) + " VND");
        }
        return focusFundDAO.withdraw(userId, amount);
    }

    @Override
    public int createContract(int userId, double stakeAmount, int penaltyPercent,
            String goalType, int goalValue, int durationDays) {
        if (stakeAmount <= 0) {
            throw new ValidationException("Stake amount must be greater than 0");
        }
        double balance = focusFundDAO.getBalance(userId);
        if (balance < stakeAmount) {
            throw new ValidationException("Insufficient balance! Need " + String.format("%,.0f", stakeAmount)
                    + " VND, current: " + String.format("%,.0f", balance) + " VND");
        }

        // Check no active contract already
        FocusFundContract active = focusFundDAO.getActiveContract(userId);
        if (active != null) {
            throw new ValidationException("You already have an active contract. Please complete or cancel it first.");
        }

        return focusFundDAO.createContract(userId, stakeAmount, penaltyPercent, goalType, goalValue, durationDays);
    }

    @Override
    public FocusFundContract getActiveContract(int userId) {
        return focusFundDAO.getActiveContract(userId);
    }

    @Override
    public List<FocusFundContract> getUserContracts(int userId) {
        return focusFundDAO.getUserContracts(userId);
    }

    @Override
    public Map<String, Object> onSessionComplete(int userId, int focusMinutes, Integer sessionId) {
        Map<String, Object> result = new HashMap<>();

        // 1. Gamification rewards (coins, EXP, streak, badges, mystery reward)
        Map<String, Object> gamificationResult = gamificationService.onSessionComplete(userId, focusMinutes, sessionId);
        result.putAll(gamificationResult);

        // 2. Contract progress (if active)
        FocusFundContract contract = focusFundDAO.getActiveContract(userId);
        if (contract != null) {
            boolean contractCompleted = focusFundDAO.recordContractDay(contract.getContractID());
            result.put("hasContract", true);
            result.put("contractDaysCompleted", contract.getDaysCompleted() + 1);
            result.put("contractDurationDays", contract.getDurationDays());

            if (contractCompleted) {
                // Contract completed — stake refunded + 5% bonus
                result.put("contractCompleted", true);
                double bonus = contract.getStakeAmount() * 0.05;
                result.put("contractRefund", contract.getStakeAmount());
                result.put("contractBonus", bonus);
                result.put("message",
                        "🎉 Contract completed! Refund " + String.format("%,.0f", contract.getStakeAmount())
                                + " + bonus " + String.format("%,.0f", bonus) + " VND!");
            } else {
                result.put("contractCompleted", false);
                int remaining = contract.getDurationDays() - (contract.getDaysCompleted() + 1);
                result.put("contractDaysRemaining", remaining);
            }
        } else {
            result.put("hasContract", false);
        }

        // 3. Current balance
        result.put("balance", focusFundDAO.getBalance(userId));

        return result;
    }

    @Override
    public Map<String, Object> onSessionFailed(int userId, Integer sessionId) {
        Map<String, Object> result = new HashMap<>();

        FocusFundContract contract = focusFundDAO.getActiveContract(userId);
        if (contract == null) {
            result.put("hasPenalty", false);
            result.put("message", "No active contract");
            return result;
        }

        double penaltyAmount = focusFundDAO.applyPenalty(contract.getContractID());
        result.put("hasPenalty", true);
        result.put("penaltyAmount", penaltyAmount);
        result.put("penaltyPercent", contract.getPenaltyPercent());
        result.put("remainingStake", contract.getStakeAmount() - penaltyAmount);
        result.put("balance", focusFundDAO.getBalance(userId));

        // Show pool info
        FocusFundPool pool = focusFundDAO.getCurrentPool();
        if (pool != null) {
            result.put("leaderboardPool", pool.getLeaderboardPool());
            result.put("totalPoolThisMonth", pool.getTotalPenalties());
        }

        result.put("message", "⚠️ Penalty " + contract.getPenaltyPercent() + "%: -"
                + String.format("%,.0f", penaltyAmount) + " VND → Leaderboard Pool");

        return result;
    }

    @Override
    public Map<String, Object> exchangeCoinsToVnd(int userId, int coins) {
        Map<String, Object> result = new HashMap<>();

        if (coins <= 0 || coins > MAX_EXCHANGE_COINS_PER_MONTH) {
            throw new ValidationException(
                    "Invalid coins amount (max " + MAX_EXCHANGE_COINS_PER_MONTH + " coins/month)");
        }

        // Check user has enough coins
        UserGamification gData = gamificationDAO.getOrCreate(userId);
        if (gData.getFocusCoins() < coins) {
            throw new ValidationException("Not enough Focus Coins! You have " + gData.getFocusCoins() + " coins");
        }

        double vndAmount = coins * VND_PER_COIN;

        // Deduct coins
        gamificationService.spendCoins(userId, coins);

        // Add VND
        focusFundDAO.exchangeCoinsToVnd(userId, coins, vndAmount);

        result.put("success", true);
        result.put("coinsSpent", coins);
        result.put("vndReceived", vndAmount);
        result.put("remainingCoins", gData.getFocusCoins() - coins);
        result.put("newBalance", focusFundDAO.getBalance(userId));
        result.put("message", "✅ Exchanged " + coins + " Focus Coins → " + String.format("%,.0f", vndAmount) + " VND!");

        return result;
    }

    @Override
    public Map<String, Object> distributeMonthlyRewards() {
        Map<String, Object> result = new HashMap<>();

        FocusFundPool pool = focusFundDAO.getCurrentPool();
        if (pool == null || pool.isDistributed()) {
            result.put("success", false);
            result.put("message", "No pool available or already distributed");
            return result;
        }

        double prizePool = pool.getLeaderboardPool();
        if (prizePool <= 0) {
            result.put("success", false);
            result.put("message", "Prize pool is empty");
            return result;
        }

        // Top 3: 50%, 30%, 20% of leaderboard pool
        List<LeaderboardMonthly> top = leaderboardDAO.getMonthlyTop(3);
        double[] splits = { 0.50, 0.30, 0.20 };
        List<Map<String, Object>> winners = new ArrayList<>();

        for (int i = 0; i < Math.min(top.size(), 3); i++) {
            double prize = prizePool * splits[i];
            LeaderboardMonthly entry = top.get(i);

            // Award VND
            focusFundDAO.deposit(entry.getUserID(), prize);

            Map<String, Object> winner = new HashMap<>();
            winner.put("rank", i + 1);
            winner.put("userId", entry.getUserID());
            winner.put("prize", prize);
            winners.add(winner);
        }

        result.put("success", true);
        result.put("totalPrize", prizePool);
        result.put("winners", winners);

        return result;
    }

    @Override
    public FocusFundPool getCurrentPool() {
        return focusFundDAO.getCurrentPool();
    }

    @Override
    public List<FocusFundTransaction> getTransactions(int userId, int limit) {
        return focusFundDAO.getTransactions(userId, limit);
    }

    @Override
    public Map<String, Object> getDashboard(int userId) {
        Map<String, Object> dashboard = new HashMap<>();

        // Balance
        dashboard.put("balance", focusFundDAO.getBalance(userId));

        // Active contract
        FocusFundContract contract = focusFundDAO.getActiveContract(userId);
        dashboard.put("activeContract", contract);

        // Gamification data
        UserGamification gData = gamificationService.getGamificationData(userId);
        dashboard.put("focusCoins", gData.getFocusCoins());
        dashboard.put("totalExp", gData.getTotalExp());
        dashboard.put("currentRank", gData.getCurrentRank());
        dashboard.put("totalStudyHours", gData.getTotalStudyHours());

        // Streak
        DailyStreak streak = gamificationService.getStreak(userId);
        dashboard.put("currentStreak", streak.getCurrentStreak());
        dashboard.put("longestStreak", streak.getLongestStreak());

        // Pool
        FocusFundPool pool = focusFundDAO.getCurrentPool();
        dashboard.put("leaderboardPool", pool != null ? pool.getLeaderboardPool() : 0);

        // Exchange rate info
        dashboard.put("coinToVndRate", VND_PER_COIN);
        dashboard.put("maxExchangePerMonth", MAX_EXCHANGE_COINS_PER_MONTH);

        // Recent transactions
        dashboard.put("recentTransactions", focusFundDAO.getTransactions(userId, 5));

        return dashboard;
    }
}
