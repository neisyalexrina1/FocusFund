package service;

import model.UserGamification;
import model.DailyStreak;
import model.Badge;
import model.UserBadge;
import model.Reward;
import model.UserReward;

import java.util.List;
import java.util.Map;

public interface GamificationService {

    // === Core Gamification ===
    UserGamification getGamificationData(int userId);

    boolean addCoins(int userId, int coins);

    boolean spendCoins(int userId, int coins);

    boolean addExp(int userId, int exp);

    boolean addStudyMinutes(int userId, int minutes);

    // === Session Completion (main integration point) ===
    /**
     * Called when a user completes a Pomodoro session (20-25 min).
     * Awards coins, exp, updates streak, checks badges, gives mystery reward.
     * Returns a map with all the results.
     */
    Map<String, Object> onSessionComplete(int userId, int focusMinutes, Integer sessionId);

    // === Daily Login Bonus ===
    Map<String, Object> claimDailyLogin(int userId);

    // === Streaks ===
    DailyStreak getStreak(int userId);

    // === Badges ===
    List<Badge> getAllBadges();

    List<UserBadge> getUserBadges(int userId);

    List<Badge> checkAndAwardBadges(int userId);

    // === Mystery Rewards ===
    Map<String, Object> claimMysteryReward(int userId, Integer sessionId);

    List<UserReward> getRecentRewards(int userId, int limit);
}
