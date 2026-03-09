package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.RoomMember;
import model.StudyRoom;
import model.User;
import service.RoomMemberService;
import service.RoomMemberServiceImpl;
import service.StudyRoomService;
import service.StudyRoomServiceImpl;
import service.ValidationException;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/StudyRoomServlet")
public class StudyRoomServlet extends HttpServlet {

    private StudyRoomService studyRoomService;
    private RoomMemberService roomMemberService;
    private Gson gson;

    @Override
    public void init() {
        studyRoomService = new StudyRoomServiceImpl();
        roomMemberService = new RoomMemberServiceImpl();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("AuthServlet");
            return;
        }

        String action = request.getParameter("action");
        User user = (User) session.getAttribute("user");

        if ("detail".equals(action)) {
            handleRoomDetail(request, response, user);
        } else if ("members".equals(action)) {
            handleGetMembers(request, response);
        } else if ("lobbyData".equals(action)) {
            handleLobbyData(request, response);
        } else {
            handleLobby(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendJsonError(response, "Please log in first.");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if (action == null)
            action = "create";

        switch (action) {
            case "create":
                handleCreateRoom(request, response, user);
                break;
            case "join":
                handleJoinRoom(request, response, user);
                break;
            case "leave":
                handleLeaveRoom(request, response, user);
                break;
            case "kick":
                handleKickMember(request, response, user);
                break;
            case "delete":
                handleDeleteRoom(request, response, user);
                break;
            case "updateSettings":
                handleUpdateSettings(request, response, user);
                break;
            case "transferHost":
                handleTransferHost(request, response, user);
                break;
            default:
                sendJsonError(response, "Unknown action.");
        }
    }

    // === GET Handlers ===

    private void handleLobby(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");
        List<StudyRoom> rooms;
        if (type != null && !type.isEmpty() && !"all".equals(type)) {
            rooms = studyRoomService.getRoomsByType(type);
        } else {
            rooms = studyRoomService.getLobbyRooms();
        }
        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("rooms.jsp").forward(request, response);
    }

    private void handleRoomDetail(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            int roomId = Integer.parseInt(request.getParameter("id"));
            StudyRoom room = studyRoomService.getRoomById(roomId);
            if (room == null) {
                response.sendRedirect("StudyRoomServlet");
                return;
            }
            List<RoomMember> members = roomMemberService.getRoomMembers(roomId);
            RoomMember currentMember = roomMemberService.getMember(roomId, user.getUserID());

            // If room is CLOSED and user is NOT a member, redirect to lobby
            if (room.isClosed() && currentMember == null) {
                response.sendRedirect("StudyRoomServlet");
                return;
            }

            request.setAttribute("room", room);
            request.setAttribute("members", members);
            request.setAttribute("currentMember", currentMember);
            request.getRequestDispatcher("study_room.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("StudyRoomServlet");
        }
    }

    private void handleGetMembers(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int roomId = Integer.parseInt(request.getParameter("id"));
            List<RoomMember> members = roomMemberService.getRoomMembers(roomId);
            StudyRoom room = studyRoomService.getRoomById(roomId);

            Map<String, Object> data = new HashMap<>();
            data.put("success", true);

            List<Map<String, Object>> memberList = new ArrayList<>();
            SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
            for (RoomMember m : members) {
                Map<String, Object> mData = new HashMap<>();
                mData.put("userID", m.getUserID());
                mData.put("displayName", m.getDisplayName());
                mData.put("role", m.getRole());
                mData.put("roleBadge", m.getRoleBadge());
                mData.put("isHost", m.isHost());
                mData.put("joinedAt", sdf.format(m.getJoinedAt()));
                memberList.add(mData);
            }
            data.put("members", memberList);
            if (room != null) {
                data.put("currentParticipants", room.getCurrentParticipants());
                data.put("maxParticipants", room.getMaxParticipants());
                data.put("status", room.getStatus());
                data.put("statusBadge", room.getStatusBadge());
                data.put("roomType", room.getRoomType());
                data.put("roomTypeBadge", room.getRoomTypeBadge());
                data.put("roomName", room.getRoomName());
                data.put("pomodoroSetting", room.getPomodoroSetting());
                data.put("pomodoroLabel", room.getPomodoroLabel());
            }

            sendJson(response, data);
        } catch (Exception e) {
            sendJsonError(response, "Failed to load members.");
        }
    }

