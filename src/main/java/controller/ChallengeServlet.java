package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Challenge;
import model.User;
import model.UserChallenge;
import service.ChallengeService;
import service.ChallengeServiceImpl;
import service.GamificationService;
import service.GamificationServiceImpl;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet("/ChallengeServlet")
public class ChallengeServlet extends HttpServlet {

    private ChallengeService challengeService;
    private GamificationService gamificationService;
    private final Gson gson = new Gson();

    @Override
    public void init() {
        challengeService = new ChallengeServiceImpl();
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

        if ("list".equals(action)) {
            List<Challenge> challenges = challengeService.getActiveChallenges();
            sendJson(response, challenges);

        } else if ("myActive".equals(action)) {
            List<UserChallenge> active = challengeService.getActiveUserChallenges(user.getUserID());
            sendJson(response, active);

        } else if ("myAll".equals(action)) {
            List<UserChallenge> all = challengeService.getUserChallenges(user.getUserID());
            sendJson(response, all);

        } else {
            List<Challenge> challenges = challengeService.getActiveChallenges();
            sendJson(response, challenges);
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
            if ("join".equals(action)) {
                int challengeId = Integer.parseInt(request.getParameter("challengeId"));
                boolean joined = challengeService.joinChallenge(user.getUserID(), challengeId);
                result.put("success", joined);
                result.put("message", joined ? "Challenge joined!" : "Unable to join challenge");

            } else if ("updateProgress".equals(action)) {
                int userChallengeId = Integer.parseInt(request.getParameter("userChallengeId"));
                int daysCompleted = Integer.parseInt(request.getParameter("daysCompleted"));
                boolean updated = challengeService.updateProgress(userChallengeId, daysCompleted, user.getUserID());

                if (updated) {
                    // Check if just completed — award coins
                    Challenge challenge = null;
                    List<UserChallenge> userChallenges = challengeService.getUserChallenges(user.getUserID());
                    for (UserChallenge uc : userChallenges) {
                        if (uc.getUserChallengeID() == userChallengeId && "completed".equals(uc.getStatus())) {
                            challenge = uc.getChallenge();
                            break;
                        }
                    }
                    if (challenge != null) {
                        gamificationService.addCoins(user.getUserID(), challenge.getCoinReward());
                        gamificationService.addExp(user.getUserID(), challenge.getExpReward());
                        result.put("challengeCompleted", true);
                        result.put("coinsEarned", challenge.getCoinReward());
                        result.put("expEarned", challenge.getExpReward());
                    }
                }
                result.put("success", updated);

            } else if ("abandon".equals(action)) {
                int userChallengeId = Integer.parseInt(request.getParameter("userChallengeId"));
                boolean abandoned = challengeService.abandonChallenge(userChallengeId, user.getUserID());
                result.put("success", abandoned);

            } else {
                result.put("success", false);
                result.put("error", "Unknown action");
            }
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
