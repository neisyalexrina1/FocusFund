package service;

import dao.EmailNotificationDAO;
import dao.UserDAO;
import model.EmailNotification;
import model.User;

/**
 * Email notification service — logs notifications to DB.
 * Actual email sending can be integrated via SMTP/webhook.
 */
public class EmailNotificationService {

    private final EmailNotificationDAO emailDAO;
    private final UserDAO userDAO;

    public EmailNotificationService() {
        this.emailDAO = new EmailNotificationDAO();
        this.userDAO = new UserDAO();
    }

    /**
     * Sends a streak warning email.
     */
    public boolean sendStreakWarning(int userId) {
        User user = userDAO.getUserById(userId);
        if (user == null || user.getEmail() == null)
            return false;

        EmailNotification notification = new EmailNotification();
        notification.setUserID(userId);
        notification.setType("streak_warning");
        notification.setSubject("Your study streak is about to break!");

        // TODO: Integrate actual email sending via SMTP or webhook
        boolean saved = emailDAO.save(notification);
        if (saved) {
            notification.setStatus("sent");
        } else {
            notification.setStatus("failed");
        }
        return saved;
    }

    /**
     * Sends a challenge completion notification.
     */
    public boolean sendChallengeComplete(int userId, String challengeName) {
        User user = userDAO.getUserById(userId);
        if (user == null || user.getEmail() == null)
            return false;

        EmailNotification notification = new EmailNotification();
        notification.setUserID(userId);
        notification.setType("challenge_complete");
        notification.setSubject("Congratulations! You completed: " + challengeName);

        return emailDAO.save(notification);
    }

    /**
     * Sends a buddy nudge notification.
     */
    public boolean sendBuddyNudge(int userId, String buddyName) {
        User user = userDAO.getUserById(userId);
        if (user == null || user.getEmail() == null)
            return false;

        EmailNotification notification = new EmailNotification();
        notification.setUserID(userId);
        notification.setType("buddy_nudge");
        notification.setSubject(buddyName + " nudged you to study!");

        return emailDAO.save(notification);
    }
}
