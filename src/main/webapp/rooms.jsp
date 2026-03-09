<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <%@ include file="common/header.jsp" %>
                <title>Study Rooms - FocusFund</title>
        </head>

        <body>
            <div class="background-effects">
                <div class="stars" id="stars"></div>
                <div class="shooting-stars" id="shooting-stars"></div>
                <div class="rain" id="rain"></div>
            </div>

            <%@ include file="common/navbar.jsp" %>

                <section class="page active" id="page-rooms">
                    <div class="page-container">
                        <div class="page-header">
                            <h1 class="page-title">Study Rooms</h1>
                            <p class="page-subtitle">Join a focused study session or create your own room</p>
                        </div>

                        <div class="rooms-filters">
                            <a href="${pageContext.request.contextPath}/StudyRoomServlet"
                                class="filter-btn ${empty param.type || param.type == 'all' ? 'active' : ''}">All
                                Rooms</a>
                            <a href="${pageContext.request.contextPath}/StudyRoomServlet?type=private"
                                class="filter-btn ${param.type == 'private' ? 'active' : ''}">Private</a>
                            <a href="${pageContext.request.contextPath}/StudyRoomServlet?type=silent"
                                class="filter-btn ${param.type == 'silent' ? 'active' : ''}">Silent</a>
                            <a href="${pageContext.request.contextPath}/StudyRoomServlet?type=public"
                                class="filter-btn ${param.type == 'public' ? 'active' : ''}">Public</a>
                        </div>

                        <!-- Error message -->
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-error"
                                style="background: rgba(239,68,68,0.15); border: 1px solid rgba(239,68,68,0.3); border-radius: var(--radius-lg); padding: var(--spacing-md); margin-bottom: var(--spacing-lg); color: #f87171;">
                                ⚠️ ${errorMessage}
                            </div>
                        </c:if>

                        <div class="rooms-grid" id="roomsGrid">
                            <c:forEach var="room" items="${rooms}">
                                <div class="room-card" data-room-id="${room.roomID}">
                                    <div class="room-card-header">
                                        <span class="room-type-badge ${room.roomType}">${room.roomTypeBadge}</span>
                                        <span class="room-status-badge status-${room.status}">${room.statusBadge}</span>
                                    </div>
                                    <h3 class="room-card-title">${room.roomName}</h3>
                                    <p class="room-card-desc">${room.description}</p>
                                    <div class="room-card-meta">
                                        <div class="room-card-timer">
                                            <span class="timer-icon">⏱</span>
                                            <span>${room.pomodoroLabel}</span>
                                        </div>
                                        <div class="room-card-host">
                                            <span class="host-icon">👑</span>
                                            <span>${room.hostName}</span>
                                        </div>
                                    </div>
                                    <div class="room-card-footer">
                                        <div class="room-card-members">
                                            <span
                                                class="members-count">${room.currentParticipants}/${room.maxParticipants}</span>
                                            <span class="members-label">members</span>
                                        </div>
                                        <c:choose>
                                            <c:when test="${room.status == 'FULL'}">
                                                <button class="btn btn-secondary btn-sm" disabled>Room Full</button>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn btn-primary btn-sm"
                                                    onclick="joinRoom(${room.roomID}, event)">Join Room</button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>

                            <c:if test="${not empty sessionScope.user}">
                                <div class="room-card create-room"
                                    onclick="document.getElementById('createRoomModal').classList.remove('hidden')">
                                    <div class="create-room-icon">+</div>
                                    <h3 class="room-card-title">Create New Room</h3>
                                    <p class="room-card-desc">Start your own study session</p>
                                </div>
                            </c:if>
                        </div>

                        <c:if test="${empty rooms}">
                            <div class="empty-state"
                                style="text-align: center; padding: 60px 20px; color: var(--color-text-secondary);">
                                <div style="font-size: 48px; margin-bottom: 16px;">📚</div>
                                <h3 style="color: var(--color-text-primary); margin-bottom: 8px;">No rooms available
                                </h3>
                                <p>Be the first to create a study room!</p>
                            </div>
                        </c:if>
                    </div>
                </section>

                <!-- Create Room Modal -->
                <c:if test="${not empty sessionScope.user}">
                    <div class="modal-overlay hidden" id="createRoomModal">
                        <div class="modal-overlay-bg"
                            onclick="document.getElementById('createRoomModal').classList.add('hidden')"></div>
                        <div class="modal-content create-room-modal"
                            style="max-width: 850px; padding: 0; overflow: hidden; display: flex; background: #1a1d2d; border-radius: 24px; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);">
                            <!-- Left Sidebar (Hero/Info) -->
                            <div
                                style="flex: 0 0 35%; background: linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(168, 85, 247, 0.1) 100%); border-right: 1px solid rgba(255,255,255,0.05); padding: 40px 30px; display: flex; flex-direction: column; justify-content: space-between;">
                                <div>
                                    <div
                                        style="width: 50px; height: 50px; background: linear-gradient(135deg, #6366f1, #a855f7); border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin-bottom: 24px; box-shadow: 0 8px 16px rgba(99, 102, 241, 0.2);">
                                        🚀</div>
                                    <h2
                                        style="font-family: var(--font-display); font-size: 2rem; font-weight: 700; color: white; margin-bottom: 12px; line-height: 1.2;">
                                        Create your<br>Study Space</h2>
                                    <p
                                        style="color: var(--color-text-secondary); font-size: 0.95rem; line-height: 1.5;">
                                        Configure your perfect environment for deep work and collaboration.</p>
                                </div>
                                <div
                                    style="background: rgba(0,0,0,0.2); padding: 20px; border-radius: 16px; border: 1px solid rgba(255,255,255,0.05);">
                                    <h4 style="color: white; font-size: 0.9rem; margin-bottom: 8px;">💡 Pro Tip</h4>
                                    <p
                                        style="color: var(--color-text-secondary); font-size: 0.85rem; line-height: 1.4; margin: 0;">
                                        Use the <strong style="color: #a855f7;">Silent</strong> room type if you want
                                        absolute zero distractions. Chat will be completely disabled.</p>
                                </div>
                            </div>

                            <!-- Right Content (Form) -->
                            <div style="flex: 1; padding: 40px; display: flex; flex-direction: column;">
                                <div style="display: flex; justify-content: flex-end; margin-bottom: 20px;">
                                    <button class="modal-close"
                                        onclick="document.getElementById('createRoomModal').classList.add('hidden')"
                                        style="background: rgba(255,255,255,0.05); border-radius: 50%; padding: 8px; border: none; cursor: pointer; color: var(--color-text-secondary); transition: all 0.2s;">
                                        <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor"
                                            stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                            <line x1="18" y1="6" x2="6" y2="18"></line>
                                            <line x1="6" y1="6" x2="18" y2="18"></line>
                                        </svg>
                                    </button>
                                </div>

                                <form id="createRoomForm" class="create-room-form"
                                    style="flex: 1; display: flex; flex-direction: column; gap: 24px;">
                                    <div class="form-row-split"
                                        style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                                        <div class="form-group" style="margin: 0;">
                                            <label for="roomName"
                                                style="font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px; display: block; color: var(--color-text-secondary);">Room
                                                Name <span class="required">*</span></label>
                                            <input type="text" id="roomName" name="roomName" class="input"
                                                placeholder="e.g., Deep Focus Zone" required minlength="3"
                                                maxlength="50"
                                                style="background: rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 14px 16px;">
                                        </div>
                                        <div class="form-group" style="margin: 0;">
                                            <label for="maxParticipants"
                                                style="font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px; display: block; color: var(--color-text-secondary);">Capacity</label>
                                            <div class="capacity-input-wrapper" style="position: relative;">
                                                <span class="capacity-icon"
                                                    style="position: absolute; left: 16px; top: 50%; transform: translateY(-50%); color: var(--color-text-secondary);">👥</span>
                                                <input type="number" id="maxParticipants" name="maxParticipants"
                                                    class="input with-icon" value="15" min="2" max="50"
                                                    style="background: rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 14px 16px 14px 44px; width: 100%;">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group" style="margin: 0;">
                                        <label for="roomDescription"
                                            style="font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px; display: block; color: var(--color-text-secondary);">Description</label>
                                        <textarea id="roomDescription" name="description" class="input textarea"
                                            rows="2" placeholder="What will you be studying?"
                                            style="background: rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 14px 16px; resize: none;"></textarea>
                                    </div>

                                    <div class="form-group" style="margin: 0;">
                                        <label
                                            style="font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 12px; display: block; color: var(--color-text-secondary);">Room
                                            Environment</label>
                                        <div class="room-type-grid"
                                            style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px;">
                                            <label class="room-type-card silent-type"
                                                style="margin:0; position:relative; cursor:pointer;">
                                                <input type="radio" name="roomType" value="silent" checked
                                                    style="position:absolute; opacity:0;">
                                                <div class="room-type-content"
                                                    style="border: 2px solid rgba(255,255,255,0.05); border-radius: 16px; padding: 16px 12px; text-align: center; background: rgba(255,255,255,0.02); transition: all 0.2s; height: 100%; display: flex; flex-direction: column; align-items: center; gap: 8px;">
                                                    <div class="type-icon-wrapper"
                                                        style="width: 36px; height: 36px; border-radius: 50%; background: rgba(255,255,255,0.05); display: flex; align-items: center; justify-content: center; font-size: 1.1rem; transition: all 0.2s;">
                                                        <span class="room-type-icon">🤫</span></div>
                                                    <div>
                                                        <div class="room-type-name"
                                                            style="font-weight: 600; font-size: 0.9rem; color: white;">
                                                            Silent</div>
                                                        <div class="room-type-desc"
                                                            style="font-size: 0.75rem; color: var(--color-text-secondary); margin-top: 4px;">
                                                            No chat</div>
                                                    </div>
                                                </div>
                                            </label>
                                            <label class="room-type-card public-type"
                                                style="margin:0; position:relative; cursor:pointer;">
                                                <input type="radio" name="roomType" value="public"
                                                    style="position:absolute; opacity:0;">
                                                <div class="room-type-content"
                                                    style="border: 2px solid rgba(255,255,255,0.05); border-radius: 16px; padding: 16px 12px; text-align: center; background: rgba(255,255,255,0.02); transition: all 0.2s; height: 100%; display: flex; flex-direction: column; align-items: center; gap: 8px;">
                                                    <div class="type-icon-wrapper"
                                                        style="width: 36px; height: 36px; border-radius: 50%; background: rgba(255,255,255,0.05); display: flex; align-items: center; justify-content: center; font-size: 1.1rem; transition: all 0.2s;">
                                                        <span class="room-type-icon">👥</span></div>
                                                    <div>
                                                        <div class="room-type-name"
                                                            style="font-weight: 600; font-size: 0.9rem; color: white;">
                                                            Public</div>
                                                        <div class="room-type-desc"
                                                            style="font-size: 0.75rem; color: var(--color-text-secondary); margin-top: 4px;">
                                                            Chat open</div>
                                                    </div>
                                                </div>
                                            </label>
                                            <label class="room-type-card private-type"
                                                style="margin:0; position:relative; cursor:pointer;">
                                                <input type="radio" name="roomType" value="private"
                                                    style="position:absolute; opacity:0;">
                                                <div class="room-type-content"
                                                    style="border: 2px solid rgba(255,255,255,0.05); border-radius: 16px; padding: 16px 12px; text-align: center; background: rgba(255,255,255,0.02); transition: all 0.2s; height: 100%; display: flex; flex-direction: column; align-items: center; gap: 8px;">
                                                    <div class="type-icon-wrapper"
                                                        style="width: 36px; height: 36px; border-radius: 50%; background: rgba(255,255,255,0.05); display: flex; align-items: center; justify-content: center; font-size: 1.1rem; transition: all 0.2s;">
                                                        <span class="room-type-icon">🔒</span></div>
                                                    <div>
                                                        <div class="room-type-name"
                                                            style="font-weight: 600; font-size: 0.9rem; color: white;">
                                                            Private</div>
                                                        <div class="room-type-desc"
                                                            style="font-size: 0.75rem; color: var(--color-text-secondary); margin-top: 4px;">
                                                            Invite only</div>
                                                    </div>
                                                </div>
                                            </label>
                                        </div>
                                    </div>

                                    <div class="form-group" style="margin: 0;">
                                        <label
                                            style="font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px; display: block; color: var(--color-text-secondary);">Pomodoro
                                            Timer</label>
                                        <div class="pomo-setting-select-wrapper" style="position: relative;">
                                            <select name="pomodoro" class="input select-input"
                                                style="background: rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 14px 16px; width: 100%; appearance: none; color: white; cursor: pointer;">
                                                <option value="25-5" selected style="background: #1a1d2d;">⏱ 25/5
                                                    Classic (25m Focus, 5m Break)</option>
                                                <option value="50-10" style="background: #1a1d2d;">⏱ 50/10 Extended (50m
                                                    Focus, 10m Break)</option>
                                                <option value="90-20" style="background: #1a1d2d;">⏱ 90/20 Deep Work
                                                    (90m Focus, 20m Break)</option>
                                            </select>
                                            <div
                                                style="position: absolute; right: 16px; top: 50%; transform: translateY(-50%); pointer-events: none; color: var(--color-text-secondary);">
                                                ▼</div>
                                        </div>
                                    </div>

                                    <div id="createRoomError" class="form-error hidden"
                                        style="color: #ef4444; font-size: 0.9rem; background: rgba(239, 68, 68, 0.1); padding: 12px; border-radius: 8px;">
                                    </div>

                                    <div class="modal-footer"
                                        style="margin-top: auto; padding-top: 24px; display: flex; justify-content: flex-end; gap: 12px; border-top: 1px solid rgba(255,255,255,0.05);">
                                        <button type="button" class="btn btn-ghost"
                                            onclick="document.getElementById('createRoomModal').classList.add('hidden')"
                                            style="padding: 12px 24px; border-radius: 12px; background: transparent; color: var(--color-text-secondary); border: 1px solid rgba(255,255,255,0.1); font-weight: 600; cursor: pointer; transition: all 0.2s;">Cancel</button>
                                        <button type="submit" class="btn btn-primary" id="createRoomBtn"
                                            style="padding: 12px 32px; border-radius: 12px; background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%); color: white; border: none; font-weight: 600; cursor: pointer; box-shadow: 0 4px 15px rgba(99, 102, 241, 0.3); transition: all 0.2s;">Launch
                                            Room 🚀</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- Toast notification -->
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

                        .modal-overlay-bg {
                            position: absolute;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            background: rgba(0, 0, 0, 0.6);
                            backdrop-filter: blur(8px);
                        }

                        .create-room-modal {
                            position: relative;
                            z-index: 1;
                            background: var(--color-surface);
                            border-radius: var(--radius-2xl);
                            padding: 0;
                            max-width: 550px;
                            width: 90%;
                            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
                            border: 1px solid rgba(255, 255, 255, 0.1);
                            overflow: hidden;
                            transform: scale(0.95) translateY(10px);
                            transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
                        }

                        .modal-overlay:not(.hidden) .create-room-modal {
                            transform: scale(1) translateY(0);
                        }

                        .modal-header {
                            padding: 24px 32px;
                            border-bottom: 1px solid rgba(255, 255, 255, 0.06);
                            display: flex;
                            justify-content: space-between;
                            align-items: flex-start;
                            background: rgba(255, 255, 255, 0.02);
                        }

                        .modal-title-wrapper {
                            display: flex;
                            align-items: center;
                            gap: 16px;
                        }

                        .modal-icon-bg {
                            width: 48px;
                            height: 48px;
                            border-radius: 12px;
                            background: linear-gradient(135deg, rgba(59, 130, 246, 0.2), rgba(147, 51, 234, 0.2));
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 1.5rem;
                            box-shadow: inset 0 0 10px rgba(255, 255, 255, 0.05);
                            border: 1px solid rgba(255, 255, 255, 0.1);
                        }

                        .modal-header h2 {
                            font-family: var(--font-display);
                            font-size: 1.5rem;
                            font-weight: 700;
                            margin: 0 0 4px 0;
                        }

                        .modal-subtitle {
                            font-size: 0.9rem;
                            color: var(--color-text-secondary);
                            margin: 0;
                        }

                        .modal-close {
                            background: rgba(255, 255, 255, 0.05);
                            border: none;
                            color: var(--color-text-secondary);
                            width: 32px;
                            height: 32px;
                            border-radius: 50%;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            cursor: pointer;
                            transition: all 0.2s;
                        }

                        .modal-close:hover {
                            background: rgba(239, 68, 68, 0.15);
                            color: #ef4444;
                            transform: rotate(90deg);
                        }

                        .create-room-form {
                            padding: 32px;
                            display: flex;
                            flex-direction: column;
                            gap: 24px;
                        }

                        .form-section {
                            display: flex;
                            flex-direction: column;
                            gap: 16px;
                        }

                        .form-group label {
                            display: block;
                            font-size: 0.85rem;
                            font-weight: 600;
                            color: var(--color-text-secondary);
                            margin-bottom: 8px;
                            text-transform: uppercase;
                            letter-spacing: 0.5px;
                        }

                        .required {
                            color: #ef4444;
                        }

                        .input {
                            width: 100%;
                            background: rgba(0, 0, 0, 0.2);
                            border: 1px solid rgba(255, 255, 255, 0.1);
                            border-radius: var(--radius-md);
                            padding: 12px 16px;
                            color: var(--color-text-primary);
                            font-family: var(--font-primary);
                            font-size: 0.95rem;
                            transition: all 0.2s;
                            box-sizing: border-box;
                        }

                        .input:focus {
                            outline: none;
                            border-color: var(--color-accent-primary);
                            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
                            background: rgba(0, 0, 0, 0.3);
                        }

                        .room-type-grid {
                            display: grid;
                            grid-template-columns: repeat(3, 1fr);
                            gap: 12px;
                        }

                        .room-type-card {
                            position: relative;
                            cursor: pointer;
                        }

                        .room-type-card input {
                            position: absolute;
                            opacity: 0;
                        }

                        .room-type-content {
                            border: 2px solid rgba(255, 255, 255, 0.05);
                            border-radius: var(--radius-lg);
                            padding: 16px 12px;
                            text-align: center;
                            background: rgba(255, 255, 255, 0.02);
                            transition: all 0.2s;
                            height: 100%;
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                            gap: 12px;
                        }

                        .room-type-card:hover .room-type-content {
                            background: rgba(255, 255, 255, 0.05);
                            border-color: rgba(255, 255, 255, 0.1);
                            transform: translateY(-2px);
                        }

                        .room-type-card input:checked+.room-type-content {
                            border-color: var(--color-accent-primary);
                            background: rgba(59, 130, 246, 0.08);
                            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.15);
                        }

                        .silent-type input:checked+.room-type-content {
                            border-color: #a855f7;
                            background: rgba(168, 85, 247, 0.08);
                        }

                        .public-type input:checked+.room-type-content {
                            border-color: #3b82f6;
                            background: rgba(59, 130, 246, 0.08);
                        }

                        .private-type input:checked+.room-type-content {
                            border-color: #f59e0b;
                            background: rgba(245, 158, 11, 0.08);
                        }

                        .type-icon-wrapper {
                            width: 40px;
                            height: 40px;
                            border-radius: 50%;
                            background: rgba(255, 255, 255, 0.05);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 1.2rem;
                            transition: all 0.2s;
                        }

                        .room-type-card input:checked+.room-type-content .type-icon-wrapper {
                            transform: scale(1.1);
                        }

                        .type-text {
                            display: flex;
                            flex-direction: column;
                            gap: 4px;
                        }

                        .room-type-name {
                            font-weight: 600;
                            font-size: 0.95rem;
                            color: var(--color-text-primary);
                        }

                        .room-type-desc {
                            font-size: 0.75rem;
                            color: var(--color-text-muted);
                            line-height: 1.2;
                        }

                        .form-row-split {
                            display: grid;
                            grid-template-columns: 2fr 1fr;
                            gap: 16px;
                        }

                        .select-input {
                            appearance: none;
                            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
                            background-repeat: no-repeat;
                            background-position: right 12px center;
                            background-size: 16px;
                            padding-right: 40px;
                            cursor: pointer;
                        }

                        .select-input option {
                            background: var(--color-surface);
                            color: var(--color-text-primary);
                        }

                        .capacity-input-wrapper {
                            position: relative;
                        }

                        .capacity-icon {
                            position: absolute;
                            left: 12px;
                            top: 50%;
                            transform: translateY(-50%);
                            color: var(--color-text-muted);
                        }

                        .input.with-icon {
                            padding-left: 36px;
                        }

                        .modal-footer {
                            display: flex;
                            justify-content: flex-end;
                            gap: 12px;
                            margin-top: 8px;
                            padding-top: 24px;
                            border-top: 1px solid rgba(255, 255, 255, 0.06);
                        }

                        .btn-ghost {
                            background: transparent;
                            color: var(--color-text-secondary);
                            border: 1px solid transparent;
                            padding: 10px 20px;
                            border-radius: var(--radius-md);
                            font-weight: 500;
                            cursor: pointer;
                            transition: all 0.2s;
                        }

                        .btn-ghost:hover {
                            background: rgba(255, 255, 255, 0.05);
                            color: var(--color-text-primary);
                        }

                        .modal-footer .btn-primary {
                            padding: 10px 24px;
                        }

                        .room-card-meta {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin: 12px 0;
                            font-size: 0.85rem;
                            color: var(--color-text-secondary);
                        }

                        .room-card-host {
                            display: flex;
                            align-items: center;
                            gap: 4px;
                        }

                        .room-card-footer {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-top: auto;
                            padding-top: 12px;
                            border-top: 1px solid rgba(255, 255, 255, 0.06);
                        }

                        .members-count {
                            font-weight: 600;
                            color: var(--color-text-primary);
                        }

                        .members-label {
                            font-size: 0.8rem;
                            color: var(--color-text-secondary);
                            margin-left: 4px;
                        }

                        .room-status-badge {
                            font-size: 0.75rem;
                            padding: 2px 8px;
                            border-radius: 12px;
                            font-weight: 500;
                        }

                        .status-OPEN {
                            background: rgba(34, 197, 94, 0.15);
                            color: #4ade80;
                        }

                        .status-FULL {
                            background: rgba(234, 179, 8, 0.15);
                            color: #facc15;
                        }

                        .btn-sm {
                            padding: 6px 16px;
                            font-size: 0.85rem;
                        }

                        .input-hint {
                            display: block;
                            font-size: 0.75rem;
                            color: var(--color-text-secondary);
                            margin-top: 4px;
                        }

                        .form-error {
                            background: rgba(239, 68, 68, 0.15);
                            border: 1px solid rgba(239, 68, 68, 0.3);
                            border-radius: var(--radius-md);
                            padding: 8px 12px;
                            margin-bottom: 12px;
                            color: #f87171;
                            font-size: 0.85rem;
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
                            border-radius: var(--radius-lg);
                            color: #fff;
                            font-size: 0.9rem;
                            font-weight: 500;
                            box-shadow: var(--shadow-lg);
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
                    </style>

                    <script>
                        var contextPath = '${pageContext.request.contextPath}';

                        function showToast(message, type) {
                            var container = document.getElementById('toastContainer');
                            var toast = document.createElement('div');
                            toast.className = 'toast toast-' + (type || 'info');
                            toast.textContent = message;
                            container.appendChild(toast);
                            setTimeout(function () { toast.remove(); }, 3000);
                        }

                        function joinRoom(roomId, event) {
                            if (event) event.stopPropagation();
                            var btn = event ? event.target : null;
                            if (btn) { btn.disabled = true; btn.textContent = 'Joining...'; }

                            fetch(contextPath + '/StudyRoomServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: 'action=join&roomId=' + roomId
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        showToast(data.message, 'success');
                                        window.location.href = contextPath + '/StudyRoomServlet?action=detail&id=' + roomId;
                                    } else {
                                        showToast(data.message, 'error');
                                        if (btn) { btn.disabled = false; btn.textContent = 'Join Room'; }
                                    }
                                })
                                .catch(function () {
                                    showToast('Network error. Please try again.', 'error');
                                    if (btn) { btn.disabled = false; btn.textContent = 'Join Room'; }
                                });
                        }

                        // Create room form
                        var createForm = document.getElementById('createRoomForm');
                        if (createForm) {
                            createForm.addEventListener('submit', function (e) {
                                e.preventDefault();
                                var errorDiv = document.getElementById('createRoomError');
                                var btn = document.getElementById('createRoomBtn');
                                errorDiv.classList.add('hidden');
                                btn.disabled = true;
                                btn.textContent = 'Creating...';

                                var formData = new FormData(createForm);
                                formData.append('action', 'create');
                                var body = new URLSearchParams(formData).toString();

                                fetch(contextPath + '/StudyRoomServlet', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                    body: body
                                })
                                    .then(function (r) { return r.json(); })
                                    .then(function (data) {
                                        if (data.success) {
                                            showToast(data.message, 'success');
                                            window.location.href = contextPath + '/StudyRoomServlet?action=detail&id=' + data.roomID;
                                        } else {
                                            errorDiv.textContent = data.message;
                                            errorDiv.classList.remove('hidden');
                                            btn.disabled = false;
                                            btn.textContent = 'Create Room';
                                        }
                                    })
                                    .catch(function () {
                                        errorDiv.textContent = 'Network error.';
                                        errorDiv.classList.remove('hidden');
                                        btn.disabled = false;
                                        btn.textContent = 'Create Room';
                                    });
                            });
                        }

                        // Auto-refresh lobby every 5 seconds
                        setInterval(function () {
                            var type = new URLSearchParams(window.location.search).get('type') || 'all';
                            fetch(contextPath + '/StudyRoomServlet?action=lobbyData&type=' + type, {
                                headers: { 'X-Requested-With': 'XMLHttpRequest' }
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        updateLobbyGrid(data.rooms);
                                    }
                                })
                                .catch(function () { });
                        }, 5000);

                        function updateLobbyGrid(rooms) {
                            var grid = document.getElementById('roomsGrid');
                            if (!grid) return;

                            // Keep the "Create New Room" card
                            var createCard = grid.querySelector('.create-room');
                            var createCardHtml = createCard ? createCard.outerHTML : '';

                            var html = '';
                            for (var i = 0; i < rooms.length; i++) {
                                var r = rooms[i];
                                var joinBtn = r.status === 'FULL'
                                    ? '<button class="btn btn-secondary btn-sm" disabled>Room Full</button>'
                                    : '<button class="btn btn-primary btn-sm" onclick="joinRoom(' + r.roomID + ', event)">Join Room</button>';

                                html += '<div class="room-card" data-room-id="' + r.roomID + '">'
                                    + '<div class="room-card-header">'
                                    + '<span class="room-type-badge ' + r.roomType + '">' + r.roomTypeBadge + '</span>'
                                    + '<span class="room-status-badge status-' + r.status + '">' + r.statusBadge + '</span>'
                                    + '</div>'
                                    + '<h3 class="room-card-title">' + escapeHtml(r.roomName) + '</h3>'
                                    + '<p class="room-card-desc">' + escapeHtml(r.description || '') + '</p>'
                                    + '<div class="room-card-meta">'
                                    + '<div class="room-card-timer"><span class="timer-icon">⏱</span><span>' + r.pomodoroLabel + '</span></div>'
                                    + '<div class="room-card-host"><span class="host-icon">👑</span><span>' + escapeHtml(r.hostName || '') + '</span></div>'
                                    + '</div>'
                                    + '<div class="room-card-footer">'
                                    + '<div class="room-card-members"><span class="members-count">' + r.currentParticipants + '/' + r.maxParticipants + '</span><span class="members-label">members</span></div>'
                                    + joinBtn
                                    + '</div></div>';
                            }
                            html += createCardHtml;
                            grid.innerHTML = html;
                        }

                        function escapeHtml(str) {
                            if (!str) return '';
                            var div = document.createElement('div');
                            div.appendChild(document.createTextNode(str));
                            return div.innerHTML;
                        }
                    </script>
        </body>

        </html>