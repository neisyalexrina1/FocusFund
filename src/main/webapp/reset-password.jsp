<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <%@ include file="common/header.jsp" %>
                <title>Set New Password - FocusFund</title>
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
                                <h1>Set New Password</h1>
                                <p>Enter your new password below.</p>
                            </div>

                            <c:if test="${not empty errorMessage}">
                                <script>document.addEventListener('DOMContentLoaded', function () { showToast('${errorMessage}', 'error'); });</script>
                            </c:if>

                            <form class="auth-form" action="${pageContext.request.contextPath}/AuthServlet"
                                method="post">
                                <input type="hidden" name="action" value="resetPassword">

                                <div class="form-group">
                                    <label for="username">Username</label>
                                    <div class="input"
                                        style="background: #f1f5f9; cursor: not-allowed; line-height: 20px; color: #64748b; user-select: none;">
                                        ${username}
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="password">New Password</label>
                                    <input type="password" id="password" name="password" class="input"
                                        placeholder="••••••••" required minlength="8">
                                </div>
                                <div class="form-group">
                                    <label for="confirmPassword">Confirm Password</label>
                                    <input type="password" id="confirmPassword" name="confirmPassword" class="input"
                                        placeholder="••••••••" required minlength="8">
                                </div>

                                <button type="submit" class="btn btn-primary btn-full">Reset Password</button>

                                <div style="text-align: center; margin-top: 20px;">
                                    <a href="login.jsp"
                                        style="color: #64748b; font-size: 14px; text-decoration: none;">Cancel</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </section>
        </body>

        </html>