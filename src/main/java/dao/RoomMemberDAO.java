package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.RoomMember;

public class RoomMemberDAO extends BaseDAO {

    public boolean addMember(int roomID, int userID, String role) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            RoomMember member = new RoomMember();
            member.setRoomID(roomID);
            member.setUserID(userID);
            member.setRole(role);
            member.setJoinedAt(new Date());
            em.persist(member);
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

    public boolean removeMember(int roomID, int userID) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            int deleted = em.createQuery(
                    "DELETE FROM RoomMember m WHERE m.roomID = :rid AND m.userID = :uid")
                    .setParameter("rid", roomID)
                    .setParameter("uid", userID)
                    .executeUpdate();
            tx.commit();
            return deleted > 0;
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public boolean removeAllMembers(int roomID) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.createQuery("DELETE FROM RoomMember m WHERE m.roomID = :rid")
                    .setParameter("rid", roomID)
                    .executeUpdate();
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

    public List<RoomMember> getMembersByRoom(int roomID) {
        EntityManager em = getEntityManager();
        try {
            List<RoomMember> members = em.createQuery(
                    "SELECT m FROM RoomMember m WHERE m.roomID = :rid ORDER BY m.role ASC, m.joinedAt ASC",
                    RoomMember.class)
                    .setParameter("rid", roomID)
                    .getResultList();

            // Load user display names
            for (RoomMember member : members) {
                Object[] userInfo = (Object[]) em.createQuery(
                        "SELECT u.username, u.fullName FROM User u WHERE u.userID = :uid")
                        .setParameter("uid", member.getUserID())
                        .getSingleResult();
                member.setUsername((String) userInfo[0]);
                member.setFullName((String) userInfo[1]);
            }
            return members;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public RoomMember getMember(int roomID, int userID) {
        EntityManager em = getEntityManager();
        try {
            List<RoomMember> results = em.createQuery(
                    "SELECT m FROM RoomMember m WHERE m.roomID = :rid AND m.userID = :uid",
                    RoomMember.class)
                    .setParameter("rid", roomID)
                    .setParameter("uid", userID)
                    .getResultList();
            return results.isEmpty() ? null : results.get(0);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public boolean isUserHostingAnyRoom(int userID) {
        EntityManager em = getEntityManager();
        try {
            Long count = em.createQuery(
                    "SELECT COUNT(m) FROM RoomMember m, StudyRoom r WHERE m.roomID = r.roomID AND m.userID = :uid AND m.role = 'host' AND r.status != 'CLOSED'",
                    Long.class)
                    .setParameter("uid", userID)
                    .getSingleResult();
            return count > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public RoomMember getOldestMember(int roomID) {
        EntityManager em = getEntityManager();
        try {
            List<RoomMember> results = em.createQuery(
                    "SELECT m FROM RoomMember m WHERE m.roomID = :rid AND m.role = 'member' ORDER BY m.joinedAt ASC",
                    RoomMember.class)
                    .setParameter("rid", roomID)
                    .setMaxResults(1)
                    .getResultList();
            return results.isEmpty() ? null : results.get(0);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public boolean updateMemberRole(int roomID, int userID, String newRole) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            int updated = em.createQuery(
                    "UPDATE RoomMember m SET m.role = :role WHERE m.roomID = :rid AND m.userID = :uid")
                    .setParameter("role", newRole)
                    .setParameter("rid", roomID)
                    .setParameter("uid", userID)
                    .executeUpdate();
            tx.commit();
            return updated > 0;
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    public int getMemberCount(int roomID) {
        EntityManager em = getEntityManager();
        try {
            Long count = em.createQuery(
                    "SELECT COUNT(m) FROM RoomMember m WHERE m.roomID = :rid",
                    Long.class)
                    .setParameter("rid", roomID)
                    .getSingleResult();
            return count.intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    public List<RoomMember> getAllMembershipsByUser(int userID) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT m FROM RoomMember m WHERE m.userID = :uid",
                    RoomMember.class)
                    .setParameter("uid", userID)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }
}
