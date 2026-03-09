package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import dao.RoomMemberDAO;
import dao.RoomMessageDAO;
import jakarta.websocket.*;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;
import model.RoomMember;
import model.RoomMessage;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/ws/room/{roomId}")
public class RoomChatEndpoint {

    // Map<roomId, Set<Session>> — tracks all connected sessions per room
    private static final Map<Integer, Set<Session>> roomSessions = new ConcurrentHashMap<>();

    private static final Gson gson = new Gson();
    private static final RoomMessageDAO messageDAO = new RoomMessageDAO();
    private static final RoomMemberDAO memberDAO = new RoomMemberDAO();

    @OnOpen
    public void onOpen(Session session, @PathParam("roomId") int roomId) {
        session.getUserProperties().put("roomId", roomId);

        // Add session to room's set
        roomSessions.computeIfAbsent(roomId, k -> Collections.synchronizedSet(new HashSet<>())).add(session);

        // Send recent chat history upon connection
        try {
            List<RoomMessage> history = messageDAO.getRecentMessages(roomId, 50);
            for (RoomMessage msg : history) {
                String json = buildMessageJson(msg);
                session.getBasicRemote().sendText(json);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        System.out.println("[WebSocket] Session opened for room " + roomId + ". Total sessions: "
                + roomSessions.get(roomId).size());
    }

    @OnMessage
    public void onMessage(String messageText, Session session, @PathParam("roomId") int roomId) {
        try {
            // Parse incoming JSON
            JsonObject incoming = JsonParser.parseString(messageText).getAsJsonObject();
            String type = incoming.has("type") ? incoming.get("type").getAsString() : "chat";

            // === Handle delete request ===
            if ("delete".equals(type)) {
                int messageId = incoming.get("messageId").getAsInt();
                int userId = incoming.get("userId").getAsInt();

                // Validate: user must be a member
                RoomMember member = memberDAO.getMember(roomId, userId);
                if (member == null)
                    return;

                // Delete from DB (only if owned by this user)
                boolean deleted = messageDAO.deleteMessage(messageId, userId);
                if (deleted) {
                    // Broadcast deletion event to all clients in the room
                    JsonObject event = new JsonObject();
                    event.addProperty("type", "deleted");
                    event.addProperty("messageId", messageId);
                    broadcastToRoom(roomId, event.toString());
                }
                return;
            }

            // === Handle regular chat message ===
            int userId = incoming.get("userId").getAsInt();
            String displayName = incoming.get("displayName").getAsString();
            String content = incoming.get("content").getAsString();

            // Validate: user must be a member of the room
            RoomMember member = memberDAO.getMember(roomId, userId);
            if (member == null) {
                session.getBasicRemote()
                        .sendText("{\"type\":\"error\",\"message\":\"You are not a member of this room.\"}");
                return;
            }

            // Sanitize content
            content = content.trim();
            if (content.isEmpty() || content.length() > 500)
                return;

            // Save to DB
            RoomMessage roomMessage = new RoomMessage(roomId, userId, displayName, content);
            messageDAO.saveMessage(roomMessage);

            // Broadcast to all sessions in this room
            String broadcastJson = buildMessageJson(roomMessage);
            broadcastToRoom(roomId, broadcastJson);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @OnClose
    public void onClose(Session session, @PathParam("roomId") int roomId) {
        Set<Session> sessions = roomSessions.get(roomId);
        if (sessions != null) {
            sessions.remove(session);
            if (sessions.isEmpty()) {
                roomSessions.remove(roomId);
            }
        }
        System.out.println("[WebSocket] Session closed for room " + roomId);
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("[WebSocket] Error: " + throwable.getMessage());
    }

    /**
     * Broadcast a message JSON to all connected sessions in a room.
     */
    private void broadcastToRoom(int roomId, String json) {
        Set<Session> sessions = roomSessions.get(roomId);
        if (sessions == null)
            return;

        synchronized (sessions) {
            for (Session s : sessions) {
                if (s.isOpen()) {
                    try {
                        s.getBasicRemote().sendText(json);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }

    /**
     * Build a JSON string for a chat message to send to clients.
     */
    private String buildMessageJson(RoomMessage msg) {
        JsonObject json = new JsonObject();
        json.addProperty("type", "chat");
        json.addProperty("messageId", msg.getMessageID());
        json.addProperty("userId", msg.getUserID());
        json.addProperty("displayName", msg.getDisplayName());
        json.addProperty("content", msg.getContent());

        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
        json.addProperty("time", sdf.format(msg.getSentAt()));

        return json.toString();
    }

    /**
     * Static helper: broadcast a system message to all sessions in a room.
     * Called from other servlets (e.g., when a user joins/leaves).
     */
    public static void broadcastSystemMessage(int roomId, String message) {
        Set<Session> sessions = roomSessions.get(roomId);
        if (sessions == null)
            return;

        JsonObject json = new JsonObject();
        json.addProperty("type", "system");
        json.addProperty("content", message);

        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
        json.addProperty("time", sdf.format(new Date()));

        String jsonStr = json.toString();

        synchronized (sessions) {
            for (Session s : sessions) {
                if (s.isOpen()) {
                    try {
                        s.getBasicRemote().sendText(jsonStr);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }
}
