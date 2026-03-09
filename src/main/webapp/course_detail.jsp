<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <%@ include file="common/header.jsp" %>
                <title>${course.courseName} - FocusFund</title>
        </head>

        <body>
            <div class="background-effects">
                <div class="stars" id="stars"></div>
                <div class="shooting-stars" id="shooting-stars"></div>
                <div class="rain" id="rain"></div>
            </div>

            <%@ include file="common/navbar.jsp" %>

                <section class="page active" id="page-course-detail">
                    <div class="page-container">
                        <a href="${pageContext.request.contextPath}/CourseServlet" class="back-btn">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M19 12H5M12 19l-7-7 7-7" />
                            </svg>
                            Back to Courses
                        </a>

                        <div class="course-detail-header">
                            <div class="course-detail-info">
                                <span class="course-detail-icon">${course.icon}</span>
                                <div>
                                    <h1 class="course-detail-title" id="courseTitle">${course.courseName}</h1>
                                    <p class="course-detail-desc" id="courseDetailDesc">${course.detailDescription}</p>
                                </div>
                            </div>
                            <div style="display:flex; gap:8px; align-items:center;">
                                <c:if test="${not empty sessionScope.user}">
                                    <button class="btn btn-secondary" onclick="showEditCourse()"
                                        style="font-size:0.85rem; padding:8px 16px;">✏️ Edit</button>
                                    <button class="btn btn-danger" onclick="deleteCourseDetail()"
                                        style="font-size:0.85rem; padding:8px 16px; background:rgba(239,68,68,0.15); color:#f87171; border:1px solid rgba(239,68,68,0.3); border-radius:var(--radius-md); cursor:pointer;">🗑
                                        Delete</button>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/StudyRoomServlet"
                                    class="btn btn-primary">Join Study Room</a>
                            </div>
                        </div>

                        <!-- Edit Course Form (hidden by default) -->
                        <div id="editCourseSection" class="hidden"
                            style="background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.08); border-radius:16px; padding:24px; margin-bottom:24px;">
                            <h3 style="color:var(--color-text-primary); margin-bottom:16px;">✏️ Edit Course</h3>
                            <form id="editCourseForm" style="display:flex; flex-direction:column; gap:16px;">
                                <div style="display:grid; grid-template-columns:1fr auto; gap:12px;">
                                    <div>
                                        <label
                                            style="font-size:0.8rem; text-transform:uppercase; color:var(--color-text-secondary); display:block; margin-bottom:4px;">Course
                                            Name</label>
                                        <input type="text" id="editCourseName" class="input"
                                            value="${course.courseName}"
                                            style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:10px; padding:10px 14px;">
                                    </div>
                                    <div>
                                        <label
                                            style="font-size:0.8rem; text-transform:uppercase; color:var(--color-text-secondary); display:block; margin-bottom:4px;">Icon</label>
                                        <input type="text" id="editCourseIcon" class="input" value="${course.icon}"
                                            style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:10px; padding:10px 14px; width:50px; text-align:center; font-size:1.3rem;">
                                    </div>
                                </div>
                                <div>
                                    <label
                                        style="font-size:0.8rem; text-transform:uppercase; color:var(--color-text-secondary); display:block; margin-bottom:4px;">Description</label>
                                    <input type="text" id="editCourseDescription" class="input"
                                        value="${course.description}"
                                        style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:10px; padding:10px 14px;">
                                </div>
                                <div>
                                    <label
                                        style="font-size:0.8rem; text-transform:uppercase; color:var(--color-text-secondary); display:block; margin-bottom:4px;">Detail
                                        Description</label>
                                    <textarea id="editCourseDetailDesc" class="input" rows="3"
                                        style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:10px; padding:10px 14px; resize:none;">${course.detailDescription}</textarea>
                                </div>
                                <div style="display:flex; gap:12px; justify-content:flex-end;">
                                    <button type="button"
                                        onclick="document.getElementById('editCourseSection').classList.add('hidden')"
                                        style="padding:8px 20px; border-radius:10px; background:transparent; color:var(--color-text-secondary); border:1px solid rgba(255,255,255,0.1); cursor:pointer;">Cancel</button>
                                    <button type="submit" id="editCourseBtn"
                                        style="padding:8px 24px; border-radius:10px; background:linear-gradient(135deg,#6366f1,#a855f7); color:white; border:none; cursor:pointer; font-weight:600;">Save
                                        Changes</button>
                                </div>
                            </form>
                        </div>

                        <div class="course-detail-content">
                            <div class="course-main">
                                <!-- Roadmap -->
                                <div class="roadmap-section">
                                    <h2 class="section-title">📍 Weekly Roadmap</h2>
                                    <div class="roadmap">
                                        <div class="roadmap-item completed">
                                            <div class="roadmap-marker">✓</div>
                                            <div class="roadmap-content">
                                                <h4>Week 1: Introduction & Fundamentals</h4>
                                                <p>Core concepts and foundational knowledge</p>
                                            </div>
                                        </div>
                                        <div class="roadmap-item current">
                                            <div class="roadmap-marker">2</div>
                                            <div class="roadmap-content">
                                                <h4>Week 2: Core Concepts</h4>
                                                <p>Deep dive into essential topics and techniques</p>
                                            </div>
                                        </div>
                                        <div class="roadmap-item">
                                            <div class="roadmap-marker">3</div>
                                            <div class="roadmap-content">
                                                <h4>Week 3: Advanced Topics</h4>
                                                <p>Complex problem-solving and advanced methods</p>
                                            </div>
                                        </div>
                                        <div class="roadmap-item">
                                            <div class="roadmap-marker">4</div>
                                            <div class="roadmap-content">
                                                <h4>Week 4: Applications</h4>
                                                <p>Real-world applications and practice</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Community Mindmaps (Dynamic) -->
                                <div class="mindmap-section" style="margin-top:var(--spacing-2xl);">
                                    <div
                                        style="display:flex; justify-content:space-between; align-items:center; margin-bottom:var(--spacing-md);">
                                        <h2 class="section-title" style="margin-bottom:0;">🧠 Community Mindmaps</h2>
                                        <c:if test="${not empty sessionScope.user}">
                                            <button class="btn btn-primary btn-sm"
                                                onclick="document.getElementById('createMindmapModal').classList.remove('hidden')">+
                                                Create Mindmap</button>
                                        </c:if>
                                    </div>
                                    <div class="rooms-grid" id="mindmapsGrid"
                                        style="grid-template-columns:repeat(auto-fill,minmax(280px,1fr));">
                                        <div
                                            style="text-align:center; padding:40px; color:var(--color-text-secondary); grid-column:1/-1;">
                                            <div style="font-size:2rem; margin-bottom:8px;">⏳</div>
                                            <p>Loading mindmaps...</p>
                                        </div>
                                    </div>
                                </div>

                                <!-- Q&A Section -->
                                <div class="qa-section">
                                    <h2 class="section-title">💬 Discussion (On-Topic Only)</h2>
                                    <div class="qa-input">
                                        <input type="text" placeholder="Ask a question about this course..."
                                            class="input">
                                        <button class="btn btn-primary">Ask</button>
                                    </div>
                                    <div class="qa-list">
                                        <div class="qa-item">
                                            <div class="qa-avatar">S</div>
                                            <div class="qa-content">
                                                <div class="qa-header">
                                                    <span class="qa-author">Sarah M.</span>
                                                    <span class="qa-time">2 hours ago</span>
                                                </div>
                                                <p class="qa-question">Can someone explain the key concept from Week 2?
                                                </p>
                                                <div class="qa-actions">
                                                    <button class="qa-action">↑ 12</button>
                                                    <button class="qa-action">Reply</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Sidebar: AI Corner -->
                            <div class="course-sidebar">
                                <div class="ai-corner">
                                    <h3 class="ai-title">🤖 AI Study Assistant</h3>
                                    <div class="ai-actions">
                                        <a href="${pageContext.request.contextPath}/ai_chat.jsp" class="ai-btn">
                                            <span class="ai-btn-icon">📝</span><span>Summarize Chapter</span>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/ai_chat.jsp" class="ai-btn">
                                            <span class="ai-btn-icon">❓</span><span>Generate Quiz</span>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/ai_chat.jsp" class="ai-btn">
                                            <span class="ai-btn-icon">💡</span><span>Explain Concept</span>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/ai_chat.jsp" class="ai-btn">
                                            <span class="ai-btn-icon">📅</span><span>Study Schedule</span>
                                        </a>
                                    </div>
                                </div>

                                <!-- Flashcard Decks for this course -->
                                <div class="resources-section" style="margin-top:var(--spacing-lg);">
                                    <h3 class="resources-title">🃏 Flashcard Decks</h3>
                                    <div id="courseFlashcards" style="display:flex; flex-direction:column; gap:8px;">
                                        <p style="color:var(--color-text-secondary); font-size:0.85rem;">Loading...</p>
                                    </div>
                                </div>

                                <div class="resources-section">
                                    <h3 class="resources-title">📎 Resources</h3>
                                    <div class="resources-list">
                                        <a href="#" class="resource-item"><span
                                                class="resource-icon">📄</span><span>Official Syllabus</span></a>
                                        <a href="#" class="resource-item"><span
                                                class="resource-icon">📊</span><span>Lecture Slides</span></a>
                                        <a href="#" class="resource-item"><span
                                                class="resource-icon">📝</span><span>Practice Problems</span></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Create Mindmap Modal -->
                <c:if test="${not empty sessionScope.user}">
                    <div class="modal-overlay hidden" id="createMindmapModal">
                        <div class="modal-overlay-bg"
                            onclick="document.getElementById('createMindmapModal').classList.add('hidden')"></div>
                        <div class="modal-content"
                            style="position:relative; z-index:1; background:#1a1d2d; border-radius:24px; max-width:500px; width:90%; box-shadow:0 25px 50px -12px rgba(0,0,0,0.5); border:1px solid rgba(255,255,255,0.1); overflow:hidden; padding:32px; transform:scale(0.95) translateY(10px); transition:all 0.3s cubic-bezier(0.34,1.56,0.64,1);">
                            <div
                                style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                                <div style="display:flex; align-items:center; gap:10px;">
                                    <div
                                        style="width:40px; height:40px; background:linear-gradient(135deg,#10b981,#06b6d4); border-radius:10px; display:flex; align-items:center; justify-content:center; font-size:1.2rem;">
                                        🧠</div>
                                    <h2
                                        style="font-family:var(--font-display); font-size:1.3rem; font-weight:700; color:white; margin:0;">
                                        Create Mindmap</h2>
                                </div>
                                <button onclick="document.getElementById('createMindmapModal').classList.add('hidden')"
                                    style="background:rgba(255,255,255,0.05); border:none; border-radius:50%; width:30px; height:30px; display:flex; align-items:center; justify-content:center; cursor:pointer; color:var(--color-text-secondary);">✕</button>
                            </div>
                            <form id="createMindmapForm" style="display:flex; flex-direction:column; gap:16px;">
                                <div>
                                    <label
                                        style="font-size:0.8rem; text-transform:uppercase; color:var(--color-text-secondary); display:block; margin-bottom:4px;">Title
                                        <span style="color:#ef4444;">*</span></label>
                                    <input type="text" id="mindmapTitle" class="input"
                                        placeholder="e.g., Chapter 1 Overview" required
                                        style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:10px; padding:10px 14px;">
                                </div>
                                <div>
                                    <label
                                        style="font-size:0.8rem; text-transform:uppercase; color:var(--color-text-secondary); display:block; margin-bottom:4px;">Description</label>
                                    <textarea id="mindmapDesc" class="input" rows="2" placeholder="Brief description..."
                                        style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:10px; padding:10px 14px; resize:none;"></textarea>
                                </div>
                                <label
                                    style="display:flex; align-items:center; gap:8px; color:var(--color-text-secondary); font-size:0.9rem; cursor:pointer;">
                                    <input type="checkbox" id="mindmapPublic" checked> Make public (visible to other
                                    learners)
                                </label>
                                <div
                                    style="display:flex; justify-content:flex-end; gap:10px; padding-top:12px; border-top:1px solid rgba(255,255,255,0.06);">
                                    <button type="button"
                                        onclick="document.getElementById('createMindmapModal').classList.add('hidden')"
                                        style="padding:8px 18px; border-radius:10px; background:transparent; color:var(--color-text-secondary); border:1px solid rgba(255,255,255,0.1); cursor:pointer;">Cancel</button>
                                    <button type="submit" id="createMindmapBtn"
                                        style="padding:8px 24px; border-radius:10px; background:linear-gradient(135deg,#10b981,#06b6d4); color:white; border:none; cursor:pointer; font-weight:600;">Create
                                        🧠</button>
                                </div>
                            </form>
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

                        .hidden {
                            display: none !important;
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
                            animation: toastSlideIn 0.3s ease, toastFadeOut 0.3s ease 2.7s forwards;
                            max-width: 360px;
                        }

                        .toast-success {
                            background: rgba(34, 197, 94, 0.9);
                        }

                        .toast-error {
                            background: rgba(239, 68, 68, 0.9);
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

                        .mindmap-card {
                            background: rgba(255, 255, 255, 0.03);
                            border: 1px solid rgba(255, 255, 255, 0.08);
                            border-radius: 16px;
                            padding: 20px;
                            cursor: pointer;
                            transition: all 0.2s;
                        }

                        .mindmap-card:hover {
                            background: rgba(255, 255, 255, 0.06);
                            border-color: rgba(255, 255, 255, 0.12);
                            transform: translateY(-2px);
                        }

                        .mindmap-delete {
                            position: absolute;
                            top: 10px;
                            right: 10px;
                            background: rgba(239, 68, 68, 0.15);
                            border: none;
                            border-radius: 50%;
                            width: 26px;
                            height: 26px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            cursor: pointer;
                            color: #f87171;
                            font-size: 0.8rem;
                            opacity: 0;
                            transition: all 0.2s;
                        }

                        .mindmap-card:hover .mindmap-delete {
                            opacity: 1;
                        }
                    </style>

                    <script>
                        var ctx = '${pageContext.request.contextPath}';
                        var courseId = ${ course.courseID };

                        function showToast(msg, type) {
                            var c = document.getElementById('toastContainer');
                            if (!c) return;
                            var t = document.createElement('div');
                            t.className = 'toast toast-' + (type || 'info');
                            t.textContent = msg;
                            c.appendChild(t);
                            setTimeout(function () { t.remove(); }, 3000);
                        }

                        // Load mindmaps for this course
                        function loadMindmaps() {
                            fetch(ctx + '/CourseServlet?action=detail&id=' + courseId)
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    var grid = document.getElementById('mindmapsGrid');
                                    var mindmaps = data.mindmaps || [];
                                    if (mindmaps.length === 0) {
                                        grid.innerHTML = '<div style="text-align:center; padding:40px; color:var(--color-text-secondary); grid-column:1/-1;"><div style="font-size:2rem; margin-bottom:8px;">🧠</div><p>No mindmaps yet. Be the first to create one!</p></div>';
                                        return;
                                    }
                                    var html = '';
                                    mindmaps.forEach(function (m) {
                                        html += '<div class="mindmap-card" style="position:relative;">'
                                            + '<button class="mindmap-delete" onclick="deleteMindmap(' + m.mindmapID + ', event)" title="Delete">🗑</button>'
                                            + '<div style="display:flex; align-items:center; gap:8px; margin-bottom:8px;">'
                                            + '<span style="font-size:1.2rem;">🧠</span>'
                                            + '<span style="font-size:0.75rem; padding:2px 8px; border-radius:10px; background:rgba(16,185,129,0.15); color:#34d399;">' + (m.isPublic ? '🌟 Public' : '🔒 Private') + '</span>'
                                            + '</div>'
                                            + '<h3 style="color:var(--color-text-primary); font-size:1rem; margin-bottom:4px;">' + m.title + '</h3>'
                                            + '<p style="color:var(--color-text-secondary); font-size:0.85rem; margin-bottom:8px;">' + (m.description || '') + '</p>'
                                            + '<div style="font-size:0.8rem; color:var(--color-text-muted);">Used ' + (m.useCount || 0) + ' times</div>'
                                            + '</div>';
                                    });
                                    grid.innerHTML = html;
                                })
                                .catch(function () {
                                    document.getElementById('mindmapsGrid').innerHTML = '<div style="text-align:center; padding:40px; color:var(--color-text-secondary); grid-column:1/-1;"><p>Failed to load mindmaps</p></div>';
                                });
                        }

                        // Create mindmap
                        var mmForm = document.getElementById('createMindmapForm');
                        if (mmForm) {
                            mmForm.addEventListener('submit', function (e) {
                                e.preventDefault();
                                var btn = document.getElementById('createMindmapBtn');
                                btn.disabled = true;
                                btn.textContent = 'Creating...';

                                var params = 'action=create'
                                    + '&title=' + encodeURIComponent(document.getElementById('mindmapTitle').value)
                                    + '&description=' + encodeURIComponent(document.getElementById('mindmapDesc').value)
                                    + '&courseId=' + courseId
                                    + '&isPublic=' + document.getElementById('mindmapPublic').checked;

                                fetch(ctx + '/MindmapServlet', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                    body: params
                                })
                                    .then(function (r) { return r.json(); })
                                    .then(function (data) {
                                        if (data.success) {
                                            showToast('Mindmap created!', 'success');
                                            document.getElementById('createMindmapModal').classList.add('hidden');
                                            mmForm.reset();
                                            document.getElementById('mindmapPublic').checked = true;
                                            loadMindmaps();
                                        } else {
                                            showToast(data.error || 'Failed', 'error');
                                        }
                                        btn.disabled = false;
                                        btn.textContent = 'Create 🧠';
                                    })
                                    .catch(function () {
                                        showToast('Network error', 'error');
                                        btn.disabled = false;
                                        btn.textContent = 'Create 🧠';
                                    });
                            });
                        }

                        // Delete mindmap
                        function deleteMindmap(mindmapId, event) {
                            if (event) event.stopPropagation();
                            if (!confirm('Delete this mindmap?')) return;
                            fetch(ctx + '/MindmapServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: 'action=delete&mindmapId=' + mindmapId
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) { showToast('Mindmap deleted!', 'success'); loadMindmaps(); }
                                    else showToast(data.error || 'Failed', 'error');
                                })
                                .catch(function () { showToast('Network error', 'error'); });
                        }

                        // Edit course
                        function showEditCourse() {
                            document.getElementById('editCourseSection').classList.toggle('hidden');
                        }

                        var editForm = document.getElementById('editCourseForm');
                        if (editForm) {
                            editForm.addEventListener('submit', function (e) {
                                e.preventDefault();
                                var btn = document.getElementById('editCourseBtn');
                                btn.disabled = true;
                                btn.textContent = 'Saving...';

                                var params = 'action=update&courseId=' + courseId
                                    + '&courseName=' + encodeURIComponent(document.getElementById('editCourseName').value)
                                    + '&icon=' + encodeURIComponent(document.getElementById('editCourseIcon').value)
                                    + '&description=' + encodeURIComponent(document.getElementById('editCourseDescription').value)
                                    + '&detailDescription=' + encodeURIComponent(document.getElementById('editCourseDetailDesc').value);

                                fetch(ctx + '/CourseServlet', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                    body: params
                                })
                                    .then(function (r) { return r.json(); })
                                    .then(function (data) {
                                        if (data.success) {
                                            showToast('Course updated!', 'success');
                                            document.getElementById('courseTitle').textContent = document.getElementById('editCourseName').value;
                                            document.getElementById('courseDetailDesc').textContent = document.getElementById('editCourseDetailDesc').value;
                                            document.getElementById('editCourseSection').classList.add('hidden');
                                        } else {
                                            showToast(data.error || 'Update failed', 'error');
                                        }
                                        btn.disabled = false;
                                        btn.textContent = 'Save Changes';
                                    })
                                    .catch(function () {
                                        showToast('Network error', 'error');
                                        btn.disabled = false;
                                        btn.textContent = 'Save Changes';
                                    });
                            });
                        }

                        // Delete course
                        function deleteCourseDetail() {
                            if (!confirm('Are you sure you want to delete this entire course? This action cannot be undone.')) return;
                            fetch(ctx + '/CourseServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: 'action=delete&courseId=' + courseId
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        showToast('Course deleted!', 'success');
                                        setTimeout(function () { window.location.href = ctx + '/CourseServlet'; }, 800);
                                    } else showToast(data.error || 'Delete failed', 'error');
                                })
                                .catch(function () { showToast('Network error', 'error'); });
                        }

                        // Init
                        loadMindmaps();
                    </script>
        </body>

        </html>