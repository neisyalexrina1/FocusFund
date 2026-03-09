package service;

import dao.NotificationDAO;
import model.Notification;

import java.util.*;

/**
 * Centralized Notification Service.
 * Called by other services to create notifications.
 * Provides data for navbar bell and notifications.jsp page.
 */
public class NotificationServiceImpl {

    private final NotificationDAO notificationDAO = new NotificationDAO();

    // ===== CREATE notifications from various events =====

    public void notifyStreakAtRisk(int userId, int streakDays, int hoursRemaining) {
        notificationDAO.create(userId, "streak", "🔥",
                "Streak at Risk!",
                "🔥 Your " + streakDays + "-day streak will be lost in " + hoursRemaining
                        + "h! Just 1 minute to save it!",
                "EngagementServlet?action=streakCountdown");
    }

    public void notifyBadgeEarned(int userId, String badgeName) {
        notificationDAO.create(userId, "badge", "🏆",
                "New Badge Earned!",
                "You just earned the \"" + badgeName + "\" badge! 🎉",
                "GamificationServlet?action=badges");
    }

    public void notifyQuestCompleted(int userId, String questName, int coinsEarned) {
        notificationDAO.create(userId, "quest", "🎯",
                "Quest Completed!",
                questName + " — Earned " + coinsEarned + " Focus Coins!",
                "EngagementServlet?action=dailyQuests");
    }

    public void notifyLike(int userId, String likerName) {
        notificationDAO.create(userId, "like", "❤️",
                "New Like",
                likerName + " liked your post",
                "PostServlet");
    }

    public void notifyFollow(int userId, String followerName) {
        notificationDAO.create(userId, "follow", "👤",
                "New Follower",
                followerName + " started following you",
                "ProfileServlet");
    }

    public void notifyBuddyActivity(int userId, String buddyName, String activity) {
        notificationDAO.create(userId, "buddy", "👥",
                "Study Buddy",
                buddyName + " " + activity,
                "EngagementServlet?action=buddyInfo");
    }

    public void notifyLeaderboardRank(int userId, int rank) {
        notificationDAO.create(userId, "leaderboard", "🏅",
                "Leaderboard Update",
                "You're currently Top " + rank + " this month! Keep it up!",
                "LeaderboardServlet");
    }

    public void notifyContractComplete(int userId, double bonus) {
        notificationDAO.create(userId, "contract", "💰",
                "Contract Completed!",
                "Contract completed! Bonus earned: " + String.format("%,.0f", bonus) + " VND!",
                "FocusFundServlet?action=dashboard");
    }

    public void notifySystem(int userId, String title, String message) {
        notificationDAO.create(userId, "system", "ℹ️", title, message, null);
    }

    // ===== READ notifications =====

    public List<Notification> getRecentForBell(int userId) {
        return notificationDAO.getRecent(userId, 5);
    }

    public int getUnreadCount(int userId) {
        return notificationDAO.getUnreadCount(userId);
    }

    public List<Notification> getAllNotifications(int userId) {
        return notificationDAO.getAll(userId, 50);
    }

    // ===== ACTIONS =====

    public void markAllRead(int userId) {
        notificationDAO.markAllRead(userId);
    }

    public void markRead(int notificationId) {
        notificationDAO.markRead(notificationId);
    }
}
