<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!-- Navigation -->
        <nav class="main-nav" id="mainNav">
            <div class="nav-inner">
                <div class="nav-brand">
                    <span class="brand-icon">✦</span>
                    <span class="brand-text">FocusFund</span>
                </div>

                <div class="nav-center">
                    <div class="nav-links">
                        <a href="${pageContext.request.contextPath}/index.jsp" class="nav-link">Home</a>
                        <a href="${pageContext.request.contextPath}/CourseServlet" class="nav-link">Courses</a>
                        <a href="${pageContext.request.contextPath}/StudyRoomServlet" class="nav-link">Study Rooms</a>
                        <a href="${pageContext.request.contextPath}/DashboardServlet" class="nav-link">Dashboard</a>
                        <a href="${pageContext.request.contextPath}/challenges.jsp" class="nav-link">Challenges</a>
                        <a href="${pageContext.request.contextPath}/flashcards.jsp" class="nav-link">Flashcards</a>
                        <a href="${pageContext.request.contextPath}/ai_chat.jsp" class="nav-link">AI Assistant</a>
                    </div>
                </div>

                <div class="nav-right">
                    <!-- Language Button -->
                    <a href="${pageContext.request.contextPath}/language.jsp" class="nav-icon-btn global-language-btn"
                        title="Language & Display">
                        <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor"
                            stroke-width="2">
                            <circle cx="12" cy="12" r="10" />
                            <path
                                d="M2 12h20M12 2a15.3 15.3 0 014 10 15.3 15.3 0 01-4 10 15.3 15.3 0 01-4-10 15.3 15.3 0 014-10z" />
                        </svg>
                    </a>

                    <c:choose>
                        <c:when test="${empty sessionScope.user}">
                            <div class="nav-auth" id="navAuth">
                                <a href="${pageContext.request.contextPath}/AuthServlet" class="btn btn-login">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M15 3h4a2 2 0 012 2v14a2 2 0 01-2 2h-4" />
                                        <polyline points="10,17 15,12 10,7" />
                                        <line x1="15" y1="12" x2="3" y2="12" />
                                    </svg>
                                    Login
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="nav-user" id="navUser">
                                <div class="nav-user-actions">
                                    <!-- Notification Bell -->
                                    <div class="notification-wrapper">
                                        <button class="notification-bell" id="notificationBell" title="Notifications"
                                            onclick="toggleNotificationsDropdown(event)">
                                            <svg viewBox="0 0 24 24" width="20" height="20" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path d="M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9" />
                                                <path d="M13.73 21a2 2 0 01-3.46 0" />
                                            </svg>
                                            <span id="notifBadge"
                                                style="display:none; position:absolute; top:-4px; right:-4px; background:#ef4444; color:white; border-radius:50%; width:18px; height:18px; font-size:10px; align-items:center; justify-content:center; font-weight:bold;">0</span>
                                        </button>

                                        <!-- Notifications Dropdown -->
                                        <div class="notifications-dropdown hidden" id="notificationsDropdown">
                                            <div class="dropdown-header">
                                                <div class="dropdown-user-info">
                                                    <span class="dropdown-username">Notifications</span>
                                                </div>
                                            </div>
                                            <div class="dropdown-divider"></div>
                                            <div class="dropdown-menu" id="notificationsList">
                                                <div class="notification-item" style="text-align:center; padding:20px;">
                                                    <p style="color:var(--text-secondary);">Loading...</p>
                                                </div>
                                            </div>
                                            <div class="dropdown-divider"></div>
                                            <div class="notifications-footer">
                                                <a href="${pageContext.request.contextPath}/notifications.jsp"
                                                    class="view-all-link">View All Notifications</a>
                                            </div>
                                        </div>
                                        <script>
                                            // Load notifications when bell is clicked
                                            var bellLoaded = false;
                                            var originalToggle = window.toggleNotificationsDropdown;
                                            window.toggleNotificationsDropdown = function (event) {
                                                if (originalToggle) originalToggle(event);
                                                if (!bellLoaded) {
                                                    bellLoaded = true;
                                                    loadBellNotifications();
                                                }
                                            };

                                            function loadBellNotifications() {
                                                var ctx = '${pageContext.request.contextPath}';
                                                fetch(ctx + '/NotificationServlet?action=bell')
                                                    .then(function (r) { return r.json(); })
                                                    .then(function (data) {
                                                        var list = document.getElementById('notificationsList');
                                                        if (!data.notifications || data.notifications.length === 0) {
                                                            list.innerHTML = '<div class="notification-item" style="text-align:center; padding:20px;"><p style="color:var(--text-secondary);">No notifications</p></div>';
                                                            return;
                                                        }
                                                        var html = '';
                                                        data.notifications.forEach(function (n) {
                                                            html += '<div class="notification-item ' + (n.isRead ? '' : 'unread') + '" onclick="markNotifRead(' + n.notificationID + ')">';
                                                            html += '<div class="notification-icon new-course"><span style="font-size:16px;">' + (n.icon || '📢') + '</span></div>';
                                                            html += '<div class="notification-content">';
                                                            html += '<p><strong>' + n.title + '</strong> ' + (n.message || '') + '</p>';
                                                            html += '<span class="notification-time">' + timeAgo(n.createdDate) + '</span>';
                                                            html += '</div></div>';
                                                        });
                                                        list.innerHTML = html;

                                                        // Update badge
                                                        var badge = document.getElementById('notifBadge');
                                                        if (badge && data.unreadCount > 0) {
                                                            badge.textContent = data.unreadCount;
                                                            badge.style.display = 'flex';
                                                        }
                                                    })
                                                    .catch(function () {
                                                        var list = document.getElementById('notificationsList');
                                                        list.innerHTML = '<div class="notification-item" style="text-align:center; padding:20px;"><p style="color:var(--text-secondary);">Error loading notifications</p></div>';
                                                    });
                                            }

                                            function markNotifRead(id) {
                                                var ctx = '${pageContext.request.contextPath}';
                                                fetch(ctx + '/NotificationServlet?action=markRead&notificationId=' + id, { method: 'POST' });
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

                                            // Poll unread count every 60s
                                            setInterval(function () {
                                                var ctx = '${pageContext.request.contextPath}';
                                                fetch(ctx + '/NotificationServlet?action=count')
                                                    .then(function (r) { return r.json(); })
                                                    .then(function (data) {
                                                        var badge = document.getElementById('notifBadge');
                                                        if (badge) {
                                                            if (data.unreadCount > 0) {
                                                                badge.textContent = data.unreadCount;
                                                                badge.style.display = 'flex';
                                                            } else {
                                                                badge.style.display = 'none';
                                                            }
                                                        }
                                                    }).catch(function () { });
                                            }, 60000);
                                        </script>
                                    </div>

                                    <!-- FocusFund Mode Button -->
                                    <a href="${pageContext.request.contextPath}/focusfund.jsp"
                                        class="nav-icon-btn focusfund-btn" title="FocusFund Mode">
                                        <svg viewBox="0 0 24 24" width="20" height="20" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <path d="M12 3l1.5 4.5L18 9l-4.5 1.5L12 15l-1.5-4.5L6 9l4.5-1.5L12 3z" />
                                            <path d="M5 19l1 3 1-3 3-1-3-1-1-3-1 3-3 1 3 1z" />
                                            <path d="M19 12l1 2.5 2.5 1-2.5 1-1 2.5-1-2.5-2.5-1 2.5-1 1-2.5z" />
                                        </svg>
                                    </a>

                                    <!-- User Avatar -->
                                    <div class="user-profile-wrapper">
                                        <div class="user-avatar-nav" id="userAvatarNav"
                                            onclick="toggleProfileDropdown(event)">
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.user.profileImage}">
                                                    <img src="${sessionScope.user.profileImage}" alt=""
                                                        class="avatar-image" id="navAvatarImage">
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="avatar-initial" id="navAvatarInitial">
                                                        ${not empty sessionScope.user.fullName ?
                                                        sessionScope.user.fullName.substring(0,1).toUpperCase() :
                                                        sessionScope.user.username.substring(0,1).toUpperCase()}
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <!-- Profile Dropdown -->
                                        <div class="profile-dropdown hidden" id="profileDropdown">
                                            <div class="dropdown-header">
                                                <div class="dropdown-avatar" id="dropdownAvatar">
                                                    <span class="avatar-initial">${not empty sessionScope.user.fullName
                                                        ? sessionScope.user.fullName.substring(0,1).toUpperCase() :
                                                        sessionScope.user.username.substring(0,1).toUpperCase()}</span>
                                                </div>
                                                <div class="dropdown-user-info">
                                                    <span class="dropdown-username">${not empty
                                                        sessionScope.user.fullName ? sessionScope.user.fullName :
                                                        sessionScope.user.username}</span>
                                                    <span class="dropdown-email">${sessionScope.user.email}</span>
                                                </div>
                                            </div>
                                            <div class="dropdown-divider"></div>
                                            <div class="dropdown-menu">
                                                <a href="${pageContext.request.contextPath}/ProfileServlet"
                                                    class="dropdown-item" onclick="closeProfileDropdown();">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2">
                                                        <path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2" />
                                                        <circle cx="12" cy="7" r="4" />
                                                    </svg>
                                                    <span>View Profile</span>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/AccountServlet?tab=profile"
                                                    class="dropdown-item" onclick="closeProfileDropdown();">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2">
                                                        <path d="M12 15a3 3 0 100-6 3 3 0 000 6z" />
                                                        <path
                                                            d="M19.4 15a1.65 1.65 0 00.33 1.82l.06.06a2 2 0 010 2.83 2 2 0 01-2.83 0l-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V21a2 2 0 01-2 2 2 2 0 01-2-2v-.09A1.65 1.65 0 009 19.4a1.65 1.65 0 00-1.82.33l-.06.06a2 2 0 01-2.83 0 2 2 0 010-2.83l.06-.06a1.65 1.65 0 00.33-1.82 1.65 1.65 0 00-1.51-1H3a2 2 0 01-2-2 2 2 0 012-2h.09A1.65 1.65 0 004.6 9a1.65 1.65 0 00-.33-1.82l-.06-.06a2 2 0 010-2.83 2 2 0 012.83 0l.06.06a1.65 1.65 0 001.82.33H9a1.65 1.65 0 001-1.51V3a2 2 0 012-2 2 2 0 012 2v.09a1.65 1.65 0 001 1.51 1.65 1.65 0 001.82-.33l.06-.06a2 2 0 012.83 0 2 2 0 010 2.83l-.06.06a1.65 1.65 0 00-.33 1.82V9a1.65 1.65 0 001.51 1H21a2 2 0 012 2 2 2 0 01-2 2h-.09a1.65 1.65 0 00-1.51 1z" />
                                                    </svg>
                                                    <span>Account Settings</span>
                                                </a>
                                                <c:if test="${sessionScope.user.role == 'admin'}">
                                                    <a href="${pageContext.request.contextPath}/AdminServlet"
                                                        class="dropdown-item" onclick="closeProfileDropdown();">
                                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                            stroke-width="2">
                                                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                                                        </svg>
                                                        <span>Admin Dashboard</span>
                                                    </a>
                                                </c:if>
                                            </div>
                                            <div class="dropdown-divider"></div>
                                            <a href="${pageContext.request.contextPath}/AuthServlet?action=logout"
                                                class="dropdown-item logout">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2">
                                                    <path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4" />
                                                    <polyline points="16,17 21,12 16,7" />
                                                    <line x1="21" y1="12" x2="9" y2="12" />
                                                </svg>
                                                <span>Logout</span>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Mobile Menu Toggle -->
                    <button class="mobile-menu-toggle" id="mobileMenuToggle" onclick="toggleMobileNav()">
                        <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor"
                            stroke-width="2">
                            <line x1="3" y1="12" x2="21" y2="12" />
                            <line x1="3" y1="6" x2="21" y2="6" />
                            <line x1="3" y1="18" x2="21" y2="18" />
                        </svg>
                    </button>
                </div>
            </div>
        </nav>
        <script>
            // Highlight active nav link based on current URL
            (function () {
                var path = window.location.pathname;
                var links = document.querySelectorAll('.nav-link');
                links.forEach(function (link) {
                    var href = link.getAttribute('href');
                    if (href && path.indexOf(href.replace(/^.*\/\/[^\/]+/, '')) !== -1) {
                        link.classList.add('active');
                    } else if (path.endsWith('/index.jsp') && href && href.endsWith('/index.jsp')) {
                        link.classList.add('active');
                    }
                });
            })();
        </script>