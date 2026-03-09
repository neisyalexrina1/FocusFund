<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:if test="${empty sessionScope.user}">
            <c:redirect url="AuthServlet" />
        </c:if>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <%@ include file="common/header.jsp" %>
                <title>Dashboard - FocusFund</title>
                <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>
        </head>

        <body>
            <div class="background-effects">
                <div class="stars" id="stars"></div>
                <div class="shooting-stars" id="shooting-stars"></div>
                <div class="rain" id="rain"></div>
            </div>

            <%@ include file="common/navbar.jsp" %>

                <section class="page active" id="page-dashboard">
                    <div class="page-container">
                        <div class="page-header">
                            <h1 class="page-title">Your Progress</h1>
                            <p class="page-subtitle">Track your learning journey</p>
                        </div>

                        <!-- Stats Row -->
                        <div class="dashboard-stats" id="statsRow">
                            <div class="stat-card">
                                <div class="stat-icon">🔥</div>
                                <div class="stat-info">
                                    <span class="stat-value" id="statStreak">--</span>
                                    <span class="stat-label">Day Streak</span>
                                </div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon">⏱</div>
                                <div class="stat-info">
                                    <span class="stat-value" id="statHours">--</span>
                                    <span class="stat-label">Total Study Hours</span>
                                </div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon">🪙</div>
                                <div class="stat-info">
                                    <span class="stat-value" id="statCoins">--</span>
                                    <span class="stat-label">Focus Coins</span>
                                </div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon">⭐</div>
                                <div class="stat-info">
                                    <span class="stat-value" id="statExp">--</span>
                                    <span class="stat-label">Total XP</span>
                                </div>
                            </div>
                        </div>

                        <!-- Row 1: Charts (2 columns) -->
                        <div class="db-row-2">
                            <div class="dashboard-card">
                                <h3>📊 Weekly Study Hours</h3>
                                <div style="position:relative; height:220px;">
                                    <canvas id="weeklyChart"></canvas>
                                </div>
                            </div>
                            <div class="dashboard-card">
                                <h3>🕐 Peak Focus Hours</h3>
                                <div id="peakFocusGrid" class="focus-grid"></div>
                                <div class="focus-legend">
                                    <span><i class="low"></i> Low</span>
                                    <span><i class="medium"></i> Medium</span>
                                    <span><i class="high"></i> High</span>
                                </div>
                            </div>
                        </div>

                        <!-- Row 2: Daily Quests (wide) + Quick Actions -->
                        <div class="db-row-2-1">
                            <div class="dashboard-card">
                                <div
                                    style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
                                    <h3>📋 Daily Quests</h3>
                                    <span id="questProgress"
                                        style="font-size:0.85rem; color:var(--color-accent-primary);"></span>
                                </div>
                                <div id="questsList" style="display:flex; flex-direction:column; gap:10px;">
                                    <p style="color:var(--color-text-secondary);">Loading quests...</p>
                                </div>
                            </div>
                            <div class="dashboard-card">
                                <h3 style="margin-bottom:16px;">⚡ Quick Actions</h3>
                                <button id="microSessionBtn" onclick="startMicroSession()" class="micro-btn">
                                    🚀 Just 1 Minute!
                                </button>
                                <p
                                    style="font-size:0.8rem; color:var(--color-text-secondary); text-align:center; margin-bottom:20px;">
                                    Start a micro study session — escalate to 5 or 25 min!</p>
                                <div style="border-top:1px solid rgba(255,255,255,0.06); padding-top:16px;">
                                    <h4 style="margin-bottom:10px; color:var(--color-text-primary);">👥 Study Buddy</h4>
                                    <div id="buddyPanel" style="min-height:60px;">
                                        <p style="color:var(--color-text-secondary); font-size:0.85rem;">Loading...</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Row 3: My Courses (full width) -->
                        <div class="db-row-full">
                            <div class="dashboard-card">
                                <div
                                    style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
                                    <h3>📚 My Courses</h3>
                                    <a href="${pageContext.request.contextPath}/CourseServlet"
                                        style="font-size:0.85rem; color:var(--color-accent-primary); text-decoration:none;">Browse
                                        Courses →</a>
                                </div>
                                <div id="coursesList" class="progress-list"></div>
                            </div>
                        </div>

                        <!-- Row 4: Challenges + Leaderboard -->
                        <div class="db-row-2">
                            <div class="dashboard-card">
                                <div
                                    style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
                                    <h3>🏆 Active Challenges</h3>
                                    <a href="${pageContext.request.contextPath}/challenges.jsp"
                                        style="font-size:0.85rem; color:var(--color-accent-primary); text-decoration:none;">View
                                        All →</a>
                                </div>
                                <div id="challengesList" style="display:flex; flex-direction:column; gap:10px;">
                                    <p style="color:var(--color-text-secondary);">Loading...</p>
                                </div>
                            </div>
                            <div class="dashboard-card">
                                <h3 style="margin-bottom:16px;">🏅 Leaderboard (Top 5)</h3>
                                <div id="leaderboardList" style="display:flex; flex-direction:column; gap:8px;">
                                    <p style="color:var(--color-text-secondary);">Loading...</p>
                                </div>
                                <div id="myRank"
                                    style="margin-top:12px; padding-top:12px; border-top:1px solid rgba(255,255,255,0.06); font-size:0.85rem; color:var(--color-text-secondary);">
                                </div>
                            </div>
                        </div>

                        <!-- Row 5: Badges + Streak -->
                        <div class="db-row-2">
                            <div class="dashboard-card">
                                <h3 style="margin-bottom:16px;">🏅 Badges</h3>
                                <div id="badgesList" class="achievement-list">
                                    <p style="color:var(--color-text-secondary);">Loading...</p>
                                </div>
                            </div>
                            <div class="dashboard-card">
                                <h3 style="margin-bottom:16px;">⏰ Streak Countdown</h3>
                                <div id="streakCountdown" style="text-align:center; padding:20px;">
                                    <p style="color:var(--color-text-secondary);">Loading...</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Toast -->
                <div class="toast-container" id="toastContainer"></div>

                <%@ include file="common/footer.jsp" %>

                    <style>
                        .toast-container {
                            position: fixed;
                            bottom: 24px;
                            right: 24px;
                            z-index: 9999;
                            display: flex;
                            flex-direction: column;
                            gap: 8px;
                        }

                        .toast {
                            padding: 12px 20px;
                            border-radius: 12px;
                            color: #fff;
                            font-size: 0.9rem;
                            font-weight: 500;
                            animation: toastSlideIn 0.3s ease, toastFadeOut 0.3s ease 2.7s forwards;
                            max-width: 360px;
                        }

                        .toast-success {
                            background: rgba(34, 197, 94, 0.9);
                        }

                        .toast-error {
                            background: rgba(239, 68, 68, 0.9);
                        }

                        .toast-info {
                            background: rgba(59, 130, 246, 0.9);
                        }

                        @keyframes toastSlideIn {
                            from {
                                transform: translateX(100%);
                                opacity: 0;
                            }

                            to {
                                transform: translateX(0);
                                opacity: 1;
                            }
                        }

                        @keyframes toastFadeOut {
                            from {
                                opacity: 1;
                            }

                            to {
                                opacity: 0;
                            }
                        }

                        /* Dashboard layout rows */
                        .db-row-2 {
                            display: grid;
                            grid-template-columns: 1fr 1fr;
                            gap: var(--spacing-lg);
                            margin-bottom: var(--spacing-lg);
                        }

                        .db-row-2-1 {
                            display: grid;
                            grid-template-columns: 2fr 1fr;
                            gap: var(--spacing-lg);
                            margin-bottom: var(--spacing-lg);
                        }

                        .db-row-full {
                            margin-bottom: var(--spacing-lg);
                        }

                        @media (max-width: 900px) {

                            .db-row-2,
                            .db-row-2-1 {
                                grid-template-columns: 1fr;
                            }
                        }

                        .quest-item {
                            display: flex;
                            align-items: center;
                            gap: 12px;
                            padding: 12px 16px;
                            background: rgba(255, 255, 255, 0.03);
                            border: 1px solid rgba(255, 255, 255, 0.06);
                            border-radius: 12px;
                            transition: all 0.2s;
                        }

                        .quest-item.completed {
                            opacity: 0.6;
                        }

                        .quest-check {
                            width: 22px;
                            height: 22px;
                            border-radius: 50%;
                            border: 2px solid rgba(255, 255, 255, 0.2);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 0.7rem;
                            flex-shrink: 0;
                        }

                        .quest-item.completed .quest-check {
                            background: rgba(34, 197, 94, 0.2);
                            border-color: #22c55e;
                            color: #22c55e;
                        }

                        .leader-item {
                            display: flex;
                            align-items: center;
                            gap: 10px;
                            padding: 8px 12px;
                            background: rgba(255, 255, 255, 0.02);
                            border-radius: 10px;
                        }

                        .leader-rank {
                            width: 28px;
                            height: 28px;
                            border-radius: 50%;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-weight: 700;
                            font-size: 0.8rem;
                        }

                        .challenge-item {
                            padding: 12px;
                            background: rgba(255, 255, 255, 0.03);
                            border: 1px solid rgba(255, 255, 255, 0.06);
                            border-radius: 12px;
                        }

                        .challenge-progress-bar {
                            height: 6px;
                            background: rgba(255, 255, 255, 0.1);
                            border-radius: 3px;
                            overflow: hidden;
                            margin-top: 8px;
                        }

                        .challenge-progress-fill {
                            height: 100%;
                            border-radius: 3px;
                            background: linear-gradient(90deg, #6366f1, #a855f7);
                            transition: width 0.3s;
                        }

                        .micro-btn {
                            width: 100%;
                            padding: 16px;
                            border-radius: 14px;
                            background: linear-gradient(135deg, #f59e0b, #ef4444);
                            color: white;
                            border: none;
                            cursor: pointer;
                            font-weight: 700;
                            font-size: 1rem;
                            margin-bottom: 16px;
                            transition: all 0.2s;
                            box-shadow: 0 4px 15px rgba(245, 158, 11, 0.3);
                        }

                        .micro-btn:hover {
                            transform: translateY(-2px);
                            box-shadow: 0 6px 20px rgba(245, 158, 11, 0.4);
                        }
                    </style>

                    <script>
                        var ctx = '${pageContext.request.contextPath}';

                        function showToast(msg, type) {
                            var c = document.getElementById('toastContainer');
                            if (!c) return;
                            var t = document.createElement('div');
                            t.className = 'toast toast-' + (type || 'info');
                            t.textContent = msg;
                            c.appendChild(t);
                            setTimeout(function () { t.remove(); }, 3000);
                        }

                        // ==================== GAMIFICATION PROFILE ====================
                        fetch(ctx + '/GamificationServlet?action=profile')
                            .then(function (r) { return r.json(); })
                            .then(function (data) {
                                document.getElementById('statStreak').textContent = (data.currentStreak || 0) + 'd';
                                document.getElementById('statHours').textContent = (data.totalStudyHours || 0) + 'h';
                                document.getElementById('statCoins').textContent = data.focusCoins || 0;
                                document.getElementById('statExp').textContent = data.totalExp || 0;

                                // Badges
                                var badgesDiv = document.getElementById('badgesList');
                                if (data.badges && data.badges.length > 0) {
                                    var bhtml = '';
                                    data.badges.forEach(function (b) {
                                        bhtml += '<div class="achievement"><span class="achievement-icon">' + (b.badgeIcon || '🏅') + '</span><div class="achievement-info"><span class="achievement-title">' + b.badgeName + '</span><span class="achievement-desc">' + (b.description || '') + '</span></div></div>';
                                    });
                                    badgesDiv.innerHTML = bhtml;
                                } else {
                                    badgesDiv.innerHTML = '<p style="color:var(--color-text-secondary); font-size:0.85rem;">No badges earned yet. Keep studying!</p>';
                                }

                                // Weekly chart data from profile
                                initWeeklyChart(data.weeklyHours || null);
                                initPeakFocus(data.peakHours || null);
                            })
                            .catch(function () {
                                document.getElementById('statStreak').textContent = '0d';
                                document.getElementById('statHours').textContent = '0h';
                                document.getElementById('statCoins').textContent = '0';
                                document.getElementById('statExp').textContent = '0';
                                // Fetch real weekly data
                                fetch(ctx + '/DashboardServlet?action=weeklyStats')
                                    .then(function (r) { return r.json(); })
                                    .then(function (data) { initWeeklyChart(data); })
                                    .catch(function () { initWeeklyChart(null); });

                                // Fetch real peak hours data  
                                fetch(ctx + '/DashboardServlet?action=peakHours')
                                    .then(function (r) { return r.json(); })
                                    .then(function (data) { initPeakFocus(data); })
                                    .catch(function () { initPeakFocus(null); });
                            });

                        // ==================== WEEKLY STUDY HOURS CHART ====================
                        function initWeeklyChart(weeklyData) {
                            var labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                            var values = weeklyData || [1.5, 2.3, 1.8, 3.2, 2.8, 1.0, 2.0];

                            var chartCtx = document.getElementById('weeklyChart').getContext('2d');
                            var gradient = chartCtx.createLinearGradient(0, 0, 0, 220);
                            gradient.addColorStop(0, 'rgba(99, 102, 241, 0.8)');
                            gradient.addColorStop(1, 'rgba(168, 85, 247, 0.4)');

                            new Chart(chartCtx, {
                                type: 'bar',
                                data: {
                                    labels: labels,
                                    datasets: [{
                                        label: 'Hours',
                                        data: values,
                                        backgroundColor: gradient,
                                        borderRadius: 6,
                                        borderSkipped: false,
                                        barPercentage: 0.6,
                                        categoryPercentage: 0.7
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: false,
                                    plugins: {
                                        legend: { display: false },
                                        tooltip: {
                                            backgroundColor: '#1a1d2d',
                                            titleColor: '#fff',
                                            bodyColor: '#a5b4fc',
                                            borderColor: 'rgba(99,102,241,0.3)',
                                            borderWidth: 1,
                                            cornerRadius: 8,
                                            callbacks: {
                                                label: function (context) {
                                                    return context.parsed.y + ' hours';
                                                }
                                            }
                                        }
                                    },
                                    scales: {
                                        x: {
                                            grid: { display: false },
                                            ticks: { color: 'rgba(255,255,255,0.4)', font: { size: 12 } },
                                            border: { display: false }
                                        },
                                        y: {
                                            grid: { color: 'rgba(255,255,255,0.05)' },
                                            ticks: {
                                                color: 'rgba(255,255,255,0.3)',
                                                font: { size: 11 },
                                                callback: function (v) { return v + 'h'; }
                                            },
                                            border: { display: false },
                                            beginAtZero: true
                                        }
                                    }
                                }
                            });
                        }

                        // ==================== PEAK FOCUS HOURS ====================
                        function initPeakFocus(peakData) {
                            var hours = ['9 AM', '10 AM', '11 AM', '12 PM', '1 PM', '2 PM', '3 PM', '4 PM', '5 PM', '6 PM', '7 PM', '8 PM'];
                            var levels = peakData || ['low', 'medium', 'high', 'high', 'medium', 'high', 'high', 'medium', 'low', 'medium', 'low', 'low'];

                            var grid = document.getElementById('peakFocusGrid');
                            var html = '';
                            hours.forEach(function (h, i) {
                                var level = levels[i] || 'low';
                                html += '<div class="focus-block ' + level + '">' + h + '</div>';
                            });
                            grid.innerHTML = html;
                        }

                        // ==================== DAILY QUESTS ====================
                        fetch(ctx + '/EngagementServlet?action=dailyQuests')
                            .then(function (r) { return r.json(); })
                            .then(function (data) {
                                var questsDiv = document.getElementById('questsList');
                                var progSpan = document.getElementById('questProgress');
                                progSpan.textContent = (data.completedCount || 0) + '/' + (data.totalCount || 0) + ' completed';

                                var quests = data.quests || [];
                                if (quests.length === 0) {
                                    questsDiv.innerHTML = '<p style="color:var(--color-text-secondary); font-size:0.85rem;">No quests available today. Check back tomorrow!</p>';
                                    return;
                                }
                                var html = '';
                                quests.forEach(function (q) {
                                    var done = q.completed || q.status === 'completed';
                                    html += '<div class="quest-item ' + (done ? 'completed' : '') + '">'
                                        + '<div class="quest-check">' + (done ? '✓' : '') + '</div>'
                                        + '<div style="flex:1;">'
                                        + '<div style="color:var(--color-text-primary); font-weight:500;">' + (q.questName || q.title || 'Quest') + '</div>'
                                        + '<div style="font-size:0.8rem; color:var(--color-text-secondary);">' + (q.description || '') + '</div>'
                                        + '</div>'
                                        + '<div style="font-size:0.8rem; color:var(--color-accent-primary);">+' + (q.rewardCoins || q.coinReward || 0) + ' 🪙</div>'
                                        + '</div>';
                                });
                                questsDiv.innerHTML = html;
                            })
                            .catch(function () {
                                document.getElementById('questsList').innerHTML = '<p style="color:var(--color-text-secondary);">Could not load quests</p>';
                            });

                        // ==================== MICRO SESSION ====================
                        function startMicroSession() {
                            var btn = document.getElementById('microSessionBtn');
                            btn.disabled = true;
                            btn.textContent = 'Starting...';

                            fetch(ctx + '/EngagementServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: 'action=startMicro'
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        showToast('Micro session started! 🎯 Just 1 minute, you can do it!', 'success');
                                        btn.textContent = '✅ Session Active!';
                                        btn.style.background = 'linear-gradient(135deg,#22c55e,#10b981)';
                                    } else {
                                        showToast(data.error || 'Could not start session', 'error');
                                        btn.disabled = false;
                                        btn.textContent = '🚀 Just 1 Minute!';
                                    }
                                })
                                .catch(function () {
                                    showToast('Network error', 'error');
                                    btn.disabled = false;
                                    btn.textContent = '🚀 Just 1 Minute!';
                                });
                        }

                        // ==================== STUDY BUDDY ====================
                        fetch(ctx + '/EngagementServlet?action=buddyInfo')
                            .then(function (r) { return r.json(); })
                            .then(function (data) {
                                var panel = document.getElementById('buddyPanel');
                                if (data.hasBuddy) {
                                    panel.innerHTML = '<div style="display:flex; align-items:center; gap:10px;">'
                                        + '<div style="width:36px; height:36px; border-radius:50%; background:linear-gradient(135deg,#6366f1,#a855f7); display:flex; align-items:center; justify-content:center; color:white; font-weight:700;">' + ((data.buddyName || 'B')[0]) + '</div>'
                                        + '<div><div style="color:var(--color-text-primary); font-weight:500;">' + (data.buddyName || 'Your Buddy') + '</div>'
                                        + '<div style="font-size:0.8rem; color:var(--color-text-secondary);">Paired since ' + (data.pairedDate || 'recently') + '</div></div>'
                                        + '</div>';
                                } else {
                                    panel.innerHTML = '<p style="font-size:0.85rem; color:var(--color-text-secondary);">No study buddy paired yet.</p>'
                                        + '<p style="font-size:0.8rem; color:var(--color-text-muted); margin-top:4px;">Find someone in Study Rooms to pair with!</p>';
                                }
                            })
                            .catch(function () {
                                document.getElementById('buddyPanel').innerHTML = '<p style="color:var(--color-text-secondary); font-size:0.85rem;">Could not load buddy info</p>';
                            });

                        // ==================== CHALLENGES ====================
                        fetch(ctx + '/ChallengeServlet?action=myActive')
                            .then(function (r) { return r.json(); })
                            .then(function (challenges) {
                                var div = document.getElementById('challengesList');
                                if (!challenges || challenges.length === 0) {
                                    div.innerHTML = '<p style="color:var(--color-text-secondary); font-size:0.85rem;">No active challenges. <a href="' + ctx + '/challenges.jsp" style="color:var(--color-accent-primary);">Join one!</a></p>';
                                    return;
                                }
                                var html = '';
                                challenges.forEach(function (c) {
                                    var ch = c.challenge || c;
                                    var progress = c.daysCompleted && ch.durationDays ? Math.round((c.daysCompleted / ch.durationDays) * 100) : 0;
                                    html += '<div class="challenge-item">'
                                        + '<div style="display:flex; justify-content:space-between; align-items:center;">'
                                        + '<span style="color:var(--color-text-primary); font-weight:500;">' + (ch.challengeName || ch.title || 'Challenge') + '</span>'
                                        + '<span style="font-size:0.8rem; color:var(--color-accent-primary);">' + (c.daysCompleted || 0) + '/' + (ch.durationDays || '?') + ' days</span>'
                                        + '</div>'
                                        + '<div class="challenge-progress-bar"><div class="challenge-progress-fill" style="width:' + progress + '%"></div></div>'
                                        + '</div>';
                                });
                                div.innerHTML = html;
                            })
                            .catch(function () {
                                document.getElementById('challengesList').innerHTML = '<p style="color:var(--color-text-secondary);">Could not load challenges</p>';
                            });

                        // ==================== LEADERBOARD ====================
                        fetch(ctx + '/LeaderboardServlet')
                            .then(function (r) { return r.json(); })
                            .then(function (data) {
                                var div = document.getElementById('leaderboardList');
                                var top = data.leaderboard || [];
                                if (top.length === 0) {
                                    div.innerHTML = '<p style="color:var(--color-text-secondary); font-size:0.85rem;">No leaderboard data yet</p>';
                                    return;
                                }
                                var medals = ['🥇', '🥈', '🥉'];
                                var html = '';
                                top.forEach(function (entry, i) {
                                    var rankIcon = i < 3 ? medals[i] : (i + 1);
                                    var rankBg = i === 0 ? 'rgba(255,215,0,0.15)' : i === 1 ? 'rgba(192,192,192,0.15)' : i === 2 ? 'rgba(205,127,50,0.15)' : 'rgba(255,255,255,0.05)';
                                    html += '<div class="leader-item">'
                                        + '<div class="leader-rank" style="background:' + rankBg + ';">' + rankIcon + '</div>'
                                        + '<div style="flex:1;"><a href="' + ctx + '/ProfileServlet?userId=' + (entry.userID || '') + '" style="color:var(--color-text-primary); font-weight:500; text-decoration:none;">' + (entry.username || entry.fullName || 'User') + '</a></div>'
                                        + '<span style="font-size:0.85rem; color:var(--color-accent-primary);">' + (entry.totalCoinsEarned || entry.coins || 0) + ' 🪙</span>'
                                        + '</div>';
                                });
                                div.innerHTML = html;

                                var myRankDiv = document.getElementById('myRank');
                                if (data.myEntry) {
                                    myRankDiv.innerHTML = 'Your rank: <strong style="color:var(--color-accent-primary);">#' + (data.myEntry.ranking || '?') + '</strong> — ' + (data.myEntry.totalCoinsEarned || 0) + ' coins this month';
                                }
                            })
                            .catch(function () {
                                document.getElementById('leaderboardList').innerHTML = '<p style="color:var(--color-text-secondary);">Could not load leaderboard</p>';
                            });

                        // ==================== MY COURSES ====================
                        fetch(ctx + '/CourseServlet?action=myCourses')
                            .then(function (r) { return r.json(); })
                            .then(function (courses) {
                                var div = document.getElementById('coursesList');
                                if (!courses || courses.length === 0) {
                                    div.innerHTML = '<p style="color:var(--color-text-secondary); font-size:0.85rem;">No courses yet. <a href="' + ctx + '/CourseServlet" style="color:var(--color-accent-primary);">Browse courses →</a></p>';
                                    return;
                                }
                                var html = '';
                                courses.forEach(function (c) {
                                    html += '<div class="progress-item" style="cursor:pointer;" onclick="window.location.href=\'' + ctx + '/CourseServlet?id=' + c.courseID + '\'">'
                                        + '<div class="progress-header"><span>' + (c.icon || '📘') + ' ' + c.courseName + '</span><span>' + (c.duration || '') + '</span></div>'
                                        + '<div class="progress-bar-container"><div class="progress-bar-fill" style="width:0%"></div></div>'
                                        + '</div>';
                                });
                                div.innerHTML = html;
                            })
                            .catch(function () {
                                document.getElementById('coursesList').innerHTML = '<p style="color:var(--color-text-secondary);">Could not load courses</p>';
                            });

                        // ==================== STREAK COUNTDOWN ====================
                        fetch(ctx + '/EngagementServlet?action=streakCountdown')
                            .then(function (r) { return r.json(); })
                            .then(function (data) {
                                var div = document.getElementById('streakCountdown');
                                if (data.hoursRemaining !== undefined) {
                                    div.innerHTML = '<div style="font-size:2.5rem; font-weight:700; color:var(--color-accent-primary);">' + (data.hoursRemaining || 0) + 'h</div>'
                                        + '<p style="color:var(--color-text-secondary); margin-top:8px;">remaining to maintain your streak</p>'
                                        + '<p style="font-size:0.8rem; color:var(--color-text-muted); margin-top:4px;">Study today to keep your ' + (data.currentStreak || 0) + '-day streak alive!</p>';
                                } else {
                                    div.innerHTML = '<div style="font-size:2rem;">🔥</div><p style="color:var(--color-text-secondary); margin-top:8px;">Start studying to begin your streak!</p>';
                                }
                            })
                            .catch(function () {
                                document.getElementById('streakCountdown').innerHTML = '<p style="color:var(--color-text-secondary);">Could not load streak info</p>';
                            });
                    </script>
        </body>

        </html>