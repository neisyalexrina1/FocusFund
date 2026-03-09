package service;

import model.FocusFundContract;
import model.FocusFundPool;
import model.FocusFundTransaction;

import java.util.List;
import java.util.Map;

public interface FocusFundService {

    // === Balance ===
    double getBalance(int userId);

    boolean deposit(int userId, double amount);

    boolean withdraw(int userId, double amount);

    // === Smart Contracts ===
    int createContract(int userId, double stakeAmount, int penaltyPercent,
            String goalType, int goalValue, int durationDays);

    FocusFundContract getActiveContract(int userId);

    List<FocusFundContract> getUserContracts(int userId);

    // === Central Session Endpoints (delegates to GamificationService) ===
    /**
     * Called when user completes a study session.
     * 1. Updates contract progress (if active)
     * 2. Awards coins + EXP + streak + badges + mystery reward
     * 3. Updates leaderboard
     * Returns unified response with all results.
     */
    Map<String, Object> onSessionComplete(int userId, int focusMinutes, Integer sessionId);

    /**
     * Called when user fails (idle/quit during active contract).
     * Applies penalty and splits into pool.
     */
    Map<String, Object> onSessionFailed(int userId, Integer sessionId);

    // === Coin Exchange ===
    Map<String, Object> exchangeCoinsToVnd(int userId, int coins);

    // === Monthly Distribution ===
    Map<String, Object> distributeMonthlyRewards();

    // === Pool & Transactions ===
    FocusFundPool getCurrentPool();

    List<FocusFundTransaction> getTransactions(int userId, int limit);

    // === Dashboard ===
    Map<String, Object> getDashboard(int userId);
}