    private void handleLobbyData(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String type = request.getParameter("type");
            List<StudyRoom> rooms;
            if (type != null && !type.isEmpty() && !"all".equals(type)) {
                rooms = studyRoomService.getRoomsByType(type);
            } else {
                rooms = studyRoomService.getLobbyRooms();
            }

            Map<String, Object> data = new HashMap<>();
            data.put("success", true);

            List<Map<String, Object>> roomList = new ArrayList<>();
            SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, HH:mm");
            for (StudyRoom r : rooms) {
                Map<String, Object> rData = new HashMap<>();
                rData.put("roomID", r.getRoomID());
                rData.put("roomName", r.getRoomName());
                rData.put("description", r.getDescription());
                rData.put("roomType", r.getRoomType());
                rData.put("roomTypeBadge", r.getRoomTypeBadge());
                rData.put("pomodoroLabel", r.getPomodoroLabel());
                rData.put("currentParticipants", r.getCurrentParticipants());
                rData.put("maxParticipants", r.getMaxParticipants());
                rData.put("status", r.getStatus());
                rData.put("statusBadge", r.getStatusBadge());
                rData.put("hostName", r.getHostName());
                rData.put("createdDate", r.getCreatedDate() != null ? sdf.format(r.getCreatedDate()) : "");
                roomList.add(rData);
            }
            data.put("rooms", roomList);
            sendJson(response, data);
        } catch (Exception e) {
            sendJsonError(response, "Failed to load rooms.");
        }
    }

    // === POST Handlers ===

    private void handleCreateRoom(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String roomName = request.getParameter("roomName");
        String description = request.getParameter("description");
        String roomType = request.getParameter("roomType");
        String pomodoroSetting = request.getParameter("pomodoro");
        String maxStr = request.getParameter("maxParticipants");

        try {
            int maxParticipants = 15;
            if (maxStr != null && !maxStr.isEmpty()) {
                maxParticipants = Integer.parseInt(maxStr);
            }

            StudyRoom room = studyRoomService.createRoom(roomName, description, roomType,
                    pomodoroSetting, maxParticipants, user.getUserID());

            // Check if AJAX request
            if (isAjax(request)) {
                Map<String, Object> data = new HashMap<>();
                data.put("success", true);
                data.put("message", "Room created successfully!");
                data.put("roomID", room.getRoomID());
                sendJson(response, data);
            } else {
                response.sendRedirect("StudyRoomServlet?action=detail&id=" + room.getRoomID());
            }
        } catch (ValidationException e) {
            if (isAjax(request)) {
                sendJsonError(response, e.getMessage());
            } else {
                request.setAttribute("errorMessage", e.getMessage());
                handleLobby(request, response);
            }
        } catch (NumberFormatException e) {
            if (isAjax(request)) {
                sendJsonError(response, "Invalid max participants value.");
            } else {
                request.setAttribute("errorMessage", "Invalid max participants value.");
                handleLobby(request, response);
            }
        }
    }

    private void handleJoinRoom(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            roomMemberService.joinRoom(roomId, user.getUserID());
            sendJsonSuccess(response, "Joined room successfully!");
        } catch (ValidationException e) {
            sendJsonError(response, e.getMessage());
        } catch (NumberFormatException e) {
            sendJsonError(response, "Invalid room ID.");
        }
    }

    private void handleLeaveRoom(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            roomMemberService.leaveRoom(roomId, user.getUserID());
            sendJsonSuccess(response, "Left the room.");
        } catch (ValidationException e) {
            sendJsonError(response, e.getMessage());
        } catch (NumberFormatException e) {
            sendJsonError(response, "Invalid room ID.");
        }
    }

    private void handleKickMember(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            int targetUserId = Integer.parseInt(request.getParameter("targetUserId"));
            roomMemberService.kickMember(roomId, user.getUserID(), targetUserId);
            sendJsonSuccess(response, "Member kicked from room.");
        } catch (ValidationException e) {
            sendJsonError(response, e.getMessage());
        } catch (NumberFormatException e) {
            sendJsonError(response, "Invalid parameters.");
        }
    }

    private void handleDeleteRoom(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            studyRoomService.deleteRoom(roomId, user.getUserID());
            sendJsonSuccess(response, "Room deleted.");
        } catch (ValidationException e) {
            sendJsonError(response, e.getMessage());
        } catch (NumberFormatException e) {
            sendJsonError(response, "Invalid room ID.");
        }
    }

    private void handleTransferHost(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            int newHostId = Integer.parseInt(request.getParameter("newHostId"));
            roomMemberService.transferHost(roomId, user.getUserID(), newHostId);
            sendJsonSuccess(response, "Host rights transferred successfully.");
        } catch (ValidationException e) {
            sendJsonError(response, e.getMessage());
        } catch (NumberFormatException e) {
            sendJsonError(response, "Invalid parameters.");
        }
    }

    private void handleUpdateSettings(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            String roomName = request.getParameter("roomName");
            String roomType = request.getParameter("roomType");
            String pomodoroSetting = request.getParameter("pomodoroSetting");
            String status = request.getParameter("status");

            if (roomName == null || roomName.trim().isEmpty() || roomName.length() < 3 || roomName.length() > 50) {
                if (isAjax(request)) {
                    sendJsonError(response, "Invalid room name");
                } else {
                    response.sendRedirect(request.getContextPath() + "/StudyRoomServlet?action=detail&id=" + roomId
                            + "&error=Invalid room name");
                }
                return;
            }

            StudyRoom room = studyRoomService.getRoomById(roomId);
            if (room != null && room.getCreatedBy() != null && room.getCreatedBy().equals(user.getUserID())) {
                room.setRoomName(roomName.trim());
                room.setRoomType(roomType);
                room.setPomodoroSetting(pomodoroSetting);
                room.setStatus(status);
                studyRoomService.updateRoom(room);
            }
            if (isAjax(request)) {
                sendJsonSuccess(response, "Settings updated successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/StudyRoomServlet?action=detail&id=" + roomId);
            }
        } catch (NumberFormatException e) {
            if (isAjax(request))
                sendJsonError(response, "Invalid room ID");
            else
                response.sendRedirect(request.getContextPath() + "/StudyRoomServlet");
        } catch (Exception e) {
            e.printStackTrace();
            if (isAjax(request))
                sendJsonError(response, "Error updating settings");
            else
                response.sendRedirect(request.getContextPath() + "/StudyRoomServlet");
        }
    }

    // === JSON Helpers ===

    private void sendJson(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(data));
        out.flush();
    }

    private void sendJsonSuccess(HttpServletResponse response, String message) throws IOException {
        Map<String, Object> data = new HashMap<>();
        data.put("success", true);
        data.put("message", message);
        sendJson(response, data);
    }

    private void sendJsonError(HttpServletResponse response, String message) throws IOException {
        Map<String, Object> data = new HashMap<>();
        data.put("success", false);
        data.put("message", message);
        sendJson(response, data);
    }

    private boolean isAjax(HttpServletRequest request) {
        return "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
    }
}
