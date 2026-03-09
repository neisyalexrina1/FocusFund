package service;

import model.StudyRoom;
import java.util.List;

public interface StudyRoomService {
    List<StudyRoom> getAllRooms();

    List<StudyRoom> getLobbyRooms();

    StudyRoom getRoomById(int roomId);

    List<StudyRoom> getRoomsByType(String roomType);

    StudyRoom createRoom(String roomName, String description, String roomType,
            String pomodoroSetting, int maxParticipants, Integer createdBy);

    void deleteRoom(int roomId, int userId);

    boolean isRoomNameTaken(String roomName);

    boolean updateRoom(StudyRoom room);
}
