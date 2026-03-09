package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import service.EmailService;
import service.UserService;
import service.UserServiceImpl;
import service.ValidationException;

import java.io.IOException;
import java.util.Random;

@WebServlet("/AuthServlet")
public class AuthServlet extends HttpServlet {

    private UserService userService;
    private EmailService emailService;

    @Override
    public void init() {
        userService = new UserServiceImpl();
        emailService = new EmailService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }

            Cookie loginCookie = new Cookie("login_verified", "");
            loginCookie.setMaxAge(0);
            response.addCookie(loginCookie);

            Cookie rememberCookie = new Cookie("remember_me", "");
            rememberCookie.setMaxAge(0);
            response.addCookie(rememberCookie);

            response.sendRedirect("index.jsp");
            return;
        }

        // Auto-login from session
        HttpSession session = request.getSession();
        if (session.getAttribute("user") != null) {
            response.sendRedirect("HomeServlet");
            return;
        }

        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case "login":
                handleLogin(request, response);
                break;
            case "register":
                handleRegister(request, response);
                break;
            case "verifyLoginOtp":
                verifyLoginOtp(request, response);
                break;
            case "verifyRegisterOtp":
                verifyRegisterOtp(request, response);
                break;
            case "forgotPassword":
                forgotPassword(request, response);
                break;
            case "verifyResetOtp":
                verifyResetOtp(request, response);
                break;
            case "resetPassword":
                resetPassword(request, response);
                break;
        }
    }

    private String generateOtp() {
        return String.format("%06d", new Random().nextInt(999999));
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        boolean rememberMe = "on".equals(request.getParameter("rememberMe"));

        User user = userService.login(username, password);
        if (user != null) {
            // Check if login is verified via cookie
            boolean isVerified = false;
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("login_verified".equals(cookie.getName())) {
                        isVerified = true;
                        break;
                    }
                }
            }

            if (isVerified) {
                // Directly login
                completeLogin(request, response, user, rememberMe);
            } else {
                // Require OTP verification
                String otp = generateOtp();
                HttpSession session = request.getSession();
                session.setAttribute("pendingLoginUser", user);
                session.setAttribute("loginOtp", otp);
                session.setAttribute("loginOtpTime", System.currentTimeMillis());
                session.setAttribute("loginRememberMe", rememberMe);

                try {
                    emailService.sendLoginOtp(user.getEmail(), user.getUsername(), otp);
                    request.setAttribute("otpType", "login");
                    request.setAttribute("emailSentTo", user.getEmail());
                    request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
                } catch (Exception e) {
                    request.setAttribute("errorMessage", "Failed to send OTP email.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            }
        } else {
            request.setAttribute("errorMessage", "Invalid username or password");
            request.setAttribute("activeTab", "login");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private void completeLogin(HttpServletRequest request, HttpServletResponse response, User user, boolean rememberMe)
            throws IOException {
        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getUserID());

        // Set login_verified cookie for 1 day
        Cookie loginCookie = new Cookie("login_verified", "true");
        loginCookie.setMaxAge(24 * 60 * 60);
        response.addCookie(loginCookie);

        if (rememberMe) {
            Cookie rememberCookie = new Cookie("remember_me", String.valueOf(user.getUserID()));
            rememberCookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
            response.addCookie(rememberCookie);
        }

        response.sendRedirect("HomeServlet");
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match");
            request.setAttribute("activeTab", "signup");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Preliminary validation
        if (userService.findByUsername(username) != null) {
            request.setAttribute("errorMessage", "Username already exists");
            request.setAttribute("activeTab", "signup");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        if (userService.findByEmail(email) != null) {
            request.setAttribute("errorMessage", "Email already registered");
            request.setAttribute("activeTab", "signup");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Store pending user in session
        HttpSession session = request.getSession();
        session.setAttribute("regUsername", username);
        session.setAttribute("regPassword", password);
        session.setAttribute("regFullName", fullName);
        session.setAttribute("regEmail", email);

        String otp = generateOtp();
        session.setAttribute("registerOtp", otp);
        session.setAttribute("registerOtpTime", System.currentTimeMillis());

        try {
            emailService.sendRegistrationOtp(email, username, otp);
            request.setAttribute("otpType", "register");
            request.setAttribute("emailSentTo", email);
            request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Registration failed. Try again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private void verifyLoginOtp(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String enteredOtp = request.getParameter("otp");
        String actualOtp = (String) session.getAttribute("loginOtp");
        Long otpTime = (Long) session.getAttribute("loginOtpTime");
        User pendingUser = (User) session.getAttribute("pendingLoginUser");
        Boolean rememberMe = (Boolean) session.getAttribute("loginRememberMe");

        if (actualOtp != null && otpTime != null && pendingUser != null) {
            if (System.currentTimeMillis() - otpTime > 10 * 60 * 1000) {
                request.setAttribute("errorMessage", "OTP has expired.");
                request.setAttribute("otpType", "login");
                request.setAttribute("emailSentTo", pendingUser.getEmail());
                request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
            } else if (actualOtp.equals(enteredOtp)) {
                // Clear session attributes
                session.removeAttribute("loginOtp");
                session.removeAttribute("loginOtpTime");
                session.removeAttribute("pendingLoginUser");

                completeLogin(request, response, pendingUser, rememberMe != null && rememberMe);
            } else {
                request.setAttribute("errorMessage", "Invalid OTP.");
                request.setAttribute("otpType", "login");
                request.setAttribute("emailSentTo", pendingUser.getEmail());
                request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    private void verifyRegisterOtp(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String enteredOtp = request.getParameter("otp");
        String actualOtp = (String) session.getAttribute("registerOtp");
        Long otpTime = (Long) session.getAttribute("registerOtpTime");

        if (actualOtp != null && otpTime != null) {
            String email = (String) session.getAttribute("regEmail");

            if (System.currentTimeMillis() - otpTime > 10 * 60 * 1000) {
                request.setAttribute("errorMessage", "OTP has expired.");
                request.setAttribute("otpType", "register");
                request.setAttribute("emailSentTo", email);
                request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
            } else if (actualOtp.equals(enteredOtp)) {
                // Register user
                String username = (String) session.getAttribute("regUsername");
                String password = (String) session.getAttribute("regPassword");
                String fullName = (String) session.getAttribute("regFullName");

                try {
                    boolean registered = userService.register(username, password, fullName, email);
                    if (registered) {
                        request.setAttribute("successMessage", "Account created successfully! Please login.");
                        request.setAttribute("activeTab", "login");
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                    } else {
                        throw new Exception();
                    }
                } catch (Exception e) {
                    request.setAttribute("errorMessage", "Registration failed.");
                    request.setAttribute("activeTab", "signup");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                } finally {
                    session.removeAttribute("registerOtp");
                    session.removeAttribute("registerOtpTime");
                }
            } else {
                request.setAttribute("errorMessage", "Invalid OTP.");
                request.setAttribute("otpType", "register");
                request.setAttribute("emailSentTo", email);
                request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    private void forgotPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        User user = userService.findByEmail(email);

        if (user != null) {
            String otp = generateOtp();
            HttpSession session = request.getSession();
            session.setAttribute("resetEmail", email);
            session.setAttribute("resetOtp", otp);
            session.setAttribute("resetOtpTime", System.currentTimeMillis());

            try {
                emailService.sendPasswordResetOtp(email, user.getUsername(), otp);
                request.setAttribute("otpType", "reset");
                request.setAttribute("emailSentTo", email);
                request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
                return;
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Failed to send reset email.");
            }
        } else {
            request.setAttribute("errorMessage", "Account not found with this email.");
        }
        request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
    }

    private void verifyResetOtp(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String enteredOtp = request.getParameter("otp");
        String actualOtp = (String) session.getAttribute("resetOtp");
        Long otpTime = (Long) session.getAttribute("resetOtpTime");

        if (actualOtp != null && otpTime != null) {
            String email = (String) session.getAttribute("resetEmail");

            if (System.currentTimeMillis() - otpTime > 10 * 60 * 1000) {
                request.setAttribute("errorMessage", "OTP has expired.");
                request.setAttribute("otpType", "reset");
                request.setAttribute("emailSentTo", email);
                request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
            } else if (actualOtp.equals(enteredOtp)) {
                // Move to reset password page, valid session set
                session.setAttribute("resetVerified", true);

                User user = userService.findByEmail(email);
                request.setAttribute("username", user.getUsername());
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Invalid OTP.");
                request.setAttribute("otpType", "reset");
                request.setAttribute("emailSentTo", email);
                request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("forgot-password.jsp");
        }
    }

    private void resetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Boolean resetVerified = (Boolean) session.getAttribute("resetVerified");
        String email = (String) session.getAttribute("resetEmail");

        if (resetVerified != null && resetVerified && email != null) {
            String newPassword = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            User user = userService.findByEmail(email);

            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "Passwords do not match.");
                request.setAttribute("username", user.getUsername());
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                return;
            }

            try {
                if (userService.updatePassword(user.getUserID(), newPassword)) {
                    session.removeAttribute("resetOtp");
                    session.removeAttribute("resetOtpTime");
                    session.removeAttribute("resetVerified");
                    session.removeAttribute("resetEmail");

                    request.setAttribute("successMessage", "Password updated successfully! Please login.");
                    request.setAttribute("activeTab", "login");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                } else {
                    throw new Exception();
                }
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Failed to update password.");
                request.setAttribute("username", user.getUsername());
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}
