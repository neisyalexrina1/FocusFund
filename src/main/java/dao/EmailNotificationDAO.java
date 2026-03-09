package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import model.EmailNotification;

import java.util.ArrayList;
import java.util.List;

public class EmailNotificationDAO extends BaseDAO {

    public boolean save(EmailNotification notification) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(notification);
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

    public List<EmailNotification> getByUser(int userId) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT e FROM EmailNotification e WHERE e.userID = :uid ORDER BY e.sentDate DESC",
                    EmailNotification.class)
                    .setParameter("uid", userId)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public List<EmailNotification> getRecent(int limit) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT e FROM EmailNotification e ORDER BY e.sentDate DESC",
                    EmailNotification.class)
                    .setMaxResults(limit)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }
}
