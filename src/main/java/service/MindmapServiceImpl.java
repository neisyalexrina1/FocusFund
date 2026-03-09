package service;

import dao.MindmapDAO;
import model.Mindmap;
import model.MindmapNode;

import java.util.List;

public class MindmapServiceImpl implements MindmapService {

    private final MindmapDAO mindmapDAO = new MindmapDAO();

    @Override
    public List<Mindmap> getUserMindmaps(int userId) {
        return mindmapDAO.getUserMindmaps(userId);
    }

    @Override
    public List<Mindmap> getPublicMindmaps() {
        return mindmapDAO.getPublicMindmaps();
    }

    @Override
    public Mindmap getMindmapById(int mindmapId) {
        return mindmapDAO.getMindmapById(mindmapId);
    }

    @Override
    public int createMindmap(int userId, String title, String description, Integer courseId, boolean isPublic) {
        if (title == null || title.trim().isEmpty()) {
            throw new ValidationException("Mindmap title is required");
        }
        return mindmapDAO.createMindmap(userId, title.trim(), description, courseId, isPublic);
    }

    @Override
    public boolean updateMindmap(int mindmapId, int userId, String title, String description, boolean isPublic) {
        Mindmap m = mindmapDAO.getMindmapById(mindmapId);
        if (m == null || m.getUserID() != userId)
            return false;
        return mindmapDAO.updateMindmap(mindmapId, title, description, isPublic);
    }

    @Override
    public boolean deleteMindmap(int mindmapId, int userId) {
        Mindmap m = mindmapDAO.getMindmapById(mindmapId);
        if (m == null || m.getUserID() != userId)
            return false;
        return mindmapDAO.deleteMindmap(mindmapId);
    }

    @Override
    public boolean useMindmap(int mindmapId) {
        return mindmapDAO.incrementUseCount(mindmapId);
    }

    @Override
    public List<MindmapNode> getNodes(int mindmapId) {
        return mindmapDAO.getNodesByMindmap(mindmapId);
    }

    @Override
    public int addNode(int mindmapId, Integer parentNodeId, String text, String color, String icon,
            double posX, double posY, int order) {
        if (text == null || text.trim().isEmpty()) {
            throw new ValidationException("Node text is required");
        }
        return mindmapDAO.addNode(mindmapId, parentNodeId, text.trim(), color, icon, posX, posY, order);
    }

    @Override
    public boolean deleteNode(int nodeId) {
        return mindmapDAO.deleteNode(nodeId);
    }
}
