package service;

import dao.*;
import model.*;

import java.util.*;

public class GamificationServiceImpl implements GamificationService {

    private final UserGamificationDAO gamificationDAO = new UserGamificationDAO();
    private final DailyStreakDAO streakDAO = new DailyStreakDAO();
    private final BadgeDAO badgeDAO = new BadgeDAO();
    private final RewardDAO rewardDAO = new RewardDAO();
    private final LeaderboardDAO leaderboardDAO = new LeaderboardDAO();

    // Coin rewards
    private static final int COINS_PER_SESSION = 5;
    private static final int COINS_DAILY_LOGIN = 1;
    private static final int COINS_STREAK_3 = 10;
    private static final int COINS_STREAK_7 = 25;
    private static final int COINS_STREAK_30 = 100;

    // EXP rewards
    private static final int EXP_PER_SESSION = 10;
    private static final int EXP_PER_MINUTE = 1;

    @Override
    public UserGamification getGamificationData(int userId) {
        return gamificationDAO.getOrCreate(userId);
    }

    @Override
    public boolean addCoins(int userId, int coins) {
        boolean result = gamificationDAO.addCoins(userId, coins);
        if (result) {
            leaderboardDAO.addMonthlyCoins(userId, coins);
        }
        return result;
    }

    @Override
    public boolean spendCoins(int userId, int coins) {
        return gamificationDAO.spendCoins(userId, coins);
    }

    @Override
    public boolean addExp(int userId, int exp) {
        return gamificationDAO.addExp(userId, exp);
    }

    @Override
    public boolean addStudyMinutes(int userId, int minutes) {
        boolean result = gamificationDAO.addStudyMinutes(userId, minutes);
        if (result) {
            leaderboardDAO.addMonthlyStudyMinutes(userId, minutes);
        }
        return result;
    }

    @Override
    public Map<String, Object> onSessionComplete(int userId, int focusMinutes, Integer sessionId) {
        Map<String, Object> result = new HashMap<>();

        // 1. Award coins for completing session
        int coinsEarned = COINS_PER_SESSION;
        addCoins(userId, coinsEarned);
        result.put("coinsEarned", coinsEarned);

        // 2. Award EXP based on minutes
        int expEarned = EXP_PER_SESSION + (focusMinutes * EXP_PER_MINUTE);
        addExp(userId, expEarned);
        result.put("expEarned", expEarned);

        // 3. Add study minutes & auto-update rank
        addStudyMinutes(userId, focusMinutes);

        // 4. Update streak
        int streakCount = streakDAO.recordStudyDay(userId);
        result.put("currentStreak", streakCount);

        // 5. Streak bonus coins
        int streakBonus = 0;
        if (streakCount == 3)
            streakBonus = COINS_STREAK_3;
        else if (streakCount == 7)
            streakBonus = COINS_STREAK_7;
        else if (streakCount == 30)
            streakBonus = COINS_STREAK_30;

        if (streakBonus > 0) {
            addCoins(userId, streakBonus);
            result.put("streakBonus", streakBonus);
        }

        // 6. Check and award badges
        List<Badge> newBadges = checkAndAwardBadges(userId);
        if (!newBadges.isEmpty()) {
            result.put("newBadges", newBadges);
        }

        // 7. Mystery reward
        Map<String, Object> reward = claimMysteryReward(userId, sessionId);
        result.put("mysteryReward", reward);

        // 8. Updated gamification data
        UserGamification gData = getGamificationData(userId);
        result.put("totalCoins", gData.getFocusCoins());
        result.put("totalExp", gData.getTotalExp());
        result.put("currentRank", gData.getCurrentRank());
        result.put("totalStudyHours", gData.getTotalStudyHours());

        return result;
    }

    @Override
    public Map<String, Object> claimDailyLogin(int userId) {
        Map<String, Object> result = new HashMap<>();

        // Award 1 coin for daily login
        addCoins(userId, COINS_DAILY_LOGIN);
        result.put("coinsEarned", COINS_DAILY_LOGIN);

        // Update streak
        int streakCount = streakDAO.recordStudyDay(userId);
        result.put("currentStreak", streakCount);

        UserGamification gData = getGamificationData(userId);
        result.put("totalCoins", gData.getFocusCoins());

        return result;
    }

    @Override
    public DailyStreak getStreak(int userId) {
        return streakDAO.getOrCreate(userId);
    }

    @Override
    public List<Badge> getAllBadges() {
        return badgeDAO.getAllBadges();
    }

    @Override
    public List<UserBadge> getUserBadges(int userId) {
        return badgeDAO.getUserBadges(userId);
    }

    @Override
    public List<Badge> checkAndAwardBadges(int userId) {
        List<Badge> newBadges = new ArrayList<>();
        List<Badge> allBadges = badgeDAO.getAllBadges();
        UserGamification gData = getGamificationData(userId);
        DailyStreak streak = getStreak(userId);

        for (Badge badge : allBadges) {
            if (badgeDAO.hasUserBadge(userId, badge.getBadgeID()))
                continue;

            boolean earned = false;
            switch (badge.getRequirementType()) {
                case "streak_days":
                    earned = streak.getCurrentStreak() >= badge.getRequirementValue()
                            || streak.getLongestStreak() >= badge.getRequirementValue();
                    break;
                case "total_hours":
                    earned = gData.getTotalStudyHours() >= badge.getRequirementValue();
                    break;
                case "coins_earned":
                    earned = gData.getFocusCoins() >= badge.getRequirementValue();
                    break;
                case "total_sessions":
                    earned = gData.getTotalExp() > 0; // simplified: any exp = at least 1 session
                    break;
            }

            if (earned) {
                badgeDAO.awardBadge(userId, badge.getBadgeID());
                newBadges.add(badge);
            }
        }

        return newBadges;
    }

    @Override
    public Map<String, Object> claimMysteryReward(int userId, Integer sessionId) {
        Map<String, Object> result = new HashMap<>();

        Reward reward = rewardDAO.getRandomReward();
        if (reward == null) {
            result.put("type", "none");
            result.put("content", "Congratulations on completing a study session! 🎉");
            return result;
        }

        rewardDAO.saveUserReward(userId, reward.getRewardID(), sessionId);

        result.put("type", reward.getRewardType());
        result.put("content", reward.getContent());
        result.put("rarity", reward.getRarity());

        // If bonus coins, award them
        if (reward.getBonusCoins() > 0) {
            addCoins(userId, reward.getBonusCoins());
            result.put("bonusCoins", reward.getBonusCoins());
        }

        return result;
    }

    @Override
    public List<UserReward> getRecentRewards(int userId, int limit) {
        return rewardDAO.getUserRewards(userId, limit);
    }
}
