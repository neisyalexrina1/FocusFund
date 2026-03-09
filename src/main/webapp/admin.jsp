<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <%@ include file="common/header.jsp" %>
                <title>Admin Dashboard - FocusFund</title>
                <style>
                    .admin-container {
                        max-width: 1200px;
                        margin: 0 auto;
                        padding: 40px 24px;
                    }

                    .admin-header {
                        margin-bottom: 32px;
                    }

                    .admin-header h1 {
                        font-family: var(--font-display);
                        font-size: 2.2rem;
                        font-weight: 700;
                        background: linear-gradient(135deg, #f59e0b, #ef4444);
                        -webkit-background-clip: text;
                        background-clip: text;
                        -webkit-text-fill-color: transparent;
                        margin-bottom: 8px;
                    }

                    .admin-header p {
                        color: var(--color-text-secondary);
                    }

                    .stats-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                        gap: 20px;
                        margin-bottom: 32px;
                    }

                    .stat-card {
                        background: rgba(255, 255, 255, 0.04);
                        border: 1px solid rgba(255, 255, 255, 0.08);
                        border-radius: var(--radius-lg);
                        padding: 24px;
                    }

                    .stat-card .stat-value {
                        font-size: 2rem;
                        font-weight: 700;
                        color: white;
                        font-family: var(--font-display);
                    }

                    .stat-card .stat-label {
                        font-size: 0.85rem;
                        color: var(--color-text-secondary);
                        margin-top: 4px;
                    }

                    .users-table-container {
                        background: rgba(255, 255, 255, 0.03);
                        border: 1px solid rgba(255, 255, 255, 0.06);
                        border-radius: var(--radius-lg);
                        overflow: hidden;
                    }

                    .users-table {
                        width: 100%;
                        border-collapse: collapse;
                    }

                    .users-table th {
                        text-align: left;
                        padding: 14px 20px;
                        font-size: 0.8rem;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                        color: var(--color-text-secondary);
                        border-bottom: 1px solid rgba(255, 255, 255, 0.06);
                        background: rgba(0, 0, 0, 0.2);
                    }

                    .users-table td {
                        padding: 12px 20px;
                        border-bottom: 1px solid rgba(255, 255, 255, 0.04);
                        color: var(--color-text-primary);
                    }

                    .users-table tr:hover td {
                        background: rgba(255, 255, 255, 0.02);
                    }

                    .role-badge {
                        padding: 3px 10px;
                        border-radius: 12px;
                        font-size: 0.75rem;
                        font-weight: 600;
                        text-transform: uppercase;
                    }

                    .role-admin {
                        background: rgba(239, 68, 68, 0.15);
                        color: #f87171;
                    }

                    .role-user {
                        background: rgba(59, 130, 246, 0.15);
                        color: #60a5fa;
                    }

                    .user-actions {
                        display: flex;
                        gap: 8px;
                    }

                    .btn-admin-sm {
                        padding: 4px 12px;
                        font-size: 0.75rem;
                        border-radius: 8px;
                        cursor: pointer;
                        border: none;
                        font-weight: 600;
                        transition: all 0.2s;
                    }

                    .btn-promote {
                        background: rgba(34, 197, 94, 0.15);
                        color: #4ade80;
                    }

                    .btn-promote:hover {
                        background: rgba(34, 197, 94, 0.3);
                    }

                    .btn-demote {
                        background: rgba(251, 191, 36, 0.15);
                        color: #fbbf24;
                    }

                    .btn-demote:hover {
                        background: rgba(251, 191, 36, 0.3);
                    }

                    .btn-delete-user {
                        background: rgba(239, 68, 68, 0.15);
                        color: #f87171;
                    }

                    .btn-delete-user:hover {
                        background: rgba(239, 68, 68, 0.3);
                    }

                    .search-bar {
                        margin-bottom: 20px;
                    }

                    .search-bar input {
                        background: rgba(0, 0, 0, 0.2);
                        border: 1px solid rgba(255, 255, 255, 0.1);
                        border-radius: 12px;
                        padding: 12px 16px;
                        color: white;
                        width: 100%;
                        max-width: 400px;
                        font-size: 0.9rem;
                        outline: none;
                    }

                    .search-bar input:focus {
                        border-color: var(--color-accent-primary);
                        box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
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

                <section class="page active" id="page-admin">
                    <div class="admin-container">
                        <div class="admin-header">
                            <h1>🛡️ Admin Dashboard</h1>
                            <p>Manage users, monitor activity, and configure the platform</p>
                        </div>

                        <!-- Stats Cards -->
                        <div class="stats-grid">
                            <div class="stat-card">
                                <div class="stat-value">${totalUsers}</div>
                                <div class="stat-label">Total Users</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-value">${activeUsers}</div>
                                <div class="stat-label">Active Users</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-value">${totalUsers - activeUsers}</div>
                                <div class="stat-label">Deactivated</div>
                            </div>
                        </div>

                        <!-- Search -->
                        <div class="search-bar">
                            <input type="text" id="userSearch" placeholder="Search users by name or email..."
                                oninput="filterUsers()">
                        </div>

                        <!-- Users Table -->
                        <div class="users-table-container">
                            <table class="users-table" id="usersTable">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Username</th>
                                        <th>Full Name</th>
                                        <th>Email</th>
                                        <th>Role</th>
                                        <th>Joined</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="u" items="${allUsers}">
                                        <tr data-userid="${u.userID}">
                                            <td>${u.userID}</td>
                                            <td>@${u.username}</td>
                                            <td>${u.fullName}</td>
                                            <td>${u.email}</td>
                                            <td>
                                                <span
                                                    class="role-badge ${u.role == 'admin' ? 'role-admin' : 'role-user'}">${u.role}</span>
                                            </td>
                                            <td>
                                                <c:if test="${not empty u.createdDate}">
                                                    ${u.createdDate}
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${u.userID != sessionScope.user.userID}">
                                                    <div class="user-actions">
                                                        <c:choose>
                                                            <c:when test="${u.role != 'admin'}">
                                                                <button class="btn-admin-sm btn-promote"
                                                                    onclick="changeRole(${u.userID}, 'admin')">Promote</button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button class="btn-admin-sm btn-demote"
                                                                    onclick="changeRole(${u.userID}, 'user')">Demote</button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <button class="btn-admin-sm btn-delete-user"
                                                            onclick="deleteUser(${u.userID}, '${u.username}')">Delete</button>
                                                    </div>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </section>

                <%@ include file="common/footer.jsp" %>

                    <script>
                        var contextPath = '${pageContext.request.contextPath}';

                        function filterUsers() {
                            var query = document.getElementById('userSearch').value.toLowerCase();
                            var rows = document.querySelectorAll('#usersTable tbody tr');
                            rows.forEach(function (row) {
                                var text = row.textContent.toLowerCase();
                                row.style.display = text.includes(query) ? '' : 'none';
                            });
                        }

                        function changeRole(userId, role) {
                            if (!confirm('Change this user\'s role to ' + role + '?')) return;
                            fetch(contextPath + '/AdminServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: 'action=changeRole&userId=' + userId + '&role=' + role
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        showToast(data.message, 'success');
                                        setTimeout(function () { location.reload(); }, 800);
                                    } else {
                                        showToast(data.message, 'error');
                                    }
                                })
                                .catch(function () { showToast('Network error', 'error'); });
                        }

                        function deleteUser(userId, username) {
                            if (!confirm('Delete user @' + username + '? This cannot be undone.')) return;
                            fetch(contextPath + '/AdminServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: 'action=deleteUser&userId=' + userId
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        showToast(data.message, 'success');
                                        var row = document.querySelector('tr[data-userid="' + userId + '"]');
                                        if (row) row.remove();
                                    } else {
                                        showToast(data.message, 'error');
                                    }
                                })
                                .catch(function () { showToast('Network error', 'error'); });
                        }
                    </script>
        </body>

        </html>