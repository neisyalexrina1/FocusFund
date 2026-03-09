package service;

import java.util.Map;

public interface SocialService {
    // Likes
    boolean toggleLike(int postId, int userId);

    boolean isLiked(int postId, int userId);

    int getLikeCount(int postId);

    // Follows
    boolean toggleFollow(int followerId, int followingId);

    boolean isFollowing(int followerId, int followingId);

    int getFollowerCount(int userId);

    int getFollowingCount(int userId);

    Map<String, Integer> getSocialCounts(int userId);
}
