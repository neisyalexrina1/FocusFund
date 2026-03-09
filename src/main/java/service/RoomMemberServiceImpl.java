package service;

import dao.RoomMemberDAO;
import dao.StudyRoomDAO;
import model.RoomMember;
import model.StudyRoom;
import java.util.List;

public class RoomMemberServiceImpl implements RoomMemberService {

    private final RoomMemberDAO roomMemberDAO;
    private final StudyRoomDAO studyRoomDAO;

    public RoomMemberServiceImpl() {
        this.roomMemberDAO = new RoomMemberDAO();
        this.studyRoomDAO = new StudyRoomDAO();
    }

    @Override
    public synchronized void joinRoom(int roomID, int userID) {
        // Validate room exists
        StudyRoom room = studyRoomDAO.getRoomById(roomID);
        if (room == null) {
            throw new ValidationException("Room does not exist.");
        }

        // Validate room is not closed
        if (room.isClosed()) {
            throw new ValidationException("This room is closed.");
        }

        if ("private".equalsIgnoreCase(room.getRoomType())) {
            throw new ValidationException("This is a private room. You need an invitation to join.");
        }

        // Validate room is not full
        if (room.isFull()) {
            throw new ValidationException("This room is full.");
        }

        // If user is already in THIS room, just let them re-enter (no error)
        RoomMember existing = roomMemberDAO.getMember(roomID, userID);
        if (existing != null) {
            // Already a member, silently allow re-entry
            return;
        }

        // Clean up any stale memberships in OTHER rooms before joining
        List<RoomMember> allMemberships = roomMemberDAO.getAllMembershipsByUser(userID);
        for (RoomMember stale : allMemberships) {
            if (stale.getRoomID() != roomID) {
                // Force leave the old room
                leaveRoom(stale.getRoomID(), userID);
            }
        }

        // Add member
        boolean added = roomMemberDAO.addMember(roomID, userID, "member");
        if (!added) {
            throw new ValidationException("Failed to join room. Please try again.");
        }

        // Increment participant count
        studyRoomDAO.incrementParticipants(roomID);

        // Check if room is now full
        int currentCount = roomMemberDAO.getMemberCount(roomID);
        if (currentCount >= room.getMaxParticipants()) {
            studyRoomDAO.updateRoomStatus(roomID, "FULL");
        }
    }

    @Override
    public synchronized void leaveRoom(int roomID, int userID) {
        // Validate membership
        RoomMember member = roomMemberDAO.getMember(roomID, userID);
        if (member == null) {
            throw new ValidationException("You are not in this room.");
        }

        StudyRoom room = studyRoomDAO.getRoomById(roomID);
        if (room == null) {
            throw new ValidationException("Room does not exist.");
        }

        boolean isHost = member.isHost();

        // Remove the member
        roomMemberDAO.removeMember(roomID, userID);
        studyRoomDAO.decrementParticipants(roomID);

        // Check remaining members
        int remaining = roomMemberDAO.getMemberCount(roomID);

        if (remaining == 0) {
            // Auto-delete room if empty
            studyRoomDAO.updateRoomStatus(roomID, "CLOSED");
            studyRoomDAO.deleteRoom(roomID);
        } else {
            // If host left, transfer to oldest member
            if (isHost) {
                RoomMember oldest = roomMemberDAO.getOldestMember(roomID);
                if (oldest != null) {
                    roomMemberDAO.updateMemberRole(roomID, oldest.getUserID(), "host");
                }
            }

            // Update status: if was FULL, now OPEN since someone left
            if (room.isFull()) {
                studyRoomDAO.updateRoomStatus(roomID, "OPEN");
            }

            // Sync participant count
            studyRoomDAO.updateParticipantCount(roomID, remaining);
        }
    }

    @Override
    public synchronized void kickMember(int roomID, int hostUserID, int targetUserID) {
        // Validate the kicker is the host
        RoomMember hostMember = roomMemberDAO.getMember(roomID, hostUserID);
        if (hostMember == null || !hostMember.isHost()) {
            throw new ValidationException("Only the room host can kick members.");
        }

        // Cannot kick yourself
        if (hostUserID == targetUserID) {
            throw new ValidationException("You cannot kick yourself. Use 'Leave Room' instead.");
        }

        // Validate target is in the room
        RoomMember targetMember = roomMemberDAO.getMember(roomID, targetUserID);
        if (targetMember == null) {
            throw new ValidationException("This user is not in the room.");
        }

        // Remove the target member
        roomMemberDAO.removeMember(roomID, targetUserID);
        studyRoomDAO.decrementParticipants(roomID);

        // Update status if was FULL
        StudyRoom room = studyRoomDAO.getRoomById(roomID);
        if (room != null && room.isFull()) {
            studyRoomDAO.updateRoomStatus(roomID, "OPEN");
        }

        // Sync count
        int remaining = roomMemberDAO.getMemberCount(roomID);
        studyRoomDAO.updateParticipantCount(roomID, remaining);
    }

    @Override
    public synchronized void transferHost(int roomID, int currentHostID, int newHostID) {
        RoomMember currentHost = roomMemberDAO.getMember(roomID, currentHostID);
        if (currentHost == null || !currentHost.isHost()) {
            throw new ValidationException("Only the room host can transfer host rights.");
        }

        RoomMember newHost = roomMemberDAO.getMember(roomID, newHostID);
        if (newHost == null) {
            throw new ValidationException("The target user is not in the room.");
        }

        // Update roles
        roomMemberDAO.updateMemberRole(roomID, currentHostID, "member");
        roomMemberDAO.updateMemberRole(roomID, newHostID, "host");
    }

    @Override
    public List<RoomMember> getRoomMembers(int roomID) {
        return roomMemberDAO.getMembersByRoom(roomID);
    }

    @Override
    public RoomMember getMember(int roomID, int userID) {
        return roomMemberDAO.getMember(roomID, userID);
    }
}
