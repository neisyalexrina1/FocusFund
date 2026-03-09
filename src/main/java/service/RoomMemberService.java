package service;

import model.RoomMember;
import java.util.List;

public interface RoomMemberService {
    void joinRoom(int roomID, int userID);

    void leaveRoom(int roomID, int userID);

    void kickMember(int roomID, int hostUserID, int targetUserID);

    void transferHost(int roomID, int currentHostID, int newHostID);

    List<RoomMember> getRoomMembers(int roomID);

    RoomMember getMember(int roomID, int userID);
}
