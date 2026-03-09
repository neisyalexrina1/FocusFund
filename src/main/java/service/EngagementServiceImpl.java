package service;

import dao.DailyQuestDAO;
import dao.MicroSessionDAO;
import dao.StudyBuddyDAO;
import model.*;

import java.util.*;

/**
 * Engagement Service — orchestrates Daily Quests, Micro-Sessions, Study Buddy,
 * Streak Countdown, and Onboarding (Tiny Habits).
 * Integrates with GamificationService for coin/EXP rewards.
 */
public class EngagementServiceImpl {

    private final DailyQuestDAO questDAO = new DailyQuestDAO();
    private final MicroSessionDAO microDAO = new MicroSessionDAO();
    private final StudyBuddyDAO buddyDAO = new StudyBuddyDAO();
    private final GamificationService gamificationService = new GamificationServiceImpl();

    // ==================== DAILY QUESTS ====================

    public List<UserDailyQuest> getTodayQuests(int userId) {
        return questDAO.getTodayQuests(userId);
    }

    /**
     * Called by other services when events happen.
     * Auto-advances quest progress and awards coins/EXP for completed quests.
     */
    public List<Map<String, Object>> onEvent(int userId, String questType, int amount) {
        List<Integer> completedIds = questDAO.progressByType(userId, questType, amount);
        List<Map<String, Object>> rewards = new ArrayList<>();

        for (int questId : completedIds) {
            Map<String, Object> reward = new HashMap<>();
            reward.put("questId", questId);
            gamificationService.addCoins(userId, 2);
            gamificationService.addExp(userId, 10);
            reward.put("coinsEarned", 2);
            reward.put("expEarned", 10);
            rewards.add(reward);
        }

        // Notify buddy
        if (!completedIds.isEmpty()) {
            buddyDAO.logActivity(userId, "quest_done",
                    "completed " + completedIds.size() + " daily quest(s)!");
        }

        return rewards;
    }

    public int getCompletedQuestsToday(int userId) {
        return questDAO.getCompletedCountToday(userId);
    }

    // ==================== MICRO SESSIONS ("Just 1 Minute") ====================

    public Map<String, Object> startMicroSession(int userId) {
        Map<String, Object> result = new HashMap<>();
        int sessionId = microDAO.startMicroSession(userId);
        result.put("microSessionId", sessionId);
        result.put("duration", 1);
        result.put("message", "⚡ Just 1 minute! You got this!");

        // Notify buddy
        buddyDAO.logActivity(userId, "session_start",
                "just started a micro-session! 🚀");

        // Progress quest
        questDAO.progressByType(userId, "micro_session", 1);

        return result;
    }

    /**
     * User chose to continue! Returns next duration suggestion.
     */
    public Map<String, Object> escalateMicroSession(int microSessionId, int userId) {
        Map<String, Object> result = new HashMap<>();
        int nextDuration = microDAO.escalate(microSessionId, userId);
        if (nextDuration < 0) {
            result.put("success", false);
            result.put("error", "Session not found or not yours");
            return result;
        }
        result.put("nextDuration", nextDuration);

        String[] encouragements = {
                "Great job! How about 5 more minutes?",
                "You're in the flow! 10 more minutes!",
                "Amazing! Just 15 more minutes!",
                "🔥 Full Pomodoro 25 min! You're incredible!"
        };

        if (nextDuration >= 25) {
            result.put("convertedToPomodoro", true);
            result.put("message", encouragements[3]);
        } else {
            int idx = nextDuration <= 5 ? 0 : nextDuration <= 10 ? 1 : 2;
            result.put("convertedToPomodoro", false);
            result.put("message", encouragements[idx]);
        }

        return result;
    }

    public Map<String, Object> completeMicroSession(int userId, int microSessionId, int actualMinutes) {
        Map<String, Object> result = new HashMap<>();
        MicroSession ms = microDAO.complete(microSessionId, actualMinutes);

        if (ms != null) {
            result.put("actualDuration", ms.getActualDuration());
            result.put("escalations", ms.getEscalations());
            result.put("convertedToPomodoro", ms.isConvertedToPomodoro());

            int coins = 1 + ms.getEscalations();
            gamificationService.addCoins(userId, coins);
            gamificationService.addExp(userId, actualMinutes);
            gamificationService.addStudyMinutes(userId, actualMinutes);

            result.put("coinsEarned", coins);
            result.put("message", ms.isConvertedToPomodoro()
                    ? "🏆 From 1 minute to a full Pomodoro! Incredible! +" + coins + " coins"
                    : "✅ Completed " + actualMinutes + " min! +" + coins + " coins");

            if (ms.isConvertedToPomodoro()) {
                questDAO.progressByType(userId, "pomodoro", 1);
            }

            buddyDAO.logActivity(userId, "session_complete",
                    "completed " + actualMinutes + " min from a micro-session! 🎯");
        }

        return result;
    }

    public Map<String, Object> getMicroSessionStats(int userId) {
        Map<String, Object> stats = new HashMap<>();
        long conversions = microDAO.getConversionCount(userId);
        List<MicroSession> recent = microDAO.getUserMicroSessions(userId, 10);
        stats.put("totalConversions", conversions);
        stats.put("recentSessions", recent);
        return stats;
    }

    // ==================== STUDY BUDDY ====================

