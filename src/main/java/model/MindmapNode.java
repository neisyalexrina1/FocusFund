package model;

import jakarta.persistence.*;

@Entity
@Table(name = "MindmapNodes")
public class MindmapNode {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "NodeID")
    private int nodeID;

    @Column(name = "MindmapID", nullable = false)
    private int mindmapID;

    @Column(name = "ParentNodeID")
    private Integer parentNodeID;

    @Column(name = "NodeText", nullable = false, length = 500)
    private String nodeText;

    @Column(name = "NodeColor", length = 20)
    private String nodeColor;

    @Column(name = "NodeIcon", length = 10)
    private String nodeIcon;

    @Column(name = "PositionX")
    private double positionX;

    @Column(name = "PositionY")
    private double positionY;

    @Column(name = "NodeOrder")
    private int nodeOrder;

    public MindmapNode() {
        this.positionX = 0;
        this.positionY = 0;
        this.nodeOrder = 0;
    }

    // Getters and Setters
    public int getNodeID() {
        return nodeID;
    }

    public void setNodeID(int nodeID) {
        this.nodeID = nodeID;
    }

    public int getMindmapID() {
        return mindmapID;
    }

    public void setMindmapID(int mindmapID) {
        this.mindmapID = mindmapID;
    }

    public Integer getParentNodeID() {
        return parentNodeID;
    }

    public void setParentNodeID(Integer parentNodeID) {
        this.parentNodeID = parentNodeID;
    }

    public String getNodeText() {
        return nodeText;
    }

    public void setNodeText(String nodeText) {
        this.nodeText = nodeText;
    }

    public String getNodeColor() {
        return nodeColor;
    }

    public void setNodeColor(String nodeColor) {
        this.nodeColor = nodeColor;
    }

    public String getNodeIcon() {
        return nodeIcon;
    }

    public void setNodeIcon(String nodeIcon) {
        this.nodeIcon = nodeIcon;
    }

    public double getPositionX() {
        return positionX;
    }

    public void setPositionX(double positionX) {
        this.positionX = positionX;
    }

    public double getPositionY() {
        return positionY;
    }

    public void setPositionY(double positionY) {
        this.positionY = positionY;
    }

    public int getNodeOrder() {
        return nodeOrder;
    }

    public void setNodeOrder(int nodeOrder) {
        this.nodeOrder = nodeOrder;
    }
}
