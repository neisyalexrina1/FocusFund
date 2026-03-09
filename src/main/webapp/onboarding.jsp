<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:if test="${empty sessionScope.user}">
            <c:redirect url="AuthServlet" />
        </c:if>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <%@ include file="common/header.jsp" %>
                <title>Welcome to FocusFund</title>
        </head>

        <body>
            <div class="background-effects">
                <div class="stars" id="stars"></div>
                <div class="shooting-stars" id="shooting-stars"></div>
                <div class="rain" id="rain"></div>
            </div>

            <section class="page active" id="page-onboarding">
                <div class="onboarding-container">
                    <div class="onboarding-card">
                        <!-- Step 1 -->
                        <div class="onboarding-step active" id="onboarding-step-1">
                            <div class="onboarding-step-icon">🎯</div>
                            <h2>Welcome to FocusFund!</h2>
                            <p>Your smart study commitment platform. Let's set up your learning profile.</p>
                            <button class="btn btn-primary btn-lg" onclick="nextOnboardingStep(2)">Get Started</button>
                        </div>

                        <!-- Step 2 -->
                        <div class="onboarding-step" id="onboarding-step-2" style="display:none;">
                            <div class="onboarding-step-icon">📚</div>
                            <h2>Choose Your Focus Areas</h2>
                            <p>Select topics you want to study</p>
                            <div class="onboarding-topics"
                                style="display: grid; grid-template-columns: repeat(3, 1fr); gap: var(--spacing-sm); margin: var(--spacing-lg) 0;">
                                <button class="topic-chip"
                                    onclick="this.classList.toggle('selected')">Mathematics</button>
                                <button class="topic-chip" onclick="this.classList.toggle('selected')">Physics</button>
                                <button class="topic-chip"
                                    onclick="this.classList.toggle('selected')">Programming</button>
                                <button class="topic-chip"
                                    onclick="this.classList.toggle('selected')">Chemistry</button>
                                <button class="topic-chip"
                                    onclick="this.classList.toggle('selected')">Statistics</button>
                                <button class="topic-chip"
                                    onclick="this.classList.toggle('selected')">Economics</button>
                            </div>
                            <button class="btn btn-primary btn-lg" onclick="nextOnboardingStep(3)">Continue</button>
                        </div>

                        <!-- Step 3 -->
                        <div class="onboarding-step" id="onboarding-step-3" style="display:none;">
                            <div class="onboarding-step-icon">⏱️</div>
                            <h2>Set Your Study Schedule</h2>
                            <p>How much time do you want to study daily?</p>
                            <div
                                style="display: flex; gap: var(--spacing-md); justify-content: center; margin: var(--spacing-lg) 0;">
                                <button class="btn btn-outline" onclick="this.classList.toggle('active')">30
                                    min</button>
                                <button class="btn btn-outline active" onclick="this.classList.toggle('active')">1
                                    hour</button>
                                <button class="btn btn-outline" onclick="this.classList.toggle('active')">2
                                    hours</button>
                                <button class="btn btn-outline" onclick="this.classList.toggle('active')">3+
                                    hours</button>
                            </div>
                            <a href="${pageContext.request.contextPath}/DashboardServlet"
                                class="btn btn-primary btn-lg">Start Studying!</a>
                        </div>

                        <!-- Progress Dots -->
                        <div class="onboarding-progress"
                            style="display: flex; gap: var(--spacing-sm); justify-content: center; margin-top: var(--spacing-xl);">
                            <span class="dot active" id="dot-1"
                                style="width:12px;height:12px;border-radius:50%;background:var(--color-accent-primary);"></span>
                            <span class="dot" id="dot-2"
                                style="width:12px;height:12px;border-radius:50%;background:var(--color-border);"></span>
                            <span class="dot" id="dot-3"
                                style="width:12px;height:12px;border-radius:50%;background:var(--color-border);"></span>
                        </div>
                    </div>
                </div>
            </section>

            <%@ include file="common/footer.jsp" %>

                <script>
                    function nextOnboardingStep(step) {
                        document.querySelectorAll('.onboarding-step').forEach(function (s) { s.style.display = 'none'; });
                        document.getElementById('onboarding-step-' + step).style.display = 'block';
                        document.querySelectorAll('.dot').forEach(function (d) { d.style.background = 'var(--color-border)'; });
                        document.getElementById('dot-' + step).style.background = 'var(--color-accent-primary)';
                    }
                </script>

                <style>
                    .onboarding-container {
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        min-height: 100vh;
                        padding: var(--spacing-xl);
                    }

                    .onboarding-card {
                        background: var(--color-surface);
                        border-radius: var(--radius-xl);
                        padding: var(--spacing-2xl);
                        max-width: 600px;
                        width: 100%;
                        text-align: center;
                        box-shadow: var(--shadow-xl);
                        border: 1px solid var(--color-border);
                    }

                    .onboarding-step-icon {
                        font-size: 4rem;
                        margin-bottom: var(--spacing-md);
                    }

                    .onboarding-step h2 {
                        color: var(--color-text-primary);
                        margin-bottom: var(--spacing-sm);
                    }

                    .onboarding-step p {
                        color: var(--color-text-secondary);
                        margin-bottom: var(--spacing-lg);
                    }

                    .topic-chip {
                        padding: var(--spacing-sm) var(--spacing-md);
                        border-radius: var(--radius-full);
                        border: 1px solid var(--color-border);
                        background: var(--color-surface-hover);
                        color: var(--color-text-primary);
                        cursor: pointer;
                        transition: all 0.2s ease;
                    }

                    .topic-chip.selected {
                        background: var(--color-accent-primary);
                        color: white;
                        border-color: var(--color-accent-primary);
                    }
                </style>
        </body>

        </html>