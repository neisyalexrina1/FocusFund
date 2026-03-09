package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.Comment;

public class CommentDAO extends BaseDAO {

    public boolean createComment(int postId, int userId, String content) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Comment comment = new Comment();
            comment.setPostID(postId);
            comment.setUserID(userId);
            comment.setContent(content);
            comment.setCreatedDate(new Date());
            em.persist(comment);
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

    public List<Comment> getCommentsByPost(int postId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Comment> q = em.createQuery(
                    "SELECT c FROM Comment c WHERE c.postID = :pid ORDER BY c.createdDate ASC", Comment.class);
            q.setParameter("pid", postId);
            return q.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }
}
