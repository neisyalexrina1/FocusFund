package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import service.EmailService;
import service.UserService;
import service.UserServiceImpl;

import java.io.IOException;
import java.util.Random;

@WebFilter("/*")
public class AutoLoginFilter implements Filter {

    private UserService userService;
    private EmailService emailService;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        userService = new UserServiceImpl();
        emailService = new EmailService();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String uri = req.getRequestURI();

        // Skip static resources and auth-related paths
        if (uri.matches(".*(css|jpg|png|gif|js|jsp|AuthServlet).*")) {
            chain.doFilter(request, response);
            return;
        }

        // If user is already in session, proceed
        if (session != null && session.getAttribute("user") != null) {
            chain.doFilter(request, response);
            return;
        }

        // Check cookies for auto-login
        Cookie[] cookies = req.getCookies();
        String rememberUserId = null;
        boolean isVerified = false;

        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("remember_me".equals(cookie.getName())) {
                    rememberUserId = cookie.getValue();
                }
                if ("login_verified".equals(cookie.getName())) {
                    isVerified = true;
                }
            }
        }

        if (rememberUserId != null && !rememberUserId.isEmpty()) {
            try {
                int userId = Integer.parseInt(rememberUserId);
                User user = userService.getUserById(userId);

                if (user != null && user.getUserID() > 0) {
                    session = req.getSession(true);

                    if (isVerified) {
                        // Fully verified, log them in
                        session.setAttribute("user", user);
                        session.setAttribute("userId", user.getUserID());
                        chain.doFilter(request, response);
                        return;
                    } else {
                        // Remembered but session expired (1 day passed). Need OTP.
                        String otp = String.format("%06d", new Random().nextInt(999999));
                        session.setAttribute("pendingLoginUser", user);
                        session.setAttribute("loginOtp", otp);
                        session.setAttribute("loginOtpTime", System.currentTimeMillis());
                        session.setAttribute("loginRememberMe", true);

                        try {
                            emailService.sendLoginOtp(user.getEmail(), user.getUsername(), otp);
                            req.setAttribute("otpType", "login");
                            req.setAttribute("emailSentTo", user.getEmail());
                            req.getRequestDispatcher("verify-otp.jsp").forward(req, res);
                            return;
                        } catch (Exception e) {
                            // Failed to send email, proceed to let normal auth handle it or login page
                        }
                    }
                }
            } catch (NumberFormatException e) {
                // Invalid cookie value, ignore
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
