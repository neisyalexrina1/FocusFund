package service;

import dao.SocialDAO;
import dao.UserDAO;
import dao.PostDAO;
import model.User;
import model.Post;

import java.util.HashMap;
import java.util.Map;

public class SocialServiceImpl implements SocialService {

    private final SocialDAO socialDAO = new SocialDAO();
    private final NotificationServiceImpl notificationService = new NotificationServiceImpl();
    private final UserDAO userDAO = new UserDAO();
    private final PostDAO postDAO = new PostDAO();

    @Override
    public boolean toggleLike(int postId, int userId) {
        boolean result = socialDAO.toggleLike(postId, userId);
        // Send notification if it's now liked (not unliked)
        if (result && isLiked(postId, userId)) {
            try {
                Post post = postDAO.getPostById(postId);
                if (post != null && post.getUserID() != userId) {
                    User liker = userDAO.getUserById(userId);
                    String likerName = liker != null
                            ? (liker.getFullName() != null ? liker.getFullName() : liker.getUsername())
                            : "Someone";
                    notificationService.notifyLike(post.getUserID(), likerName);
                }
            } catch (Exception e) {
                // Don't fail the like if notification fails
            }
        }
        return result;
    }

    @Override
    public boolean isLiked(int postId, int userId) {
        return socialDAO.isLiked(postId, userId);
    }

    @Override
    public int getLikeCount(int postId) {
        return socialDAO.getLikeCount(postId);
    }

    @Override
    public boolean toggleFollow(int followerId, int followingId) {
        if (followerId == followingId)
            return false;
        boolean result = socialDAO.toggleFollow(followerId, followingId);
        // Send notification if now following (not unfollowing)
        if (result && isFollowing(followerId, followingId)) {
            try {
                User follower = userDAO.getUserById(followerId);
                String followerName = follower != null
                        ? (follower.getFullName() != null ? follower.getFullName() : follower.getUsername())
                        : "Someone";
                notificationService.notifyFollow(followingId, followerName);
            } catch (Exception e) {
                // Don't fail the follow if notification fails
            }
        }
        return result;
    }

    @Override
    public boolean isFollowing(int followerId, int followingId) {
        return socialDAO.isFollowing(followerId, followingId);
    }

    @Override
    public int getFollowerCount(int userId) {
        return socialDAO.getFollowerCount(userId);
    }

    @Override
    public int getFollowingCount(int userId) {
        return socialDAO.getFollowingCount(userId);
    }

    @Override
    public Map<String, Integer> getSocialCounts(int userId) {
        Map<String, Integer> counts = new HashMap<>();
        counts.put("followers", getFollowerCount(userId));
        counts.put("following", getFollowingCount(userId));
        return counts;
    }
}
