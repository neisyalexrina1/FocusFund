<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <%@ include file="common/header.jsp" %>
                <title>Account Settings - FocusFund</title>
        </head>

        <body>
            <div class="background-effects">
                <div class="stars" id="stars"></div>
                <div class="shooting-stars" id="shooting-stars"></div>
                <div class="rain" id="rain"></div>
            </div>

            <%@ include file="common/navbar.jsp" %>

                <section class="page active" id="page-account">
                    <div class="account-container">
                        <!-- Account Sidebar -->
                        <aside class="account-sidebar">
                            <div class="account-sidebar-header">
                                <a href="${pageContext.request.contextPath}/DashboardServlet" class="back-btn">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M19 12H5M12 19l-7-7 7-7" />
                                    </svg>
                                    Back
                                </a>
                                <h2>Account Settings</h2>
                            </div>
                            <nav class="account-nav">
                                <button
                                    class="account-nav-item ${empty activeTab || activeTab == 'profile' ? 'active' : ''}"
                                    onclick="setAccountTab('profile')">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2" />
                                        <circle cx="12" cy="7" r="4" />
                                    </svg>
                                    <span>Profile</span>
                                </button>
                                <button class="account-nav-item ${activeTab == 'security' ? 'active' : ''}"
                                    onclick="setAccountTab('security')">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                                        <path d="M7 11V7a5 5 0 0110 0v4" />
                                    </svg>
                                    <span>Security</span>
                                </button>
                                <button class="account-nav-item ${activeTab == 'privacy' ? 'active' : ''}"
                                    onclick="setAccountTab('privacy')">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                                    </svg>
                                    <span>Privacy</span>
                                </button>
                                <button class="account-nav-item ${activeTab == 'notifications' ? 'active' : ''}"
                                    onclick="setAccountTab('notifications')">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9" />
                                        <path d="M13.73 21a2 2 0 01-3.46 0" />
                                    </svg>
                                    <span>Notifications</span>
                                </button>
                                <button class="account-nav-item ${activeTab == 'data' ? 'active' : ''}"
                                    onclick="setAccountTab('data')">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <ellipse cx="12" cy="5" rx="9" ry="3" />
                                        <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3" />
                                        <path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5" />
                                    </svg>
                                    <span>Data & Storage</span>
                                </button>
                                <button class="account-nav-item danger" onclick="setAccountTab('deactivate')">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <circle cx="12" cy="12" r="10" />
                                        <line x1="15" y1="9" x2="9" y2="15" />
                                        <line x1="9" y1="9" x2="15" y2="15" />
                                    </svg>
                                    <span>Deactivate Account</span>
                                </button>
                            </nav>
                        </aside>

                        <!-- Account Content -->
                        <main class="account-content">
                            <c:if test="${not empty successMessage}">
                                <script>document.addEventListener('DOMContentLoaded', function () { showToast('${successMessage}', 'success'); });</script>
                            </c:if>
                            <c:if test="${not empty errorMessage}">
                                <script>document.addEventListener('DOMContentLoaded', function () { showToast('${errorMessage}', 'error'); });</script>
                            </c:if>

                            <!-- Profile Tab -->
                            <div class="account-tab ${empty activeTab || activeTab == 'profile' ? 'active' : ''}"
                                id="tab-profile">
                                <div class="account-tab-header">
                                    <h1>Profile</h1>
                                    <p>Manage your personal information</p>
                                </div>
                                <div class="account-section">
                                    <div class="profile-avatar-section">
                                        <div class="profile-avatar-large">
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.user.profileImage}">
                                                    <img src="${sessionScope.user.profileImage}" alt=""
                                                        class="avatar-image">
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="avatar-initial">${not empty sessionScope.user.fullName
                                                        ? sessionScope.user.fullName.substring(0,1).toUpperCase() :
                                                        sessionScope.user.username.substring(0,1).toUpperCase()}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="profile-avatar-info">
                                            <p class="avatar-hint">Recommended: Square image, at least 200x200px</p>
                                            <form action="${pageContext.request.contextPath}/ProfileServlet"
                                                method="post" enctype="multipart/form-data"
                                                style="display:flex;align-items:center;gap:12px;margin-top:8px;">
                                                <input type="hidden" name="action" value="uploadImage">
                                                <input type="file" name="imageFile"
                                                    accept="image/jpeg,image/png,image/gif,image/webp"
                                                    style="font-size:0.85rem;color:var(--color-text-secondary);"
                                                    required>
                                                <button type="submit" class="btn btn-primary btn-sm">Upload</button>
                                            </form>
                                        </div>
                                    </div>
                                    <form class="account-form"
                                        action="${pageContext.request.contextPath}/AccountServlet" method="post">
                                        <input type="hidden" name="action" value="updateProfile">
                                        <div class="form-group">
                                            <label for="profileUsername">Display Name</label>
                                            <input type="text" id="profileUsername" name="fullName" class="input"
                                                value="${sessionScope.user.fullName}" placeholder="Your display name">
                                        </div>
                                        <div class="form-group">
                                            <label for="profileHandle">Username</label>
                                            <div class="input-with-prefix">
                                                <span class="input-prefix">@</span>
                                                <input type="text" id="profileHandle" name="username" class="input"
                                                    value="${sessionScope.user.username}" placeholder="username">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="profileEmail">Email</label>
                                            <input type="email" id="profileEmail" name="email" class="input"
                                                value="${sessionScope.user.email}" placeholder="your@email.com">
                                        </div>
                                        <div class="form-group">
                                            <label for="profileBio">Bio</label>
                                            <textarea id="profileBio" name="bio" class="input textarea"
                                                placeholder="Tell us about yourself..."
                                                rows="3">${sessionScope.user.bio}</textarea>
                                        </div>
                                        <div class="form-group">
                                            <label for="profileLocation">Country</label>
                                            <select id="profileLocation" name="location" class="input">
                                                <option value="">Select Country</option>
                                                <option value="Vietnam" ${sessionScope.user.location=='Vietnam'
                                                    ? 'selected' : '' }>Vietnam</option>
                                                <option value="United States"
                                                    ${sessionScope.user.location=='United States' ? 'selected' : '' }>
                                                    United States</option>
                                                <option value="United Kingdom"
                                                    ${sessionScope.user.location=='United Kingdom' ? 'selected' : '' }>
                                                    United Kingdom</option>
                                                <option value="Japan" ${sessionScope.user.location=='Japan' ? 'selected'
                                                    : '' }>Japan</option>
                                                <option value="South Korea" ${sessionScope.user.location=='South Korea'
                                                    ? 'selected' : '' }>South Korea</option>
                                                <option value="Singapore" ${sessionScope.user.location=='Singapore'
                                                    ? 'selected' : '' }>Singapore</option>
                                                <option value="Other" ${sessionScope.user.location=='Other' ? 'selected'
                                                    : '' }>Other</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="profileWebsiteName">Website Name</label>
                                            <input type="text" id="profileWebsiteName" name="websiteName" class="input"
                                                value="${sessionScope.user.websiteName}"
                                                placeholder="e.g., My Portfolio">
                                        </div>
                                        <div class="form-group">
                                            <label for="profileWebsite">Website URL</label>
                                            <input type="url" id="profileWebsite" name="website" class="input"
                                                value="${sessionScope.user.website}"
                                                placeholder="https://yourwebsite.com">
                                        </div>
                                        <div class="form-actions">
                                            <button type="submit" class="btn btn-primary">Save Changes</button>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <!-- Security Tab -->
                            <div class="account-tab ${activeTab == 'security' ? 'active' : ''}" id="tab-security">
                                <div class="account-tab-header">
                                    <h1>Security</h1>
                                    <p>Manage your password and security settings</p>
                                </div>
                                <div class="account-section">
                                    <h3 class="section-subtitle">Change Password</h3>
                                    <form class="account-form"
                                        action="${pageContext.request.contextPath}/AccountServlet" method="post">
                                        <input type="hidden" name="action" value="changePassword">
                                        <div class="form-group">
                                            <label for="currentPassword">Current Password</label>
                                            <input type="password" id="currentPassword" name="currentPassword"
                                                class="input" placeholder="••••••••" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="newPassword">New Password</label>
                                            <input type="password" id="newPassword" name="newPassword" class="input"
                                                placeholder="••••••••" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="confirmNewPassword">Confirm New Password</label>
                                            <input type="password" id="confirmNewPassword" name="confirmNewPassword"
                                                class="input" placeholder="••••••••" required>
                                        </div>
                                        <div class="form-actions">
                                            <button type="submit" class="btn btn-primary">Update Password</button>
                                        </div>
                                    </form>
                                </div>
                                <div class="account-section">
                                    <h3 class="section-subtitle">Two-Factor Authentication</h3>
                                    <div class="setting-row">
                                        <div class="setting-info">
                                            <span class="setting-label">Enable 2FA</span>
                                            <span class="setting-desc">Add an extra layer of security to your
                                                account</span>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox" id="toggle2FA">
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <!-- Privacy Tab -->
                            <div class="account-tab ${activeTab == 'privacy' ? 'active' : ''}" id="tab-privacy">
                                <div class="account-tab-header">
                                    <h1>Privacy</h1>
                                    <p>Control your privacy settings</p>
                                </div>
                                <div class="account-section">
                                    <div class="setting-row">
                                        <div class="setting-info">
                                            <span class="setting-label">Public Profile</span>
                                            <span class="setting-desc">Allow others to see your profile</span>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox" checked>
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                    <div class="setting-row">
                                        <div class="setting-info">
                                            <span class="setting-label">Show Study Stats</span>
                                            <span class="setting-desc">Display your study statistics on your
                                                profile</span>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox" checked>
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                    <div class="setting-row">
                                        <div class="setting-info">
                                            <span class="setting-label">Show Online Status</span>
                                            <span class="setting-desc">Let others see when you're studying</span>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox" checked>
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <!-- Notifications Tab -->
                            <div class="account-tab ${activeTab == 'notifications' ? 'active' : ''}"
                                id="tab-notifications">
                                <div class="account-tab-header">
                                    <h1>Notifications</h1>
                                    <p>Manage how you receive notifications</p>
                                </div>
                                <div class="account-section">
                                    <h3 class="section-subtitle">Email Notifications</h3>
                                    <div class="setting-row">
                                        <div class="setting-info">
                                            <span class="setting-label">Email Notifications</span>
                                            <span class="setting-desc">Receive important updates via email</span>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox" checked>
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                </div>
                                <div class="account-section">
                                    <h3 class="section-subtitle">Push Notifications</h3>
                                    <div class="setting-row">
                                        <div class="setting-info">
                                            <span class="setting-label">Study Reminders</span>
                                            <span class="setting-desc">Get reminders to maintain your study
                                                streak</span>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox" checked>
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <!-- Data & Storage Tab -->
                            <div class="account-tab ${activeTab == 'data' ? 'active' : ''}" id="tab-data">
                                <div class="account-tab-header">
                                    <h1>Data & Storage</h1>
                                    <p>Manage your data and storage usage</p>
                                </div>
                                <div class="account-section">
                                    <h3 class="section-subtitle">Storage Usage</h3>
                                    <div class="storage-info">
                                        <div class="storage-visual">
                                            <div class="storage-bar">
                                                <div class="storage-used" style="width: 35%"></div>
                                            </div>
                                            <div class="storage-stats">
                                                <span class="storage-used-text">1.2 GB used</span>
                                                <span class="storage-total-text">of 5 GB</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="account-section">
                                    <h3 class="section-subtitle">Export Your Data</h3>
                                    <p class="section-desc">Download a copy of all your data.</p>
                                    <button class="btn btn-outline" onclick="alert('Data export coming soon!')">Download
                                        My Data</button>
                                </div>
                            </div>

                            <!-- Deactivate Account Tab -->
                            <div class="account-tab ${activeTab == 'deactivate' ? 'active' : ''}" id="tab-deactivate">
                                <div class="account-tab-header">
                                    <h1>Deactivate Account</h1>
                                    <p>Permanently deactivate your account</p>
                                </div>
                                <div class="account-section danger-zone">
                                    <div class="danger-warning">
                                        <svg viewBox="0 0 24 24" width="48" height="48" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <path
                                                d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z" />
                                            <line x1="12" y1="9" x2="12" y2="13" />
                                            <line x1="12" y1="17" x2="12.01" y2="17" />
                                        </svg>
                                        <h3>Warning: This action is irreversible</h3>
                                        <p>Once you deactivate your account, all your data will be permanently deleted.
                                        </p>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/AccountServlet" method="post">
                                        <input type="hidden" name="action" value="deactivate">
                                        <div class="deactivate-confirm">
                                            <label class="checkbox-label">
                                                <input type="checkbox" id="confirmDeactivate"
                                                    onchange="document.getElementById('deactivateBtn').disabled = !this.checked">
                                                <span>I understand that this action cannot be undone</span>
                                            </label>
                                            <button type="submit" class="btn btn-danger" id="deactivateBtn" disabled>
                                                Deactivate My Account
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </main>
                    </div>
                </section>

                <%@ include file="common/footer.jsp" %>

                    <script>
                        function setAccountTab(tab) {
                            document.querySelectorAll('.account-nav-item').forEach(function (btn) { btn.classList.remove('active'); });
                            document.querySelectorAll('.account-tab').forEach(function (t) { t.classList.remove('active'); });
                            event.target.closest('.account-nav-item').classList.add('active');
                            var el = document.getElementById('tab-' + tab);
                            if (el) el.classList.add('active');
                        }
                    </script>
        </body>

        </html>