    public Map<String, Object> pairWithBuddy(int userId, int buddyUserId) {
        Map<String, Object> result = new HashMap<>();

        if (userId == buddyUserId) {
            throw new ValidationException("Cannot pair with yourself!");
        }

        StudyBuddy existing = buddyDAO.getActiveBuddy(userId);
        if (existing != null) {
            throw new ValidationException("You already have a study buddy!");
        }

        int pairId = buddyDAO.createBuddyPair(userId, buddyUserId);
        result.put("success", pairId > 0);
        result.put("buddyPairId", pairId);

        if (pairId > 0) {
            buddyDAO.logActivity(userId, "buddy_paired", "paired as study buddies! 🤝");
        }

        return result;
    }

    public Map<String, Object> getBuddyInfo(int userId) {
        Map<String, Object> result = new HashMap<>();
        StudyBuddy pair = buddyDAO.getActiveBuddy(userId);
        result.put("hasBuddy", pair != null);

        if (pair != null) {
            User buddyUser = buddyDAO.getBuddyUser(userId);
            result.put("buddyName", buddyUser != null ? buddyUser.getFullName() : "Unknown");
            result.put("buddyUsername", buddyUser != null ? buddyUser.getUsername() : "");
            result.put("totalSessionsTogether", pair.getTotalSessionsTogether());

            List<BuddyActivity> unread = buddyDAO.getUnreadNotifications(userId);
            result.put("unreadCount", unread.size());
            result.put("notifications", unread);
        }

        return result;
    }

    public boolean endBuddyPair(int userId) {
        return buddyDAO.endBuddyPair(userId);
    }

    public void markBuddyNotificationsRead(int userId) {
        buddyDAO.markNotificationsRead(userId);
    }

    // ==================== STREAK COUNTDOWN ====================

    public Map<String, Object> getStreakCountdown(int userId) {
        Map<String, Object> result = new HashMap<>();
        DailyStreak streak = gamificationService.getStreak(userId);

        result.put("currentStreak", streak.getCurrentStreak());
        result.put("longestStreak", streak.getLongestStreak());

        if (streak.getCurrentStreak() > 0 && streak.getLastStudyDate() != null) {
            Calendar midnight = Calendar.getInstance();
            midnight.add(Calendar.DAY_OF_YEAR, 1);
            midnight.set(Calendar.HOUR_OF_DAY, 0);
            midnight.set(Calendar.MINUTE, 0);
            midnight.set(Calendar.SECOND, 0);

            long msRemaining = midnight.getTimeInMillis() - System.currentTimeMillis();
            long hoursRemaining = msRemaining / (1000 * 60 * 60);
            long minutesRemaining = (msRemaining / (1000 * 60)) % 60;

            result.put("hoursRemaining", hoursRemaining);
            result.put("minutesRemaining", minutesRemaining);
            result.put("isAtRisk", hoursRemaining < 4);

            Calendar today = Calendar.getInstance();
            Calendar lastStudy = Calendar.getInstance();
            lastStudy.setTime(streak.getLastStudyDate());
            boolean studiedToday = today.get(Calendar.YEAR) == lastStudy.get(Calendar.YEAR)
                    && today.get(Calendar.DAY_OF_YEAR) == lastStudy.get(Calendar.DAY_OF_YEAR);

            result.put("studiedToday", studiedToday);

            if (!studiedToday && streak.getCurrentStreak() > 0) {
                result.put("urgentMessage", "🔥 Your " + streak.getCurrentStreak()
                        + "-day streak will be lost in " + hoursRemaining + "h " + minutesRemaining
                        + "m! Just 1 minute to save it!");
            }
        } else {
            result.put("hoursRemaining", 24);
            result.put("minutesRemaining", 0);
            result.put("isAtRisk", false);
            result.put("studiedToday", false);
        }

        return result;
    }

    // ==================== ONBOARDING (Tiny Habits) ====================

    public Map<String, Object> getOnboardingStatus(int userId) {
        Map<String, Object> result = new HashMap<>();
        UserGamification gData = gamificationService.getGamificationData(userId);

        result.put("step1_chooseSubject", true);
        result.put("step2_reviewFlashcard", gData.getTotalExp() > 0);
        result.put("step3_startMicroSession", gData.getTotalStudyMinutes() > 0);
        result.put("step4_completePomodoro", gData.getTotalStudyMinutes() >= 25);
        result.put("step5_postStatus", false);

        int completed = 1;
        if (gData.getTotalExp() > 0)
            completed++;
        if (gData.getTotalStudyMinutes() > 0)
            completed++;
        if (gData.getTotalStudyMinutes() >= 25)
            completed++;

        result.put("completedSteps", completed);
        result.put("totalSteps", 5);
        result.put("percentComplete", (completed * 100) / 5);

        if (gData.getTotalStudyMinutes() == 0) {
            result.put("nextStep", "Try the 'Just 1 Minute' button to get started! ⚡");
            result.put("nextAction", "micro_session");
        } else if (gData.getTotalStudyMinutes() < 25) {
            result.put("nextStep", "You tried a micro-session! Now try a full 25-min Pomodoro? 🎯");
            result.put("nextAction", "pomodoro");
        } else {
            result.put("nextStep", "Share your accomplishments! ✍️");
            result.put("nextAction", "post");
        }

        return result;
    }
}
