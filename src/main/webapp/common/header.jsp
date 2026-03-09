<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/animations.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">
        <link
            href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Space+Grotesk:wght@400;500;600;700&display=swap"
            rel="stylesheet">
        <style>
            /* ===== SPA → MPA Overrides ===== */

            /* Override SPA page hiding - each JSP is its own page now */
            .page {
                display: block !important;
            }

            .page.active {
                animation: none;
            }

            /* ===== Missing CSS Variables ===== */
            :root {
                --color-surface: var(--color-bg-card);
                --shadow-xl: 0 20px 60px hsla(0, 0%, 0%, 0.5);
                --shadow-md: 0 4px 12px hsla(0, 0%, 0%, 0.3);
            }

            /* ===== Missing Utility Classes ===== */
            .btn-full {
                width: 100%;
            }

            .btn-danger {
                background: var(--color-error);
                color: white;
                border: none;
            }

            .btn-danger:hover {
                background: hsl(0, 60%, 45%);
                transform: translateY(-2px);
            }

            .btn-danger:disabled {
                opacity: 0.5;
                cursor: not-allowed;
                transform: none;
            }

            /* ===== Textarea ===== */
            .textarea {
                resize: vertical;
                min-height: 80px;
                font-family: var(--font-primary);
            }

            /* ===== Form Layout ===== */
            .form-group {
                margin-bottom: var(--spacing-md);
            }

            .form-group label {
                display: block;
                margin-bottom: var(--spacing-xs);
                font-weight: 500;
                color: var(--color-text-secondary);
                font-size: 0.9rem;
            }

            .form-actions {
                margin-top: var(--spacing-lg);
            }

            .form-options {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: var(--spacing-md);
            }

            .checkbox-label {
                display: flex;
                align-items: center;
                gap: var(--spacing-sm);
                cursor: pointer;
                font-size: 0.9rem;
                color: var(--color-text-secondary);
            }

            .checkbox-label input[type="checkbox"] {
                accent-color: var(--color-accent-primary);
            }

            /* ===== Select Dropdown ===== */
            select.input {
                appearance: none;
                -webkit-appearance: none;
                cursor: pointer;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%236b7280' stroke-width='2'%3E%3Cpolyline points='6,9 12,15 18,9'/%3E%3C/svg%3E");
                background-repeat: no-repeat;
                background-position: right 12px center;
                padding-right: 36px;
            }

            /* ===== Modal Header Layout ===== */
            .modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: var(--spacing-lg);
            }

            .modal-header h2 {
                font-family: var(--font-display);
                font-size: 1.5rem;
                font-weight: 600;
            }

            /* ===== Account Page Tab Switching ===== */
            .account-tab {
                display: none;
            }

            .account-tab.active {
                display: block;
            }

            .account-tab-header h1 {
                font-family: var(--font-display);
                font-size: 1.75rem;
                font-weight: 700;
                margin-bottom: var(--spacing-xs);
            }

            .account-tab-header p {
                color: var(--color-text-secondary);
                margin-bottom: var(--spacing-xl);
            }

            .account-section {
                background: var(--color-bg-card);
                border: var(--border-card);
                border-radius: var(--radius-lg);
                padding: var(--spacing-xl);
                margin-bottom: var(--spacing-lg);
            }

            .section-subtitle {
                font-size: 1.1rem;
                font-weight: 600;
                margin-bottom: var(--spacing-lg);
                color: var(--color-text-primary);
            }

            .section-desc {
                color: var(--color-text-secondary);
                font-size: 0.9rem;
                margin-bottom: var(--spacing-md);
            }

            /* ===== Setting Rows (Account, Language, FocusFund) ===== */
            .setting-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: var(--spacing-md) 0;
                border-bottom: var(--border-subtle);
            }

            .setting-row:last-child {
                border-bottom: none;
            }

            .setting-info {
                display: flex;
                flex-direction: column;
                gap: var(--spacing-xs);
            }

            .setting-label {
                font-weight: 500;
                color: var(--color-text-primary);
            }

            .setting-desc {
                font-size: 0.85rem;
                color: var(--color-text-muted);
            }

            /* ===== Toggle Switch ===== */
            .toggle-switch {
                position: relative;
                display: inline-block;
                width: 48px;
                height: 26px;
                flex-shrink: 0;
            }

            .toggle-switch input {
                opacity: 0;
                width: 0;
                height: 0;
            }

            .toggle-slider {
                position: absolute;
                cursor: pointer;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background-color: var(--color-bg-light);
                transition: var(--transition-base);
                border-radius: var(--radius-full);
            }

            .toggle-slider::before {
                content: "";
                position: absolute;
                height: 20px;
                width: 20px;
                left: 3px;
                bottom: 3px;
                background-color: white;
                transition: var(--transition-base);
                border-radius: 50%;
            }

            .toggle-switch input:checked+.toggle-slider {
                background: var(--gradient-primary);
            }

            .toggle-switch input:checked+.toggle-slider::before {
                transform: translateX(22px);
            }

            /* ===== Account Layout ===== */
            .account-container {
                display: grid;
                grid-template-columns: 280px 1fr;
                min-height: calc(100vh - 70px);
            }

            .account-sidebar {
                background: var(--color-bg-medium);
                border-right: var(--border-subtle);
                padding: var(--spacing-xl);
            }

            .account-sidebar-header {
                margin-bottom: var(--spacing-xl);
            }

            .account-sidebar-header h2 {
                font-family: var(--font-display);
                font-size: 1.25rem;
                font-weight: 600;
                margin-top: var(--spacing-md);
            }

            .account-nav {
                display: flex;
                flex-direction: column;
                gap: var(--spacing-xs);
            }

            .account-nav-item {
                display: flex;
                align-items: center;
                gap: var(--spacing-md);
                padding: var(--spacing-md);
                background: transparent;
                border: none;
                border-radius: var(--radius-md);
                color: var(--color-text-secondary);
                font-size: 0.9rem;
                font-weight: 500;
                cursor: pointer;
                transition: var(--transition-fast);
                font-family: var(--font-primary);
                text-align: left;
            }

            .account-nav-item:hover {
                background: var(--color-bg-light);
                color: var(--color-text-primary);
            }

            .account-nav-item.active {
                background: hsla(210, 60%, 55%, 0.1);
                color: var(--color-accent-primary);
            }

            .account-nav-item.danger {
                color: var(--color-error);
            }

            .account-nav-item.danger:hover {
                background: hsla(0, 60%, 55%, 0.1);
            }

            .account-nav-item svg {
                flex-shrink: 0;
            }

            .account-content {
                padding: var(--spacing-xl) var(--spacing-2xl);
                max-width: 800px;
            }

            /* ===== Account - Profile Avatar ===== */
            .profile-avatar-section {
                display: flex;
                align-items: center;
                gap: var(--spacing-lg);
                margin-bottom: var(--spacing-xl);
            }

            .profile-avatar-large {
                width: 80px;
                height: 80px;
                border-radius: var(--radius-full);
                background: var(--gradient-primary);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 2rem;
                font-weight: 600;
                color: var(--color-text-primary);
                flex-shrink: 0;
                overflow: hidden;
            }

            .profile-avatar-large .avatar-image {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .avatar-hint {
                font-size: 0.85rem;
                color: var(--color-text-muted);
            }

            /* ===== Account - Input Prefix ===== */
            .input-with-prefix {
                display: flex;
                align-items: center;
                background: var(--color-bg-light);
                border: var(--border-subtle);
                border-radius: var(--radius-md);
                overflow: hidden;
                transition: var(--transition-fast);
            }

            .input-with-prefix:focus-within {
                border-color: var(--color-accent-primary);
                box-shadow: 0 0 0 3px var(--color-accent-glow);
            }

            .input-prefix {
                padding: var(--spacing-md);
                background: var(--color-bg-medium);
                color: var(--color-text-muted);
                font-size: 0.95rem;
                border-right: var(--border-subtle);
            }

            .input-with-prefix .input {
                border: none;
                border-radius: 0;
                background: transparent;
            }

            .input-with-prefix .input:focus {
                box-shadow: none;
            }

            /* ===== Account - Danger Zone ===== */
            .danger-zone {
                border-color: hsla(0, 60%, 55%, 0.3);
            }

            .danger-warning {
                text-align: center;
                padding: var(--spacing-xl);
            }

            .danger-warning svg {
                color: var(--color-error);
                margin-bottom: var(--spacing-md);
            }

            .danger-warning h3 {
                color: var(--color-error);
                margin-bottom: var(--spacing-sm);
            }

            .danger-warning p {
                color: var(--color-text-secondary);
            }

            .deactivate-confirm {
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: var(--spacing-lg);
                padding-top: var(--spacing-lg);
            }

            /* ===== Account - Storage ===== */
            .storage-bar {
                width: 100%;
                height: 8px;
                background: var(--color-bg-light);
                border-radius: var(--radius-full);
                overflow: hidden;
                margin-bottom: var(--spacing-sm);
            }

            .storage-used {
                height: 100%;
                background: var(--gradient-primary);
                border-radius: var(--radius-full);
                transition: width 0.3s ease;
            }

            .storage-stats {
                display: flex;
                justify-content: space-between;
                font-size: 0.85rem;
                color: var(--color-text-muted);
            }

            /* ===== FocusFund Content Styles ===== */

            .focusfund-tab {
                display: none;
            }

            .focusfund-tab.active {
                display: block;
            }

            .focusfund-info-card {
                background: var(--color-bg-light);
                border-radius: var(--radius-lg);
                padding: var(--spacing-lg);
                border: var(--border-subtle);
            }

            .focusfund-info-card h3 {
                font-family: var(--font-display);
                font-weight: 600;
                margin-bottom: var(--spacing-md);
            }

            /* ===== FocusFund Balance Card ===== */
            .current-balance-card {
                display: flex;
                align-items: center;
                gap: var(--spacing-lg);
                padding: var(--spacing-xl);
                background: var(--gradient-card);
                border: var(--border-card);
                border-radius: var(--radius-lg);
            }

            .balance-icon {
                font-size: 2.5rem;
            }

            .balance-details {
                display: flex;
                flex-direction: column;
            }

            .balance-title {
                font-size: 0.85rem;
                color: var(--color-text-muted);
                margin-bottom: var(--spacing-xs);
            }

            .balance-amount {
                font-family: var(--font-display);
                font-size: 1.75rem;
                font-weight: 700;
                color: var(--color-text-primary);
            }

            /* ===== Active Room Container Layout ===== */
            .active-room-container {
                display: grid;
                grid-template-columns: 1fr 350px;
                min-height: calc(100vh - 70px);
            }

            @media (max-width: 900px) {
                .active-room-container {
                    grid-template-columns: 1fr;
                }

                .account-container {
                    grid-template-columns: 1fr;
                }

            }

            .room-main {
                padding: var(--spacing-xl);
                display: flex;
                flex-direction: column;
            }

            .active-room-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: var(--spacing-xl);
                flex-wrap: wrap;
                gap: var(--spacing-md);
            }

            .room-info-header {
                display: flex;
                align-items: center;
                gap: var(--spacing-md);
            }

            .active-room-title {
                font-family: var(--font-display);
                font-size: 1.5rem;
                font-weight: 600;
            }

            .room-actions {
                display: flex;
                gap: var(--spacing-sm);
            }

            /* ===== Profile Page ===== */
            .profile-page-container {
                max-width: 800px;
                margin: 0 auto;
                padding: 0 var(--spacing-xl) var(--spacing-2xl);
            }

            .profile-banner {
                height: 200px;
                background: var(--gradient-primary);
                border-radius: 0 0 var(--radius-xl) var(--radius-xl);
                position: relative;
                overflow: hidden;
            }

            .banner-overlay {
                width: 100%;
                height: 100%;
                background: var(--gradient-primary);
                opacity: 0.8;
            }

            .banner-gradient {
                width: 100%;
                height: 100%;
                background-size: cover;
                background-position: center;
            }

            .change-banner-btn {
                position: absolute;
                bottom: var(--spacing-md);
                right: var(--spacing-md);
                display: flex;
                align-items: center;
                gap: var(--spacing-sm);
                padding: var(--spacing-sm) var(--spacing-md);
                background: hsla(0, 0%, 0%, 0.5);
                backdrop-filter: blur(10px);
                border: none;
                border-radius: var(--radius-md);
                color: white;
                font-size: 0.85rem;
                cursor: pointer;
                transition: var(--transition-fast);
            }

            .change-banner-btn:hover {
                background: hsla(0, 0%, 0%, 0.7);
            }

            .profile-info-section {
                margin-top: -50px;
                padding: 0 var(--spacing-lg);
            }

            .profile-avatar-wrapper {
                margin-bottom: var(--spacing-md);
            }

            .profile-page-avatar {
                width: 100px;
                height: 100px;
                border-radius: var(--radius-full);
                background: var(--gradient-primary);
                border: 4px solid var(--color-bg-dark);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 2.5rem;
                font-weight: 700;
                color: var(--color-text-primary);
                overflow: hidden;
            }

            .profile-page-avatar .avatar-image {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .profile-details {
                display: flex;
                flex-direction: column;
                gap: var(--spacing-md);
            }

            .profile-display-name {
                font-family: var(--font-display);
                font-size: 1.75rem;
                font-weight: 700;
            }

            .profile-handle {
                color: var(--color-text-muted);
                font-size: 0.95rem;
            }

            .profile-bio-text {
                color: var(--color-text-secondary);
                line-height: 1.6;
            }

            .profile-meta {
                display: flex;
                flex-wrap: wrap;
                gap: var(--spacing-md);
            }

            .profile-meta-item {
                display: flex;
                align-items: center;
                gap: var(--spacing-xs);
                color: var(--color-text-muted);
                font-size: 0.85rem;
                text-decoration: none;
            }

            .profile-website-link {
                color: var(--color-accent-primary);
            }

            .profile-website-link:hover {
                text-decoration: underline;
            }

            .profile-stats-row {
                display: flex;
                gap: var(--spacing-xl);
            }

            .profile-stat-item {
                display: flex;
                flex-direction: column;
                align-items: center;
            }

            .stat-number {
                font-family: var(--font-display);
                font-size: 1.25rem;
                font-weight: 700;
            }

            .profile-action-buttons {
                display: flex;
                gap: var(--spacing-sm);
            }

            /* ===== Profile Tabs ===== */
            .profile-tabs {
                display: flex;
                gap: var(--spacing-xs);
                border-bottom: var(--border-subtle);
                margin: var(--spacing-xl) 0;
                padding: 0 var(--spacing-lg);
            }

            .profile-tab {
                padding: var(--spacing-md) var(--spacing-lg);
                background: transparent;
                border: none;
                border-bottom: 2px solid transparent;
                color: var(--color-text-muted);
                font-size: 0.9rem;
                font-weight: 500;
                cursor: pointer;
                transition: var(--transition-fast);
                font-family: var(--font-primary);
            }

            .profile-tab:hover {
                color: var(--color-text-primary);
            }

            .profile-tab.active {
                color: var(--color-accent-primary);
                border-bottom-color: var(--color-accent-primary);
            }

            .profile-tab-content {
                padding: 0 var(--spacing-lg);
            }

            /* ===== Posts ===== */
            .create-post-box {
                display: flex;
                align-items: center;
                gap: var(--spacing-md);
                padding: var(--spacing-md);
                background: var(--color-bg-card);
                border: var(--border-card);
                border-radius: var(--radius-lg);
                margin-bottom: var(--spacing-lg);
            }

            .create-post-avatar {
                width: 40px;
                height: 40px;
                border-radius: var(--radius-full);
                background: var(--gradient-primary);
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 600;
                flex-shrink: 0;
            }

            .post-item {
                background: var(--color-bg-card);
                border: var(--border-card);
                border-radius: var(--radius-lg);
                padding: var(--spacing-lg);
                margin-bottom: var(--spacing-md);
            }

            .post-header {
                display: flex;
                align-items: center;
                gap: var(--spacing-md);
                margin-bottom: var(--spacing-md);
            }

            .post-avatar {
                width: 40px;
                height: 40px;
                border-radius: var(--radius-full);
                background: var(--gradient-primary);
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 600;
                flex-shrink: 0;
            }

            .post-meta {
                display: flex;
                flex-direction: column;
            }

            .post-author {
                font-weight: 600;
                font-size: 0.9rem;
            }

            .post-time {
                font-size: 0.8rem;
                color: var(--color-text-muted);
            }

            .post-content {
                color: var(--color-text-secondary);
                line-height: 1.6;
                margin-bottom: var(--spacing-md);
            }

            .post-image img {
                width: 100%;
                border-radius: var(--radius-md);
                margin-bottom: var(--spacing-md);
            }

            .post-actions {
                display: flex;
                gap: var(--spacing-md);
                border-top: var(--border-subtle);
                padding-top: var(--spacing-md);
            }

            .post-action {
                display: flex;
                align-items: center;
                gap: var(--spacing-xs);
                padding: var(--spacing-xs) var(--spacing-sm);
                background: transparent;
                border: none;
                border-radius: var(--radius-md);
                color: var(--color-text-muted);
                font-size: 0.85rem;
                cursor: pointer;
                transition: var(--transition-fast);
                font-family: var(--font-primary);
            }

            .post-action:hover {
                background: var(--color-bg-light);
                color: var(--color-text-primary);
            }

            /* ===== Empty State ===== */
            .empty-state {
                text-align: center;
                padding: var(--spacing-3xl) var(--spacing-xl);
                color: var(--color-text-muted);
            }

            .empty-icon {
                font-size: 3rem;
                display: block;
                margin-bottom: var(--spacing-md);
            }

            /* ===== Achievement Grid ===== */
            .achievement-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: var(--spacing-md);
            }

            .achievement-card {
                background: var(--color-bg-card);
                border: var(--border-card);
                border-radius: var(--radius-lg);
                padding: var(--spacing-lg);
                text-align: center;
            }

            .achievement-card.locked {
                opacity: 0.5;
            }

            .achievement-badge {
                font-size: 2rem;
                display: block;
                margin-bottom: var(--spacing-sm);
            }

            /* ===== Language / Settings Page ===== */
            .settings-container {
                max-width: 800px;
                margin: 0 auto;
                padding: var(--spacing-2xl);
            }

            .settings-header {
                margin-bottom: var(--spacing-2xl);
            }

            .settings-header h1 {
                font-family: var(--font-display);
                font-size: 2rem;
                font-weight: 700;
                margin-top: var(--spacing-md);
            }

            .settings-section {
                background: var(--color-bg-card);
                border: var(--border-card);
                border-radius: var(--radius-lg);
                padding: var(--spacing-xl);
                margin-bottom: var(--spacing-lg);
            }

            .settings-section-title {
                font-family: var(--font-display);
                font-size: 1.1rem;
                font-weight: 600;
                margin-bottom: var(--spacing-lg);
            }

            .language-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
                gap: var(--spacing-sm);
            }

            .language-option {
                display: flex;
                align-items: center;
                gap: var(--spacing-sm);
                padding: var(--spacing-md);
                border: var(--border-subtle);
                border-radius: var(--radius-md);
                cursor: pointer;
                transition: var(--transition-fast);
            }

            .language-option:hover {
                background: var(--color-bg-light);
            }

            .language-option.active,
            .language-option:has(input:checked) {
                border-color: var(--color-accent-primary);
                background: hsla(210, 60%, 55%, 0.1);
            }

            .language-option input[type="radio"] {
                display: none;
            }

            .language-flag {
                font-size: 1.25rem;
            }

            .language-name {
                font-size: 0.9rem;
                font-weight: 500;
            }

            /* ===== Navbar Avatar ===== */
            .user-avatar-nav {
                width: 36px;
                height: 36px;
                border-radius: var(--radius-full);
                background: var(--gradient-primary);
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                overflow: hidden;
                transition: var(--transition-fast);
            }

            .user-avatar-nav:hover {
                box-shadow: var(--shadow-glow);
            }

            .user-avatar-nav .avatar-initial {
                font-weight: 600;
                font-size: 0.9rem;
                color: var(--color-text-primary);
            }

            .user-avatar-nav .avatar-image {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            /* ===== Profile Dropdown ===== */
            .user-profile-wrapper {
                position: relative;
            }

            .profile-dropdown {
                position: absolute;
                top: calc(100% + var(--spacing-sm));
                right: 0;
                width: 280px;
                background: var(--color-bg-card);
                border: var(--border-card);
                border-radius: var(--radius-lg);
                box-shadow: var(--shadow-card);
                overflow: hidden;
                z-index: 200;
            }

            .dropdown-header {
                display: flex;
                align-items: center;
                gap: var(--spacing-md);
                padding: var(--spacing-lg);
            }

            .dropdown-avatar {
                width: 48px;
                height: 48px;
                border-radius: var(--radius-full);
                background: var(--gradient-primary);
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 600;
                font-size: 1.1rem;
                flex-shrink: 0;
                overflow: hidden;
            }

            .dropdown-user-info {
                display: flex;
                flex-direction: column;
                overflow: hidden;
            }

            .dropdown-username {
                font-weight: 600;
                font-size: 0.95rem;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .dropdown-email {
                font-size: 0.8rem;
                color: var(--color-text-muted);
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .dropdown-divider {
                height: 1px;
                background: var(--color-bg-light);
                margin: 0;
            }

            .dropdown-menu {
                padding: var(--spacing-sm) 0;
            }

            .dropdown-item {
                display: flex;
                align-items: center;
                gap: var(--spacing-md);
                padding: var(--spacing-md) var(--spacing-lg);
                background: transparent;
                border: none;
                color: var(--color-text-secondary);
                font-size: 0.9rem;
                cursor: pointer;
                transition: var(--transition-fast);
                width: 100%;
                text-decoration: none;
                font-family: var(--font-primary);
            }

            .dropdown-item:hover {
                background: var(--color-bg-light);
                color: var(--color-text-primary);
            }

            .dropdown-item svg {
                width: 18px;
                height: 18px;
                flex-shrink: 0;
            }

            .dropdown-item.logout {
                color: var(--color-error);
            }

            .dropdown-item.logout:hover {
                background: hsla(0, 60%, 55%, 0.1);
            }

            /* ===== Notification Bell ===== */
            .notification-bell {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 40px;
                height: 40px;
                background: transparent;
                border: none;
                border-radius: var(--radius-full);
                color: var(--color-text-secondary);
                cursor: pointer;
                transition: var(--transition-fast);
                text-decoration: none;
            }

            .notification-bell:hover {
                background: hsla(210, 60%, 55%, 0.1);
                color: var(--color-text-primary);
            }

            /* ===== Anchor tag back-btn fix ===== */
            a.back-btn {
                text-decoration: none;
            }

            /* ===== Mobile Menu Toggle ===== */
            .mobile-menu-toggle {
                display: none;
                align-items: center;
                justify-content: center;
                width: 40px;
                height: 40px;
                background: transparent;
                border: none;
                border-radius: var(--radius-full);
                color: var(--color-text-secondary);
                cursor: pointer;
            }

            @media (max-width: 768px) {
                .mobile-menu-toggle {
                    display: flex;
                }

                .nav-center {
                    display: none;
                }

                .nav-user-actions {
                    gap: var(--spacing-sm);
                }
            }
        </style>