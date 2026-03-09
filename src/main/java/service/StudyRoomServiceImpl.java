package service;

import dao.RoomMemberDAO;
import dao.StudyRoomDAO;
import model.StudyRoom;
import java.util.List;

public class StudyRoomServiceImpl implements StudyRoomService {

    private final StudyRoomDAO studyRoomDAO;
    private final RoomMemberDAO roomMemberDAO;

    public StudyRoomServiceImpl() {
        this.studyRoomDAO = new StudyRoomDAO();
        this.roomMemberDAO = new RoomMemberDAO();
    }

    @Override
    public List<StudyRoom> getAllRooms() {
        return studyRoomDAO.getAllRooms();
    }

    @Override
    public List<StudyRoom> getLobbyRooms() {
        return studyRoomDAO.getLobbyRooms();
    }

    @Override
    public StudyRoom getRoomById(int roomId) {
        return studyRoomDAO.getRoomById(roomId);
    }

    @Override
    public List<StudyRoom> getRoomsByType(String roomType) {
        return studyRoomDAO.getRoomsByType(roomType);
    }

    @Override
    public synchronized StudyRoom createRoom(String roomName, String description, String roomType,
            String pomodoroSetting, int maxParticipants, Integer createdBy) {

        // Validate room name
        if (roomName == null || roomName.trim().isEmpty()) {
            throw new ValidationException("Room name is required.");
        }
        roomName = roomName.trim();
        if (roomName.length() < 3 || roomName.length() > 50) {
            throw new ValidationException("Room name must be between 3 and 50 characters.");
        }
        // Sanitize: reject dangerous characters
        if (roomName.matches(".*[<>\"';&|].*")) {
            throw new ValidationException("Room name contains invalid characters.");
        }

        // Validate max participants
        if (maxParticipants < 2 || maxParticipants > 50) {
            throw new ValidationException("Max participants must be between 2 and 50.");
        }

        // Check if user is already hosting a room
        if (createdBy != null && roomMemberDAO.isUserHostingAnyRoom(createdBy)) {
            throw new ValidationException("You are already hosting another room.");
        }

        // Check for duplicate room name among active rooms
        if (studyRoomDAO.isRoomNameTaken(roomName)) {
            throw new ValidationException("A room with this name already exists.");
        }

        // Create the room
        StudyRoom room = studyRoomDAO.createRoom(roomName, description, roomType,
                pomodoroSetting, maxParticipants, createdBy);
        if (room == null) {
            throw new ValidationException("Failed to create room. Please try again.");
        }

        // Auto-add creator as host member
        if (createdBy != null) {
            roomMemberDAO.addMember(room.getRoomID(), createdBy, "host");
        }

        return room;
    }

    @Override
    public synchronized void deleteRoom(int roomId, int userId) {
        StudyRoom room = studyRoomDAO.getRoomById(roomId);
        if (room == null) {
            throw new ValidationException("Room does not exist.");
        }

        // Only host can delete
        if (room.getCreatedBy() == null || room.getCreatedBy() != userId) {
            // Also check if user is current host in RoomMembers
            var hostMember = roomMemberDAO.getMember(roomId, userId);
            if (hostMember == null || !hostMember.isHost()) {
                throw new ValidationException("Only the room host can delete this room.");
            }
        }

        // Remove all members first (CASCADE should handle but be explicit)
        roomMemberDAO.removeAllMembers(roomId);

        // Set status to CLOSED then delete
        studyRoomDAO.updateRoomStatus(roomId, "CLOSED");
        studyRoomDAO.deleteRoom(roomId);
    }

    @Override
    public boolean isRoomNameTaken(String roomName) {
        return studyRoomDAO.isRoomNameTaken(roomName);
    }

    @Override
    public boolean updateRoom(StudyRoom room) {
        // We could add validation here if needed
        return studyRoomDAO.updateRoom(room);
    }
}
