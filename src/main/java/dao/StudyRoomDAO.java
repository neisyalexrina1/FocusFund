package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.StudyRoom;

public class StudyRoomDAO extends BaseDAO {

    public List<StudyRoom> getAllRooms() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT r FROM StudyRoom r ORDER BY r.createdDate DESC", StudyRoom.class)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public List<StudyRoom> getLobbyRooms() {
        EntityManager em = getEntityManager();
        try {
            List<StudyRoom> rooms = em.createQuery(
                    "SELECT r FROM StudyRoom r WHERE r.status IN ('OPEN', 'FULL') ORDER BY r.createdDate DESC",
                    StudyRoom.class)
                    .getResultList();

            // Load host names
            for (StudyRoom room : rooms) {
                loadHostName(em, room);
            }
            return rooms;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public StudyRoom getRoomById(int roomId) {
        EntityManager em = getEntityManager();
        try {
            List<StudyRoom> results = em.createQuery(
                    "SELECT r FROM StudyRoom r WHERE r.roomID = :rid", StudyRoom.class)
                    .setParameter("rid", roomId)
                    .getResultList();
            StudyRoom room = results.isEmpty() ? null : results.get(0);
            if (room != null) {
                loadHostName(em, room);
            }
            return room;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public List<StudyRoom> getRoomsByType(String roomType) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<StudyRoom> q = em.createQuery(
                    "SELECT r FROM StudyRoom r WHERE r.roomType = :type AND r.status IN ('OPEN', 'FULL') ORDER BY r.createdDate DESC",
                    StudyRoom.class);
            q.setParameter("type", roomType);
            List<StudyRoom> rooms = q.getResultList();
            for (StudyRoom room : rooms) {
                loadHostName(em, room);
            }
            return rooms;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public StudyRoom createRoom(String roomName, String description, String roomType,
            String pomodoroSetting, int maxParticipants, Integer createdBy) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            StudyRoom room = new StudyRoom();
            room.setRoomName(roomName);
            room.setDescription(description);
            room.setRoomType(roomType);
            room.setPomodoroSetting(pomodoroSetting);
            room.setMaxParticipants(maxParticipants);
            room.setCurrentParticipants(1); // creator joins automatically
            room.setCreatedBy(createdBy);
            room.setCreatedDate(new Date());
            room.setStatus("OPEN");
            em.persist(room);
            tx.commit();
            return room;
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public boolean updateRoomStatus(int roomId, String status) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            int updated = em.createQuery(
                    "UPDATE StudyRoom r SET r.status = :status WHERE r.roomID = :rid")
                    .setParameter("status", status)
                    .setParameter("rid", roomId)
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

    public boolean updateRoom(StudyRoom room) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.merge(room);
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

    public boolean incrementParticipants(int roomId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            int updated = em.createQuery(
                    "UPDATE StudyRoom r SET r.currentParticipants = r.currentParticipants + 1 WHERE r.roomID = :rid")
                    .setParameter("rid", roomId)
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

    public boolean decrementParticipants(int roomId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            int updated = em.createQuery(
                    "UPDATE StudyRoom r SET r.currentParticipants = r.currentParticipants - 1 WHERE r.roomID = :rid AND r.currentParticipants > 0")
                    .setParameter("rid", roomId)
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

    public boolean updateParticipantCount(int roomId, int count) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            int updated = em.createQuery(
                    "UPDATE StudyRoom r SET r.currentParticipants = :count WHERE r.roomID = :rid")
                    .setParameter("count", count)
                    .setParameter("rid", roomId)
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

    public boolean deleteRoom(int roomId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            StudyRoom room = em.find(StudyRoom.class, roomId);
            if (room != null) {
                em.remove(room);
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

    public boolean isRoomNameTaken(String roomName) {
        EntityManager em = getEntityManager();
        try {
            Long count = em.createQuery(
                    "SELECT COUNT(r) FROM StudyRoom r WHERE r.roomName = :name AND r.status != 'CLOSED'",
                    Long.class)
                    .setParameter("name", roomName)
                    .getSingleResult();
            return count > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    private void loadHostName(EntityManager em, StudyRoom room) {
        try {
            List<Object[]> results = em.createQuery(
                    "SELECT u.username, u.fullName FROM User u WHERE u.userID = :uid",
                    Object[].class)
                    .setParameter("uid", room.getCreatedBy())
                    .getResultList();
            if (!results.isEmpty()) {
                Object[] userInfo = results.get(0);
                String fullName = (String) userInfo[1];
                String username = (String) userInfo[0];
                room.setHostName(fullName != null && !fullName.isEmpty() ? fullName : username);
            }
        } catch (Exception e) {
            room.setHostName("Unknown");
        }
    }
}
