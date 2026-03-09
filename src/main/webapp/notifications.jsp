<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:if test="${empty sessionScope.user}">
            <c:redirect url="AuthServlet" />
        </c:if>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <%@ include file="common/header.jsp" %>
                <title>Notifications - FocusFund</title>
                <style>
                    .notifications-page {
                        max-width: 700px;
                        margin: 0 auto;
                        padding: 40px 20px;
                    }

                    .notif-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: 24px;
                    }

                    .notif-header h1 {
                        font-size: 1.8rem;
                        color: var(--text-primary);
                    }

                    .notif-list {
                        display: flex;
                        flex-direction: column;
                        gap: 8px;
                    }

                    .notif-card {
                        display: flex;
                        gap: 16px;
                        padding: 16px 20px;
                        border-radius: 12px;
                        background: var(--glass-bg);
                        border: 1px solid var(--glass-border);
                        transition: all 0.2s;
                        cursor: pointer;
                    }

                    .notif-card:hover {
                        background: rgba(255, 255, 255, 0.08);
                        transform: translateX(4px);
                    }

                    .notif-card.unread {
                        border-left: 3px solid var(--primary-color);
                    }

                    .notif-emoji {
                        font-size: 24px;
                        flex-shrink: 0;
                    }

                    .notif-body {
                        flex: 1;
                    }

                    .notif-title {
                        font-weight: 600;
                        color: var(--text-primary);
                        margin-bottom: 4px;
                    }

                    .notif-msg {
                        color: var(--text-secondary);
                        font-size: 0.9rem;
                        line-height: 1.4;
                    }

                    .notif-time {
                        color: var(--text-secondary);
                        font-size: 0.8rem;
                        margin-top: 6px;
                        opacity: 0.7;
                    }

                    .notif-empty {
                        text-align: center;
                        padding: 60px 20px;
                        color: var(--text-secondary);
                    }

                    .notif-empty-icon {
                        font-size: 48px;
                        margin-bottom: 16px;
                    }

                    .day-divider {
                        font-size: 0.85rem;
                        color: var(--text-secondary);
                        padding: 8px 0;
                        margin-top: 16px;
                        font-weight: 600;
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

                <section class="page active" id="page-notifications">
                    <div class="notifications-page">
                        <div class="notif-header">
                            <h1>🔔 Notifications</h1>
                            <button class="btn btn-ghost" id="markAllBtn" onclick="markAllRead()">
                                Mark all as read
                            </button>
                        </div>

                        <div class="notif-list" id="notifList">
                            <div class="notif-empty">
                                <div class="notif-empty-icon">⏳</div>
                                <p>Loading notifications...</p>
                            </div>
                        </div>
                    </div>
                </section>

                <script>
                    var ctx = '${pageContext.request.contextPath}';

                    function loadNotifications() {
                        fetch(ctx + '/NotificationServlet?action=all')
                            .then(function (r) { return r.json(); })
                            .then(function (data) {
                                var list = document.getElementById('notifList');

                                if (!data.notifications || data.notifications.length === 0) {
                                    list.innerHTML = '<div class="notif-empty"><div class="notif-empty-icon">🔕</div><p>No notifications yet</p></div>';
                                    return;
                                }

                                var html = '';
                                var lastDay = '';
                                data.notifications.forEach(function (n) {
                                    var day = getDayLabel(n.createdDate);
                                    if (day !== lastDay) {
                                        html += '<div class="day-divider">' + day + '</div>';
                                        lastDay = day;
                                    }

                                    html += '<div class="notif-card ' + (n.isRead ? '' : 'unread') + '" onclick="onNotifClick(' + n.notificationID + ', \'' + (n.actionUrl || '') + '\')">';
                                    html += '<div class="notif-emoji">' + (n.icon || '📢') + '</div>';
                                    html += '<div class="notif-body">';
                                    html += '<div class="notif-title">' + n.title + '</div>';
                                    html += '<div class="notif-msg">' + (n.message || '') + '</div>';
                                    html += '<div class="notif-time">' + timeAgo(n.createdDate) + '</div>';
                                    html += '</div></div>';
                                });
                                list.innerHTML = html;
                            })
                            .catch(function () {
                                document.getElementById('notifList').innerHTML = '<div class="notif-empty"><div class="notif-empty-icon">⚠️</div><p>Error loading notifications</p></div>';
                            });
                    }

                    function onNotifClick(id, actionUrl) {
                        fetch(ctx + '/NotificationServlet?action=markRead&notificationId=' + id, { method: 'POST' })
                            .then(function () {
                                if (actionUrl) {
                                    window.location.href = ctx + '/' + actionUrl;
                                } else {
                                    loadNotifications(); // Reload
                                }
                            });
                    }

                    function markAllRead() {
                        fetch(ctx + '/NotificationServlet?action=markAllRead', { method: 'POST' })
                            .then(function () {
                                loadNotifications();
                                if (typeof showToast === 'function') {
                                    showToast('All notifications marked as read!', 'success');
                                }
                            });
                    }

                    function getDayLabel(dateStr) {
                        if (!dateStr) return '';
                        var date = new Date(dateStr);
                        var today = new Date();
                        var yesterday = new Date(today);
                        yesterday.setDate(yesterday.getDate() - 1);

                        if (date.toDateString() === today.toDateString()) return 'Today';
                        if (date.toDateString() === yesterday.toDateString()) return 'Yesterday';
                        return date.toLocaleDateString('vi-VN', { weekday: 'long', day: 'numeric', month: 'long' });
                    }

                    function timeAgo(dateStr) {
                        if (!dateStr) return '';
                        var date = new Date(dateStr);
                        var now = new Date();
                        var diff = Math.floor((now - date) / 1000);
                        if (diff < 60) return 'Just now';
                        if (diff < 3600) return Math.floor(diff / 60) + 'm ago';
                        if (diff < 86400) return Math.floor(diff / 3600) + 'h ago';
                        return Math.floor(diff / 86400) + 'd ago';
                    }

                    // Load on page ready
                    loadNotifications();
                </script>

                <%@ include file="common/footer.jsp" %>
        </body>

        </html>