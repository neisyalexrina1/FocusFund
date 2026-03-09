package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import model.Follow;
import model.PostLike;

import java.util.ArrayList;
import java.util.List;

public class SocialDAO extends BaseDAO {

    // ===== Post Likes =====

    public boolean toggleLike(int postId, int userId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            TypedQuery<PostLike> q = em.createQuery(
                    "SELECT pl FROM PostLike pl WHERE pl.postID = :postId AND pl.userID = :userId", PostLike.class);
            q.setParameter("postId", postId);
            q.setParameter("userId", userId);
            List<PostLike> results = q.getResultList();

            if (results.isEmpty()) {
                // Like
                PostLike like = new PostLike();
                like.setPostID(postId);
                like.setUserID(userId);
                em.persist(like);
            } else {
                // Unlike
                em.remove(results.get(0));
            }
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

    public boolean isLiked(int postId, int userId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Long> q = em.createQuery(
                    "SELECT COUNT(pl) FROM PostLike pl WHERE pl.postID = :postId AND pl.userID = :userId", Long.class);
            q.setParameter("postId", postId);
            q.setParameter("userId", userId);
            return q.getSingleResult() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public int getLikeCount(int postId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Long> q = em.createQuery(
                    "SELECT COUNT(pl) FROM PostLike pl WHERE pl.postID = :postId", Long.class);
            q.setParameter("postId", postId);
            return q.getSingleResult().intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    // ===== Follows =====

    public boolean toggleFollow(int followerId, int followingId) {
        if (followerId == followingId)
            return false;
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            TypedQuery<Follow> q = em.createQuery(
                    "SELECT f FROM Follow f WHERE f.followerID = :followerId AND f.followingID = :followingId",
                    Follow.class);
            q.setParameter("followerId", followerId);
            q.setParameter("followingId", followingId);
            List<Follow> results = q.getResultList();

            if (results.isEmpty()) {
                Follow follow = new Follow();
                follow.setFollowerID(followerId);
                follow.setFollowingID(followingId);
                em.persist(follow);
            } else {
                em.remove(results.get(0));
            }
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

    public boolean isFollowing(int followerId, int followingId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Long> q = em.createQuery(
                    "SELECT COUNT(f) FROM Follow f WHERE f.followerID = :followerId AND f.followingID = :followingId",
                    Long.class);
            q.setParameter("followerId", followerId);
            q.setParameter("followingId", followingId);
            return q.getSingleResult() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public int getFollowerCount(int userId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Long> q = em.createQuery(
                    "SELECT COUNT(f) FROM Follow f WHERE f.followingID = :userId", Long.class);
            q.setParameter("userId", userId);
            return q.getSingleResult().intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    public int getFollowingCount(int userId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Long> q = em.createQuery(
                    "SELECT COUNT(f) FROM Follow f WHERE f.followerID = :userId", Long.class);
            q.setParameter("userId", userId);
            return q.getSingleResult().intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    public List<Integer> getFollowerIds(int userId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Integer> q = em.createQuery(
                    "SELECT f.followerID FROM Follow f WHERE f.followingID = :userId", Integer.class);
            q.setParameter("userId", userId);
            return q.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public List<Integer> getFollowingIds(int userId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Integer> q = em.createQuery(
                    "SELECT f.followingID FROM Follow f WHERE f.followerID = :userId", Integer.class);
            q.setParameter("userId", userId);
            return q.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }
}
