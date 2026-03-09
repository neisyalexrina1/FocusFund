package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.FocusFundContract;
import model.FocusFundPool;
import model.FocusFundTransaction;
import model.User;
import service.FocusFundService;
import service.FocusFundServiceImpl;
import service.ValidationException;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet("/FocusFundServlet")
public class FocusFundServlet extends HttpServlet {

    private FocusFundService focusFundService;
    private final Gson gson = new Gson();

    @Override
    public void init() {
        focusFundService = new FocusFundServiceImpl();
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

        if ("dashboard".equals(action)) {
            // Full dashboard: balance + contract + gamification + pool + transactions
            Map<String, Object> dashboard = focusFundService.getDashboard(user.getUserID());
            sendJson(response, dashboard);

        } else if ("balance".equals(action)) {
            Map<String, Object> result = new HashMap<>();
            result.put("balance", focusFundService.getBalance(user.getUserID()));
            sendJson(response, result);

        } else if ("contracts".equals(action)) {
            List<FocusFundContract> contracts = focusFundService.getUserContracts(user.getUserID());
            sendJson(response, contracts);

        } else if ("activeContract".equals(action)) {
            FocusFundContract contract = focusFundService.getActiveContract(user.getUserID());
            Map<String, Object> result = new HashMap<>();
            result.put("hasContract", contract != null);
            result.put("contract", contract);
            sendJson(response, result);

        } else if ("pool".equals(action)) {
            FocusFundPool pool = focusFundService.getCurrentPool();
            Map<String, Object> result = new HashMap<>();
            if (pool != null) {
                result.put("leaderboardPool", pool.getLeaderboardPool());
                result.put("totalPenalties", pool.getTotalPenalties());
                result.put("distributed", pool.isDistributed());
            } else {
                result.put("leaderboardPool", 0);
                result.put("totalPenalties", 0);
            }
            sendJson(response, result);

        } else if ("transactions".equals(action)) {
            String limitStr = request.getParameter("limit");
            int limit = limitStr != null ? Integer.parseInt(limitStr) : 20;
            List<FocusFundTransaction> transactions = focusFundService.getTransactions(user.getUserID(), limit);
            sendJson(response, transactions);

        } else {
            // Default: dashboard
            Map<String, Object> dashboard = focusFundService.getDashboard(user.getUserID());
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
            if ("deposit".equals(action)) {
                double amount = Double.parseDouble(request.getParameter("amount"));
                boolean success = focusFundService.deposit(user.getUserID(), amount);
                result.put("success", success);
                result.put("balance", focusFundService.getBalance(user.getUserID()));
                result.put("message",
                        success ? "Deposited " + String.format("%,.0f", amount) + " VND successfully!"
                                : "Deposit failed");

            } else if ("withdraw".equals(action)) {
                double amount = Double.parseDouble(request.getParameter("amount"));
                boolean success = focusFundService.withdraw(user.getUserID(), amount);
                result.put("success", success);
                result.put("balance", focusFundService.getBalance(user.getUserID()));
                result.put("message",
                        success ? "Withdrawn " + String.format("%,.0f", amount) + " VND successfully!"
                                : "Withdrawal failed");

            } else if ("createContract".equals(action)) {
                double stakeAmount = Double.parseDouble(request.getParameter("stakeAmount"));
                int penaltyPercent = Integer.parseInt(request.getParameter("penaltyPercent") != null
                        ? request.getParameter("penaltyPercent")
                        : "10");
                String goalType = request.getParameter("goalType") != null
                        ? request.getParameter("goalType")
                        : "session";
                int goalValue = Integer.parseInt(request.getParameter("goalValue") != null
                        ? request.getParameter("goalValue")
                        : "25");
                int durationDays = Integer.parseInt(request.getParameter("durationDays") != null
                        ? request.getParameter("durationDays")
                        : "1");

                int contractId = focusFundService.createContract(user.getUserID(), stakeAmount,
                        penaltyPercent, goalType, goalValue, durationDays);
                result.put("success", contractId > 0);
                result.put("contractId", contractId);
                result.put("balance", focusFundService.getBalance(user.getUserID()));
                result.put("message", "Contract created! Staked " + String.format("%,.0f", stakeAmount) + " VND");

            } else if ("sessionComplete".equals(action)) {
                // ★ CENTRAL ENDPOINT — triggers everything
                int focusMinutes = Integer.parseInt(request.getParameter("focusMinutes"));
                String sessionIdStr = request.getParameter("sessionId");
                Integer sessionId = sessionIdStr != null && !sessionIdStr.isEmpty()
                        ? Integer.parseInt(sessionIdStr)
                        : null;

                result = focusFundService.onSessionComplete(user.getUserID(), focusMinutes, sessionId);
                result.put("success", true);

            } else if ("sessionFailed".equals(action)) {
                String sessionIdStr = request.getParameter("sessionId");
                Integer sessionId = sessionIdStr != null && !sessionIdStr.isEmpty()
                        ? Integer.parseInt(sessionIdStr)
                        : null;

                result = focusFundService.onSessionFailed(user.getUserID(), sessionId);
                result.put("success", true);

            } else if ("exchangeCoins".equals(action)) {
                int coins = Integer.parseInt(request.getParameter("coins"));
                result = focusFundService.exchangeCoinsToVnd(user.getUserID(), coins);

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
