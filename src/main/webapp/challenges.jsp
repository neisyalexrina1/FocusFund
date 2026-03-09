<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:if test="${empty sessionScope.user}">
            <c:redirect url="AuthServlet" />
        </c:if>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <%@ include file="common/header.jsp" %>
                <title>Challenges - FocusFund</title>
        </head>

        <body>
            <div class="background-effects">
                <div class="stars" id="stars"></div>
                <div class="shooting-stars" id="shooting-stars"></div>
                <div class="rain" id="rain"></div>
            </div>

            <%@ include file="common/navbar.jsp" %>

                <section class="page active" id="page-challenges">
                    <div class="page-container">
                        <div class="page-header">
                            <h1 class="page-title">🏆 Challenges</h1>
                            <p class="page-subtitle">Take on 7-day or 30-day challenges to level up your skills</p>
                        </div>

                        <!-- My Active Challenges -->
                        <div style="margin-bottom:var(--spacing-2xl);">
                            <h2
                                style="color:var(--color-text-primary); margin-bottom:var(--spacing-md); font-size:1.3rem;">
                                🔥 My Active Challenges</h2>
                            <div id="myChallenges" class="rooms-grid"
                                style="grid-template-columns:repeat(auto-fill,minmax(320px,1fr)); margin-bottom:var(--spacing-lg);">
                                <p
                                    style="color:var(--color-text-secondary); grid-column:1/-1; text-align:center; padding:30px;">
                                    Loading...</p>
                            </div>
                        </div>

                        <!-- Available Challenges -->
                        <div>
                            <h2
                                style="color:var(--color-text-primary); margin-bottom:var(--spacing-md); font-size:1.3rem;">
                                📋 Available Challenges</h2>
                            <div id="availableChallenges" class="rooms-grid"
                                style="grid-template-columns:repeat(auto-fill,minmax(320px,1fr));">
                                <p
                                    style="color:var(--color-text-secondary); grid-column:1/-1; text-align:center; padding:30px;">
                                    Loading...</p>
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

                        .challenge-card {
                            background: rgba(255, 255, 255, 0.03);
                            border: 1px solid rgba(255, 255, 255, 0.08);
                            border-radius: 16px;
                            padding: 24px;
                            transition: all 0.2s;
                        }

                        .challenge-card:hover {
                            background: rgba(255, 255, 255, 0.05);
                            border-color: rgba(255, 255, 255, 0.12);
                            transform: translateY(-2px);
                        }

                        .challenge-badge {
                            font-size: 0.75rem;
                            padding: 3px 10px;
                            border-radius: 20px;
                            font-weight: 600;
                        }

                        .badge-7day {
                            background: rgba(59, 130, 246, 0.15);
                            color: #60a5fa;
                        }

                        .badge-30day {
                            background: rgba(168, 85, 247, 0.15);
                            color: #c084fc;
                        }

                        .ch-progress-bar {
                            height: 8px;
                            background: rgba(255, 255, 255, 0.1);
                            border-radius: 4px;
                            overflow: hidden;
                            margin-top: 12px;
                        }

                        .ch-progress-fill {
                            height: 100%;
                            border-radius: 4px;
                            background: linear-gradient(90deg, #6366f1, #a855f7);
                            transition: width 0.5s;
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

                        // Load available challenges
                        fetch(ctx + '/ChallengeServlet?action=list')
                            .then(function (r) { return r.json(); })
                            .then(function (challenges) {
                                var div = document.getElementById('availableChallenges');
                                if (!challenges || challenges.length === 0) {
                                    div.innerHTML = '<div style="text-align:center; padding:40px; color:var(--color-text-secondary); grid-column:1/-1;"><div style="font-size:2rem; margin-bottom:8px;">🏆</div><p>No challenges available right now. Check back soon!</p></div>';
                                    return;
                                }
                                var html = '';
                                challenges.forEach(function (c) {
                                    var badgeClass = c.durationDays <= 7 ? 'badge-7day' : 'badge-30day';
                                    var badgeText = c.durationDays + '-Day Challenge';
                                    html += '<div class="challenge-card">'
                                        + '<div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:12px;">'
                                        + '<span class="challenge-badge ' + badgeClass + '">' + badgeText + '</span>'
                                        + '<span style="font-size:0.8rem; color:var(--color-accent-primary);">+' + (c.coinReward || 0) + ' 🪙</span>'
                                        + '</div>'
                                        + '<h3 style="color:var(--color-text-primary); font-size:1.1rem; margin-bottom:8px;">' + (c.challengeName || c.title || 'Challenge') + '</h3>'
                                        + '<p style="color:var(--color-text-secondary); font-size:0.85rem; margin-bottom:16px;">' + (c.description || '') + '</p>'
                                        + '<div style="display:flex; justify-content:space-between; align-items:center;">'
                                        + '<span style="font-size:0.8rem; color:var(--color-text-muted);">👥 ' + (c.participantCount || 0) + ' participants</span>'
                                        + '<button class="btn btn-primary btn-sm" onclick="joinChallenge(' + c.challengeID + ', this)">Join Challenge</button>'
                                        + '</div>'
                                        + '</div>';
                                });
                                div.innerHTML = html;
                            })
                            .catch(function () {
                                document.getElementById('availableChallenges').innerHTML = '<p style="color:var(--color-text-secondary); grid-column:1/-1; text-align:center;">Could not load challenges</p>';
                            });

                        // Load my active challenges
                        function loadMyChallenges() {
                            fetch(ctx + '/ChallengeServlet?action=myActive')
                                .then(function (r) { return r.json(); })
                                .then(function (challenges) {
                                    var div = document.getElementById('myChallenges');
                                    if (!challenges || challenges.length === 0) {
                                        div.innerHTML = '<div style="text-align:center; padding:30px; color:var(--color-text-secondary); grid-column:1/-1;"><p>No active challenges. Join one below to get started!</p></div>';
                                        return;
                                    }
                                    var html = '';
                                    challenges.forEach(function (uc) {
                                        var ch = uc.challenge || uc;
                                        var progress = uc.daysCompleted && ch.durationDays ? Math.round((uc.daysCompleted / ch.durationDays) * 100) : 0;
                                        var badgeClass = ch.durationDays <= 7 ? 'badge-7day' : 'badge-30day';
                                        html += '<div class="challenge-card" style="border-color:rgba(99,102,241,0.2);">'
                                            + '<div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:12px;">'
                                            + '<span class="challenge-badge ' + badgeClass + '">' + (ch.durationDays || '?') + '-Day</span>'
                                            + '<span style="font-size:0.8rem; color:var(--color-accent-primary);">' + (uc.daysCompleted || 0) + '/' + (ch.durationDays || '?') + ' days</span>'
                                            + '</div>'
                                            + '<h3 style="color:var(--color-text-primary); font-size:1.05rem; margin-bottom:8px;">' + (ch.challengeName || ch.title || 'Challenge') + '</h3>'
                                            + '<div class="ch-progress-bar"><div class="ch-progress-fill" style="width:' + progress + '%"></div></div>'
                                            + '<div style="display:flex; justify-content:space-between; align-items:center; margin-top:12px;">'
                                            + '<button class="btn btn-primary btn-sm" onclick="updateProgress(' + (uc.userChallengeID || ch.challengeID) + ', ' + (uc.daysCompleted || 0) + ', this)" style="font-size:0.8rem;">✅ Update Progress</button>'
                                            + '<button onclick="abandonChallenge(' + (uc.userChallengeID || ch.challengeID) + ', this)" style="font-size:0.8rem; padding:6px 12px; border-radius:8px; background:rgba(239,68,68,0.1); color:#f87171; border:1px solid rgba(239,68,68,0.2); cursor:pointer;">Abandon</button>'
                                            + '</div>'
                                            + '</div>';
                                    });
                                    div.innerHTML = html;
                                })
                                .catch(function () {
                                    document.getElementById('myChallenges').innerHTML = '<p style="color:var(--color-text-secondary); grid-column:1/-1; text-align:center;">Could not load your challenges</p>';
                                });
                        }

                        function joinChallenge(challengeId, btn) {
                            btn.disabled = true; btn.textContent = 'Joining...';
                            fetch(ctx + '/ChallengeServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: 'action=join&challengeId=' + challengeId
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        showToast(data.message || 'Challenge joined!', 'success');
                                        loadMyChallenges();
                                        btn.textContent = '✅ Joined!';
                                    } else {
                                        showToast(data.error || 'Could not join', 'error');
                                        btn.disabled = false; btn.textContent = 'Join Challenge';
                                    }
                                })
                                .catch(function () { showToast('Network error', 'error'); btn.disabled = false; btn.textContent = 'Join Challenge'; });
                        }

                        function updateProgress(id, currentDays, btn) {
                            btn.disabled = true; btn.textContent = 'Updating...';
                            var newDays = (currentDays || 0) + 1;
                            fetch(ctx + '/ChallengeServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: 'action=updateProgress&userChallengeId=' + id + '&daysCompleted=' + newDays
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        showToast(data.message || 'Progress updated!', 'success');
                                        loadMyChallenges();
                                    } else showToast(data.error || 'Failed', 'error');
                                    btn.disabled = false; btn.textContent = '✅ Update Progress';
                                })
                                .catch(function () { showToast('Network error', 'error'); btn.disabled = false; btn.textContent = '✅ Update Progress'; });
                        }

                        function abandonChallenge(id, btn) {
                            if (!confirm('Are you sure you want to abandon this challenge?')) return;
                            btn.disabled = true;
                            fetch(ctx + '/ChallengeServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: 'action=abandon&userChallengeId=' + id
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        showToast('Challenge abandoned', 'info');
                                        loadMyChallenges();
                                    } else showToast(data.error || 'Failed', 'error');
                                })
                                .catch(function () { showToast('Network error', 'error'); });
                        }

                        // Init
                        loadMyChallenges();
                    </script>
        </body>

        </html>