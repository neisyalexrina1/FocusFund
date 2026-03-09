package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import java.util.ArrayList;
import java.util.List;
import model.User;

public class UserDAO extends BaseDAO {

    public User login(String username, String password) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<User> q = em.createQuery(
                    "SELECT u FROM User u WHERE u.username = :username AND u.passwordHash = :password", User.class);
            q.setParameter("username", username);
            q.setParameter("password", password);
            List<User> results = q.getResultList();
            return results.isEmpty() ? null : results.get(0);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public boolean register(String username, String password, String fullName, String email) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            User user = new User();
            user.setUsername(username);
            user.setPasswordHash(password);
            user.setFullName(fullName);
            user.setEmail(email);
            user.setRole("user");
            user.setBalance(0);
            user.setCreatedDate(new java.util.Date());
            em.persist(user);
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

    public User getUserById(int userId) {
        if (userId <= 0) {
            return createDeletedUserPlaceholder();
        }
        EntityManager em = getEntityManager();
        try {
            User user = em.find(User.class, userId);
            if (user == null) {
                return createDeletedUserPlaceholder();
            }
            return user;
        } catch (Exception e) {
            e.printStackTrace();
            return createDeletedUserPlaceholder();
        } finally {
            em.close();
        }
    }

    private User createDeletedUserPlaceholder() {
        User deletedUser = new User();
        deletedUser.setUserID(0);
        deletedUser.setUsername("Deleted User");
        deletedUser.setFullName("Deleted User");
        deletedUser.setProfileImage("assets/images/default-avatar.png");
        return deletedUser;
    }

    public User findByUsername(String username) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<User> q = em.createQuery(
                    "SELECT u FROM User u WHERE u.username = :username", User.class);
            q.setParameter("username", username);
            List<User> results = q.getResultList();
            return results.isEmpty() ? null : results.get(0);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public User findByEmail(String email) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<User> q = em.createQuery(
                    "SELECT u FROM User u WHERE u.email = :email", User.class);
            q.setParameter("email", email);
            List<User> results = q.getResultList();
            return results.isEmpty() ? null : results.get(0);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public List<User> getAllUsers() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT u FROM User u ORDER BY u.userID", User.class).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public boolean updateProfile(int userId, String fullName, String username, String email,
            String bio, String location, String website, String websiteName) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            User user = em.find(User.class, userId);
            if (user == null)
                return false;
            user.setFullName(fullName);
            user.setUsername(username);
            user.setEmail(email);
            user.setBio(bio);
            user.setLocation(location);
            user.setWebsite(website);
            user.setWebsiteName(websiteName);
            em.merge(user);
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

    public boolean updatePassword(int userId, String newPassword) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            User user = em.find(User.class, userId);
            if (user == null)
                return false;
            user.setPasswordHash(newPassword);
            em.merge(user);
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

    public boolean updateProfileImage(int userId, String imageUrl) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            User user = em.find(User.class, userId);
            if (user == null)
                return false;
            user.setProfileImage(imageUrl);
            em.merge(user);
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

    public boolean updateBalance(int userId, double amount) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            User user = em.find(User.class, userId);
            if (user == null)
                return false;
            user.setBalance(user.getBalance() + amount);
            em.merge(user);
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

    public boolean deleteUser(int userId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            User user = em.find(User.class, userId);
            if (user == null)
                return false;
            em.remove(user);
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

    public boolean updateRole(int userId, String role) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            User user = em.find(User.class, userId);
            if (user == null)
                return false;
            user.setRole(role);
            em.merge(user);
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
