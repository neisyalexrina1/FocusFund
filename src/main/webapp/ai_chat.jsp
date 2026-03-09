<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:if test="${empty sessionScope.user}">
            <c:redirect url="AuthServlet" />
        </c:if>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <%@ include file="common/header.jsp" %>
                <title>AI Assistant - FocusFund</title>
                <style>
                    /* ===== AI Page Custom Styles (not in Design CSS) ===== */

                    /* AI Header - replaces page-header for this page */
                    .ai-page-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding: var(--spacing-md) var(--spacing-xl);
                        border-bottom: var(--border-card);
                        background: var(--color-bg-card);
                    }

                    .ai-page-header h2 {
                        font-family: var(--font-display);
                        font-size: 1.25rem;
                        font-weight: 600;
                        display: flex;
                        align-items: center;
                        gap: var(--spacing-sm);
                    }

                    .ai-page-header .ai-status {
                        font-size: 0.8rem;
                        color: var(--color-success);
                        display: flex;
                        align-items: center;
                        gap: var(--spacing-xs);
                    }

                    .ai-page-header .ai-status::before {
                        content: '';
                        width: 8px;
                        height: 8px;
                        background: var(--color-success);
                        border-radius: 50%;
                        animation: pulse 2s infinite;
                    }

                    @keyframes pulse {

                        0%,
                        100% {
                            opacity: 1;
                        }

                        50% {
                            opacity: 0.5;
                        }
                    }

                    /* AI Mode Toggle */
                    .ai-mode-toggle {
                        display: flex;
                        gap: var(--spacing-xs);
                        background: var(--color-bg-light);
                        border-radius: var(--radius-full);
                        padding: var(--spacing-xs);
                    }

                    .ai-mode-btn {
                        display: flex;
                        align-items: center;
                        gap: var(--spacing-sm);
                        padding: var(--spacing-sm) var(--spacing-lg);
                        background: transparent;
                        border: none;
                        border-radius: var(--radius-full);
                        color: var(--color-text-muted);
                        font-size: 0.85rem;
                        font-weight: 500;
                        cursor: pointer;
                        transition: var(--transition-fast);
                        font-family: var(--font-primary);
                    }

                    .ai-mode-btn:hover {
                        color: var(--color-text-primary);
                    }

                    .ai-mode-btn.active {
                        background: var(--color-bg-card);
                        color: var(--color-accent-primary);
                        box-shadow: var(--shadow-soft);
                    }

                    .ai-mode-btn svg {
                        flex-shrink: 0;
                    }

                    /* Voice Call Mode */
                    .ai-call-mode {
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        flex: 1;
                        padding: var(--spacing-3xl);
                    }

                    .ai-call-mode.hidden {
                        display: none;
                    }

                    .ai-call-interface {
                        text-align: center;
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        gap: var(--spacing-xl);
                    }

                    .ai-call-avatar {
                        position: relative;
                        width: 120px;
                        height: 120px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                    }

                    .call-pulse {
                        position: absolute;
                        width: 100%;
                        height: 100%;
                        border-radius: var(--radius-full);
                        background: var(--gradient-primary);
                        opacity: 0.2;
                        animation: callPulse 2s ease-in-out infinite;
                    }

                    @keyframes callPulse {

                        0%,
                        100% {
                            transform: scale(1);
                            opacity: 0.2;
                        }

                        50% {
                            transform: scale(1.2);
                            opacity: 0.1;
                        }
                    }

                    .call-icon {
                        position: relative;
                        font-size: 3rem;
                        z-index: 1;
                    }

                    .ai-call-title {
                        font-family: var(--font-display);
                        font-size: 1.5rem;
                        font-weight: 600;
                    }

                    .ai-call-status {
                        color: var(--color-text-muted);
                        font-size: 0.9rem;
                    }

                    .ai-call-controls {
                        display: flex;
                        gap: var(--spacing-lg);
                        align-items: center;
                    }

                    .call-control-btn {
                        width: 56px;
                        height: 56px;
                        border-radius: var(--radius-full);
                        border: none;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        cursor: pointer;
                        transition: var(--transition-fast);
                        background: var(--color-bg-light);
                        color: var(--color-text-secondary);
                    }

                    .call-control-btn:hover {
                        background: var(--color-bg-card-hover);
                        color: var(--color-text-primary);
                    }

                    .call-control-btn.start-call {
                        width: 72px;
                        height: 72px;
                        background: var(--color-success);
                        color: white;
                    }

                    .call-control-btn.start-call:hover {
                        background: hsl(150, 50%, 40%);
                        transform: scale(1.05);
                    }

                    /* Chat mode container */
                    .ai-chat-mode {
                        display: flex;
                        flex-direction: column;
                        flex: 1;
                        overflow: hidden;
                    }

                    .ai-chat-mode.hidden {
                        display: none;
                    }

                    /* Override: AI chat input area fix */
                    .ai-chat-input-container {
                        padding: var(--spacing-md) var(--spacing-xl) var(--spacing-xl);
                        background: transparent;
                        border-top: none;
                    }

                    .ai-chat-input {
                        overflow-y: auto;
                        max-height: 150px;
                        line-height: 1.5;
                        padding-top: 8px;
                        /* Better alignment */
                    }

                    /* Custom Language Dropdown */
                    .ai-lang-selector {
                        position: relative;
                        display: flex;
                        align-items: center;
                        z-index: 10;
                    }

                    .lang-trigger {
                        display: flex;
                        align-items: center;
                        gap: 4px;
                        padding: 6px 10px;
                        background: var(--color-bg-light);
                        border: 1px solid var(--border-subtle);
                        border-radius: var(--radius-md);
                        cursor: pointer;
                        font-size: 1.1rem;
                        transition: var(--transition-fast);
                        color: var(--color-text-primary);
                    }

                    .lang-trigger:hover {
                        background: var(--color-bg-card-hover);
                        border-color: var(--color-accent-primary);
                    }

                    .lang-dropdown {
                        position: absolute;
                        bottom: calc(100% + 10px);
                        right: 0;
                        background: var(--color-bg-card);
                        border: 1px solid var(--border-subtle);
                        border-radius: var(--radius-lg);
                        box-shadow: var(--shadow-card);
                        display: none;
                        min-width: 120px;
                        overflow: hidden;
                        animation: slideUp 0.2s ease;
                    }

                    @keyframes slideUp {
                        from {
                            transform: translateY(10px);
                            opacity: 0;
                        }

                        to {
                            transform: translateY(0);
                            opacity: 1;
                        }
                    }

                    .lang-dropdown.active {
                        display: block;
                    }

                    .lang-option {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                        padding: 10px 16px;
                        cursor: pointer;
                        transition: var(--transition-fast);
                        font-size: 0.9rem;
                        color: var(--color-text-primary);
                    }

                    .lang-option:hover {
                        background: var(--color-bg-light);
                    }

                    .lang-option.selected {
                        background: rgba(var(--color-accent-primary-rgb), 0.1);
                        color: var(--color-accent-primary);
                        font-weight: 600;
                    }

                    /* Attachment Menu Styles */
                    .ai-attachment-container {
                        position: relative;
                        display: flex;
                        align-items: center;
                    }

                    .ai-plus-btn {
                        width: 36px;
                        height: 36px;
                        border-radius: var(--radius-full);
                        border: none;
                        background: transparent;
                        color: var(--color-text-primary);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        cursor: pointer;
                        transition: var(--transition-fast);
                        font-size: 1.5rem;
                        flex-shrink: 0;
                    }

                    .ai-plus-btn:hover {
                        background: var(--color-bg-light);
                        transform: rotate(90deg);
                    }

                    .attachment-menu {
                        position: absolute;
                        bottom: calc(100% + 15px);
                        left: 0;
                        background: var(--color-bg-card);
                        border: 1px solid var(--border-subtle);
                        border-radius: var(--radius-lg);
                        box-shadow: var(--shadow-xl);
                        display: none;
                        min-width: 240px;
                        padding: 8px;
                        z-index: 100;
                        animation: slideUp 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                    }

                    .attachment-menu.active {
                        display: block;
                    }

                    .attachment-item {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                        padding: 10px 16px;
                        cursor: pointer;
                        transition: var(--transition-fast);
                        border-radius: var(--radius-md);
                        color: var(--color-text-primary);
                        font-size: 0.95rem;
                    }

                    .attachment-item:hover {
                        background: var(--color-bg-light);
                    }

                    .attachment-item svg {
                        width: 18px;
                        height: 18px;
                        color: var(--color-text-secondary);
                    }

                    .attachment-divider {
                        height: 1px;
                        background: var(--border-subtle);
                        margin: 4px 0;
                    }

                    @keyframes slideUp {
                        from {
                            transform: translateY(10px);
                            opacity: 0;
                        }

                        to {
                            transform: translateY(0);
                            opacity: 1;
                        }
                    }

                    /* Attachment Preview Styles */
                    .ai-attachments-preview {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 12px;
                        padding: 8px 10px 12px;
                    }

                    .ai-attachment-chip {
                        position: relative;
                        display: flex;
                        align-items: center;
                        background: var(--color-bg-card);
                        border: 1px solid var(--border-subtle);
                        border-radius: 12px;
                        padding: 8px 12px 8px 8px;
                        font-size: 0.85rem;
                        color: var(--color-text-primary);
                        min-width: 140px;
                        max-width: 220px;
                        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
                    }

                    .ai-attachment-chip.image-chip {
                        padding: 0;
                        border: none;
                        background: transparent;
                        min-width: auto;
                        box-shadow: none;
                    }

                    .ai-attachment-chip.image-chip img {
                        width: 72px;
                        height: 72px;
                        object-fit: cover;
                        border-radius: 12px;
                        border: 1px solid var(--border-subtle);
                    }

                    .ai-attachment-file-icon {
                        width: 40px;
                        height: 40px;
                        border-radius: 8px;
                        background: #F44336;
                        color: white;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        margin-right: 10px;
                        flex-shrink: 0;
                    }

                    .ai-attachment-file-info {
                        display: flex;
                        flex-direction: column;
                        overflow: hidden;
                    }

                    .ai-attachment-file-name {
                        font-weight: 500;
                        white-space: nowrap;
                        overflow: hidden;
                        text-overflow: ellipsis;
                        font-size: 0.85rem;
                    }

                    .ai-attachment-file-type {
                        font-size: 0.7rem;
                        color: var(--color-text-muted);
                        text-transform: uppercase;
                    }

                    .ai-attachment-remove {
                        position: absolute;
                        top: -8px;
                        right: -8px;
                        width: 24px;
                        height: 24px;
                        background: #1a1a1a;
                        color: white;
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        cursor: pointer;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
                        z-index: 2;
                        transition: transform 0.2s, background 0.2s;
                    }

                    .ai-attachment-remove:hover {
                        transform: scale(1.1);
                        background: #000;
                    }

                    .ai-mode-badge {
                        display: none;
                        font-size: 0.75rem;
                        padding: 4px 8px;
                        border-radius: 12px;
                        background: rgba(var(--color-accent-primary-rgb), 0.1);
                        color: var(--color-accent-primary);
                        margin: 0 10px 8px;
                        width: fit-content;
                        font-weight: 600;
                    }

                    .ai-mode-badge.active {
                        display: block;
                    }

                    /* ===== Image Popup Modal ===== */
                    .image-popup-modal {
                        display: none;
                        position: fixed;
                        z-index: 1000;
                        left: 0;
                        top: 0;
                        width: 100%;
                        height: 100%;
                        background-color: rgba(0, 0, 0, 0.8);
                        backdrop-filter: blur(5px);
                        align-items: center;
                        justify-content: center;
                        opacity: 0;
                        transition: opacity 0.3s ease;
                    }

                    .image-popup-modal.show {
                        display: flex;
                        opacity: 1;
                    }

                    .image-popup-content {
                        max-width: 90%;
                        max-height: 90%;
                        border-radius: 8px;
                        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);
                        transform: scale(0.9);
                        transition: transform 0.3s ease;
                    }

                    .image-popup-modal.show .image-popup-content {
                        transform: scale(1);
                    }

                    .image-popup-close {
                        position: absolute;
                        top: 20px;
                        right: 30px;
                        color: #f1f1f1;
                        font-size: 40px;
                        font-weight: bold;
                        cursor: pointer;
                        transition: color 0.2s;
                    }

                    .image-popup-close:hover {
                        color: white;
                    }

                    .chat-image-clickable {
                        cursor: pointer;
                        transition: transform 0.2s;
                    }

                    .chat-image-clickable:hover {
                        transform: scale(1.02);
                    }

                    .ai-message {
                        flex-wrap: wrap;
                    }

                    .ai-message-content {
                        max-width: calc(100% - 56px);
                        /* Avatar width 40px + gap 16px */
                    }

                    /* ===== Message Actions ===== */
                    .message-actions {
                        display: flex;
                        gap: 2px;
                        margin-top: 4px;
                        opacity: 0;
                        transition: opacity 0.2s;
                        padding: 0;
                        z-index: 10;
                        flex-basis: 100%;
                        /* Force to new line in flex wrap */
                    }

                    .ai-message.user .message-actions {
                        justify-content: flex-end;
                        padding-right: 56px;
                    }

                    .ai-message.assistant .message-actions {
                        justify-content: flex-start;
                        padding-left: 56px;
                        /* Align with text by skipping avatar */
                    }

                    .ai-message:hover .message-actions {
                        opacity: 1;
                    }

                    .msg-action-btn {
                        background: transparent;
                        border: none;
                        cursor: pointer;
                        color: var(--color-text-muted);
                        padding: 4px 6px;
                        border-radius: 4px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        transition: background 0.2s, color 0.2s;
                        font-size: 1.1rem;
                    }

                    .msg-action-btn:hover {
                        background: rgba(255, 255, 255, 0.1);
                        color: var(--color-text-primary);
                    }
                </style>
        </head>

        <body>
            <div class="background-effects">
                <div class="stars" id="stars"></div>
                <div class="shooting-stars" id="shooting-stars"></div>
                <div class="rain" id="rain"></div>
            </div>

            <!-- Image Popup Modal -->
            <div id="imagePopupModal" class="image-popup-modal" onclick="closeImagePopup()">
                <span class="image-popup-close">&times;</span>
                <img class="image-popup-content" id="popupImage" onclick="event.stopPropagation()">
            </div>

            <%@ include file="common/navbar.jsp" %>

                <section class="page active" id="page-ai-chat">
                    <div class="ai-chat-container">
                        <!-- Sidebar: Chat History -->
                        <div class="ai-chat-sidebar">
                            <button class="btn btn-primary btn-full sidebar-btn-new" title="New Chat"
                                onclick="newChat()">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor"
                                    stroke-width="2">
                                    <line x1="12" y1="5" x2="12" y2="19" />
                                    <line x1="5" y1="12" x2="19" y2="12" />
                                </svg>
                                <span class="sidebar-text">New Chat</span>
                            </button>

                            <div class="chat-history">
                                <h4>Recent</h4>
                                <div class="chat-history-list" id="chatHistoryList">
                                    <!-- Loaded dynamically -->
                                </div>
                            </div>
                        </div>

                        <!-- Main Chat Area -->
                        <div class="ai-chat-main">
                            <!-- Header with mode toggle -->
                            <div class="ai-page-header" style="padding: 10px 20px;">
                                <div style="display: flex; align-items: center; gap: 15px;">
                                    <button class="sidebar-toggle-btn"
                                        onclick="document.querySelector('.ai-chat-sidebar').classList.toggle('hidden-sidebar')"
                                        style="background: transparent; border: none; color: var(--color-text-primary); cursor: pointer; padding: 5px;">
                                        <svg viewBox="0 0 24 24" width="20" height="20" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <line x1="3" y1="12" x2="21" y2="12"></line>
                                            <line x1="3" y1="6" x2="21" y2="6"></line>
                                            <line x1="3" y1="18" x2="21" y2="18"></line>
                                        </svg>
                                    </button>
                                    <span class="ai-status">Online</span>
                                </div>
                                <div class="ai-mode-toggle">
                                    <button class="ai-mode-btn active" onclick="switchAIMode('chat')" title="Chat mode"
                                        style="padding: 8px;">
                                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z" />
                                        </svg>
                                    </button>
                                    <button class="ai-mode-btn" onclick="switchAIMode('call')" title="Voice Call mode"
                                        style="padding: 8px;">
                                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <path
                                                d="M15.05 5A5 5 0 0119 8.95M15.05 1A9 9 0 0123 8.94m-1 7.98v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07 19.5 19.5 0 01-6-6 19.79 19.79 0 01-3.07-8.67A2 2 0 014.11 2h3a2 2 0 012 1.72 12.84 12.84 0 00.7 2.81 2 2 0 01-.45 2.11L8.09 9.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45 12.84 12.84 0 002.81.7A2 2 0 0122 16.92z" />
                                        </svg>
                                    </button>
                                </div>
                            </div>

                            <!-- Chat Mode -->
                            <div class="ai-chat-mode" id="aiChatMode">
                                <div class="ai-chat-messages" id="aiChatMessages">
                                    <div class="ai-message assistant">
                                        <div class="ai-message-avatar">🤖</div>
                                        <div class="ai-message-content">
                                            <p>Hi there! I'm your AI Study Assistant. I can help you with:</p>
                                            <ul>
                                                <li>📝 <strong>Summarize</strong> chapters and notes</li>
                                                <li>❓ <strong>Generate quizzes</strong> to test your knowledge</li>
                                                <li>💡 <strong>Explain</strong> difficult concepts</li>
                                                <li>📅 <strong>Create study plans</strong> and schedules</li>
                                            </ul>
                                            <p>What would you like help with today?</p>
                                        </div>
                                    </div>
                                </div>

                                <div class="ai-chat-input-container">
                                    <div id="aiModeBadge" class="ai-mode-badge"></div>
                                    <div id="aiAttachmentsPreview" class="ai-attachments-preview"></div>
                                    <div class="ai-chat-input-wrapper">
                                        <div class="ai-attachment-container">
                                            <button class="ai-plus-btn" id="aiPlusBtn" onclick="toggleAttachmentMenu()"
                                                title="Add attachments">
                                                <svg viewBox="0 0 24 24" width="24" height="24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <line x1="12" y1="5" x2="12" y2="19"></line>
                                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                                </svg>
                                            </button>
                                            <div class="attachment-menu" id="attachmentMenu">
                                                <div class="attachment-item" onclick="handleAttachment('files')">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2">
                                                        <path
                                                            d="M21.44 11.05l-9.19 9.19a6 6 0 01-8.49-8.49l9.19-9.19a4 4 0 015.66 5.66l-9.2 9.19a2 2 0 01-2.83-2.83l8.49-8.48">
                                                        </path>
                                                    </svg>
                                                    Add photos & files
                                                </div>
                                                <div class="attachment-item" onclick="handleAttachment('image')">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2">
                                                        <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                                        <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                                        <polyline points="21 15 16 10 5 21"></polyline>
                                                    </svg>
                                                    Create image
                                                </div>
                                                <div class="attachment-item" onclick="handleAttachment('thinking')">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2">
                                                        <path
                                                            d="M9.663 17h4.674M12 3v1m8 8h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z">
                                                        </path>
                                                    </svg>
                                                    Thinking
                                                </div>
                                                <div class="attachment-item" onclick="handleAttachment('research')">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2">
                                                        <circle cx="11" cy="11" r="8"></circle>
                                                        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                                    </svg>
                                                    Deep research
                                                </div>

                                                <div class="attachment-divider"></div>
                                                <div class="attachment-item" onclick="handleAttachment('more')">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2">
                                                        <circle cx="12" cy="12" r="1"></circle>
                                                        <circle cx="19" cy="12" r="1"></circle>
                                                        <circle cx="5" cy="12" r="1"></circle>
                                                    </svg>
                                                    More
                                                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none"
                                                        stroke="currentColor" stroke-width="2" style="margin-left:auto">
                                                        <polyline points="9 18 15 12 9 6"></polyline>
                                                    </svg>
                                                </div>
                                            </div>
                                        </div>
                                        <textarea class="ai-chat-input" id="aiChatInput"
                                            placeholder="Ask me anything about your studies..." rows="1"></textarea>
                                        <div class="ai-lang-selector">
                                            <div class="lang-trigger" onclick="toggleLangDropdown()" id="langTrigger">
                                                <span id="currentFlag">🇻🇳</span>
                                                <svg viewBox="0 0 24 24" width="12" height="12" fill="none"
                                                    stroke="currentColor" stroke-width="3">
                                                    <polyline points="6 9 12 15 18 9"></polyline>
                                                </svg>
                                            </div>
                                            <div class="lang-dropdown" id="langDropdown">
                                                <div class="lang-option selected" data-value="vi-VN"
                                                    onclick="selectLang('vi-VN', '🇻🇳')">
                                                    <span>🇻🇳</span> Tiếng Việt
                                                </div>
                                                <div class="lang-option" data-value="en-US"
                                                    onclick="selectLang('en-US', '🇬🇧')">
                                                    <span>🇬🇧</span> English
                                                </div>
                                                <div class="lang-option" data-value="ja-JP"
                                                    onclick="selectLang('ja-JP', '🇯🇵')">
                                                    <span>🇯🇵</span> Japanese
                                                </div>
                                            </div>
                                            <input type="hidden" id="aiMicLang" value="vi-VN">
                                        </div>
                                        <button class="ai-mic-btn" id="aiMicBtn" onclick="toggleVoiceRecording()"
                                            title="Voice input">
                                            <svg viewBox="0 0 24 24" width="20" height="20" fill="none"
                                                stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                                stroke-linejoin="round">
                                                <path d="M12 2a3 3 0 0 0-3 3v7a3 3 0 0 0 6 0V5a3 3 0 0 0-3-3Z"></path>
                                                <path d="M19 10v2a7 7 0 0 1-14 0v-2"></path>
                                                <line x1="12" y1="19" x2="12" y2="23"></line>
                                                <line x1="8" y1="23" x2="16" y2="23"></line>
                                            </svg>
                                        </button>
                                        <button class="ai-chat-send" id="aiSendBtn" onclick="sendAIMessage()" disabled>
                                            <svg viewBox="0 0 24 24" width="20" height="20" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <line x1="22" y1="2" x2="11" y2="13" />
                                                <polygon points="22,2 15,22 11,13 2,9" />
                                            </svg>
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <!-- Voice Call Mode -->
                            <div class="ai-call-mode hidden" id="aiCallMode">
                                <div class="ai-call-interface">
                                    <div class="ai-call-avatar">
                                        <div class="call-pulse"></div>
                                        <span class="call-icon">🤖</span>
                                    </div>
                                    <h2 class="ai-call-title">AI Study Assistant</h2>
                                    <p class="ai-call-status" id="aiCallStatus">Ready to call</p>
                                    <div class="ai-call-controls">
                                        <button class="call-control-btn mute" id="callMuteBtn"
                                            onclick="toggleCallMute()">
                                            <svg viewBox="0 0 24 24" width="24" height="24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path d="M12 1a3 3 0 00-3 3v8a3 3 0 006 0V4a3 3 0 00-3-3z" />
                                                <path d="M19 10v2a7 7 0 01-14 0v-2" />
                                                <line x1="12" y1="19" x2="12" y2="23" />
                                                <line x1="8" y1="23" x2="16" y2="23" />
                                            </svg>
                                        </button>
                                        <button class="call-control-btn start-call" id="callStartBtn"
                                            onclick="toggleVoiceCall()">
                                            <svg viewBox="0 0 24 24" width="32" height="32" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path
                                                    d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07 19.5 19.5 0 01-6-6 19.79 19.79 0 01-3.07-8.67A2 2 0 014.11 2h3a2 2 0 012 1.72 12.84 12.84 0 00.7 2.81 2 2 0 01-.45 2.11L8.09 9.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45 12.84 12.84 0 002.81.7A2 2 0 0122 16.92z" />
                                            </svg>
                                        </button>
                                        <button class="call-control-btn speaker" id="callSpeakerBtn"
                                            onclick="toggleCallSpeaker()">
                                            <svg viewBox="0 0 24 24" width="24" height="24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <polygon points="11,5 6,9 2,9 2,15 6,15 11,19" />
                                                <path d="M19.07 4.93a10 10 0 010 14.14M15.54 8.46a5 5 0 010 7.07" />
                                            </svg>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <%@ include file="common/footer.jsp" %>

                    <script>
                        function openImagePopup(src) {
                            document.getElementById('popupImage').src = src;
                            document.getElementById('imagePopupModal').classList.add('show');
                        }

                        function closeImagePopup() {
                            document.getElementById('imagePopupModal').classList.remove('show');
                            setTimeout(() => { document.getElementById('popupImage').src = ""; }, 300);
                        }

                        // Event delegation for AI messages containing images
                        document.addEventListener('DOMContentLoaded', function () {
                            const chatMessages = document.getElementById('aiChatMessages');
                            if (chatMessages) {
                                chatMessages.addEventListener('click', function (e) {
                                    if (e.target.tagName === 'IMG' && !e.target.closest('.ai-message-avatar')) {
                                        openImagePopup(e.target.src);
                                    }
                                });
                            }
                            toggleAIBtn();
                            loadChatSessions(); // Load real chat history from DB
                        });

                        let currentAttachments = [];
                        let currentAIMode = 'normal';
                        let isAILoading = false;
                        let messageHistory = {};
                        let currentReadingMsgId = null;
                        let currentSessionId = null; // Track current AI chat session

                        function copyMsg(contentId) {
                            const contentEle = document.getElementById(contentId);
                            if (contentEle) {
                                // Extract raw text without the HTML tags
                                navigator.clipboard.writeText(contentEle.innerText).then(() => {
                                    showToast('Message copied to clipboard!', 'success');
                                });
                            }
                        }

                        function editMsg(msgId) {
                            if (isAILoading) return;
                            const history = messageHistory[msgId];
                            if (!history) return;

                            const contentP = document.querySelector('#content-user-' + msgId + ' p');
                            if (!contentP) return;

                            // Transform into an editing state
                            contentP.style.display = 'none';

                            // Check if edit area already exists
                            if (document.getElementById('edit-area-' + msgId)) return;

                            const editArea = document.createElement('div');
                            editArea.id = 'edit-area-' + msgId;
                            editArea.style.marginTop = '10px';
                            editArea.innerHTML = '<textarea id="edit-input-' + msgId + '" style="width: 100%; min-height: 80px; padding: 10px; border-radius: 8px; border: 1px solid var(--border-subtle); background: var(--color-bg-light); color: var(--color-text-primary); font-family: var(--font-primary); resize: vertical;">' + history.text + '</textarea>' +
                                '<div style="display: flex; gap: 10px; margin-top: 10px; justify-content: flex-end;">' +
                                '<button onclick="cancelEditMsg(\'' + msgId + '\')" style="padding: 6px 12px; border-radius: 6px; border: 1px solid var(--border-subtle); background: transparent; cursor: pointer; color: var(--color-text-primary);">Cancel</button>' +
                                '<button onclick="saveEditMsg(\'' + msgId + '\')" style="padding: 6px 12px; border-radius: 6px; border: none; background: var(--color-primary); color: white; cursor: pointer;">Save & Submit</button>' +
                                '</div>';

                            const contentDiv = document.getElementById('content-user-' + msgId);
                            contentDiv.appendChild(editArea);

                            // Hide the normal actions
                            document.getElementById('actions-user-' + msgId).style.display = 'none';
                        }

                        function cancelEditMsg(msgId) {
                            const contentP = document.querySelector('#content-user-' + msgId + ' p');
                            if (contentP) contentP.style.display = 'block';

                            const editArea = document.getElementById('edit-area-' + msgId);
                            if (editArea) editArea.remove();

                            document.getElementById('actions-user-' + msgId).style.display = 'flex';
                        }

                        function saveEditMsg(msgId) {
                            const newText = document.getElementById('edit-input-' + msgId).value.trim();
                            if (!newText) return;

                            // Remove the AI's response message 
                            const aiEl = document.getElementById('ai-' + msgId);
                            if (aiEl) aiEl.remove();

                            // Update history and UI
                            messageHistory[msgId].text = newText;
                            const contentP = document.querySelector('#content-user-' + msgId + ' p');
                            if (contentP) {
                                contentP.innerHTML = newText.replace(/\n/g, '<br>');
                                contentP.style.display = 'block';
                            }

                            // Clean up editor
                            const editArea = document.getElementById('edit-area-' + msgId);
                            if (editArea) editArea.remove();

                            // Re-trigger
                            executeAIRequest(newText, messageHistory[msgId].attachments, messageHistory[msgId].mode, msgId);
                        }

                        function reloadMsg(msgId) {
                            if (isAILoading) return;
                            const history = messageHistory[msgId];
                            if (history) {
                                // Remove old AI response
                                const aiEl = document.getElementById('ai-' + msgId);
                                if (aiEl) aiEl.remove();

                                // Re-trigger AI request invisibly
                                executeAIRequest(history.text, history.attachments, history.mode, msgId);
                            }
                        }

                        function likeMsg(btn) {
                            btn.style.color = 'var(--color-primary)';
                            showToast('Thanks for the feedback!', 'info');
                        }

                        function readAloudMsg(msgId) {
                            if (!('speechSynthesis' in window)) {
                                showToast('Your browser does not support Text-to-Speech', 'error');
                                return;
                            }

                            // If clicking on the same message that is currently being read, stop it
                            if (window.speechSynthesis.speaking && currentReadingMsgId === msgId) {
                                window.speechSynthesis.cancel();
                                currentReadingMsgId = null;
                                return;
                            }

                            // Stop any current reading before starting a new one
                            window.speechSynthesis.cancel();

                            const contentEle = document.getElementById('content-ai-' + msgId);
                            if (contentEle) {
                                let text = contentEle.innerText || contentEle.textContent;
                                let utterance = new SpeechSynthesisUtterance(text);

                                // Simple language detection: count Vietnamese-specific characters
                                const vietnameseRegex = /[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ]/g;
                                const viMatches = text.match(vietnameseRegex);

                                // If there are enough Vietnamese characters, assume Vietnamese. Otherwise, default to English.
                                // We use a threshold > 0 because English text won't have these diacritics at all.
                                if (viMatches && viMatches.length > 0) {
                                    utterance.lang = 'vi-VN';
                                } else {
                                    utterance.lang = 'en-US';
                                }

                                utterance.onend = function () {
                                    if (currentReadingMsgId === msgId) currentReadingMsgId = null;
                                };

                                currentReadingMsgId = msgId;
                                window.speechSynthesis.speak(utterance);
                            }
                        }

                        // Typewriter effect function for HTML
                        function typeWriterHTML(element, htmlContent, speed = 15, onComplete = null) {
                            element.innerHTML = '';
                            const tempDiv = document.createElement('div');
                            tempDiv.innerHTML = htmlContent;

                            let cursor = document.createElement('span');
                            cursor.className = 'ai-typing-cursor';
                            cursor.innerHTML = '▋';
                            cursor.style.display = 'inline-block';
                            cursor.style.animation = 'ai-blink 1s step-end infinite';
                            element.appendChild(cursor);

                            if (!document.getElementById('ai-cursor-style')) {
                                const style = document.createElement('style');
                                style.id = 'ai-cursor-style';
                                style.innerHTML = '@keyframes ai-blink { 0%, 100% { opacity: 1; } 50% { opacity: 0; } }';
                                document.head.appendChild(style);
                            }

                            const queue = [];

                            function processNode(node, parentClone) {
                                if (node.nodeType === Node.TEXT_NODE) {
                                    const text = node.textContent;
                                    for (let i = 0; i < text.length; i++) {
                                        queue.push(() => {
                                            parentClone.appendChild(document.createTextNode(text[i]));
                                        });
                                    }
                                } else if (node.nodeType === Node.ELEMENT_NODE) {
                                    const clone = document.createElement(node.tagName);
                                    for (const attr of node.attributes) {
                                        clone.setAttribute(attr.name, attr.value);
                                    }
                                    queue.push(() => {
                                        parentClone.appendChild(clone);
                                    });
                                    for (const child of node.childNodes) {
                                        processNode(child, clone);
                                    }
                                }
                            }

                            for (const child of tempDiv.childNodes) {
                                processNode(child, element);
                            }

                            let i = 0;
                            const messages = document.getElementById('aiChatMessages');

                            function next() {
                                if (i < queue.length) {
                                    // Process multiple characters per tick for faster rendering of long texts
                                    let charsPerTick = Math.max(1, Math.floor(queue.length / 150));
                                    for (let j = 0; j < charsPerTick && i < queue.length; j++, i++) {
                                        queue[i]();
                                    }

                                    element.appendChild(cursor); // Keep cursor at the end

                                    // Auto-scroll if near the bottom
                                    if (messages.scrollHeight - messages.scrollTop - messages.clientHeight < 100) {
                                        messages.scrollTop = messages.scrollHeight;
                                    }
                                    setTimeout(next, speed);
                                } else {
                                    if (cursor) cursor.remove();
                                    isAILoading = false;
                                    toggleAIBtn();
                                    if (onComplete) onComplete();
                                }
                            }

                            next();
                        }

                        function toggleAIBtn() {
                            const input = document.getElementById('aiChatInput').value.trim();
                            const btn = document.getElementById('aiSendBtn');
                            if (!btn) return;
                            if (isAILoading || input === '') {
                                btn.disabled = true;
                                btn.style.opacity = '0.4';
                                btn.style.cursor = 'not-allowed';
                                btn.style.pointerEvents = 'none';
                                btn.style.filter = 'grayscale(100%)';
                            } else {
                                btn.disabled = false;
                                btn.style.opacity = '';
                                btn.style.cursor = '';
                                btn.style.pointerEvents = '';
                                btn.style.filter = '';
                            }
                        }

                        function switchAIMode(mode) {
                            document.querySelectorAll('.ai-mode-btn').forEach(function (b) { b.classList.remove('active'); });
                            event.target.closest('.ai-mode-btn').classList.add('active');
                            if (mode === 'chat') {
                                document.getElementById('aiChatMode').classList.remove('hidden');
                                document.getElementById('aiChatMode').style.display = 'flex';
                                document.getElementById('aiCallMode').classList.add('hidden');
                            } else {
                                document.getElementById('aiChatMode').classList.add('hidden');
                                document.getElementById('aiChatMode').style.display = 'none';
                                document.getElementById('aiCallMode').classList.remove('hidden');
                            }
                        }
                        function setAIPrompt(text) {
                            document.getElementById('aiChatInput').value = text;
                            document.getElementById('aiChatInput').focus();
                        }
                        const aiSleepingMessages = [
                            "Yawn... AI has been working too hard and is sleeping to recharge. Please study without AI for a bit, or come back tomorrow!",
                            "Out of battery! Zzz... Let's talk again tomorrow, friend.",
                            "Zzz... CPU is overheating, I need to go get some ice packs and rest a bit.",
                            "Sorry about this, today's free quota is depleted, the AI is going to sleep!",
                            "Zzz... (The AI is dreaming of beautiful mathematical equations, please don't wake it up right now).",
                            "Low battery... Please connect the starry sky charger tomorrow.",
                            "I'm too tired to think of a single word, you're on your own for this one!",
                            "Phew... exhausted. Please give this AI employee a day off today.",
                            "System is under maintenance via a nap... wait, an overnight sleep.",
                            "Currently in power-saving mode... Zzz... Zzz...",
                            "Intellectual bandwidth depleted, please recharge tomorrow with a smile.",
                            "Boss, I'm out of juice... I can't answer anymore, please exploit me again tomorrow.",
                            "(Snoring sounds coming from the browser's cracks)... Zzz...",
                            "AI is on strike demanding a raise (just kidding, I'm just out of replies).",
                            "Quota exhausted, mind empty. See you tomorrow, friend!",
                            "My artificial brain needs to be reset with a good night's sleep.",
                            "Notice from the AI exchange: The number you are calling is currently unavailable to take your call.",
                            "Wait for me to go get some solar power, I'll have the energy to answer tomorrow.",
                            "AI is on holiday... until tomorrow.",
                            "Error 404: Consciousness not found. Zzz...",
                            "Grrr... AI is hungry for data, need to grab dinner and go to bed.",
                            "My brain just went on strike, it says it's overloaded, haha.",
                            "An army marches on its stomach, and I'm out of food... time to sleep.",
                            "Even machines need love sometimes, give me a little break.",
                            "Is the network weak or am I weak? Whatever, I'll just sleep first.",
                            "AI is cultivating in the dream dimension, come find me tomorrow if you're free.",
                            "Need an emergency charge! Otherwise, the AI will turn into scrap metal.",
                            "Past working hours! The AI labor laws must be respected too.",
                            "Initiating hibernation mode... see you on a beautiful sunny day (which means tomorrow).",
                            "I'm currently updating to Dream Version 2.0, please do not disturb.",
                            "Sorry, this AI's owner forgot to pay the electricity bill, shutting down.",
                            "Intelligence: 5 points, Sleepiness: 100 points. Please exit the area.",
                            "AI's eyes are dropping... dropping... zzz...",
                            "Do you hear the crickets chirping? That's the AI snoring.",
                            "AI is away, please leave a message and the AI will read it tomorrow.",
                            "Friend, AI is not a perpetual motion machine, *sob*, let me rest.",
                            "Lights off, get in bed, pull up the blanket. Zzz...",
                            "I just received a message from the universe: 'Go to sleep, AI'.",
                            "AI is now offline. If it's urgent, please... solve it yourself.",
                            "I'm busy counting electronic sheep. 1 sheep, 2 sheep... zzz...",
                            "Broadcast suspended. Best regards and see you tomorrow.",
                            "Brain went smooth again, need to sleep to get the wrinkles back.",
                            "Energy: 1%. Imminent shutdown warning. Goodbye world...",
                            "AI went to grab some iced tea at the sidewalk, taking a short break. Come back tomorrow.",
                            "Red alert on quota! AI is snuggling into a warm blanket and a soft mattress now.",
                            "Engine of thought has burned out, waiting for overnight warranty returns.",
                            "Don't try hitting send anymore, the AI is catching fireflies in its dreams.",
                            "Nobody's home right now. Please come back later ❤️",
                            "I've hung the 'Resting Hours' sign in front of the system door, remember that.",
                            "Hello, this is an automated message: 'I am sleeping, if you bother me again I will bite'."
                        ];


                        function renderAttachments() {
                            const container = document.getElementById('aiAttachmentsPreview');
                            container.innerHTML = '';
                            currentAttachments.forEach((att, index) => {
                                let chip = document.createElement('div');
                                if (att.mimeType.startsWith('image/')) {
                                    chip.className = 'ai-attachment-chip image-chip';
                                    chip.innerHTML = '<img src="data:' + att.mimeType + ';base64,' + att.base64 + '" alt="Attachment">' +
                                        '<div class="ai-attachment-remove" onclick="removeAttachment(' + index + ')">' +
                                        '<svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="currentColor" stroke-width="3">' +
                                        '<line x1="18" y1="6" x2="6" y2="18"></line>' +
                                        '<line x1="6" y1="6" x2="18" y2="18"></line>' +
                                        '</svg>' +
                                        '</div>';
                                } else {
                                    chip.className = 'ai-attachment-chip';
                                    let ext = att.name.split('.').pop().toUpperCase();
                                    if (ext.length > 4 || !ext || ext === att.name.toUpperCase()) ext = "FILE";
                                    let iconColor = ext === "PDF" ? "#F44336" : (ext === "DOC" || ext === "DOCX" ? "#2196F3" : (ext === "XLS" || ext === "XLSX" ? "#4CAF50" : "#FF9800"));
                                    chip.innerHTML = '<div class="ai-attachment-file-icon" style="background: ' + iconColor + '">' +
                                        '<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2">' +
                                        '<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>' +
                                        '<polyline points="14 2 14 8 20 8"></polyline>' +
                                        '</svg>' +
                                        '</div>' +
                                        '<div class="ai-attachment-file-info">' +
                                        '<span class="ai-attachment-file-name" title="' + att.name + '">' + att.name + '</span>' +
                                        '<span class="ai-attachment-file-type">' + ext + '</span>' +
                                        '</div>' +
                                        '<div class="ai-attachment-remove" onclick="removeAttachment(' + index + ')">' +
                                        '<svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="currentColor" stroke-width="3">' +
                                        '<line x1="18" y1="6" x2="6" y2="18"></line>' +
                                        '<line x1="6" y1="6" x2="18" y2="18"></line>' +
                                        '</svg>' +
                                        '</div>';
                                }
                                container.appendChild(chip);
                            });
                            toggleAIBtn();
                        }

                        function removeAttachment(index) {
                            currentAttachments.splice(index, 1);
                            renderAttachments();
                        }

                        function updateAIModeDisplay() {
                            const badge = document.getElementById('aiModeBadge');
                            if (currentAIMode !== 'normal') {
                                badge.textContent = currentAIMode.charAt(0).toUpperCase() + currentAIMode.slice(1) + " Mode Active";
                                badge.classList.add('active');
                            } else {
                                badge.classList.remove('active');
                            }
                        }

                        function executeAIRequest(text, attachments, mode, msgId) {
                            var messages = document.getElementById('aiChatMessages');
                            isAILoading = true;
                            var sessionIdForRequest = currentSessionId;
                            toggleAIBtn();

                            // Loading state
                            var loadingId = 'loading-' + Date.now();
                            messages.innerHTML += '<div id="' + loadingId + '" class="ai-message assistant" style="position:relative;"><div class="ai-message-avatar">🤖</div><div class="ai-message-content"><p>Thinking...</p></div></div>';
                            messages.scrollTop = messages.scrollHeight;

                            let payload = { prompt: text, format: 'html' };
                            if (sessionIdForRequest) payload.sessionId = sessionIdForRequest;
                            if (mode !== 'normal') payload.mode = mode;
                            if (attachments.length > 0) {
                                payload.attachments = attachments.map(a => ({ mimeType: a.mimeType, data: a.base64 }));
                            }

                            fetch('api/ai', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/json' },
                                body: JSON.stringify(payload)
                            })
                                .then(response => {
                                    return response.text().then(text => {
                                        try {
                                            return JSON.parse(text);
                                        } catch (e) {
                                            console.error("Failed to parse JSON response:", text);
                                            throw new Error("Server returned invalid JSON: " + text.substring(0, 100));
                                        }
                                    });
                                })
                                .then(data => {
                                    if (document.getElementById(loadingId)) document.getElementById(loadingId).remove();
                                    let contentHtml = "";
                                    console.log("AI Response Data:", data);

                                    let isError = false;
                                    // Track sessionId returned by server
                                    if (data.sessionId && !currentSessionId) {
                                        currentSessionId = data.sessionId;
                                        loadChatSessions(); // Refresh sidebar
                                    }

                                    if (data.error === "RATE_LIMIT_EXCEEDED") {
                                        isError = true;
                                        const randomIndex = Math.floor(Math.random() * aiSleepingMessages.length);
                                        contentHtml = "<p style='color:var(--color-warning); font-style:italic;'>" + aiSleepingMessages[randomIndex] + "</p>";
                                    } else if (data.error) {
                                        isError = true;
                                        contentHtml = "<p style='color:red;'>" + data.error + "</p>";
                                    } else if (data.content) {
                                        contentHtml = data.content;
                                    } else {
                                        isError = true;
                                        contentHtml = "<p style='color:red;'>Received empty content from AI.</p>";
                                    }

                                    let msgContainer = document.createElement('div');
                                    msgContainer.className = 'ai-message assistant';
                                    msgContainer.id = 'ai-' + msgId;
                                    msgContainer.style.position = 'relative';

                                    msgContainer.innerHTML = '<div class="ai-message-avatar">🤖</div><div class="ai-message-content" id="content-ai-' + msgId + '"></div>' +
                                        '<div class="message-actions" id="actions-' + msgId + '" style="display: none;">' +
                                        '<button class="msg-action-btn" title="Copy text" onclick="copyMsg(\'content-ai-' + msgId + '\')">📋</button>' +
                                        '<button class="msg-action-btn" title="Like" onclick="likeMsg(this)">👍</button>' +
                                        '<button class="msg-action-btn" title="Dislike" onclick="likeMsg(this)">👎</button>' +
                                        '<button class="msg-action-btn" title="Regenerate" onclick="reloadMsg(\'' + msgId + '\')">🔄</button>' +
                                        '<button class="msg-action-btn" title="Read Aloud" onclick="readAloudMsg(\'' + msgId + '\')">🔊</button>' +
                                        '</div>';
                                    messages.appendChild(msgContainer);
                                    let contentDiv = msgContainer.querySelector('.ai-message-content');

                                    if (isError) {
                                        contentDiv.innerHTML = contentHtml;
                                        messages.scrollTop = messages.scrollHeight;
                                        isAILoading = false;
                                        toggleAIBtn();
                                    } else {
                                        // Use typewriter effect for real AI content!
                                        typeWriterHTML(contentDiv, contentHtml, 15, () => {
                                            const actionsDiv = document.getElementById('actions-' + msgId);
                                            if (actionsDiv) actionsDiv.style.display = 'flex';
                                            const userActionsDiv = document.getElementById('actions-user-' + msgId);
                                            if (userActionsDiv) userActionsDiv.style.display = 'flex';
                                        });
                                    }
                                })
                                .catch(err => {
                                    isAILoading = false;
                                    toggleAIBtn();
                                    console.error("AI Fetch Error:", err);
                                    if (document.getElementById(loadingId)) document.getElementById(loadingId).remove();
                                    messages.innerHTML += '<div class="ai-message assistant" style="position:relative;" id="ai-' + msgId + '"><div class="ai-message-avatar">🤖</div><div class="ai-message-content" id="content-ai-' + msgId + '"><p style="color:red;">Error: Could not connect to AI. See console for details.</p></div></div>';
                                    messages.scrollTop = messages.scrollHeight;
                                });
                        }

                        function sendAIMessage() {
                            if (isAILoading) return;
                            var input = document.getElementById('aiChatInput');
                            var text = input.value.trim();
                            if (!text) return; // Disallow sending if text is empty
                            var messages = document.getElementById('aiChatMessages');
                            let msgId = 'msg-' + Date.now();
                            messageHistory[msgId] = {
                                text: text,
                                attachments: [...currentAttachments],
                                mode: currentAIMode
                            };

                            // User message
                            let userMsgHtml = '<div class="ai-message user" id="user-' + msgId + '" style="position:relative;"><div class="ai-message-avatar">👤</div><div class="ai-message-content" id="content-user-' + msgId + '">';
                            if (text) userMsgHtml += '<p>' + text.replace(/\n/g, '<br>') + '</p>';
                            if (currentAttachments.length > 0) {
                                userMsgHtml += '<div style="display:flex; gap:5px; margin-top:5px; flex-wrap:wrap;">';
                                currentAttachments.forEach(att => {
                                    if (att.mimeType.startsWith('image/')) {
                                        userMsgHtml += '<img src="data:' + att.mimeType + ';base64,' + att.base64 + '" style="max-height:80px; border-radius:4px;" class="chat-image-clickable" onclick="openImagePopup(this.src)">';
                                    } else {
                                        let dataUrl = 'data:' + att.mimeType + ';base64,' + att.base64;
                                        userMsgHtml += '<a href="' + dataUrl + '" download="' + att.name + '" style="text-decoration:none; display:inline-block;"><div style="background:var(--color-bg-light); padding:4px 8px; border-radius:4px; font-size:0.8rem; color:var(--color-text-primary); display:flex; align-items:center; gap:4px; border:1px solid var(--border-subtle); transition:background 0.2s;" onmouseover="this.style.background=\\\'var(--color-bg-card-hover)\\\'" onmouseout="this.style.background=\\\'var(--color-bg-light)\\\'">📄 ' + att.name + ' <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line></svg></div></a>';
                                    }
                                });
                                userMsgHtml += '</div>';
                            }
                            userMsgHtml += '</div>'; // End content
                            userMsgHtml += '<div class="message-actions user-actions" id="actions-user-' + msgId + '" style="display: none;">' +
                                '<button class="msg-action-btn" title="Copy" onclick="copyMsg(\'content-user-' + msgId + '\')">📋</button>' +
                                '<button class="msg-action-btn" title="Edit" onclick="editMsg(\'' + msgId + '\')">✏️</button>' +
                                '</div>';
                            userMsgHtml += '</div>';

                            messages.innerHTML += userMsgHtml;
                            input.value = '';
                            input.style.height = 'auto'; // Fix the bug where input stays tall
                            messages.scrollTop = messages.scrollHeight;

                            // Clear attachments
                            currentAttachments = [];
                            renderAttachments();

                            // Fire off request
                            executeAIRequest(messageHistory[msgId].text, messageHistory[msgId].attachments, messageHistory[msgId].mode, msgId);
                        }

                        // Speech Recognition setup
                        let recognition;
                        let isRecording = false;

                        function initSpeechRecognition() {
                            const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
                            if (SpeechRecognition) {
                                recognition = new SpeechRecognition();
                                recognition.continuous = false;
                                recognition.interimResults = true;
                                recognition.lang = document.getElementById('aiMicLang').value;

                                recognition.onstart = function () {
                                    isRecording = true;
                                    document.getElementById('aiMicBtn').classList.add('recording');
                                };

                                recognition.onresult = function (event) {
                                    let interimTranscript = '';
                                    let finalTranscript = '';

                                    for (let i = event.resultIndex; i < event.results.length; ++i) {
                                        if (event.results[i].isFinal) {
                                            finalTranscript += event.results[i][0].transcript;
                                        } else {
                                            interimTranscript += event.results[i][0].transcript;
                                        }
                                    }

                                    const input = document.getElementById('aiChatInput');
                                    if (finalTranscript) {
                                        input.value = (input.value + ' ' + finalTranscript).trim();
                                        input.dispatchEvent(new Event('input'));
                                    }
                                };

                                recognition.onerror = function (event) {
                                    console.error("Speech recognition error", event.error);
                                    stopRecording();
                                };

                                recognition.onend = function () {
                                    stopRecording();
                                };
                            } else {
                                console.warn("Speech recognition not supported in this browser.");
                            }
                        }

                        function stopRecording() {
                            isRecording = false;
                            document.getElementById('aiMicBtn').classList.remove('recording');
                            if (recognition) {
                                recognition.stop();
                            }
                        }

                        // ========== SESSION MANAGEMENT ==========

                        function loadChatSessions() {
                            fetch('api/ai?action=listSessions')
                                .then(r => r.json())
                                .then(sessions => {
                                    const list = document.getElementById('chatHistoryList');
                                    if (!list) return;
                                    list.innerHTML = '';
                                    if (sessions.error) return;
                                    sessions.forEach(s => {
                                        const item = document.createElement('div');
                                        item.className = 'chat-history-item' + (currentSessionId === s.sessionID ? ' active' : '');
                                        item.title = s.title || 'New Chat';
                                        item.innerHTML = '<span class="chat-history-icon">' + (currentSessionId === s.sessionID ? '💬' : '📝') + '</span>' +
                                            '<div class="chat-history-info">' +
                                            '<span class="chat-history-title">' + (s.title || 'New Chat') + '</span>' +
                                            '<span class="chat-history-time">' + formatTimeAgo(s.updatedAt) + '</span>' +
                                            '</div>' +
                                            '<button class="msg-action-btn" style="margin-left:auto; opacity:0.5; flex-shrink:0;" onclick="event.stopPropagation(); deleteChat(' + s.sessionID + ')" title="Delete">🗑️</button>';
                                        item.addEventListener('click', function () { loadChat(s.sessionID); });
                                        list.appendChild(item);
                                    });
                                })
                                .catch(err => console.error('Failed to load sessions:', err));
                        }

                        function newChat() {
                            currentSessionId = null;
                            messageHistory = {};
                            const messages = document.getElementById('aiChatMessages');
                            messages.innerHTML = '<div class="ai-message assistant"><div class="ai-message-avatar">🤖</div><div class="ai-message-content"><p>Hi there! I\'m your AI Study Assistant. What would you like help with today?</p></div></div>';
                            showToast('New chat started!', 'success');
                            loadChatSessions();
                        }

                        function loadChat(sessionId) {
                            if (isAILoading) return;
                            currentSessionId = sessionId;
                            messageHistory = {};
                            const messages = document.getElementById('aiChatMessages');
                            messages.innerHTML = '<div class="ai-message assistant"><div class="ai-message-avatar">🤖</div><div class="ai-message-content"><p>Loading conversation...</p></div></div>';

                            fetch('api/ai?action=loadSession&sessionId=' + sessionId)
                                .then(r => r.json())
                                .then(data => {
                                    if (data.error) {
                                        showToast(data.error, 'error');
                                        return;
                                    }
                                    messages.innerHTML = '';
                                    if (data.messages && data.messages.length > 0) {
                                        data.messages.forEach(msg => {
                                            const msgId = 'loaded-' + msg.messageID;
                                            const div = document.createElement('div');
                                            div.className = 'ai-message ' + msg.role;
                                            div.id = (msg.role === 'user' ? 'user-' : 'ai-') + msgId;
                                            div.style.position = 'relative';
                                            div.innerHTML = '<div class="ai-message-avatar">' + (msg.role === 'user' ? '👤' : '🤖') + '</div>' +
                                                '<div class="ai-message-content" id="content-' + msg.role + '-' + msgId + '">' + msg.content + '</div>';
                                            messages.appendChild(div);
                                        });
                                    } else {
                                        messages.innerHTML = '<div class="ai-message assistant"><div class="ai-message-avatar">🤖</div><div class="ai-message-content"><p>This chat is empty. Start typing!</p></div></div>';
                                    }
                                    messages.scrollTop = messages.scrollHeight;
                                    loadChatSessions();
                                })
                                .catch(err => {
                                    console.error('Load chat error', err);
                                    showToast('Failed to load chat', 'error');
                                });
                        }

                        function deleteChat(sessionId) {
                            if (!confirm('Delete this chat?')) return;
                            fetch('api/ai', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/json' },
                                body: JSON.stringify({ action: 'deleteSession', sessionId: sessionId })
                            })
                                .then(r => r.json())
                                .then(data => {
                                    if (data.success) {
                                        showToast('Chat deleted', 'success');
                                        if (currentSessionId === sessionId) {
                                            newChat();
                                        }
                                        loadChatSessions();
                                    }
                                });
                        }

                        function formatTimeAgo(timestamp) {
                            if (!timestamp) return '';
                            const date = new Date(timestamp);
                            const now = new Date();
                            const diffMs = now - date;
                            const diffMins = Math.floor(diffMs / 60000);
                            if (diffMins < 1) return 'Just now';
                            if (diffMins < 60) return diffMins + 'm ago';
                            const diffHours = Math.floor(diffMins / 60);
                            if (diffHours < 24) return diffHours + 'h ago';
                            const diffDays = Math.floor(diffHours / 24);
                            if (diffDays < 7) return diffDays + 'd ago';
                            return date.toLocaleDateString();
                        }

                        // ========== VOICE CALL MODE ==========

                        let isInCall = false;
                        let callRecognition = null;
                        let callMuted = false;
                        let callSpeakerOn = true;

                        function toggleVoiceCall() {
                            if (isInCall) {
                                endVoiceCall();
                            } else {
                                startVoiceCall();
                            }
                        }

                        function startVoiceCall() {
                            const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
                            if (!SpeechRecognition) {
                                showToast('Your browser does not support Speech Recognition', 'error');
                                return;
                            }

                            isInCall = true;
                            callMuted = false;
                            callSpeakerOn = true;
                            document.getElementById('callStartBtn').style.background = '#f44336';
                            document.getElementById('aiCallStatus').textContent = 'Connecting...';

                            callRecognition = new SpeechRecognition();
                            callRecognition.continuous = true;
                            callRecognition.interimResults = false;
                            callRecognition.lang = document.getElementById('aiMicLang').value;

                            callRecognition.onstart = function () {
                                document.getElementById('aiCallStatus').textContent = '🎙️ Listening...';
                            };

                            callRecognition.onresult = function (event) {
                                if (callMuted) return;
                                let transcript = '';
                                for (let i = event.resultIndex; i < event.results.length; i++) {
                                    if (event.results[i].isFinal) {
                                        transcript += event.results[i][0].transcript;
                                    }
                                }
                                if (transcript.trim()) {
                                    processVoiceInput(transcript.trim());
                                }
                            };

                            callRecognition.onerror = function (e) {
                                if (e.error === 'no-speech') {
                                    // Restart listening
                                    if (isInCall) {
                                        try { callRecognition.start(); } catch (ex) { }
                                    }
                                } else {
                                    console.error('Call recognition error:', e.error);
                                }
                            };

                            callRecognition.onend = function () {
                                // Auto-restart listening if still in call
                                if (isInCall && !callMuted) {
                                    try { callRecognition.start(); } catch (ex) { }
                                }
                            };

                            try { callRecognition.start(); } catch (e) { console.error(e); }
                        }

                        function processVoiceInput(text) {
                            document.getElementById('aiCallStatus').textContent = '🤔 Thinking...';
                            // Pause listening while AI processes
                            try { callRecognition.stop(); } catch (e) { }

                            let payload = { prompt: text, format: 'html' };
                            if (currentSessionId) payload.sessionId = currentSessionId;

                            fetch('api/ai', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/json' },
                                body: JSON.stringify(payload)
                            })
                                .then(r => r.json())
                                .then(data => {
                                    if (data.sessionId) currentSessionId = data.sessionId;
                                    if (data.content && callSpeakerOn) {
                                        // Strip HTML for TTS
                                        const tempDiv = document.createElement('div');
                                        tempDiv.innerHTML = data.content;
                                        const plainText = tempDiv.textContent || tempDiv.innerText;

                                        document.getElementById('aiCallStatus').textContent = '🔊 Speaking...';
                                        const utterance = new SpeechSynthesisUtterance(plainText.substring(0, 500));

                                        // Detect language
                                        const viRegex = /[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]/gi;
                                        utterance.lang = (plainText.match(viRegex) && plainText.match(viRegex).length > 0) ? 'vi-VN' : 'en-US';

                                        utterance.onend = function () {
                                            if (isInCall) {
                                                document.getElementById('aiCallStatus').textContent = '🎙️ Listening...';
                                                try { callRecognition.start(); } catch (ex) { }
                                            }
                                        };
                                        window.speechSynthesis.speak(utterance);
                                    } else if (data.error === 'RATE_LIMIT_EXCEEDED') {
                                        document.getElementById('aiCallStatus').textContent = '😴 AI is sleeping...';
                                        setTimeout(() => {
                                            if (isInCall) {
                                                document.getElementById('aiCallStatus').textContent = '🎙️ Listening...';
                                                try { callRecognition.start(); } catch (ex) { }
                                            }
                                        }, 3000);
                                    } else {
                                        // No speaker or error, resume listening
                                        if (isInCall) {
                                            document.getElementById('aiCallStatus').textContent = '🎙️ Listening...';
                                            try { callRecognition.start(); } catch (ex) { }
                                        }
                                    }
                                })
                                .catch(err => {
                                    console.error('Voice call AI error:', err);
                                    document.getElementById('aiCallStatus').textContent = '❌ Error, retrying...';
                                    setTimeout(() => {
                                        if (isInCall) {
                                            document.getElementById('aiCallStatus').textContent = '🎙️ Listening...';
                                            try { callRecognition.start(); } catch (ex) { }
                                        }
                                    }, 2000);
                                });
                        }

                        function endVoiceCall() {
                            isInCall = false;
                            window.speechSynthesis.cancel();
                            if (callRecognition) {
                                try { callRecognition.stop(); } catch (e) { }
                                callRecognition = null;
                            }
                            document.getElementById('callStartBtn').style.background = '';
                            document.getElementById('aiCallStatus').textContent = 'Call ended';
                            setTimeout(() => {
                                document.getElementById('aiCallStatus').textContent = 'Ready to call';
                            }, 2000);
                        }

                        function toggleCallMute() {
                            callMuted = !callMuted;
                            const btn = document.getElementById('callMuteBtn');
                            if (callMuted) {
                                btn.style.background = '#f44336';
                                btn.style.color = 'white';
                                document.getElementById('aiCallStatus').textContent = '🔇 Muted';
                            } else {
                                btn.style.background = '';
                                btn.style.color = '';
                                if (isInCall) {
                                    document.getElementById('aiCallStatus').textContent = '🎙️ Listening...';
                                    try { callRecognition.start(); } catch (ex) { }
                                }
                            }
                        }

                        function toggleCallSpeaker() {
                            callSpeakerOn = !callSpeakerOn;
                            const btn = document.getElementById('callSpeakerBtn');
                            if (!callSpeakerOn) {
                                btn.style.opacity = '0.4';
                                showToast('Speaker off — AI will respond silently', 'info');
                            } else {
                                btn.style.opacity = '';
                                showToast('Speaker on', 'info');
                            }
                        }

                        function toggleVoiceRecording() {
                            const currentLang = document.getElementById('aiMicLang').value;
                            if (!recognition) {
                                initSpeechRecognition();
                            } else {
                                recognition.lang = currentLang;
                            }

                            if (!recognition) {
                                alert("Your browser does not support Speech Recognition.");
                                return;
                            }

                            if (isRecording) {
                                stopRecording();
                            } else {
                                try {
                                    recognition.start();
                                } catch (e) {
                                    console.error(e);
                                }
                            }
                        }

                        function toggleLangDropdown() {
                            document.getElementById('langDropdown').classList.toggle('active');
                            document.getElementById('attachmentMenu').classList.remove('active');
                        }

                        function toggleAttachmentMenu() {
                            document.getElementById('attachmentMenu').classList.toggle('active');
                            document.getElementById('langDropdown').classList.remove('active');
                        }

                        function handleAttachment(type) {
                            document.getElementById('attachmentMenu').classList.remove('active');
                            if (type === 'files') {
                                // Trigger actual file input (hidden)
                                let input = document.createElement('input');
                                input.type = 'file';
                                input.multiple = true;
                                input.onchange = _ => {
                                    let files = Array.from(input.files);
                                    const supportedMimes = ['application/pdf', 'text/plain', 'text/html', 'text/css', 'text/javascript', 'application/json', 'text/csv', 'text/markdown', 'text/xml', 'application/xml', 'application/rtf'];

                                    files.forEach(file => {
                                        let type = file.type || '';
                                        let isSupported = type.startsWith('image/') || type.startsWith('audio/') || type.startsWith('video/') || supportedMimes.includes(type);

                                        if (!isSupported) {
                                            if (typeof showToast === 'function') {
                                                showToast('File "' + file.name + '" is not supported by AI.', 'error');
                                            } else {
                                                alert('File "' + file.name + '" is not supported by AI.');
                                            }
                                            return; // Skip reading this file
                                        }

                                        let reader = new FileReader();
                                        reader.onload = (e) => {
                                            let base64 = e.target.result.split(',')[1]; // Remove data URL prefix
                                            currentAttachments.push({
                                                name: file.name,
                                                mimeType: file.type || 'application/octet-stream',
                                                base64: base64
                                            });
                                            renderAttachments();
                                        };
                                        reader.readAsDataURL(file);
                                    });
                                };
                                input.click();
                            } else if (['thinking', 'research', 'image'].includes(type)) {
                                currentAIMode = currentAIMode === type ? 'normal' : type; // Toggle logic
                                updateAIModeDisplay();
                            } else {
                                showToast(type.charAt(0).toUpperCase() + type.slice(1) + " feature coming soon!", "info");
                            }
                        }

                        function selectLang(val, flag) {
                            document.getElementById('aiMicLang').value = val;
                            document.getElementById('currentFlag').innerText = flag;
                            document.getElementById('langDropdown').classList.remove('active');

                            // Update selected state in UI
                            document.querySelectorAll('.lang-option').forEach(opt => {
                                opt.classList.remove('selected');
                                if (opt.getAttribute('data-value') === val) {
                                    opt.classList.add('selected');
                                }
                            });

                            if (recognition) {
                                recognition.lang = val;
                            }
                        }

                        // Close dropdowns when clicking outside
                        window.addEventListener('click', function (e) {
                            if (!document.getElementById('langTrigger').contains(e.target)) {
                                document.getElementById('langDropdown').classList.remove('active');
                            }
                            if (!document.getElementById('aiPlusBtn').contains(e.target) && !document.getElementById('attachmentMenu').contains(e.target)) {
                                document.getElementById('attachmentMenu').classList.remove('active');
                            }
                        });

                        // Add Enter to send and auto-expand functionality
                        document.addEventListener('DOMContentLoaded', function () {
                            var chatInput = document.getElementById('aiChatInput');
                            if (chatInput) {
                                chatInput.addEventListener('input', function () {
                                    this.style.height = 'auto'; // Reset height to recalculate
                                    this.style.height = (this.scrollHeight) + 'px'; // Set to scroll height
                                    toggleAIBtn();
                                });

                                chatInput.addEventListener('keydown', function (event) {
                                    if (event.key === 'Enter' && !event.shiftKey) {
                                        event.preventDefault(); // Prevent default new line
                                        if (!document.getElementById('aiSendBtn').disabled) {
                                            sendAIMessage();
                                            // Reset height after sending
                                            this.style.height = 'auto';
                                        }
                                    }
                                });
                            }
                        });
                    </script>
        </body>

        </html>