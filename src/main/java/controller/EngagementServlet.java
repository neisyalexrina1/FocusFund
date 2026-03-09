package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.UserDailyQuest;
import service.EngagementServiceImpl;
import service.ValidationException;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

/**
 * Unified Engagement Servlet — Daily Quests, Micro-Sessions, Study Buddy,
 * Streak Countdown, and Onboarding.
 */
@WebServlet("/EngagementServlet")
public class EngagementServlet extends HttpServlet {

    private EngagementServiceImpl engagementService;
    private final Gson gson = new Gson();

    @Override
    public void init() {
        engagementService = new EngagementServiceImpl();
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

        if ("dailyQuests".equals(action)) {
            List<UserDailyQuest> quests = engagementService.getTodayQuests(user.getUserID());
            int completed = engagementService.getCompletedQuestsToday(user.getUserID());
            Map<String, Object> result = new HashMap<>();
            result.put("quests", quests);
            result.put("completedCount", completed);
            result.put("totalCount", quests.size());
            sendJson(response, result);

        } else if ("streakCountdown".equals(action)) {
            Map<String, Object> countdown = engagementService.getStreakCountdown(user.getUserID());
            sendJson(response, countdown);

        } else if ("buddyInfo".equals(action)) {
            Map<String, Object> buddyInfo = engagementService.getBuddyInfo(user.getUserID());
            sendJson(response, buddyInfo);

        } else if ("microStats".equals(action)) {
            Map<String, Object> stats = engagementService.getMicroSessionStats(user.getUserID());
            sendJson(response, stats);

        } else if ("onboarding".equals(action)) {
            Map<String, Object> onboarding = engagementService.getOnboardingStatus(user.getUserID());
            sendJson(response, onboarding);

        } else if ("dashboard".equals(action) || action == null) {
            // Full engagement dashboard
            Map<String, Object> dashboard = new HashMap<>();
            dashboard.put("quests", engagementService.getTodayQuests(user.getUserID()));
            dashboard.put("questsCompleted", engagementService.getCompletedQuestsToday(user.getUserID()));
            dashboard.put("streakCountdown", engagementService.getStreakCountdown(user.getUserID()));
            dashboard.put("buddyInfo", engagementService.getBuddyInfo(user.getUserID()));
            dashboard.put("onboarding", engagementService.getOnboardingStatus(user.getUserID()));
            sendJson(response, dashboard);
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
        Map<String, Object> result = new HashMap<>();

        try {
            if ("startMicro".equals(action)) {
                // ★ "Just 1 Minute" button
                result = engagementService.startMicroSession(user.getUserID());
                result.put("success", true);

            } else if ("escalateMicro".equals(action)) {
                int microId = Integer.parseInt(request.getParameter("microSessionId"));
                result = engagementService.escalateMicroSession(microId, user.getUserID());
                result.put("success", true);

            } else if ("completeMicro".equals(action)) {
                int microId = Integer.parseInt(request.getParameter("microSessionId"));
                int actualMinutes = Integer.parseInt(request.getParameter("actualMinutes"));
                result = engagementService.completeMicroSession(user.getUserID(), microId, actualMinutes);
                result.put("success", true);

            } else if ("pairBuddy".equals(action)) {
                int buddyUserId = Integer.parseInt(request.getParameter("buddyUserId"));
                result = engagementService.pairWithBuddy(user.getUserID(), buddyUserId);

            } else if ("endBuddy".equals(action)) {
                boolean ended = engagementService.endBuddyPair(user.getUserID());
                result.put("success", ended);

            } else if ("markBuddyRead".equals(action)) {
                engagementService.markBuddyNotificationsRead(user.getUserID());
                result.put("success", true);

            } else {
                result.put("success", false);
                result.put("error", "Unknown action");
            }
        } catch (ValidationException e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("error", "Invalid data");
        }

        sendJson(response, result);
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
