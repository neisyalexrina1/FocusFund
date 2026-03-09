<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <%@ include file="common/header.jsp" %>
                    <title>${profileUser.fullName} - Profile - FocusFund</title>
            </head>

            <body>
                <div class="background-effects">
                    <div class="stars" id="stars"></div>
                    <div class="shooting-stars" id="shooting-stars"></div>
                    <div class="rain" id="rain"></div>
                </div>

                <%@ include file="common/navbar.jsp" %>

                    <section class="page active" id="page-profile">
                        <div class="profile-page-container">
                            <!-- Banner -->
                            <div class="profile-banner" id="profileBanner">
                                <c:choose>
                                    <c:when test="${not empty profileUser.bannerImage}">
                                        <div class="banner-gradient"
                                            style="background-image: url('${profileUser.bannerImage}'); background-size: cover;">
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="banner-overlay"></div>
                                    </c:otherwise>
                                </c:choose>
                                <c:if
                                    test="${not empty sessionScope.user && sessionScope.user.userID == profileUser.userID}">
                                    <button class="change-banner-btn"
                                        onclick="document.getElementById('bannerUpload').click()">
                                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <path
                                                d="M23 19a2 2 0 01-2 2H3a2 2 0 01-2-2V8a2 2 0 012-2h4l2-3h6l2 3h4a2 2 0 012 2z" />
                                            <circle cx="12" cy="13" r="4" />
                                        </svg>
                                        Change Banner
                                    </button>
                                    <input type="file" id="bannerUpload" accept="image/*" hidden
                                        onchange="alert('Upload functionality coming soon!')">
                                </c:if>
                            </div>

                            <!-- Profile Info -->
                            <div class="profile-info-section">
                                <div class="profile-avatar-wrapper">
                                    <div class="profile-page-avatar" id="profilePageAvatar">
                                        <c:choose>
                                            <c:when test="${not empty profileUser.profileImage}">
                                                <img src="${profileUser.profileImage}" alt="" class="avatar-image">
                                            </c:when>
                                            <c:otherwise>
                                                <span class="avatar-initial" id="profilePageAvatarInitial">${not empty
                                                    profileUser.fullName ?
                                                    profileUser.fullName.substring(0,1).toUpperCase() :
                                                    profileUser.username.substring(0,1).toUpperCase()}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="profile-details">
                                    <div class="profile-name-section">
                                        <h1 class="profile-display-name">${not empty profileUser.fullName ?
                                            profileUser.fullName : profileUser.username}</h1>
                                        <span class="profile-handle">@${profileUser.username}</span>
                                    </div>
                                    <c:if test="${not empty profileUser.bio}">
                                        <p class="profile-bio-text">${profileUser.bio}</p>
                                    </c:if>

                                    <div class="profile-meta">
                                        <span class="profile-meta-item">
                                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
                                                <line x1="16" y1="2" x2="16" y2="6" />
                                                <line x1="8" y1="2" x2="8" y2="6" />
                                                <line x1="3" y1="10" x2="21" y2="10" />
                                            </svg>
                                            Joined
                                            <fmt:formatDate value="${profileUser.createdDate}" pattern="MMMM yyyy" />
                                        </span>
                                        <c:if test="${not empty profileUser.location}">
                                            <span class="profile-meta-item">
                                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z" />
                                                    <circle cx="12" cy="10" r="3" />
                                                </svg>
                                                ${profileUser.location}
                                            </span>
                                        </c:if>
                                        <c:if test="${not empty profileUser.website}">
                                            <a href="${profileUser.website}"
                                                class="profile-meta-item profile-website-link" target="_blank">
                                                <svg viewBox="0 0 24 24" width="16" height="16" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <circle cx="12" cy="12" r="10" />
                                                    <path
                                                        d="M2 12h20M12 2a15.3 15.3 0 014 10 15.3 15.3 0 01-4 10 15.3 15.3 0 01-4-10 15.3 15.3 0 014-10z" />
                                                </svg>
                                                <span>${not empty profileUser.websiteName ? profileUser.websiteName :
                                                    profileUser.website}</span>
                                            </a>
                                        </c:if>
                                    </div>

                                    <div class="profile-stats-row">
                                        <div class="profile-stat-item">
                                            <span class="stat-number" id="statFollowing">--</span>
                                            <span class="stat-label">Following</span>
                                        </div>
                                        <div class="profile-stat-item">
                                            <span class="stat-number" id="statFollowers">--</span>
                                            <span class="stat-label">Followers</span>
                                        </div>
                                        <div class="profile-stat-item">
                                            <span class="stat-number" id="statStudyHours">--</span>
                                            <span class="stat-label">Study Hours</span>
                                        </div>
                                    </div>

                                    <div class="profile-action-buttons">
                                        <c:if test="${isOwnProfile}">
                                            <button class="btn btn-primary"
                                                onclick="window.location.href='${pageContext.request.contextPath}/AccountServlet?tab=profile'">Edit
                                                Profile</button>
                                        </c:if>
                                        <c:if test="${not isOwnProfile}">
                                            <button class="btn btn-primary" id="followBtn" onclick="toggleFollow()"
                                                style="min-width:120px;">Follow</button>
                                        </c:if>
                                        <button class="btn btn-outline" onclick="copyProfileLink()">Share
                                            Profile</button>
                                    </div>
                                </div>
                            </div>

                            <!-- Profile Tabs -->
                            <div class="profile-tabs">
                                <button class="profile-tab active" onclick="switchProfileTab('posts')">Posts</button>
                                <button class="profile-tab"
                                    onclick="switchProfileTab('achievements')">Achievements</button>
                                <button class="profile-tab" onclick="switchProfileTab('courses')">Courses</button>
                                <button class="profile-tab" onclick="switchProfileTab('stats')">Stats</button>
                            </div>

                            <!-- Profile Content -->
                            <div class="profile-tab-content" id="profileTabContent">
                                <c:if
                                    test="${not empty sessionScope.user && sessionScope.user.userID == profileUser.userID}">
                                    <div class="create-post-section" id="createPostSection" style="display: block;">
                                        <form action="${pageContext.request.contextPath}/PostServlet" method="post"
                                            class="create-post-inline">
                                            <div class="create-post-box">
                                                <div class="create-post-avatar">${not empty sessionScope.user.fullName ?
                                                    sessionScope.user.fullName.substring(0,1).toUpperCase() :
                                                    sessionScope.user.username.substring(0,1).toUpperCase()}</div>
                                                <input type="hidden" name="action" value="createPost">
                                                <input type="text" name="content" class="create-post-placeholder"
                                                    placeholder="What's on your mind?"
                                                    style="border:none;flex:1;background:transparent;color:var(--color-text);outline:none;">
                                                <button type="submit" class="btn btn-primary btn-sm">Post</button>
                                            </div>
                                        </form>
                                    </div>
                                </c:if>

                                <div class="profile-posts profile-tab-panel" id="profile-tab-posts"
                                    style="display: block;">
                                    <c:forEach var="post" items="${posts}">
                                        <div class="post-item">
                                            <div class="post-header">
                                                <div class="post-avatar"><span>${not empty post.author.fullName ?
                                                        post.author.fullName.substring(0,1).toUpperCase() : 'U'}</span>
                                                </div>
                                                <div class="post-meta">
                                                    <span class="post-author">${not empty post.author.fullName ?
                                                        post.author.fullName : post.author.username}</span>
                                                    <span class="post-time">
                                                        <fmt:formatDate value="${post.createdDate}"
                                                            pattern="MMM dd, yyyy" />
                                                    </span>
                                                </div>
                                            </div>
                                            <p class="post-content">${post.content}</p>
                                            <c:if test="${not empty post.imageURL}">
                                                <div class="post-image">
                                                    <img src="${post.imageURL}" alt="Post image">
                                                </div>
                                            </c:if>
                                            <div class="post-actions">
                                                <button class="post-action like-btn" id="like-${post.postID}"
                                                    onclick="toggleLike(${post.postID}, this)">❤️
                                                    <span class="like-count">${post.likeCount}</span></button>
                                                <button class="post-action">💬 ${post.commentCount}</button>
                                                <button class="post-action">🔄 ${post.shareCount}</button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                    <c:if test="${empty posts}">
                                        <div class="empty-state">
                                            <span class="empty-icon">📝</span>
                                            <p>No posts yet. Share your first study update!</p>
                                        </div>
                                    </c:if>
                                </div>

                                <div class="profile-achievements profile-tab-panel" id="profile-tab-achievements"
                                    style="display: none;">
                                    <div class="achievement-grid">
                                        <div class="achievement-card earned">
                                            <span class="achievement-badge">🔥</span>
                                            <h4>7-Day Streak</h4>
                                            <p>Study for 7 consecutive days</p>
                                        </div>
                                        <div class="achievement-card locked">
                                            <span class="achievement-badge locked">💎</span>
                                            <h4>Diamond</h4>
                                            <p>100 hours studied</p>
                                        </div>
                                    </div>
                                </div>

                                <div class="profile-courses profile-tab-panel" id="profile-tab-courses"
                                    style="display: none;">
                                    <div class="empty-state">
                                        <span class="empty-icon">📖</span>
                                        <p>View your enrolled courses and progress here.</p>
                                        <a href="${pageContext.request.contextPath}/CourseServlet"
                                            class="btn btn-primary" style="margin-top: var(--spacing-md);">Browse
                                            Courses</a>
                                    </div>
                                </div>

                                <div class="profile-stats-tab profile-tab-panel" id="profile-tab-stats"
                                    style="display: none;">
                                    <div class="stats-grid"
                                        style="margin-top: var(--spacing-md); display: flex; gap: var(--spacing-md); flex-wrap: wrap;">
                                        <div class="stat-card">
                                            <div class="stat-card-icon">📚</div>
                                            <div class="stat-card-content">
                                                <span class="stat-card-value">0h</span>
                                                <span class="stat-card-label">Total Study Time</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <%@ include file="common/footer.jsp" %>

                        <!-- Toast -->
                        <div class="toast-container" id="toastContainer"></div>

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

                            .like-btn.liked {
                                color: #ef4444;
                            }

                            #followBtn.following {
                                background: rgba(255, 255, 255, 0.1);
                                border: 1px solid rgba(255, 255, 255, 0.2);
                            }
                        </style>

                        <script>
                            var ctx = '${pageContext.request.contextPath}';
                            var profileUserId = ${ profileUser.userID };
                            var isOwnProfile = ${ isOwnProfile };

                            function showToast(msg, type) {
                                var c = document.getElementById('toastContainer');
                                if (!c) return;
                                var t = document.createElement('div');
                                t.className = 'toast toast-' + (type || 'info');
                                t.textContent = msg;
                                c.appendChild(t);
                                setTimeout(function () { t.remove(); }, 3000);
                            }

                            function switchProfileTab(tab) {
                                document.querySelectorAll('.profile-tab').forEach(function (t) { t.classList.remove('active'); });
                                document.querySelectorAll('.profile-tab-panel').forEach(function (c) { c.style.display = 'none'; });
                                event.target.classList.add('active');
                                var el = document.getElementById('profile-tab-' + tab);
                                if (el) { el.style.display = 'block'; }
                            }

                            // ==================== SOCIAL COUNTS ====================
                            fetch(ctx + '/SocialServlet?action=socialCounts&userId=' + profileUserId)
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    document.getElementById('statFollowers').textContent = data.followers || 0;
                                    document.getElementById('statFollowing').textContent = data.following || 0;

                                    // Update follow button state
                                    if (!isOwnProfile) {
                                        var btn = document.getElementById('followBtn');
                                        if (btn && data.isFollowing) {
                                            btn.textContent = 'Following ✓';
                                            btn.classList.add('following');
                                        }
                                    }
                                })
                                .catch(function () {
                                    document.getElementById('statFollowers').textContent = '0';
                                    document.getElementById('statFollowing').textContent = '0';
                                });

                            // Study hours from gamification
                            fetch(ctx + '/GamificationServlet?action=profile')
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    document.getElementById('statStudyHours').textContent = (data.totalStudyHours || 0) + 'h';
                                })
                                .catch(function () {
                                    document.getElementById('statStudyHours').textContent = '0h';
                                });

                            // ==================== FOLLOW/UNFOLLOW ====================
                            function toggleFollow() {
                                var btn = document.getElementById('followBtn');
                                btn.disabled = true;

                                fetch(ctx + '/SocialServlet', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                    body: 'action=follow&followingId=' + profileUserId
                                })
                                    .then(function (r) { return r.json(); })
                                    .then(function (data) {
                                        if (data.success) {
                                            if (data.isFollowing) {
                                                btn.textContent = 'Following ✓';
                                                btn.classList.add('following');
                                                showToast('Followed!', 'success');
                                            } else {
                                                btn.textContent = 'Follow';
                                                btn.classList.remove('following');
                                                showToast('Unfollowed', 'info');
                                            }
                                            document.getElementById('statFollowers').textContent = data.followerCount || 0;
                                        } else {
                                            showToast(data.error || 'Failed', 'error');
                                        }
                                        btn.disabled = false;
                                    })
                                    .catch(function () {
                                        showToast('Network error', 'error');
                                        btn.disabled = false;
                                    });
                            }

                            // ==================== LIKE (AJAX) ====================
                            function toggleLike(postId, btn) {
                                fetch(ctx + '/SocialServlet', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                    body: 'action=like&postId=' + postId
                                })
                                    .then(function (r) { return r.json(); })
                                    .then(function (data) {
                                        if (data.success) {
                                            var countSpan = btn.querySelector('.like-count');
                                            if (countSpan) countSpan.textContent = data.likeCount || 0;
                                            if (data.isLiked) {
                                                btn.classList.add('liked');
                                            } else {
                                                btn.classList.remove('liked');
                                            }
                                        }
                                    })
                                    .catch(function () { });
                            }

                            // ==================== SHARE PROFILE ====================
                            function copyProfileLink() {
                                var url = window.location.origin + ctx + '/ProfileServlet?userId=' + profileUserId;
                                navigator.clipboard.writeText(url).then(function () {
                                    showToast('Profile link copied!', 'success');
                                }).catch(function () {
                                    showToast('Could not copy link', 'error');
                                });
                            }
                        </script>
            </body>

            </html>