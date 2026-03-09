package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.VipTier;
import model.UserVipStatus;
import service.SocialService;
import service.SocialServiceImpl;
import service.VipService;
import service.VipServiceImpl;
import service.ValidationException;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet("/SocialServlet")
public class SocialServlet extends HttpServlet {

    private SocialService socialService;
    private VipService vipService;
    private final Gson gson = new Gson();

    @Override
    public void init() {
        socialService = new SocialServiceImpl();
        vipService = new VipServiceImpl();
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
            if ("socialCounts".equals(action)) {
                String userIdStr = request.getParameter("userId");
                int targetUserId = userIdStr != null ? Integer.parseInt(userIdStr) : user.getUserID();
                Map<String, Object> result = new HashMap<>();
                result.put("followers", socialService.getFollowerCount(targetUserId));
                result.put("following", socialService.getFollowingCount(targetUserId));
                result.put("isFollowing", socialService.isFollowing(user.getUserID(), targetUserId));
                sendJson(response, result);

            } else if ("isLiked".equals(action)) {
                int postId = Integer.parseInt(request.getParameter("postId"));
                Map<String, Object> result = new HashMap<>();
                result.put("isLiked", socialService.isLiked(postId, user.getUserID()));
                result.put("likeCount", socialService.getLikeCount(postId));
                sendJson(response, result);

            } else if ("vipTiers".equals(action)) {
                List<VipTier> tiers = vipService.getAllTiers();
                UserVipStatus status = vipService.getUserVipStatus(user.getUserID());
                Map<String, Object> result = new HashMap<>();
                result.put("tiers", tiers);
                result.put("currentVip", status);
                sendJson(response, result);

            } else {
                Map<String, Integer> counts = socialService.getSocialCounts(user.getUserID());
                sendJson(response, counts);
            }
        } catch (NumberFormatException e) {
            sendJsonError(response, "Invalid data");
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
            if ("like".equals(action)) {
                int postId = Integer.parseInt(request.getParameter("postId"));
                socialService.toggleLike(postId, user.getUserID());
                result.put("success", true);
                result.put("isLiked", socialService.isLiked(postId, user.getUserID()));
                result.put("likeCount", socialService.getLikeCount(postId));

            } else if ("follow".equals(action)) {
                int followingId = Integer.parseInt(request.getParameter("followingId"));
                socialService.toggleFollow(user.getUserID(), followingId);
                result.put("success", true);
                result.put("isFollowing", socialService.isFollowing(user.getUserID(), followingId));
                result.put("followerCount", socialService.getFollowerCount(followingId));

            } else if ("purchaseVip".equals(action)) {
                int tierId = Integer.parseInt(request.getParameter("tierId"));
                boolean purchased = vipService.purchaseVip(user.getUserID(), tierId);
                result.put("success", purchased);
                result.put("message", purchased ? "VIP activated!" : "Unable to purchase VIP");

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
