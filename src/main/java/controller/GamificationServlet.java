package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.UserGamification;
import model.DailyStreak;
import model.UserBadge;
import model.Badge;
import service.GamificationService;
import service.GamificationServiceImpl;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet("/GamificationServlet")
public class GamificationServlet extends HttpServlet {

    private GamificationService gamificationService;
    private final Gson gson = new Gson();

    @Override
    public void init() {
        gamificationService = new GamificationServiceImpl();
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

        if ("profile".equals(action)) {
            // Get full gamification profile
            Map<String, Object> result = new HashMap<>();
            UserGamification gData = gamificationService.getGamificationData(user.getUserID());
            DailyStreak streak = gamificationService.getStreak(user.getUserID());
            List<UserBadge> badges = gamificationService.getUserBadges(user.getUserID());

            result.put("focusCoins", gData.getFocusCoins());
            result.put("totalExp", gData.getTotalExp());
            result.put("currentRank", gData.getCurrentRank());
            result.put("totalStudyHours", gData.getTotalStudyHours());
            result.put("totalStudyMinutes", gData.getTotalStudyMinutes());
            result.put("currentStreak", streak.getCurrentStreak());
            result.put("longestStreak", streak.getLongestStreak());
            result.put("badges", badges);

            sendJson(response, result);

        } else if ("badges".equals(action)) {
            // Get all badges with user's earned status
            List<Badge> allBadges = gamificationService.getAllBadges();
            List<UserBadge> userBadges = gamificationService.getUserBadges(user.getUserID());
            Set<Integer> earnedIds = new HashSet<>();
            for (UserBadge ub : userBadges) {
                earnedIds.add(ub.getBadgeID());
            }

            List<Map<String, Object>> badgeList = new ArrayList<>();
            for (Badge b : allBadges) {
                Map<String, Object> item = new HashMap<>();
                item.put("badgeID", b.getBadgeID());
                item.put("badgeName", b.getBadgeName());
                item.put("badgeIcon", b.getBadgeIcon());
                item.put("description", b.getDescription());
                item.put("badgeType", b.getBadgeType());
                item.put("earned", earnedIds.contains(b.getBadgeID()));
                badgeList.add(item);
            }

            sendJson(response, badgeList);

        } else {
            // Default: return basic gamification data
            UserGamification gData = gamificationService.getGamificationData(user.getUserID());
            sendJson(response, gData);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendJsonError(response, "Not logged in");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        try {
            if ("sessionComplete".equals(action)) {
                // ★ DEPRECATED — Use FocusFundServlet?action=sessionComplete instead
                Map<String, Object> redirect = new HashMap<>();
                redirect.put("success", false);
                redirect.put("error", "Please use /FocusFundServlet?action=sessionComplete");
                redirect.put("redirectTo", "FocusFundServlet");
                sendJson(response, redirect);

            } else if ("dailyLogin".equals(action)) {
                Map<String, Object> result = gamificationService.claimDailyLogin(user.getUserID());
                sendJson(response, result);

            } else if ("claimReward".equals(action)) {
                String sessionIdStr = request.getParameter("sessionId");
                Integer sessionId = sessionIdStr != null ? Integer.parseInt(sessionIdStr) : null;
                Map<String, Object> result = gamificationService.claimMysteryReward(user.getUserID(), sessionId);
                sendJson(response, result);

            } else {
                sendJsonError(response, "Unknown action");
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
