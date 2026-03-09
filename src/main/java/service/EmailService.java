package service;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import com.google.gson.Gson;
import java.util.HashMap;
import java.util.Map;

/**
 * Sends emails via Google Apps Script Webhook to bypass Render port
 * restrictions.
 */
public class EmailService {

    private final String webhookUrl;
    private final Gson gson = new Gson();

    public EmailService() {
        String envUrl = System.getenv("WEBHOOK_URL");
        // Use provided Webhook URL as fallback if environment variable is not set
        this.webhookUrl = (envUrl != null && !envUrl.isEmpty()) ? envUrl
                : "https://script.google.com/macros/s/AKfycbwOkoEaDzfgwzZdyvmIsjR-vo0VnrHPcGdOLxkTkfltOSkJqH0i8lbSEpaXYSK91sKT/exec";
    }

    /** Sends an HTML email via Webhook */
    public void sendHtml(String toEmail, String subject, String htmlBody) throws Exception {
        URL url = new URL(webhookUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        Map<String, String> payload = new HashMap<>();
        payload.put("to", toEmail);
        payload.put("subject", subject);
        payload.put("htmlBody", htmlBody);

        String jsonPayload = gson.toJson(payload);

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonPayload.getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }

        int responseCode = conn.getResponseCode();
        /*
         * Google Apps Script Web App frequently returns 302 Redirect upon POST.
         * HttpURLConnection automatically follows redirects.
         * If the final code is 200, it succeeded.
         */
        if (responseCode != HttpURLConnection.HTTP_OK && responseCode != HttpURLConnection.HTTP_CREATED) {
            throw new RuntimeException("Failed to send email. HTTP response code: " + responseCode);
        }
    }

    /** Sends a password reset OTP email. */
    public void sendPasswordResetOtp(String toEmail, String username, String otp) throws Exception {
        String html = "<!DOCTYPE html><html><head><meta charset='UTF-8'></head>"
                + "<body style='margin:0;padding:0;background:#f1f4f8;font-family:Inter,Segoe UI,sans-serif;'>"
                + "<table width='100%' cellpadding='0' cellspacing='0' style='background:#f1f4f8;padding:40px 0;'><tr><td align='center'>"
                + "<table width='520' cellpadding='0' cellspacing='0' style='background:#fff;border-radius:14px;box-shadow:0 4px 20px rgba(0,0,0,0.08);overflow:hidden;'>"
                + "<tr><td style='background:linear-gradient(135deg,#1e293b,#0f172a);padding:28px 40px;text-align:center;'>"
                + "<h1 style='margin:0;color:#fff;font-size:22px;font-weight:700;'>🔐 Password Reset</h1>"
                + "<p style='margin:6px 0 0;color:#94a3b8;font-size:13px;'>FocusFund Focus System</p></td></tr>"
                + "<tr><td style='padding:32px 40px;'>"
                + "<p style='color:#374151;font-size:15px;line-height:1.6;margin:0 0 20px;'>Hi <strong>" + username
                + "</strong>,<br>We received a request to reset your password. Use the code below:</p>"
                + "<div style='background:#f0f7ff;border:2px dashed #0284c7;border-radius:10px;padding:20px;text-align:center;margin:0 0 20px;'>"
                + "<div style='font-size:2.4rem;font-weight:800;letter-spacing:0.25em;color:#0b6cb3;'>" + otp + "</div>"
                + "<p style='margin:8px 0 0;font-size:12px;color:#64748b;'>Valid for <strong>10 minutes</strong></p></div>"
                + "<p style='color:#6b7280;font-size:13px;line-height:1.6;'>If you did not request a password reset, please ignore this email.<br>Your account remains secure.</p>"
                + "</td></tr>"
                + "<tr><td style='padding:16px 40px 28px;text-align:center;border-top:1px solid #f1f4f8;'>"
                + "<p style='margin:0;color:#94a3b8;font-size:12px;'>© 2026 FocusFund System</p></td></tr>"
                + "</table></td></tr></table></body></html>";
        sendHtml(toEmail, "🔐 Password Reset — Verification Code", html);
    }

