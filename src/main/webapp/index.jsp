<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <%@ include file="common/header.jsp" %>
                <meta name="description"
                    content="FocusFund - Smart Study Commitment Platform. Study with discipline, discuss on topic, measure your progress.">
                <title>FocusFund - Smart Study Commitment Platform</title>
        </head>

        <body>
            <!-- Background Effects -->
            <div class="background-effects">
                <div class="stars" id="stars"></div>
                <div class="shooting-stars" id="shooting-stars"></div>
                <div class="rain" id="rain"></div>
            </div>

            <%@ include file="common/navbar.jsp" %>

                <!-- Page: Landing -->
                <section class="page active" id="page-landing">
                    <div class="landing-content">
                        <div class="landing-hero">
                            <div class="hero-badge">✦ Smart Study Platform</div>
                            <h1 class="hero-title">Study with <span class="text-gradient">Discipline</span></h1>
                            <p class="hero-subtitle">Discuss on topic. Measure your progress. Achieve your goals with
                                focused study sessions
                                in a calm, distraction-free environment.</p>
                            <div class="hero-actions" id="heroActions">
                                <c:choose>
                                    <c:when test="${empty sessionScope.user}">
                                        <a href="${pageContext.request.contextPath}/AuthServlet"
                                            class="btn btn-primary btn-lg">
                                            <span>Start Your Journey</span>
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M5 12h14M12 5l7 7-7 7" />
                                            </svg>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/DashboardServlet"
                                            class="btn btn-primary btn-lg">
                                            <span>Go to Dashboard</span>
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M5 12h14M12 5l7 7-7 7" />
                                            </svg>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                                <a href="${pageContext.request.contextPath}/CourseServlet" class="btn btn-ghost btn-lg">
                                    <span>Explore Courses</span>
                                </a>
                            </div>
                            <div class="hero-stats">
                                <div class="stat">
                                    <span class="stat-value">2,500+</span>
                                    <span class="stat-label">Active Learners</span>
                                </div>
                                <div class="stat">
                                    <span class="stat-value">15,000+</span>
                                    <span class="stat-label">Study Hours</span>
                                </div>
                                <div class="stat">
                                    <span class="stat-value">98%</span>
                                    <span class="stat-label">Focus Rate</span>
                                </div>
                            </div>
                        </div>
                        <div class="landing-features">
                            <div class="feature-card">
                                <div class="feature-icon">🎯</div>
                                <h3>Study Rooms</h3>
                                <p>Synchronized Pomodoro sessions with silent study periods and structured breaks.</p>
                            </div>
                            <div class="feature-card">
                                <div class="feature-icon">📚</div>
                                <h3>Course Hub</h3>
                                <p>Roadmap-first learning with weekly guides and curated resources.</p>
                            </div>
                            <div class="feature-card">
                                <div class="feature-icon">🤖</div>
                                <h3>AI Assistant</h3>
                                <p>Summarize chapters, generate quizzes, and get personalized study plans.</p>
                            </div>
                        </div>
                    </div>
                </section>

                <%@ include file="common/footer.jsp" %>
        </body>

        </html>