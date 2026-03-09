package controller;

import com.google.gson.Gson;
import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import service.StudySessionService;
import service.StudySessionServiceImpl;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {

    private StudySessionService studySessionService;
    private final Gson gson = new Gson();

    @Override
    public void init() {
        studySessionService = new StudySessionServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("AuthServlet");
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getUserID();
        String action = request.getParameter("action");

        // AJAX endpoints return JSON
        if ("weeklyStats".equals(action)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(getWeeklyStats(userId)));
            out.flush();
            return;
        }

        if ("peakHours".equals(action)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(getPeakHours(userId)));
            out.flush();
            return;
        }

        // Default: forward to dashboard page
        int totalMinutes = studySessionService.getTotalFocusMinutes(userId);
        int totalSessions = studySessionService.getTotalSessions(userId);

        request.setAttribute("totalMinutes", totalMinutes);
        request.setAttribute("totalHours", String.format("%.1f", totalMinutes / 60.0));
        request.setAttribute("totalSessions", totalSessions);

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }

    // Returns array of 7 doubles (hours per day, Mon=0 to Sun=6)
    private List<Double> getWeeklyStats(int userId) {
        EntityManager em = dao.JPAUtil.getEntityManager();
        try {
            // Get start of current week (Monday)
            Calendar cal = Calendar.getInstance();
            cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
            cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.MINUTE, 0);
            cal.set(Calendar.SECOND, 0);
            cal.set(Calendar.MILLISECOND, 0);
            Date weekStart = cal.getTime();

            @SuppressWarnings("unchecked")
            List<Object[]> results = em.createNativeQuery(
                    "SELECT EXTRACT(ISODOW FROM StartTime), COALESCE(SUM(FocusMinutes), 0) " +
                            "FROM StudySessions WHERE UserID = ?1 AND StartTime >= ?2 " +
                            "GROUP BY EXTRACT(ISODOW FROM StartTime)")
                    .setParameter(1, userId)
                    .setParameter(2, weekStart)
                    .getResultList();

            double[] hours = new double[7];
            for (Object[] row : results) {
                // PostgreSQL EXTRACT(ISODOW) returns 1=Monday, 2=Tuesday... 7=Sunday
                int pgIsoDow = ((Number) row[0]).intValue();
                int idx = pgIsoDow - 1; // Convert: Mon=0, Tue=1 ... Sun=6
                hours[idx] = ((Number) row[1]).doubleValue() / 60.0;
            }

            List<Double> result = new ArrayList<>();
            for (double h : hours) {
                result.add(Math.round(h * 10) / 10.0);
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return Arrays.asList(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        } finally {
            em.close();
        }
    }

    // Returns array of 24 strings ("low"/"medium"/"high") for each hour 0-23
    private List<String> getPeakHours(int userId) {
        EntityManager em = dao.JPAUtil.getEntityManager();
        try {
            @SuppressWarnings("unchecked")
            List<Object[]> results = em.createNativeQuery(
                    "SELECT EXTRACT(HOUR FROM StartTime), COALESCE(SUM(FocusMinutes), 0) " +
                            "FROM StudySessions WHERE UserID = ?1 " +
                            "GROUP BY EXTRACT(HOUR FROM StartTime)")
                    .setParameter(1, userId)
                    .getResultList();

            int[] minutesPerHour = new int[24];
            int maxMinutes = 1;
            for (Object[] row : results) {
                int hour = ((Number) row[0]).intValue();
                int mins = ((Number) row[1]).intValue();
                if (hour >= 0 && hour < 24) {
                    minutesPerHour[hour] = mins;
                    if (mins > maxMinutes)
                        maxMinutes = mins;
                }
            }

            List<String> levels = new ArrayList<>();
            for (int i = 0; i < 24; i++) {
                double ratio = (double) minutesPerHour[i] / maxMinutes;
                if (ratio > 0.6)
                    levels.add("high");
                else if (ratio > 0.2)
                    levels.add("medium");
                else
                    levels.add("low");
            }
            return levels;
        } catch (Exception e) {
            e.printStackTrace();
            List<String> defaults = new ArrayList<>();
            for (int i = 0; i < 24; i++)
                defaults.add("low");
            return defaults;
        } finally {
            em.close();
        }
    }
}