    /** Sends a login verification OTP email when session has expired. */
    public void sendLoginOtp(String toEmail, String username, String otp) throws Exception {
        String html = "<!DOCTYPE html><html><head><meta charset='UTF-8'></head>"
                + "<body style='margin:0;padding:0;background:#f1f4f8;font-family:Inter,Segoe UI,sans-serif;'>"
                + "<table width='100%' cellpadding='0' cellspacing='0' style='background:#f1f4f8;padding:40px 0;'><tr><td align='center'>"
                + "<table width='520' cellpadding='0' cellspacing='0' style='background:#fff;border-radius:14px;box-shadow:0 4px 20px rgba(0,0,0,0.08);overflow:hidden;'>"
                + "<tr><td style='background:linear-gradient(135deg,#4f46e5,#7c3aed);padding:28px 40px;text-align:center;'>"
                + "<h1 style='margin:0;color:#fff;font-size:22px;font-weight:700;'>🔒 Login Verification</h1>"
                + "<p style='margin:6px 0 0;color:#c4b5fd;font-size:13px;'>FocusFund Focus System</p></td></tr>"
                + "<tr><td style='padding:32px 40px;'>"
                + "<p style='color:#374151;font-size:15px;line-height:1.6;margin:0 0 20px;'>Hi <strong>" + username
                + "</strong>,<br>Your login session requires verification. Please enter the code below to confirm your identity:</p>"
                + "<div style='background:#f5f3ff;border:2px dashed #7c3aed;border-radius:10px;padding:20px;text-align:center;margin:0 0 20px;'>"
                + "<div style='font-size:2.4rem;font-weight:800;letter-spacing:0.25em;color:#4f46e5;'>" + otp + "</div>"
                + "<p style='margin:8px 0 0;font-size:12px;color:#64748b;'>Code is valid for <strong>10 minutes</strong></p></div>"
                + "<div style='background:#fef3c7;border-left:4px solid #f59e0b;border-radius:6px;padding:12px 16px;margin-bottom:16px;'>"
                + "<p style='margin:0;color:#92400e;font-size:13px;'>⚠️ If you did not attempt this login, please change your password immediately.</p></div>"
                + "<p style='color:#6b7280;font-size:13px;line-height:1.6;'>For security reasons, this code is for one-time use and expires in 10 minutes.</p>"
                + "</td></tr>"
                + "<tr><td style='padding:16px 40px 28px;text-align:center;border-top:1px solid #f1f4f8;'>"
                + "<p style='margin:0;color:#94a3b8;font-size:12px;'>© 2026 FocusFund System</p></td></tr>"
                + "</table></td></tr></table></body></html>";
        sendHtml(toEmail, "🔒 Login Verification — FocusFund", html);
    }

    /** Sends a registration OTP email to verify the user's email address. */
    public void sendRegistrationOtp(String toEmail, String username, String otp) throws Exception {
        String html = "<!DOCTYPE html><html><head><meta charset='UTF-8'></head>"
                + "<body style='margin:0;padding:0;background:#f1f4f8;font-family:Inter,Segoe UI,sans-serif;'>"
                + "<table width='100%' cellpadding='0' cellspacing='0' style='background:#f1f4f8;padding:40px 0;'><tr><td align='center'>"
                + "<table width='520' cellpadding='0' cellspacing='0' style='background:#fff;border-radius:14px;box-shadow:0 4px 20px rgba(0,0,0,0.08);overflow:hidden;'>"
                + "<tr><td style='background:linear-gradient(135deg,#0b6cb3,#0284c7);padding:28px 40px;text-align:center;'>"
                + "<h1 style='margin:0;color:#fff;font-size:22px;font-weight:700;'>✅ Account Verification</h1>"
                + "<p style='margin:6px 0 0;color:#bae6fd;font-size:13px;'>FocusFund Focus System</p></td></tr>"
                + "<tr><td style='padding:32px 40px;'>"
                + "<p style='color:#374151;font-size:15px;line-height:1.6;margin:0 0 20px;'>Hi <strong>" + username
                + "</strong>,<br>Thanks for registering! Please enter the verification code below to activate your account:</p>"
                + "<div style='background:#f0fdf4;border:2px dashed #16a34a;border-radius:10px;padding:20px;text-align:center;margin:0 0 20px;'>"
                + "<div style='font-size:2.4rem;font-weight:800;letter-spacing:0.25em;color:#15803d;'>" + otp + "</div>"
                + "<p style='margin:8px 0 0;font-size:12px;color:#64748b;'>Code is valid for <strong>10 minutes</strong></p></div>"
                + "<p style='color:#6b7280;font-size:13px;line-height:1.6;'>If you did not register for an account, please ignore this email.</p>"
                + "</td></tr>"
                + "<tr><td style='padding:16px 40px 28px;text-align:center;border-top:1px solid #f1f4f8;'>"
                + "<p style='margin:0;color:#94a3b8;font-size:12px;'>© 2026 FocusFund System</p></td></tr>"
                + "</table></td></tr></table></body></html>";
        sendHtml(toEmail, "✅ Account Registration Verification — FocusFund", html);
    }
}
