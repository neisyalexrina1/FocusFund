<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <%@ include file="common/header.jsp" %>
                <title>Verify OTP - FocusFund</title>
                <style>
                    .otp-inputs {
                        display: flex;
                        justify-content: center;
                        gap: 12px;
                        margin: 20px 0;
                    }

                    .otp-input {
                        width: 45px;
                        height: 55px;
                        border: 1px solid #e2e8f0;
                        border-radius: 8px;
                        font-size: 24px;
                        text-align: center;
                        font-weight: bold;
                        color: #0f172a;
                        background: #fff;
                        transition: border-color 0.2s;
                    }

                    .otp-input:focus {
                        border-color: #4f46e5;
                        outline: none;
                        box-shadow: 0 0 0 2px rgba(79, 70, 229, 0.2);
                    }

                    .resend-text {
                        text-align: center;
                        font-size: 14px;
                        color: #64748b;
                        margin-top: 20px;
                    }
                </style>
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
                        <div class="auth-card" style="text-align: center;">
                            <div
                                style="margin: 0 auto 20px; width: 60px; height: 60px; background: linear-gradient(135deg, #4f46e5, #7c3aed); border-radius: 50%; display: flex; align-items: center; justify-content: center; box-shadow: 0 10px 20px rgba(79, 70, 229, 0.3);">
                                <svg viewBox="0 0 24 24" width="28" height="28" stroke="white" stroke-width="2"
                                    fill="none" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                </svg>
                            </div>

                            <c:choose>
                                <c:when test="${otpType == 'login'}">
                                    <h2>Login Verification</h2>
                                </c:when>
                                <c:when test="${otpType == 'register'}">
                                    <h2>Account Verification</h2>
                                </c:when>
                                <c:when test="${otpType == 'reset'}">
                                    <h2>Verify Code</h2>
                                </c:when>
                            </c:choose>

                            <p style="color: #64748b; font-size: 14px; margin-top: 8px;">
                                We sent a 6-digit code to <strong>${emailSentTo}</strong>
                            </p>

                            <c:if test="${not empty errorMessage}">
                                <script>document.addEventListener('DOMContentLoaded', function () { showToast('${errorMessage}', 'error'); });</script>
                            </c:if>

                            <form class="auth-form" action="${pageContext.request.contextPath}/AuthServlet"
                                method="post" id="otpForm">
                                <input type="hidden" name="action"
                                    value="verify${otpType == 'login' ? 'Login' : (otpType == 'register' ? 'Register' : 'Reset')}Otp">
                                <input type="hidden" name="otp" id="fullOtp" value="">

                                <div class="otp-inputs">
                                    <input type="text" class="otp-input" maxlength="1" pattern="[0-9]"
                                        inputmode="numeric" required />
                                    <input type="text" class="otp-input" maxlength="1" pattern="[0-9]"
                                        inputmode="numeric" required />
                                    <input type="text" class="otp-input" maxlength="1" pattern="[0-9]"
                                        inputmode="numeric" required />
                                    <input type="text" class="otp-input" maxlength="1" pattern="[0-9]"
                                        inputmode="numeric" required />
                                    <input type="text" class="otp-input" maxlength="1" pattern="[0-9]"
                                        inputmode="numeric" required />
                                    <input type="text" class="otp-input" maxlength="1" pattern="[0-9]"
                                        inputmode="numeric" required />
                                </div>

                                <button type="submit" class="btn btn-primary btn-full">Verify & Proceed</button>

                                <div class="resend-text">
                                    Didn't receive the code? <span id="resendTimer">(wait 60s)</span>
                                </div>

                                <div style="margin-top: 20px;">
                                    <a href="login.jsp"
                                        style="color: #0b6cb3; font-size: 14px; text-decoration: none;">← Back to
                                        login</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </section>

                <script>
                    document.addEventListener('DOMContentLoaded', () => {
                        const inputs = document.querySelectorAll('.otp-input');
                        const fullOtpHidden = document.getElementById('fullOtp');

                        inputs.forEach((input, index) => {
                            input.addEventListener('input', (e) => {
                                const next = inputs[index + 1];
                                if (e.target.value.length === 1 && next) {
                                    next.focus();
                                }
                                updateFullOtp();
                            });

                            input.addEventListener('keydown', (e) => {
                                if (e.key === 'Backspace' && e.target.value === '' && index > 0) {
                                    inputs[index - 1].focus();
                                }
                            });

                            input.addEventListener('paste', (e) => {
                                e.preventDefault();
                                const pastedData = e.clipboardData.getData('text').slice(0, 6).replace(/[^0-9]/g, '');
                                const digits = pastedData.split('');
                                for (let i = 0; i < digits.length; i++) {
                                    if (inputs[i]) {
                                        inputs[i].value = digits[i];
                                    }
                                }
                                if (digits.length > 0 && digits.length <= inputs.length) {
                                    inputs[digits.length - 1].focus();
                                    if (digits.length === inputs.length) inputs[inputs.length - 1].blur();
                                }
                                updateFullOtp();
                            });
                        });

                        function updateFullOtp() {
                            let otpStr = '';
                            inputs.forEach(input => otpStr += input.value);
                            fullOtpHidden.value = otpStr;
                        }

                        // Simple timer simulation
                        let timeLeft = 60;
                        const timerEl = document.getElementById('resendTimer');
                        const interval = setInterval(() => {
                            timeLeft--;
                            timerEl.textContent = `(wait \${timeLeft}s)`;
                            if (timeLeft <= 0) {
                                clearInterval(interval);
                                timerEl.innerHTML = '<a href="#" style="color:#0b6cb3; text-decoration:none;">Resend Code</a>';
                            }
                        }, 1000);
                    });
                </script>
        </body>

        </html>