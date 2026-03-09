package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import model.Mindmap;
import model.MindmapNode;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class MindmapDAO extends BaseDAO {

    public List<Mindmap> getUserMindmaps(int userId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Mindmap> q = em.createQuery(
                    "SELECT m FROM Mindmap m WHERE m.userID = :userId ORDER BY m.updatedDate DESC",
                    Mindmap.class);
            q.setParameter("userId", userId);
            return q.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public List<Mindmap> getPublicMindmaps() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                    "SELECT m FROM Mindmap m WHERE m.isPublic = true ORDER BY m.likeCount DESC, m.updatedDate DESC",
                    Mindmap.class).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public Mindmap getMindmapById(int mindmapId) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Mindmap.class, mindmapId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public int createMindmap(int userId, String title, String description, Integer courseId, boolean isPublic) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Mindmap m = new Mindmap();
            m.setUserID(userId);
            m.setTitle(title);
            m.setDescription(description);
            m.setCourseID(courseId);
            m.setIsPublic(isPublic);
            em.persist(m);
            tx.commit();
            return m.getMindmapID();
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return -1;
        } finally {
            em.close();
        }
    }

    public boolean updateMindmap(int mindmapId, String title, String description, boolean isPublic) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Mindmap m = em.find(Mindmap.class, mindmapId);
            if (m == null)
                return false;
            m.setTitle(title);
            m.setDescription(description);
            m.setIsPublic(isPublic);
            m.setUpdatedDate(new Date());
            em.merge(m);
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

    public boolean deleteMindmap(int mindmapId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Mindmap m = em.find(Mindmap.class, mindmapId);
            if (m == null)
                return false;
            em.remove(m);
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

    public boolean incrementUseCount(int mindmapId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Mindmap m = em.find(Mindmap.class, mindmapId);
            if (m == null)
                return false;
            m.setUseCount(m.getUseCount() + 1);
            em.merge(m);
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

    // ===== Course-related queries =====

    public List<Mindmap> getMindmapsByCourse(int courseId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Mindmap> q = em.createQuery(
                    "SELECT m FROM Mindmap m WHERE m.courseID = :courseId ORDER BY m.updatedDate DESC",
                    Mindmap.class);
            q.setParameter("courseId", courseId);
            return q.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    // ===== Node operations =====

    public List<MindmapNode> getNodesByMindmap(int mindmapId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<MindmapNode> q = em.createQuery(
                    "SELECT n FROM MindmapNode n WHERE n.mindmapID = :mindmapId ORDER BY n.nodeOrder",
                    MindmapNode.class);
            q.setParameter("mindmapId", mindmapId);
            return q.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public int addNode(int mindmapId, Integer parentNodeId, String text, String color, String icon,
            double posX, double posY, int order) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            MindmapNode node = new MindmapNode();
            node.setMindmapID(mindmapId);
            node.setParentNodeID(parentNodeId);
            node.setNodeText(text);
            node.setNodeColor(color);
            node.setNodeIcon(icon);
            node.setPositionX(posX);
            node.setPositionY(posY);
            node.setNodeOrder(order);
            em.persist(node);

            // Update mindmap timestamp
            Mindmap m = em.find(Mindmap.class, mindmapId);
            if (m != null) {
                m.setUpdatedDate(new Date());
                em.merge(m);
            }

            tx.commit();
            return node.getNodeID();
        } catch (Exception e) {
            if (tx.isActive())
                tx.rollback();
            e.printStackTrace();
            return -1;
        } finally {
            em.close();
        }
    }

    public boolean deleteNode(int nodeId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            MindmapNode node = em.find(MindmapNode.class, nodeId);
            if (node == null)
                return false;
            em.remove(node);
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
