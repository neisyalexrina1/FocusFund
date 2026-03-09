package service;

import model.LeaderboardMonthly;

import java.util.List;
import java.util.Map;

public interface LeaderboardService {
    List<Map<String, Object>> getMonthlyTop(int limit);

    LeaderboardMonthly getUserMonthlyEntry(int userId);
}
