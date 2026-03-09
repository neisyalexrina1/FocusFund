package service;

import model.StudySession;
import java.util.List;

public interface StudySessionService {
    boolean createSession(int userId, Integer roomId, String goal);

    List<StudySession> getSessionsByUser(int userId);

    boolean updateSession(int sessionId, int focusMinutes, int pomodorosCompleted, String status);

    int getTotalFocusMinutes(int userId);

    int getTotalSessions(int userId);
}
