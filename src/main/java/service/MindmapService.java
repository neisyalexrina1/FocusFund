package service;

import model.Mindmap;
import model.MindmapNode;

import java.util.List;

public interface MindmapService {
    List<Mindmap> getUserMindmaps(int userId);

    List<Mindmap> getPublicMindmaps();

    Mindmap getMindmapById(int mindmapId);

    int createMindmap(int userId, String title, String description, Integer courseId, boolean isPublic);

    boolean updateMindmap(int mindmapId, int userId, String title, String description, boolean isPublic);

    boolean deleteMindmap(int mindmapId, int userId);

    boolean useMindmap(int mindmapId);

    List<MindmapNode> getNodes(int mindmapId);

    int addNode(int mindmapId, Integer parentNodeId, String text, String color, String icon,
            double posX, double posY, int order);

    boolean deleteNode(int nodeId);
}
