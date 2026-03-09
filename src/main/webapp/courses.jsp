<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <%@ include file="common/header.jsp" %>
                <title>Course Hub - FocusFund</title>
        </head>

        <body>
            <div class="background-effects">
                <div class="stars" id="stars"></div>
                <div class="shooting-stars" id="shooting-stars"></div>
                <div class="rain" id="rain"></div>
            </div>

            <%@ include file="common/navbar.jsp" %>

                <section class="page active" id="page-courses">
                    <div class="page-container">
                        <div class="page-header"
                            style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:16px;">
                            <div>
                                <h1 class="page-title">Course Hub</h1>
                                <p class="page-subtitle">Roadmap-first learning with structured guides</p>
                            </div>
                            <c:if test="${not empty sessionScope.user}">
                                <button class="btn btn-primary"
                                    onclick="document.getElementById('createCourseModal').classList.remove('hidden')"
                                    style="display:flex; align-items:center; gap:8px;">
                                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <line x1="12" y1="5" x2="12" y2="19" />
                                        <line x1="5" y1="12" x2="19" y2="12" />
                                    </svg>
                                    Create Course
                                </button>
                            </c:if>
                        </div>

                        <!-- Tabs: My Courses / All Courses -->
                        <c:if test="${not empty sessionScope.user}">
                            <div class="rooms-filters" style="margin-bottom: var(--spacing-lg);">
                                <button class="filter-btn active" onclick="loadCourses('my', this)">My Courses</button>
                                <button class="filter-btn" onclick="loadCourses('all', this)">All Courses</button>
                                <button class="filter-btn" onclick="loadCourses('public', this)">Public Courses</button>
                            </div>
                        </c:if>

                        <div class="courses-grid" id="coursesGrid">
                            <c:forEach var="course" items="${courses}">
                                <div class="course-card" data-course-id="${course.courseID}"
                                    onclick="window.location.href='${pageContext.request.contextPath}/CourseServlet?id=${course.courseID}'"
                                    style="cursor:pointer; position:relative;">
                                    <div class="course-header">
                                        <span class="course-icon">${course.icon}</span>
                                        <span class="course-badge">${course.duration}</span>
                                    </div>
                                    <h3 class="course-title">${course.courseName}</h3>
                                    <p class="course-desc">${course.description}</p>
                                    <div class="course-meta">
                                        <span>📊 ${course.topicCount} Topics</span>
                                        <span>👥 ${course.learnerCount} Learners</span>
                                    </div>
                                    <div class="course-progress">
                                        <div class="progress-bar" style="--progress: 0%"></div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <c:if test="${empty courses}">
                            <div class="empty-state" id="emptyState"
                                style="text-align:center; padding:60px 20px; color:var(--color-text-secondary);">
                                <div style="font-size:48px; margin-bottom:16px;">📚</div>
                                <h3 style="color:var(--color-text-primary); margin-bottom:8px;">No courses yet</h3>
                                <p>Create your first course to start learning!</p>
                            </div>
                        </c:if>
                    </div>
                </section>

                <!-- Create Course Modal -->
                <c:if test="${not empty sessionScope.user}">
                    <div class="modal-overlay hidden" id="createCourseModal">
                        <div class="modal-overlay-bg"
                            onclick="document.getElementById('createCourseModal').classList.add('hidden')"></div>
                        <div class="modal-content"
                            style="position:relative; z-index:1; background:#1a1d2d; border-radius:24px; max-width:600px; width:90%; box-shadow:0 25px 50px -12px rgba(0,0,0,0.5); border:1px solid rgba(255,255,255,0.1); overflow:hidden; transform:scale(0.95) translateY(10px); transition:all 0.3s cubic-bezier(0.34,1.56,0.64,1);">
                            <div style="padding:32px;">
                                <div
                                    style="display:flex; justify-content:space-between; align-items:center; margin-bottom:24px;">
                                    <div style="display:flex; align-items:center; gap:12px;">
                                        <div
                                            style="width:44px; height:44px; background:linear-gradient(135deg,#6366f1,#a855f7); border-radius:12px; display:flex; align-items:center; justify-content:center; font-size:1.3rem;">
                                            📚</div>
                                        <div>
                                            <h2
                                                style="font-family:var(--font-display); font-size:1.4rem; font-weight:700; color:white; margin:0;">
                                                Create New Course</h2>
                                            <p style="color:var(--color-text-secondary); font-size:0.85rem; margin:0;">
                                                Set up your learning roadmap</p>
                                        </div>
                                    </div>
                                    <button
                                        onclick="document.getElementById('createCourseModal').classList.add('hidden')"
                                        style="background:rgba(255,255,255,0.05); border:none; border-radius:50%; width:32px; height:32px; display:flex; align-items:center; justify-content:center; cursor:pointer; color:var(--color-text-secondary); transition:all 0.2s;">✕</button>
                                </div>

                                <form id="createCourseForm" style="display:flex; flex-direction:column; gap:20px;">
                                    <div style="display:grid; grid-template-columns:1fr auto; gap:16px;">
                                        <div class="form-group" style="margin:0;">
                                            <label
                                                style="font-size:0.8rem; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:6px; display:block; color:var(--color-text-secondary);">Course
                                                Name <span style="color:#ef4444;">*</span></label>
                                            <input type="text" id="courseName" name="courseName" class="input"
                                                placeholder="e.g., Calculus I" required minlength="2" maxlength="100"
                                                style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:12px; padding:12px 16px;">
                                        </div>
                                        <div class="form-group" style="margin:0;">
                                            <label
                                                style="font-size:0.8rem; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:6px; display:block; color:var(--color-text-secondary);">Icon</label>
                                            <input type="text" id="courseIcon" name="icon" class="input" value="📘"
                                                maxlength="4"
                                                style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:12px; padding:12px 16px; width:60px; text-align:center; font-size:1.4rem;">
                                        </div>
                                    </div>

                                    <div class="form-group" style="margin:0;">
                                        <label
                                            style="font-size:0.8rem; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:6px; display:block; color:var(--color-text-secondary);">Short
                                            Description</label>
                                        <input type="text" id="courseDesc" name="description" class="input"
                                            placeholder="Brief course overview..." maxlength="200"
                                            style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:12px; padding:12px 16px;">
                                    </div>

                                    <div class="form-group" style="margin:0;">
                                        <label
                                            style="font-size:0.8rem; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:6px; display:block; color:var(--color-text-secondary);">Detailed
                                            Description</label>
                                        <textarea id="courseDetailDesc" name="detailDescription" class="input" rows="3"
                                            placeholder="Full course description..."
                                            style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:12px; padding:12px 16px; resize:none;"></textarea>
                                    </div>

                                    <div class="form-group" style="margin:0;">
                                        <label
                                            style="font-size:0.8rem; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:6px; display:block; color:var(--color-text-secondary);">Duration</label>
                                        <select id="courseDuration" name="duration" class="input"
                                            style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:12px; padding:12px 16px; appearance:none; cursor:pointer;">
                                            <option value="4 Weeks" style="background:#1a1d2d;">4 Weeks</option>
                                            <option value="8 Weeks" style="background:#1a1d2d;">8 Weeks</option>
                                            <option value="12 Weeks" style="background:#1a1d2d;">12 Weeks</option>
                                            <option value="16 Weeks" style="background:#1a1d2d;">16 Weeks</option>
                                            <option value="Ongoing" style="background:#1a1d2d;">Ongoing</option>
                                        </select>
                                    </div>

                                    <div id="createCourseError" class="hidden"
                                        style="color:#ef4444; font-size:0.9rem; background:rgba(239,68,68,0.1); padding:10px 14px; border-radius:8px;">
                                    </div>

                                    <div
                                        style="display:flex; justify-content:flex-end; gap:12px; padding-top:12px; border-top:1px solid rgba(255,255,255,0.06);">
                                        <button type="button"
                                            onclick="document.getElementById('createCourseModal').classList.add('hidden')"
                                            style="padding:10px 20px; border-radius:12px; background:transparent; color:var(--color-text-secondary); border:1px solid rgba(255,255,255,0.1); font-weight:600; cursor:pointer;">Cancel</button>
                                        <button type="submit" id="createCourseBtn"
                                            style="padding:10px 28px; border-radius:12px; background:linear-gradient(135deg,#6366f1,#a855f7); color:white; border:none; font-weight:600; cursor:pointer; box-shadow:0 4px 15px rgba(99,102,241,0.3);">Create
                                            Course 📚</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- Toast -->
                <div class="toast-container" id="toastContainer"></div>

                <%@ include file="common/footer.jsp" %>

                    <style>
                        .modal-overlay {
                            position: fixed;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            z-index: 1000;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            opacity: 0;
                            visibility: hidden;
                            transition: all 0.3s ease;
                        }

                        .modal-overlay:not(.hidden) {
                            opacity: 1;
                            visibility: visible;
                        }

                        .modal-overlay:not(.hidden) .modal-content {
                            transform: scale(1) translateY(0);
                        }

                        .modal-overlay-bg {
                            position: absolute;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            background: rgba(0, 0, 0, 0.6);
                            backdrop-filter: blur(8px);
                        }

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
                            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
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

                        .course-card {
                            position: relative;
                        }

                        .course-delete-btn {
                            position: absolute;
                            top: 12px;
                            right: 12px;
                            background: rgba(239, 68, 68, 0.15);
                            border: none;
                            border-radius: 50%;
                            width: 30px;
                            height: 30px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            cursor: pointer;
                            color: #f87171;
                            font-size: 0.9rem;
                            transition: all 0.2s;
                            z-index: 5;
                            opacity: 0;
                        }

                        .course-card:hover .course-delete-btn {
                            opacity: 1;
                        }

                        .course-delete-btn:hover {
                            background: rgba(239, 68, 68, 0.3);
                            transform: scale(1.1);
                        }
                    </style>

                    <script>
                        var ctx = '${pageContext.request.contextPath}';
                        var currentUserId = ${ not empty sessionScope.user ?sessionScope.user.userID: 0};

                        function showToast(message, type) {
                            var container = document.getElementById('toastContainer');
                            if (!container) return;
                            var toast = document.createElement('div');
                            toast.className = 'toast toast-' + (type || 'info');
                            toast.textContent = message;
                            container.appendChild(toast);
                            setTimeout(function () { toast.remove(); }, 3000);
                        }

                        // Create course form
                        var createForm = document.getElementById('createCourseForm');
                        if (createForm) {
                            createForm.addEventListener('submit', function (e) {
                                e.preventDefault();
                                var errorDiv = document.getElementById('createCourseError');
                                var btn = document.getElementById('createCourseBtn');
                                errorDiv.classList.add('hidden');
                                btn.disabled = true;
                                btn.textContent = 'Creating...';

                                var params = 'action=create'
                                    + '&courseName=' + encodeURIComponent(document.getElementById('courseName').value)
                                    + '&icon=' + encodeURIComponent(document.getElementById('courseIcon').value)
                                    + '&description=' + encodeURIComponent(document.getElementById('courseDesc').value)
                                    + '&detailDescription=' + encodeURIComponent(document.getElementById('courseDetailDesc').value)
                                    + '&duration=' + encodeURIComponent(document.getElementById('courseDuration').value);

                                fetch(ctx + '/CourseServlet', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                    body: params
                                })
                                    .then(function (r) { return r.json(); })
                                    .then(function (data) {
                                        if (data.success) {
                                            showToast(data.message || 'Course created!', 'success');
                                            document.getElementById('createCourseModal').classList.add('hidden');
                                            createForm.reset();
                                            document.getElementById('courseIcon').value = '📘';
                                            setTimeout(function () { window.location.reload(); }, 800);
                                        } else {
                                            errorDiv.textContent = data.error || 'Failed to create course';
                                            errorDiv.classList.remove('hidden');
                                            btn.disabled = false;
                                            btn.textContent = 'Create Course 📚';
                                        }
                                    })
                                    .catch(function () {
                                        errorDiv.textContent = 'Network error. Please try again.';
                                        errorDiv.classList.remove('hidden');
                                        btn.disabled = false;
                                        btn.textContent = 'Create Course 📚';
                                    });
                            });
                        }

                        // Delete course
                        function deleteCourse(courseId, event) {
                            event.stopPropagation();
                            if (!confirm('Are you sure you want to delete this course?')) return;

                            fetch(ctx + '/CourseServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: 'action=delete&courseId=' + courseId
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        showToast(data.message || 'Course deleted!', 'success');
                                        var card = document.querySelector('[data-course-id="' + courseId + '"]');
                                        if (card) card.remove();
                                    } else {
                                        showToast(data.error || 'Delete failed', 'error');
                                    }
                                })
                                .catch(function () { showToast('Network error', 'error'); });
                        }

                        // Load courses via AJAX (for tabs)
                        function loadCourses(type, btn) {
                            document.querySelectorAll('.filter-btn').forEach(function (b) { b.classList.remove('active'); });
                            if (btn) btn.classList.add('active');

                            var url = ctx + '/CourseServlet?action=' + (type === 'my' ? 'myCourses' : type === 'public' ? 'public' : 'all');
                            fetch(url)
                                .then(function (r) { return r.json(); })
                                .then(function (courses) {
                                    var grid = document.getElementById('coursesGrid');
                                    var empty = document.getElementById('emptyState');
                                    if (!courses || courses.length === 0) {
                                        grid.innerHTML = '';
                                        if (empty) empty.style.display = 'block';
                                        return;
                                    }
                                    if (empty) empty.style.display = 'none';
                                    var html = '';
                                    courses.forEach(function (c) {
                                        var deleteBtn = (c.createdBy === currentUserId)
                                            ? '<button class="course-delete-btn" onclick="deleteCourse(' + c.courseID + ', event)" title="Delete Course">🗑</button>'
                                            : '';
                                        html += '<div class="course-card" data-course-id="' + c.courseID + '" onclick="window.location.href=\'' + ctx + '/CourseServlet?id=' + c.courseID + '\'" style="cursor:pointer; position:relative;">'
                                            + deleteBtn
                                            + '<div class="course-header"><span class="course-icon">' + (c.icon || '📘') + '</span><span class="course-badge">' + (c.duration || '') + '</span></div>'
                                            + '<h3 class="course-title">' + c.courseName + '</h3>'
                                            + '<p class="course-desc">' + (c.description || '') + '</p>'
                                            + '<div class="course-meta"><span>📊 ' + (c.topicCount || 0) + ' Topics</span><span>👥 ' + (c.learnerCount || 0) + ' Learners</span></div>'
                                            + '<div class="course-progress"><div class="progress-bar" style="--progress: 0%"></div></div>'
                                            + '</div>';
                                    });
                                    grid.innerHTML = html;
                                })
                                .catch(function () { showToast('Failed to load courses', 'error'); });
                        }
                    </script>
        </body>

        </html>