package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.LeaderboardMonthly;
import model.User;
import service.LeaderboardService;
import service.LeaderboardServiceImpl;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet("/LeaderboardServlet")
public class LeaderboardServlet extends HttpServlet {

    private LeaderboardService leaderboardService;
    private final Gson gson = new Gson();

    @Override
    public void init() {
        leaderboardService = new LeaderboardServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendJsonError(response, "Not logged in");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        try {
            if ("top".equals(action)) {
                String limitStr = request.getParameter("limit");
                int limit = limitStr != null ? Integer.parseInt(limitStr) : 10;
                List<Map<String, Object>> top = leaderboardService.getMonthlyTop(limit);
                sendJson(response, top);

            } else if ("myRank".equals(action)) {
                LeaderboardMonthly entry = leaderboardService.getUserMonthlyEntry(user.getUserID());
                Map<String, Object> result = new HashMap<>();
                if (entry != null) {
                    result.put("coinsEarned", entry.getTotalCoinsEarned());
                    result.put("studyMinutes", entry.getTotalStudyMinutes());
                    result.put("ranking", entry.getRanking());
                } else {
                    result.put("coinsEarned", 0);
                    result.put("studyMinutes", 0);
                    result.put("ranking", null);
                }
                sendJson(response, result);

            } else {
                // Default: top 5
                List<Map<String, Object>> top = leaderboardService.getMonthlyTop(5);

                // Also include current user's rank
                LeaderboardMonthly myEntry = leaderboardService.getUserMonthlyEntry(user.getUserID());

                Map<String, Object> result = new HashMap<>();
                result.put("leaderboard", top);
                result.put("myEntry", myEntry);
                sendJson(response, result);
            }
        } catch (NumberFormatException e) {
            sendJsonError(response, "Invalid data");
        }
    }

    private void sendJson(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(data));
        out.flush();
    }

    private void sendJsonError(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("error", message);
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(error));
        out.flush();
    }
}
