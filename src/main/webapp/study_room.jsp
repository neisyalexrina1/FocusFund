<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <%@ include file="common/header.jsp" %>
                <title>${room.roomName} - Study Room - FocusFund</title>
        </head>

        <body>
            <div class="background-effects">
                <div class="stars" id="stars"></div>
                <div class="shooting-stars" id="shooting-stars"></div>
                <div class="rain" id="rain"></div>
            </div>

            <%@ include file="common/navbar.jsp" %>

                <section class="page active" id="page-active-room">
                    <div class="active-room-container">
                        <div class="room-main">
                            <div class="active-room-header">
                                <div class="room-info-header">
                                    <h2 class="active-room-title">${room.roomName}</h2>
                                    <div class="room-badges">
                                        <span class="room-type-badge ${room.roomType}">${room.roomTypeBadge}</span>
                                        <span class="room-status-badge status-${room.status}"
                                            id="roomStatusBadge">${room.statusBadge}</span>
                                    </div>
                                </div>
                                <div class="room-actions">
                                    <c:if test="${not empty currentMember && currentMember.host}">
                                        <button class="btn btn-danger btn-sm" onclick="deleteRoom(${room.roomID})"
                                            title="Delete Room">
                                            🗑️ Delete Room
                                        </button>
                                    </c:if>
                                    <c:choose>
                                        <c:when test="${not empty currentMember}">
                                            <c:if test="${currentMember.host}">
                                                <button class="btn btn-ghost" onclick="toggleSettings()">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2">
                                                        <circle cx="12" cy="12" r="3" />
                                                        <path
                                                            d="M19.4 15a1.65 1.65 0 00.33 1.82l.06.06a2 2 0 010 2.83 2 2 0 01-2.83 0l-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V21a2 2 0 01-2 2 2 2 0 01-2-2v-.09A1.65 1.65 0 009 19.4a1.65 1.65 0 00-1.82.33l-.06.06a2 2 0 01-2.83 0 2 2 0 010-2.83l.06-.06a1.65 1.65 0 00.33-1.82 1.65 1.65 0 00-1.51-1H3a2 2 0 01-2-2 2 2 0 012-2h.09A1.65 1.65 0 004.6 9a1.65 1.65 0 00-.33-1.82l-.06-.06a2 2 0 010-2.83 2 2 0 012.83 0l.06.06a1.65 1.65 0 001.82.33H9a1.65 1.65 0 001-1.51V3a2 2 0 012-2 2 2 0 012 2v.09a1.65 1.65 0 001 1.51 1.65 1.65 0 001.82-.33l.06-.06a2 2 0 012.83 0 2 2 0 010 2.83l-.06.06a1.65 1.65 0 00-.33 1.82V9a1.65 1.65 0 001.51 1H21a2 2 0 012 2 2 2 0 01-2 2h-.09a1.65 1.65 0 00-1.51 1z" />
                                                    </svg>
                                                    Settings
                                                </button>
                                            </c:if>
                                            <button class="btn btn-primary" onclick="leaveRoom(${room.roomID})">Leave
                                                Room</button>
                                        </c:when>
                                        <c:otherwise>
                                            <c:if test="${room.status == 'OPEN'}">
                                                <button class="btn btn-primary"
                                                    onclick="joinRoomFromDetail(${room.roomID})">Join Room</button>
                                            </c:if>
                                            <a href="${pageContext.request.contextPath}/StudyRoomServlet"
                                                class="btn btn-ghost">Back to Lobby</a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Room Info Panel -->
                            <div class="room-info-panel">
                                <div class="info-item">
                                    <span class="info-label">Host</span>
                                    <span class="info-value">👑 ${room.hostName}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Timer</span>
                                    <span class="info-value">⏱ ${room.pomodoroLabel}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Members</span>
                                    <span class="info-value"
                                        id="memberCountDisplay">${room.currentParticipants}/${room.maxParticipants}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Type</span>
                                    <span class="info-value">${room.roomTypeBadge}</span>
                                </div>
                            </div>

                            <!-- Timer Section (only for members) -->
                            <c:if test="${not empty currentMember}">
                                <div class="timer-section">
                                    <div class="timer-display">
                                        <div class="timer-ring">
                                            <svg viewBox="0 0 200 200">
                                                <defs>
                                                    <linearGradient id="focusGradient" x1="0%" y1="0%" x2="100%"
                                                        y2="100%">
                                                        <stop offset="0%" stop-color="#3b82f6" />
                                                        <stop offset="100%" stop-color="#a855f7" />
                                                    </linearGradient>
                                                    <linearGradient id="breakGradient" x1="0%" y1="0%" x2="100%"
                                                        y2="100%">
                                                        <stop offset="0%" stop-color="#10b981" />
                                                        <stop offset="100%" stop-color="#3b82f6" />
                                                    </linearGradient>
                                                </defs>
                                                <circle class="timer-bg" cx="100" cy="100" r="90" fill="none"
                                                    stroke="rgba(255,255,255,0.05)" stroke-width="8" />
                                                <circle class="timer-progress" cx="100" cy="100" r="90" fill="none"
                                                    stroke="url(#focusGradient)" stroke-width="8" stroke-linecap="round"
                                                    id="timerProgress"
                                                    style="transform: rotate(-90deg); transform-origin: 50% 50%; transition: stroke-dashoffset 1s linear;" />
                                            </svg>
                                            <div class="timer-text">
                                                <span class="timer-minutes" id="timerMinutes">25</span>
                                                <span class="timer-separator">:</span>
                                                <span class="timer-seconds" id="timerSeconds">00</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="timer-controls">
                                        <button class="timer-btn" id="timerToggle" onclick="toggleTimer()">
                                            <svg class="play-icon" viewBox="0 0 24 24" fill="currentColor">
                                                <path d="M8 5v14l11-7z" />
                                            </svg>
                                            <svg class="pause-icon hidden" viewBox="0 0 24 24" fill="currentColor">
                                                <path d="M6 4h4v16H6zM14 4h4v16h-4z" />
                                            </svg>
                                        </button>
                                        <button class="timer-btn-secondary" onclick="resetTimer()">Reset</button>
                                        <button class="timer-btn-secondary" onclick="skipPhase()">Skip</button>
                                    </div>
                                    <div class="session-info">
                                        <span class="session-phase" id="sessionPhase">Focus Session 1</span>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Members Section -->
                            <div class="members-section">
                                <h3>👥 Room Members <span class="member-count-badge"
                                        id="memberCountBadge">${room.currentParticipants}</span></h3>
                                <div class="members-list" id="membersList">
                                    <c:forEach var="member" items="${members}">
                                        <div class="member-item" data-user-id="${member.userID}">
                                            <div class="member-avatar ${member.host ? 'host' : ''} online">
                                                <span class="member-avatar-initial">
                                                    ${member.displayName.substring(0,1).toUpperCase()}
                                                </span>
                                            </div>
                                            <div class="member-info">
                                                <span class="member-name">
                                                    ${member.displayName}
                                                    <c:if test="${member.userID == sessionScope.user.userID}"> (You)
                                                    </c:if>
                                                    <c:if test="${member.host}">
                                                        <span class="host-badge">👑 Host</span>
                                                    </c:if>
                                                </span>
                                                <span class="member-status">${member.host ? 'Room Host' :
                                                    'Studying...'}</span>
                                            </div>
                                            <div class="member-actions">
                                                <c:if
                                                    test="${not empty currentMember && currentMember.host && member.userID != sessionScope.user.userID}">
                                                    <button class="btn btn-xs"
                                                        style="margin-right: 5px; padding: 2px 8px; font-size: 0.75rem;"
                                                        onclick="transferHost(${room.roomID}, ${member.userID}, '${member.displayName}')">
                                                        Make Host
                                                    </button>
                                                    <button class="btn btn-danger-ghost btn-xs"
                                                        onclick="kickMember(${room.roomID}, ${member.userID}, '${member.displayName}')">
                                                        Kick
                                                    </button>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <!-- Chat Section (only for members) -->
                        <c:if test="${not empty currentMember}">
                            <div class="chat-section" id="chatSection">
                                <div class="chat-header">
                                    <h3>💬 Room Chat</h3>
                                    <span class="chat-status" id="chatStatus">
                                        <c:choose>
                                            <c:when test="${room.roomType == 'silent'}">🤫 Silent Room (Chat Disabled)
                                            </c:when>
                                            <c:otherwise>🔒 Chat opens during break</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="chat-messages" id="chatMessages">
                                    <div class="chat-message system">
                                        <p>
                                            <c:choose>
                                                <c:when test="${room.roomType == 'silent'}">Chat is permanently disabled
                                                    in silent rooms. Total focus required! 🤫</c:when>
                                                <c:otherwise>Chat is disabled during study time. Focus on your work! 🎯
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                </div>
                                <div class="chat-input-container disabled" id="chatInputContainer">
                                    <input type="text" class="chat-input"
                                        placeholder="${room.roomType == 'silent' ? 'Silent room...' : 'Chat available during breaks...'}"
                                        disabled id="chatInput">
                                    <button class="chat-send" disabled id="chatSend">Send</button>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </section>

                <!-- Toast notification -->
                <div class="toast-container" id="toastContainer"></div>

                <%@ include file="common/footer.jsp" %>

                    <style>
                        /* Chat messages fill all remaining space in the panel */
                        #chatSection .chat-messages {
                            flex: 1;
                            overflow-y: auto;
                            max-height: none;
                        }

                        /* Delete button on own messages */
                        .chat-message {
                            position: relative;
                        }

                        .chat-delete-btn {
                            display: none;
                            position: absolute;
                            top: 2px;
                            right: 2px;
                            background: rgba(239, 68, 68, 0.8);
                            color: white;
                            border: none;
                            border-radius: 50%;
                            width: 18px;
                            height: 18px;
                            font-size: 10px;
                            line-height: 18px;
                            text-align: center;
                            cursor: pointer;
                            padding: 0;
                            transition: background 0.15s;
                        }

                        .chat-delete-btn:hover {
                            background: rgba(239, 68, 68, 1);
                        }

                        .chat-message:hover .chat-delete-btn {
                            display: block;
                        }

                        .room-badges {
                            display: flex;
                            gap: 8px;
                            align-items: center;
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

                        .status-CLOSED {
                            background: rgba(239, 68, 68, 0.15);
                            color: #f87171;
                        }

                        .room-info-panel {
                            display: grid;
                            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                            gap: 12px;
                            padding: 16px;
                            background: rgba(255, 255, 255, 0.03);
                            border-radius: var(--radius-lg);
                            border: 1px solid rgba(255, 255, 255, 0.06);
                            margin-bottom: 24px;
                        }

                        .info-item {
                            display: flex;
                            flex-direction: column;
                            gap: 4px;
                        }

                        .info-label {
                            font-size: 0.75rem;
                            color: var(--color-text-secondary);
                            text-transform: uppercase;
                            letter-spacing: 0.5px;
                        }

                        .info-value {
                            font-size: 0.9rem;
                            color: var(--color-text-primary);
                            font-weight: 500;
                        }

                        .member-count-badge {
                            display: inline-block;
                            background: var(--color-primary);
                            color: #fff;
                            border-radius: 12px;
                            padding: 0 8px;
                            font-size: 0.8rem;
                            font-weight: 600;
                            margin-left: 8px;
                        }

                        .member-item {
                            display: flex;
                            align-items: center;
                            gap: 12px;
                            padding: 10px 12px;
                            border-radius: var(--radius-md);
                            transition: background 0.2s;
                        }

                        .member-item:hover {
                            background: rgba(255, 255, 255, 0.03);
                        }

                        .member-avatar.host {
                            border: 2px solid #facc15;
                        }

                        .host-badge {
                            font-size: 0.75rem;
                            padding: 1px 6px;
                            border-radius: 8px;
                            background: rgba(250, 204, 21, 0.15);
                            color: #facc15;
                            margin-left: 6px;
                        }

                        .member-actions {
                            margin-left: auto;
                        }

                        .btn-danger {
                            background: rgba(239, 68, 68, 0.2);
                            color: #f87171;
                            border: 1px solid rgba(239, 68, 68, 0.3);
                        }

                        .btn-danger:hover {
                            background: rgba(239, 68, 68, 0.35);
                        }

                        .btn-danger-ghost {
                            background: transparent;
                            color: #f87171;
                            border: 1px solid rgba(239, 68, 68, 0.3);
                            padding: 3px 10px;
                            font-size: 0.75rem;
                            border-radius: var(--radius-md);
                            cursor: pointer;
                            transition: background 0.2s;
                        }

                        .btn-danger-ghost:hover {
                            background: rgba(239, 68, 68, 0.15);
                        }

                        .btn-xs {
                            padding: 3px 10px;
                            font-size: 0.75rem;
                        }

                        .btn-sm {
                            padding: 6px 16px;
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

                        /* Chat Message Styles */
                        .chat-messages {
                            max-height: 400px;
                            overflow-y: auto;
                            padding: 12px;
                            display: flex;
                            flex-direction: column;
                            gap: 8px;
                        }

                        .chat-message {
                            display: flex;
                            max-width: 80%;
                            align-items: flex-end;
                            gap: 8px;
                        }

                        .chat-avatar {
                            width: 28px;
                            height: 28px;
                            border-radius: 50%;
                            background: linear-gradient(135deg, #3b82f6, #10b981);
                            color: white;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 0.8rem;
                            font-weight: bold;
                            flex-shrink: 0;
                        }

                        .chat-message.own {
                            align-self: flex-end;
                            flex-direction: row-reverse;
                        }

                        .chat-message.own .chat-avatar {
                            background: linear-gradient(135deg, #6366f1, #a855f7);
                        }

                        .chat-message.other {
                            align-self: flex-start;
                        }

                        .chat-message.system {
                            align-self: center;
                            max-width: 100%;
                        }

                        .chat-message.system p {
                            text-align: center;
                            font-size: 0.8rem;
                            color: var(--color-text-secondary);
                            font-style: italic;
                            margin: 4px 0;
                        }

                        .chat-bubble {
                            padding: 10px 14px;
                            border-radius: 16px;
                            background: rgba(255, 255, 255, 0.06);
                            border: 1px solid rgba(255, 255, 255, 0.06);
                            word-wrap: break-word;
                            position: relative;
                        }

                        .chat-bubble.own-bubble {
                            background: linear-gradient(135deg, rgba(99, 102, 241, 0.25) 0%, rgba(168, 85, 247, 0.2) 100%);
                            border-color: rgba(99, 102, 241, 0.2);
                        }

                        .chat-bubble p {
                            margin: 0;
                            font-size: 0.9rem;
                            color: var(--color-text-primary);
                            line-height: 1.4;
                        }

                        .chat-sender {
                            display: block;
                            font-size: 0.75rem;
                            font-weight: 600;
                            color: #a78bfa;
                            margin-bottom: 4px;
                        }

                        .chat-time {
                            font-size: 0.7rem;
                            color: var(--color-text-secondary);
                            margin-top: 4px;
                            display: block;
                            text-align: right;
                        }

                        .chat-input-container {
                            display: flex;
                            gap: 8px;
                            padding: 12px;
                            border-top: 1px solid rgba(255, 255, 255, 0.06);
                        }

                        .chat-input-container.disabled {
                            opacity: 0.5;
                            pointer-events: none;
                        }

                        .chat-input {
                            flex: 1;
                            background: rgba(0, 0, 0, 0.2);
                            border: 1px solid rgba(255, 255, 255, 0.1);
                            border-radius: 12px;
                            padding: 10px 16px;
                            color: var(--color-text-primary);
                            font-family: var(--font-primary);
                            font-size: 0.9rem;
                            outline: none;
                            transition: all 0.2s;
                        }

                        .chat-input:focus {
                            border-color: var(--color-accent-primary);
                            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
                        }

                        .chat-send {
                            background: linear-gradient(135deg, #6366f1, #a855f7);
                            color: white;
                            border: none;
                            border-radius: 12px;
                            padding: 10px 20px;
                            font-weight: 600;
                            cursor: pointer;
                            transition: all 0.2s;
                            font-size: 0.9rem;
                        }

                        .chat-send:hover:not(:disabled) {
                            transform: translateY(-1px);
                            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
                        }

                        .chat-send:disabled {
                            opacity: 0.5;
                            cursor: not-allowed;
                        }
                    </style>

                    </main>
                    </div>

                    <!-- Checkout Warning Modal -->
                    <div class="modal-overlay hidden" id="checkoutWarningModal"
                        style="z-index: 1050; display: flex; align-items: center; justify-content: center;">
                        <div class="modal-overlay-bg"></div>
                        <div class="modal-content"
                            style="max-width: 420px; text-align: center; border-radius: 20px; background: #161a29; padding: 40px 30px; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);">
                            <div style="font-size: 3rem; margin-bottom: 20px;">👋</div>
                            <h2
                                style="color: white; margin-bottom: 12px; font-family: var(--font-display); font-weight: 700; font-size: 1.8rem;">
                                Session Checkpoint!</h2>
                            <p style="margin-bottom: 30px; color: var(--color-text-secondary); font-size: 1rem;">Please
                                confirm you're still studying</p>

                            <div style="font-size: 4.5rem; font-family: var(--font-display); font-weight: bold; margin-bottom: 8px; background: linear-gradient(to right, #6366f1, #a855f7); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;"
                                id="checkoutTimerDisplay">60</div>
                            <div style="color: var(--color-text-secondary); font-size: 0.9rem; margin-bottom: 30px;">
                                seconds remaining</div>

                            <div
                                style="width: 100%; height: 6px; background: rgba(255,255,255,0.1); border-radius: 4px; margin-bottom: 30px; overflow: hidden;">
                                <div id="checkoutProgressBar"
                                    style="width: 100%; height: 100%; background: linear-gradient(to right, #3b82f6, #8b5cf6); transition: width 1s linear;">
                                </div>
                            </div>

                            <button class="btn btn-primary btn-full" onclick="confirmPresence()"
                                style="font-size: 1.1rem; padding: 14px; border-radius: 12px; background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%); border: none; font-weight: 600; margin-bottom: 24px; box-shadow: 0 4px 15px rgba(99, 102, 241, 0.3);">
                                ✅ I'm Here, Continue Studying!
                            </button>

                            <div
                                style="color: #fbbf24; font-size: 0.85rem; display: flex; align-items: flex-start; gap: 8px; text-align: left; line-height: 1.4;">
                                <span>⚠️</span>
                                <span>If you don't confirm within 60 seconds, you'll be removed from the study
                                    room.</span>
                            </div>
                        </div>
                    </div>
                    </div>

                    <!-- Room Settings Modal (Host Only) -->
                    <div class="modal-overlay hidden" id="roomSettingsModal"
                        style="z-index: 1050; display: flex; align-items: center; justify-content: center;">
                        <div class="modal-overlay-bg" onclick="toggleSettings()"></div>
                        <div class="modal-content"
                            style="max-width: 850px; padding: 0; overflow: hidden; display: flex; background: #1a1d2d; border-radius: 24px; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5); width: 100%; margin: 0 20px;">
                            <!-- Left Sidebar -->
                            <div
                                style="flex: 0 0 35%; background: linear-gradient(135deg, rgba(59, 130, 246, 0.1) 0%, rgba(16, 185, 129, 0.1) 100%); border-right: 1px solid rgba(255,255,255,0.05); padding: 40px 30px; display: flex; flex-direction: column; justify-content: space-between;">
                                <div>
                                    <div
                                        style="width: 50px; height: 50px; background: linear-gradient(135deg, #3b82f6, #10b981); border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin-bottom: 24px; box-shadow: 0 8px 16px rgba(59, 130, 246, 0.2);">
                                        ⚙️</div>
                                    <h2
                                        style="font-family: var(--font-display); font-size: 2rem; font-weight: 700; color: white; margin-bottom: 12px; line-height: 1.2;">
                                        Room<br>Settings</h2>
                                    <p
                                        style="color: var(--color-text-secondary); font-size: 0.95rem; line-height: 1.5;">
                                        Update your room's configuration on the fly.</p>
                                </div>
                                <div
                                    style="background: rgba(0,0,0,0.2); padding: 20px; border-radius: 16px; border: 1px solid rgba(255,255,255,0.05);">
                                    <h4 style="color: white; font-size: 0.9rem; margin-bottom: 8px;">💡 Pro Tip</h4>
                                    <p
                                        style="color: var(--color-text-secondary); font-size: 0.85rem; line-height: 1.4; margin: 0;">
                                        Change the status to <strong style="color: #ef4444;">Closed</strong> to
                                        prevent any new members from joining your session.</p>
                                </div>
                            </div>
                            <!-- Right Content -->
                            <div style="flex: 1; padding: 40px; display: flex; flex-direction: column;">
                                <div style="display: flex; justify-content: flex-end; margin-bottom: 20px;">
                                    <button class="modal-close" onclick="toggleSettings()"
                                        style="background: rgba(255,255,255,0.05); border-radius: 50%; padding: 8px; border: none; cursor: pointer; color: var(--color-text-secondary); transition: all 0.2s;">
                                        <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor"
                                            stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                            <line x1="18" y1="6" x2="6" y2="18"></line>
                                            <line x1="6" y1="6" x2="18" y2="18"></line>
                                        </svg>
                                    </button>
                                </div>
                                <form id="roomSettingsForm" action="${pageContext.request.contextPath}/StudyRoomServlet"
                                    method="POST" style="flex: 1; display: flex; flex-direction: column; gap: 20px;">
                                    <input type="hidden" name="action" value="updateSettings">
                                    <input type="hidden" name="roomId" value="${room.roomID}">
                                    <div class="form-group" style="margin: 0;">
                                        <label
                                            style="font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px; display: block; color: var(--color-text-secondary);">Room
                                            Name</label>
                                        <input type="text" name="roomName" class="input" value="${room.roomName}"
                                            required
                                            style="background: rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 14px 16px; width: 100%; box-sizing: border-box;">
                                    </div>

                                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                                        <div class="form-group" style="margin: 0;">
                                            <label
                                                style="font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px; display: block; color: var(--color-text-secondary);">Room
                                                Type</label>
                                            <div style="position: relative;">
                                                <select name="roomType" class="input"
                                                    style="background: rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 14px 16px; width: 100%; appearance: none; color: white;">
                                                    <option value="silent" ${room.roomType=='silent' ? 'selected' : ''
                                                        }>🤫 Silent</option>
                                                    <option value="public" ${room.roomType=='public' ? 'selected' : ''
                                                        }>👥 Public</option>
                                                    <option value="private" ${room.roomType=='private' ? 'selected' : ''
                                                        }>🔒 Private</option>
                                                </select>
                                                <div
                                                    style="position: absolute; right: 16px; top: 50%; transform: translateY(-50%); pointer-events: none; color: var(--color-text-secondary);">
                                                    ▼</div>
                                            </div>
                                        </div>

                                        <div class="form-group" style="margin: 0;">
                                            <label
                                                style="font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px; display: block; color: var(--color-text-secondary);">Pomodoro
                                                Mode</label>
                                            <div style="position: relative;">
                                                <select name="pomodoroSetting" class="input"
                                                    style="background: rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 14px 16px; width: 100%; appearance: none; color: white;">
                                                    <option value="25-5" ${room.pomodoroSetting=='25-5' ? 'selected'
                                                        : '' }>25/5 Classic</option>
                                                    <option value="50-10" ${room.pomodoroSetting=='50-10' ? 'selected'
                                                        : '' }>50/10 Extended</option>
                                                    <option value="90-20" ${room.pomodoroSetting=='90-20' ? 'selected'
                                                        : '' }>90/20 Deep Work</option>
                                                </select>
                                                <div
                                                    style="position: absolute; right: 16px; top: 50%; transform: translateY(-50%); pointer-events: none; color: var(--color-text-secondary);">
                                                    ▼</div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group" style="margin: 0;">
                                        <label
                                            style="font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px; display: block; color: var(--color-text-secondary);">Status</label>
                                        <div style="position: relative;">
                                            <select name="status" class="input"
                                                style="background: rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 14px 16px; width: 100%; appearance: none; color: white;">
                                                <option value="OPEN" ${room.status=='OPEN' ? 'selected' : '' }>🟢
                                                    Open to new members</option>
                                                <option value="CLOSED" ${room.status=='CLOSED' ? 'selected' : '' }>
                                                    🔴 Closed (No new joins)</option>
                                            </select>
                                            <div
                                                style="position: absolute; right: 16px; top: 50%; transform: translateY(-50%); pointer-events: none; color: var(--color-text-secondary);">
                                                ▼</div>
                                        </div>
                                    </div>

                                    <div class="modal-footer"
                                        style="margin-top: auto; padding-top: 24px; display: flex; justify-content: flex-end; gap: 12px; border-top: 1px solid rgba(255,255,255,0.05);">
                                        <button type="button" class="btn btn-ghost" onclick="toggleSettings()"
                                            style="padding: 12px 24px; border-radius: 12px; background: transparent; color: var(--color-text-secondary); border: 1px solid rgba(255,255,255,0.1); font-weight: 600; cursor: pointer; transition: all 0.2s;">Cancel</button>
                                        <button type="submit" class="btn btn-primary"
                                            style="padding: 12px 32px; border-radius: 12px; background: linear-gradient(135deg, #3b82f6 0%, #10b981 100%); color: white; border: none; font-weight: 600; cursor: pointer; box-shadow: 0 4px 15px rgba(59, 130, 246, 0.3); transition: all 0.2s;">Save
                                            Changes ✨</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    </div>

                    <!-- Kicked Notification Modal -->
                    <div class="modal-overlay hidden" id="kickedModal"
                        style="z-index: 9999; display: flex; align-items: center; justify-content: center;">
                        <div class="modal-overlay-bg"></div>
                        <div class="modal-content"
                            style="max-width: 420px; text-align: center; border-radius: 20px; background: #161a29; padding: 40px 30px; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);">
                            <div style="font-size: 3rem; margin-bottom: 20px;">👢</div>
                            <h2
                                style="color: white; margin-bottom: 12px; font-family: var(--font-display); font-weight: 700; font-size: 1.8rem;">
                                You were kicked!</h2>
                            <p style="margin-bottom: 30px; color: var(--color-text-secondary); font-size: 1rem;">The
                                host has removed you from this study room.<br>Returning to lobby soon...</p>
                        </div>
                    </div>

                    <script>
                        // === Navigation Interception ===
                        let isDeliberateLeave = false;

                        window.addEventListener('beforeunload', function (e) {
                            if (!isDeliberateLeave) {
                                var confirmationMessage = 'Are you sure you want to leave this study room?';
                                e.returnValue = confirmationMessage;
                                return confirmationMessage;
                            }
                        });

                        // === Room Settings Modal ===
                        function toggleSettings() {
                            const modal = document.getElementById('roomSettingsModal');
                            if (modal) {
                                modal.classList.toggle('hidden');
                            }
                        }
                        // === Pomodoro Timer Logic ===
                        let pomodoroSetting = '${room.pomodoroSetting}';
                        let focusMinutes = 25;
                        let breakMinutes = 5;
                        if (pomodoroSetting) {
                            const parts = pomodoroSetting.split('-');
                            if (parts.length === 2) {
                                focusMinutes = parseInt(parts[0]);
                                breakMinutes = parseInt(parts[1]);
                            }
                        }

                        let currentPhase = 'FOCUS'; // 'FOCUS' or 'BREAK'
                        let phaseCount = 1;
                        let isRunning = false;
                        let timeRemaining = focusMinutes * 60;
                        let timerInterval = null;

                        const timeMinutesDisplay = document.getElementById('timerMinutes');
                        const timeSecondsDisplay = document.getElementById('timerSeconds');
                        const phaseDisplay = document.getElementById('sessionPhase');

                        function updateTimerDisplay() {
                            if (!timeMinutesDisplay || !timeSecondsDisplay || !phaseDisplay) return;
                            const m = Math.floor(timeRemaining / 60);
                            const s = timeRemaining % 60;

                            timeMinutesDisplay.textContent = (m < 10 ? '0' : '') + m;
                            timeSecondsDisplay.textContent = (s < 10 ? '0' : '') + s;

                            if (currentPhase === 'FOCUS') {
                                phaseDisplay.textContent = 'Focus Session ' + phaseCount;
                            } else {
                                phaseDisplay.textContent = 'Break Time';
                            }

                            // Update SVG Ring Progress
                            const progressCircle = document.getElementById('timerProgress');
                            if (progressCircle) {
                                const totalTime = (currentPhase === 'FOCUS' ? focusMinutes : breakMinutes) * 60;
                                const radius = progressCircle.r.baseVal.value;
                                const circumference = 2 * Math.PI * radius;
                                const dashoffset = circumference - (timeRemaining / totalTime) * circumference;
                                progressCircle.style.strokeDasharray = `${circumference} ${circumference}`;
                                progressCircle.style.strokeDashoffset = dashoffset;

                                // Color change based on phase
                                if (currentPhase === 'FOCUS') {
                                    progressCircle.style.stroke = 'url(#focusGradient)';
                                } else {
                                    progressCircle.style.stroke = 'url(#breakGradient)';
                                }
                            }
                        }

                        function toggleTimer() {
                            isRunning = !isRunning;
                            const toggleBtn = document.getElementById('timerToggle');
                            const playIcon = toggleBtn.querySelector('.play-icon');
                            const pauseIcon = toggleBtn.querySelector('.pause-icon');

                            if (isRunning) {
                                playIcon.classList.add('hidden');
                                pauseIcon.classList.remove('hidden');
                                timerInterval = setInterval(() => {
                                    if (timeRemaining > 0) {
                                        timeRemaining--;
                                        updateTimerDisplay();
                                    } else {
                                        // Phase ended
                                        pauseTimerState();
                                        if (currentPhase === 'FOCUS') {
                                            showCheckoutWarning();
                                        } else {
                                            // Break ended, auto-start next focus session
                                            switchPhase();
                                            toggleTimer();
                                        }
                                    }
                                }, 1000);
                            } else {
                                pauseTimerState();
                            }
                        }

                        function pauseTimerState() {
                            isRunning = false;
                            if (timerInterval) clearInterval(timerInterval);
                            const toggleBtn = document.getElementById('timerToggle');
                            if (toggleBtn) {
                                const playIcon = toggleBtn.querySelector('.play-icon');
                                const pauseIcon = toggleBtn.querySelector('.pause-icon');
                                playIcon.classList.remove('hidden');
                                pauseIcon.classList.add('hidden');
                            }
                        }

                        function resetTimer() {
                            pauseTimerState();
                            if (currentPhase === 'FOCUS') {
                                timeRemaining = focusMinutes * 60;
                            } else {
                                timeRemaining = breakMinutes * 60;
                            }
                            updateTimerDisplay();
                        }

                        function skipPhase() {
                            pauseTimerState();
                            if (currentPhase === 'FOCUS') {
                                showCheckoutWarning();
                            } else {
                                switchPhase();
                                toggleTimer();
                            }
                        }

                        // === Chat Toggle based on user's own phase ===
                        var roomType = '${room.roomType}';

                        function updateChatState() {
                            var chatInput = document.getElementById('chatInput');
                            var chatSend = document.getElementById('chatSend');
                            var chatContainer = document.getElementById('chatInputContainer');
                            var chatStatus = document.getElementById('chatStatus');
                            if (!chatInput || !chatSend || !chatContainer) return;

                            if (roomType === 'silent') {
                                // Silent rooms: chat ALWAYS disabled
                                chatInput.disabled = true;
                                chatSend.disabled = true;
                                chatContainer.classList.add('disabled');
                                if (chatStatus) chatStatus.textContent = '🤫 Silent Room (Chat Disabled)';
                                return;
                            }

                            if (currentPhase === 'BREAK') {
                                // Break time: enable chat for this user
                                chatInput.disabled = false;
                                chatSend.disabled = false;
                                chatContainer.classList.remove('disabled');
                                chatInput.placeholder = 'Type a message...';
                                if (chatStatus) chatStatus.textContent = '💬 Chat is open (Break Time)';
                            } else {
                                // Focus time: disable chat for this user
                                chatInput.disabled = true;
                                chatSend.disabled = true;
                                chatContainer.classList.add('disabled');
                                chatInput.placeholder = 'Chat available during breaks...';
                                if (chatStatus) chatStatus.textContent = '🔒 Chat opens during break';
                            }
                        }

                        function switchPhase() {
                            if (currentPhase === 'FOCUS') {
                                currentPhase = 'BREAK';
                                timeRemaining = breakMinutes * 60;
                            } else {
                                currentPhase = 'FOCUS';
                                phaseCount++;
                                timeRemaining = focusMinutes * 60;
                            }
                            updateTimerDisplay();
                            updateChatState(); // Toggle chat based on new phase
                        }

                        // === Checkout Warning Logic ===
                        let checkoutInterval = null;
                        let checkoutTimeLeft = 60;
                        const MAX_CHECKOUT_TIME = 60;

                        function showCheckoutWarning() {
                            const modal = document.getElementById('checkoutWarningModal');
                            const display = document.getElementById('checkoutTimerDisplay');
                            const progressBar = document.getElementById('checkoutProgressBar');
                            if (!modal || !display) return;

                            modal.classList.remove('hidden');
                            modal.classList.add('flex'); // Enable flex layout for centering
                            checkoutTimeLeft = MAX_CHECKOUT_TIME;
                            display.textContent = checkoutTimeLeft;
                            if (progressBar) progressBar.style.width = '100%';

                            checkoutInterval = setInterval(() => {
                                checkoutTimeLeft--;
                                display.textContent = checkoutTimeLeft;
                                if (progressBar) {
                                    progressBar.style.width = ((checkoutTimeLeft / MAX_CHECKOUT_TIME) * 100) + '%';
                                }

                                if (checkoutTimeLeft <= 0) {
                                    clearInterval(checkoutInterval);
                                    // Auto-kick ONLY this user (silent, no confirm)
                                    leaveRoom(currentRoomId, true);
                                }
                            }, 1000);
                        }

                        function confirmPresence() {
                            if (checkoutInterval) clearInterval(checkoutInterval);
                            const modal = document.getElementById('checkoutWarningModal');
                            if (modal) {
                                modal.classList.add('hidden');
                                modal.classList.remove('flex');
                            }
                            switchPhase();
                            // Auto-start the next phase
                            toggleTimer();
                        }

                        // Initialize timer display and chat state on load
                        document.addEventListener('DOMContentLoaded', () => {
                            updateTimerDisplay();
                            updateChatState();
                        });

                        var contextPath = '${pageContext.request.contextPath}';
                        var currentRoomId = ${ room.roomID };
                        var currentUserId = ${ sessionScope.user.userID };
                        var isCurrentMember = ${ not empty currentMember };
                        var isCurrentHost = ${ not empty currentMember && currentMember.host};

                        function showToast(message, type) {
                            var container = document.getElementById('toastContainer');
                            var toast = document.createElement('div');
                            toast.className = 'toast toast-' + (type || 'info');
                            toast.textContent = message;
                            container.appendChild(toast);
                            setTimeout(function () { toast.remove(); }, 3000);
                        }

                        // silent = true means no confirm dialog (auto-kick from checkout)
                        function leaveRoom(roomId, silent) {
                            if (!roomId) roomId = currentRoomId;
                            if (!silent && !confirm('Are you sure you want to leave this room?')) return;
                            isDeliberateLeave = true;
                            fetch(contextPath + '/StudyRoomServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: 'action=leave&roomId=' + roomId
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        if (silent) {
                                            // Silently kicked for checkout timeout
                                            window.location.href = contextPath + '/StudyRoomServlet';
                                        } else {
                                            showToast(data.message, 'success');
                                            setTimeout(function () { window.location.href = contextPath + '/StudyRoomServlet'; }, 500);
                                        }
                                    } else {
                                        showToast(data.message || 'Error leaving room.', 'error');
                                    }
                                })
                                .catch(function () {
                                    // Even on error, redirect if silent kick
                                    if (silent) window.location.href = contextPath + '/StudyRoomServlet';
                                    else showToast('Network error.', 'error');
                                });
                        }

                        function joinRoomFromDetail(roomId) {
                            fetch(contextPath + '/StudyRoomServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: 'action=join&roomId=' + roomId
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        showToast(data.message, 'success');
                                        setTimeout(function () { window.location.reload(); }, 500);
                                    } else {
                                        showToast(data.message, 'error');
                                    }
                                })
                                .catch(function () { showToast('Network error.', 'error'); });
                        }

                        function kickMember(roomId, targetUserId, displayName) {
                            if (!confirm('Kick ' + displayName + ' from the room?')) return;
                            fetch(contextPath + '/StudyRoomServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: 'action=kick&roomId=' + roomId + '&targetUserId=' + targetUserId
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        showToast(data.message, 'success');
                                        refreshMembers();
                                    } else {
                                        showToast(data.message, 'error');
                                    }
                                })
                                .catch(function () { showToast('Network error.', 'error'); });
                        }

                        function deleteRoom(roomId) {
                            if (!confirm('Are you sure you want to DELETE this room? All members will be removed.')) return;
                            fetch(contextPath + '/StudyRoomServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: 'action=delete&roomId=' + roomId
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        showToast(data.message, 'success');
                                        setTimeout(function () { window.location.href = contextPath + '/StudyRoomServlet'; }, 500);
                                    } else {
                                        showToast(data.message, 'error');
                                    }
                                })
                                .catch(function () { showToast('Network error.', 'error'); });
                        }

                        function transferHost(roomId, newHostId, newHostName) {
                            if (!confirm('Are you sure you want to transfer Host rights to ' + newHostName + '? You will become a regular member.')) return;
                            fetch(contextPath + '/StudyRoomServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: 'action=transferHost&roomId=' + roomId + '&newHostId=' + newHostId
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        showToast(data.message, 'success');
                                        refreshMembers(); // Refresh instantly
                                    } else {
                                        showToast(data.message, 'error');
                                    }
                                })
                                .catch(function () { showToast('Network error.', 'error'); });
                        }

                        function escapeHtml(str) {
                            if (!str) return '';
                            var div = document.createElement('div');
                            div.appendChild(document.createTextNode(str));
                            return div.innerHTML;
                        }

                        function refreshMembers() {
                            fetch(contextPath + '/StudyRoomServlet?action=members&id=' + currentRoomId, {
                                headers: { 'X-Requested-With': 'XMLHttpRequest' }
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (!data.success) return;

                                    // Update member count
                                    var countBadge = document.getElementById('memberCountBadge');
                                    var countDisplay = document.getElementById('memberCountDisplay');
                                    var statusBadge = document.getElementById('roomStatusBadge');
                                    if (countBadge) countBadge.textContent = data.currentParticipants;
                                    if (countDisplay) countDisplay.textContent = data.currentParticipants + '/' + data.maxParticipants;
                                    if (statusBadge) {
                                        statusBadge.textContent = data.statusBadge;
                                        statusBadge.className = 'room-status-badge status-' + data.status;
                                    }

                                    // Check if current user was kicked
                                    if (isCurrentMember) {
                                        var stillInRoom = false;
                                        for (var i = 0; i < data.members.length; i++) {
                                            if (data.members[i].userID === currentUserId) {
                                                stillInRoom = true;
                                                break;
                                            }
                                        }
                                        if (!stillInRoom && !isDeliberateLeave) {
                                            const kickedModal = document.getElementById('kickedModal');
                                            if (kickedModal) {
                                                kickedModal.classList.remove('hidden');
                                                setTimeout(function () {
                                                    isDeliberateLeave = true;
                                                    window.location.href = contextPath + '/StudyRoomServlet';
                                                }, 3000);
                                            } else {
                                                alert('You were kicked from this study room by the host.');
                                                isDeliberateLeave = true;
                                                window.location.href = contextPath + '/StudyRoomServlet';
                                            }
                                            return;
                                        }
                                    }

                                    // Find current host info
                                    var currentHostName = '';
                                    isCurrentHost = false; // Reset and calculate accurately
                                    for (var i = 0; i < data.members.length; i++) {
                                        if (data.members[i].isHost) {
                                            currentHostName = data.members[i].displayName;
                                        }
                                        if (data.members[i].userID === currentUserId && data.members[i].isHost) {
                                            isCurrentHost = true;
                                        }
                                    }

                                    // Update Host Name in Info Panel
                                    var hostInfoItems = document.querySelectorAll('.room-info-panel .info-item');
                                    hostInfoItems.forEach(function (item) {
                                        if (item.querySelector('.info-label') && item.querySelector('.info-label').textContent.trim() === 'Host') {
                                            item.querySelector('.info-value').textContent = '👑 ' + currentHostName;
                                        }
                                        if (item.querySelector('.info-label') && item.querySelector('.info-label').textContent.trim() === 'Type' && data.roomTypeBadge) {
                                            item.querySelector('.info-value').innerHTML = data.roomTypeBadge;
                                        }
                                    });

                                    // Update Room Badges Header
                                    var headerTypeBadge = document.querySelector('.room-type-badge');
                                    if (headerTypeBadge && data.roomTypeBadge && data.roomType) {
                                        headerTypeBadge.className = 'room-type-badge ' + data.roomType;
                                        headerTypeBadge.innerHTML = data.roomTypeBadge;
                                    }

                                    var headerTitle = document.querySelector('.active-room-title');
                                    if (headerTitle && data.roomName) {
                                        headerTitle.textContent = data.roomName;
                                    }

                                    // Update Room Actions (Settings / Delete buttons dynamically for new host)
                                    var roomActionsDiv = document.querySelector('.room-actions');
                                    if (roomActionsDiv && isCurrentMember) {
                                        var settingsHtml = isCurrentHost ? '<button class="btn btn-ghost" onclick="toggleSettings()"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3" /><path d="M19.4 15a1.65 1.65 0 00.33 1.82l.06.06a2 2 0 010 2.83 2 2 0 01-2.83 0l-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V21a2 2 0 01-2 2 2 2 0 01-2-2v-.09A1.65 1.65 0 009 19.4a1.65 1.65 0 00-1.82.33l-.06.06a2 2 0 01-2.83 0 2 2 0 010-2.83l.06-.06a1.65 1.65 0 00.33-1.82 1.65 1.65 0 00-1.51-1H3a2 2 0 01-2-2 2 2 0 012-2h.09A1.65 1.65 0 004.6 9a1.65 1.65 0 00-.33-1.82l-.06-.06a2 2 0 010-2.83 2 2 0 012.83 0l.06.06a1.65 1.65 0 001.82.33H9a1.65 1.65 0 001-1.51V3a2 2 0 012-2 2 2 0 012 2v.09a1.65 1.65 0 001 1.51 1.65 1.65 0 001.82-.33l.06-.06a2 2 0 012.83 0 2 2 0 010 2.83l-.06.06a1.65 1.65 0 00-.33 1.82V9a1.65 1.65 0 001.51 1H21a2 2 0 012 2 2 2 0 01-2 2h-.09a1.65 1.65 0 00-1.51 1z" /></svg>Settings</button>' : '';
                                        var deleteHtml = isCurrentHost ? '<button class="btn btn-danger btn-sm" onclick="deleteRoom(' + currentRoomId + ')" title="Delete Room">🗑️ Delete Room</button>' : '';
                                        var leaveHtml = '<button class="btn btn-primary" onclick="leaveRoom(' + currentRoomId + ')">Leave Room</button>';
                                        roomActionsDiv.innerHTML = deleteHtml + settingsHtml + leaveHtml;
                                    }

                                    // Update member list
                                    var list = document.getElementById('membersList');
                                    if (!list) return;
                                    var html = '';
                                    for (var i = 0; i < data.members.length; i++) {
                                        var m = data.members[i];
                                        var isYou = m.userID === currentUserId;
                                        var kickBtn = '';
                                        var transferBtn = '';
                                        if (isCurrentHost && !isYou) {
                                            transferBtn = '<button class="btn btn-xs" style="margin-right: 5px; padding: 2px 8px; font-size: 0.75rem;" onclick="transferHost(' + currentRoomId + ', ' + m.userID + ', \'' + escapeHtml(m.displayName) + '\')">Make Host</button>';
                                            kickBtn = '<button class="btn-danger-ghost btn-xs" onclick="kickMember(' + currentRoomId + ', ' + m.userID + ', \'' + escapeHtml(m.displayName) + '\')">Kick</button>';
                                        }
                                        html += '<div class="member-item" data-user-id="' + m.userID + '">'
                                            + '<div class="member-avatar ' + (m.isHost ? 'host' : '') + ' online">'
                                            + '<span class="member-avatar-initial">' + m.displayName.charAt(0).toUpperCase() + '</span></div>'
                                            + '<div class="member-info">'
                                            + '<span class="member-name">' + escapeHtml(m.displayName)
                                            + (isYou ? ' (You)' : '')
                                            + (m.isHost ? ' <span class="host-badge">👑 Host</span>' : '')
                                            + '</span>'
                                            + '<span class="member-status">' + (m.isHost ? 'Room Host' : 'Studying...') + '</span>'
                                            + '</div>'
                                            + '<div class="member-actions">' + transferBtn + kickBtn + '</div>'
                                            + '</div>';
                                    }
                                    list.innerHTML = html;
                                })
                                .catch(function () { });
                        }

                        // Auto-refresh member list every 1 second
                        setInterval(refreshMembers, 1000);

                        // === WebSocket Chat ===
                        var currentDisplayName = '${not empty currentMember ? currentMember.displayName : sessionScope.user.username}';
                        var chatSocket = null;

                        function connectWebSocket() {
                            if (roomType === 'silent') return; // No chat for silent rooms
                            if (!isCurrentMember) return;

                            var wsProtocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
                            var wsUrl = wsProtocol + '//' + window.location.host + contextPath + '/ws/room/' + currentRoomId;

                            chatSocket = new WebSocket(wsUrl);

                            chatSocket.onopen = function () {
                                console.log('[WebSocket] Connected to room ' + currentRoomId);
                            };

                            chatSocket.onmessage = function (event) {
                                var data = JSON.parse(event.data);
                                if (data.type === 'chat') {
                                    renderChatMessage(data);
                                } else if (data.type === 'system') {
                                    renderSystemMessage(data.content, data.time);
                                } else if (data.type === 'error') {
                                    showToast(data.message, 'error');
                                } else if (data.type === 'deleted') {
                                    // Remove the deleted message from DOM
                                    var el = document.querySelector('[data-message-id="' + data.messageId + '"]');
                                    if (el) el.remove();
                                }
                            };

                            chatSocket.onclose = function () {
                                console.log('[WebSocket] Disconnected from room ' + currentRoomId);
                                // Reconnect after 3 seconds if still on the page
                                setTimeout(function () {
                                    if (!isDeliberateLeave) {
                                        connectWebSocket();
                                    }
                                }, 3000);
                            };

                            chatSocket.onerror = function (err) {
                                console.error('[WebSocket] Error:', err);
                            };
                        }

                        function sendChatMessage() {
                            var chatInput = document.getElementById('chatInput');
                            if (!chatInput || !chatSocket || chatSocket.readyState !== WebSocket.OPEN) return;

                            var content = chatInput.value.trim();
                            if (!content) return;

                            var payload = JSON.stringify({
                                userId: currentUserId,
                                displayName: currentDisplayName,
                                content: content
                            });

                            chatSocket.send(payload);
                            chatInput.value = '';
                            chatInput.focus();
                        }

                        function renderChatMessage(data) {
                            var chatMessages = document.getElementById('chatMessages');
                            if (!chatMessages) return;

                            var isMe = data.userId === currentUserId;
                            var div = document.createElement('div');
                            div.className = 'chat-message ' + (isMe ? 'own' : 'other');
                            div.setAttribute('data-message-id', data.messageId);

                            var deleteBtn = isMe
                                ? '<button class="chat-delete-btn" onclick="deleteMessage(' + data.messageId + ')" title="Delete message">✕</button>'
                                : '';

                            var senderName = data.displayName || data.username || 'User';
                            var avatarInitial = senderName.charAt(0).toUpperCase();
                            var avatarHtml = '<div class="chat-avatar">' + avatarInitial + '</div>';

                            div.innerHTML =
                                avatarHtml +
                                '<div class="chat-bubble' + (isMe ? ' own-bubble' : '') + '">' +
                                (isMe ? '' : '<span class="chat-sender">' + escapeHtml(senderName) + '</span>') +
                                '<p>' + escapeHtml(data.content) + '</p>' +
                                '<span class="chat-time">' + data.time + '</span>' +
                                '</div>' +
                                deleteBtn;

                            chatMessages.appendChild(div);
                            chatMessages.scrollTop = chatMessages.scrollHeight;
                        }

                        function deleteMessage(messageId) {
                            if (!chatSocket || chatSocket.readyState !== WebSocket.OPEN) return;
                            chatSocket.send(JSON.stringify({
                                type: 'delete',
                                messageId: messageId,
                                userId: currentUserId
                            }));
                        }

                        function renderSystemMessage(content, time) {
                            var chatMessages = document.getElementById('chatMessages');
                            if (!chatMessages) return;

                            var div = document.createElement('div');
                            div.className = 'chat-message system';
                            div.innerHTML = '<p>' + escapeHtml(content) + ' <span class="chat-time">' + (time || '') + '</span></p>';

                            chatMessages.appendChild(div);
                            chatMessages.scrollTop = chatMessages.scrollHeight;
                        }

                        // Bind Send button and Enter key
                        document.addEventListener('DOMContentLoaded', function () {
                            var sendBtn = document.getElementById('chatSend');
                            var chatInput = document.getElementById('chatInput');
                            if (sendBtn) {
                                sendBtn.addEventListener('click', sendChatMessage);
                            }
                            if (chatInput) {
                                chatInput.addEventListener('keydown', function (e) {
                                    if (e.key === 'Enter' && !e.shiftKey) {
                                        e.preventDefault();
                                        if (!chatInput.disabled) {
                                            sendChatMessage();
                                        }
                                    }
                                });
                            }
                            // Connect WebSocket on page load
                            connectWebSocket();
                        });
                    </script>
        </body>

        </html>