package service;

import dao.LeaderboardDAO;
import dao.UserDAO;
import model.LeaderboardMonthly;
import model.User;

import java.util.*;

public class LeaderboardServiceImpl implements LeaderboardService {

    private final LeaderboardDAO leaderboardDAO = new LeaderboardDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    public List<Map<String, Object>> getMonthlyTop(int limit) {
        List<LeaderboardMonthly> entries = leaderboardDAO.getMonthlyTop(limit);
        List<Map<String, Object>> result = new ArrayList<>();

        int rank = 1;
        for (LeaderboardMonthly entry : entries) {
            Map<String, Object> item = new HashMap<>();
            item.put("rank", rank++);
            item.put("userId", entry.getUserID());
            item.put("coinsEarned", entry.getTotalCoinsEarned());
            item.put("studyMinutes", entry.getTotalStudyMinutes());

            // Fetch user info
            User user = userDAO.getUserById(entry.getUserID());
            if (user != null) {
                item.put("username", user.getUsername());
                item.put("fullName", user.getFullName());
                item.put("profileImage", user.getProfileImage());
            }

            result.add(item);
        }

        return result;
    }

    @Override
    public LeaderboardMonthly getUserMonthlyEntry(int userId) {
        return leaderboardDAO.getUserMonthlyEntry(userId);
    }
}
