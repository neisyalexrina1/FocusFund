package service;

import dao.StudySessionDAO;
import model.StudySession;
import java.util.List;

public class StudySessionServiceImpl implements StudySessionService {

    private final StudySessionDAO studySessionDAO;

    public StudySessionServiceImpl() {
        this.studySessionDAO = new StudySessionDAO();
    }

    @Override
    public boolean createSession(int userId, Integer roomId, String goal) {
        return studySessionDAO.createSession(userId, roomId, goal);
    }

    @Override
    public List<StudySession> getSessionsByUser(int userId) {
        return studySessionDAO.getSessionsByUser(userId);
    }

    @Override
    public boolean updateSession(int sessionId, int focusMinutes, int pomodorosCompleted, String status) {
        return studySessionDAO.updateSession(sessionId, focusMinutes, pomodorosCompleted, status);
    }

    @Override
    public int getTotalFocusMinutes(int userId) {
        return studySessionDAO.getTotalFocusMinutes(userId);
    }

    @Override
    public int getTotalSessions(int userId) {
        return studySessionDAO.getTotalSessions(userId);
    }
}
