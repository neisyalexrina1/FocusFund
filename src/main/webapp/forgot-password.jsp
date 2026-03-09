<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <%@ include file="common/header.jsp" %>
                <title>Forgot Password - FocusFund</title>
        </head>

        <body>
            <div class="background-effects">
                <div class="stars" id="stars"></div>
                <div class="shooting-stars" id="shooting-stars"></div>
                <div class="rain" id="rain"></div>
            </div>

            <%@ include file="common/navbar.jsp" %>

                <section class="page active">
                    <div class="auth-container">
                        <div class="auth-card">
                            <div class="auth-header">
                                <h1>Reset Password</h1>
                                <p>Enter your email to receive a reset code.</p>
                            </div>

                            <c:if test="${not empty errorMessage}">
                                <script>document.addEventListener('DOMContentLoaded', function () { showToast('${errorMessage}', 'error'); });</script>
                            </c:if>

                            <form class="auth-form" action="${pageContext.request.contextPath}/AuthServlet"
                                method="post">
                                <input type="hidden" name="action" value="forgotPassword">
                                <div class="form-group">
                                    <label for="email">Email</label>
                                    <input type="email" id="email" name="email" class="input"
                                        placeholder="your@email.com" required>
                                </div>
                                <button type="submit" class="btn btn-primary btn-full">Send OTP</button>

                                <div style="text-align: center; margin-top: 20px;">
                                    <a href="login.jsp"
                                        style="color: #64748b; font-size: 14px; text-decoration: none;">← Back to
                                        login</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </section>
        </body>

        </html>