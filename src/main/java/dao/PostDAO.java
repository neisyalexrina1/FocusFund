package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.Post;
import model.PostLike;

public class PostDAO extends BaseDAO {

    public boolean createPost(int userId, String content, String imageURL) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Post post = new Post();
            post.setUserID(userId);
            post.setContent(content);
            post.setImageURL(imageURL);
            post.setLikeCount(0);
            post.setCommentCount(0);
            post.setShareCount(0);
            post.setCreatedDate(new Date());
            em.persist(post);
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

    public List<Post> getAllPosts() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT p FROM Post p ORDER BY p.createdDate DESC", Post.class).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public List<Post> getPostsByUser(int userId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Post> q = em.createQuery(
                    "SELECT p FROM Post p WHERE p.userID = :uid ORDER BY p.createdDate DESC", Post.class);
            q.setParameter("uid", userId);
            return q.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public Post getPostById(int postId) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Post.class, postId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public boolean updateLikeCount(int postId, int increment) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Post post = em.find(Post.class, postId);
            if (post == null)
                return false;
            post.setLikeCount(post.getLikeCount() + increment);
            em.merge(post);
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

    public boolean incrementCommentCount(int postId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Post post = em.find(Post.class, postId);
            if (post == null)
                return false;
            post.setCommentCount(post.getCommentCount() + 1);
            em.merge(post);
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

    /**
     * Toggle like: if user already liked → remove like & decrement count.
     * If not liked yet → add like & increment count.
     */
    public boolean toggleLike(int postId, int userId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Post post = em.find(Post.class, postId);
            if (post == null)
                return false;

            // Check if already liked
            List<PostLike> existing = em.createQuery(
                    "SELECT pl FROM PostLike pl WHERE pl.postID = :pid AND pl.userID = :uid", PostLike.class)
                    .setParameter("pid", postId)
                    .setParameter("uid", userId)
                    .getResultList();

            if (!existing.isEmpty()) {
                // Unlike: remove entry + decrement
                em.remove(existing.get(0));
                post.setLikeCount(Math.max(0, post.getLikeCount() - 1));
            } else {
                // Like: add entry + increment
                PostLike like = new PostLike();
                like.setPostID(postId);
                like.setUserID(userId);
                em.persist(like);
                post.setLikeCount(post.getLikeCount() + 1);
            }

            em.merge(post);
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
}
