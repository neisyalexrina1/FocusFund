<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <%@ include file="common/header.jsp" %>
                <title>Login - FocusFund</title>
        </head>

        <body>
            <div class="background-effects">
                <div class="stars" id="stars"></div>
                <div class="shooting-stars" id="shooting-stars"></div>
                <div class="rain" id="rain"></div>
            </div>

            <%@ include file="common/navbar.jsp" %>

                <!-- Page: Login -->
                <section class="page active" id="page-login">
                    <div class="auth-container">
                        <div class="auth-card">
                            <div class="auth-header">
                                <span class="auth-logo">✦</span>
                                <h1>Welcome Back</h1>
                                <p>Sign in to continue your learning journey</p>
                            </div>

                            <c:if test="${not empty successMessage}">
                                <script>document.addEventListener('DOMContentLoaded', function () { showToast('${successMessage}', 'success'); });</script>
                            </c:if>
                            <c:if test="${not empty errorMessage}">
                                <script>document.addEventListener('DOMContentLoaded', function () { showToast('${errorMessage}', 'error'); });</script>
                            </c:if>

                            <div class="auth-tabs">
                                <button class="auth-tab ${empty activeTab || activeTab == 'login' ? 'active' : ''}"
                                    onclick="switchAuthTab('login')">Login</button>
                                <button class="auth-tab ${activeTab == 'signup' ? 'active' : ''}"
                                    onclick="switchAuthTab('signup')">Sign Up</button>
                            </div>

                            <!-- Login Form -->
                            <form class="auth-form ${empty activeTab || activeTab == 'login' ? '' : 'hidden'}"
                                id="loginForm" action="${pageContext.request.contextPath}/AuthServlet" method="post">
                                <input type="hidden" name="action" value="login">
                                <div class="form-group">
                                    <label for="loginEmailOrUsername">Username</label>
                                    <input type="text" id="loginEmailOrUsername" name="username" class="input"
                                        placeholder="Your username" required>
                                </div>
                                <div class="form-group">
                                    <label for="loginPassword">Password</label>
                                    <input type="password" id="loginPassword" name="password" class="input"
                                        placeholder="••••••••" required>
                                </div>
                                <div style="text-align: right; margin-bottom: 20px;">
                                    <a href="forgot-password.jsp"
                                        style="color: #64748b; font-size: 14px; text-decoration: none;">Forgot
                                        Password?</a>
                                </div>
                                <div class="form-options">
                                    <label class="checkbox-label">
                                        <input type="checkbox" id="rememberMe" name="rememberMe">
                                        <span>Remember me</span>
                                    </label>
                                </div>
                                <button type="submit" class="btn btn-primary btn-full">Sign In</button>
                            </form>

                            <!-- Signup Form -->
                            <form class="auth-form ${activeTab == 'signup' ? '' : 'hidden'}" id="signupForm"
                                action="${pageContext.request.contextPath}/AuthServlet" method="post">
                                <input type="hidden" name="action" value="register">
                                <div class="form-group">
                                    <label for="signupName">Full Name</label>
                                    <input type="text" id="signupName" name="fullName" class="input"
                                        placeholder="John Doe" required>
                                </div>
                                <div class="form-group">
                                    <label for="signupUsername">Username</label>
                                    <div class="input-with-prefix">
                                        <span class="input-prefix">@</span>
                                        <input type="text" id="signupUsername" name="username" class="input"
                                            placeholder="johndoe" required pattern="[A-Za-z0-9_]+"
                                            title="Letters, numbers, and underscores only">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="signupEmail">Email</label>
                                    <input type="email" id="signupEmail" name="email" class="input"
                                        placeholder="your@email.com" required>
                                </div>
                                <div class="form-group">
                                    <label for="signupPassword">Password</label>
                                    <input type="password" id="signupPassword" name="password" class="input"
                                        placeholder="••••••••" required minlength="8">
                                </div>
                                <div class="form-group">
                                    <label for="signupConfirm">Confirm Password</label>
                                    <input type="password" id="signupConfirm" name="confirmPassword" class="input"
                                        placeholder="••••••••" required>
                                </div>
                                <button type="submit" class="btn btn-primary btn-full">Create Account</button>
                            </form>

                        </div>
                    </div>
                </section>

                <%@ include file="common/footer.jsp" %>

                    <script>
                        function switchAuthTab(tab) {
                            document.querySelectorAll('.auth-tab').forEach(function (t) { t.classList.remove('active'); });
                            document.querySelectorAll('.auth-form').forEach(function (f) { f.classList.add('hidden'); });
                            if (tab === 'login') {
                                document.querySelector('.auth-tab:first-child').classList.add('active');
                                document.getElementById('loginForm').classList.remove('hidden');
                            } else {
                                document.querySelector('.auth-tab:last-child').classList.add('active');
                                document.getElementById('signupForm').classList.remove('hidden');
                            }
                        }
                    </script>
        </body>

        </html>