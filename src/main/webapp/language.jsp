<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <%@ include file="common/header.jsp" %>
                <title>Language & Display - FocusFund</title>
        </head>

        <body>
            <div class="background-effects">
                <div class="stars" id="stars"></div>
                <div class="shooting-stars" id="shooting-stars"></div>
                <div class="rain" id="rain"></div>
            </div>

            <%@ include file="common/navbar.jsp" %>

                <!-- Page: Language & Display -->
                <section class="page active" id="page-language">
                    <div class="settings-page-container">
                        <aside class="settings-sidebar">
                            <div class="settings-sidebar-header">
                                <button class="back-btn"
                                    onclick="window.location.href='${pageContext.request.contextPath}/DashboardServlet'">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M19 12H5M12 19l-7-7 7-7" />
                                    </svg>
                                    Back
                                </button>
                                <h2>Language & Display</h2>
                            </div>
                            <nav class="settings-nav">
                                <button class="settings-nav-item active" data-settings-tab="language">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <circle cx="12" cy="12" r="10" />
                                        <path
                                            d="M2 12h20M12 2a15.3 15.3 0 014 10 15.3 15.3 0 01-4 10 15.3 15.3 0 01-4-10 15.3 15.3 0 014-10z" />
                                    </svg>
                                    <span>Language</span>
                                </button>
                                <button class="settings-nav-item" data-settings-tab="display">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <circle cx="12" cy="12" r="3" />
                                        <path
                                            d="M12 1v6M12 17v6M4.22 4.22l4.24 4.24M15.54 15.54l4.24 4.24M1 12h6M17 12h6M4.22 19.78l4.24-4.24M15.54 8.46l4.24-4.24" />
                                    </svg>
                                    <span>Display</span>
                                </button>
                                <button class="settings-nav-item" data-settings-tab="sound">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M11 5L6 9H2v6h4l5 4V5z" />
                                        <path d="M19.07 4.93a10 10 0 010 14.14M15.54 8.46a5 5 0 010 7.07" />
                                    </svg>
                                    <span>Sound</span>
                                </button>
                                <button class="settings-nav-item" data-settings-tab="accessibility">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <circle cx="12" cy="4" r="2" />
                                        <path d="M4 10l8 2 8-2M12 12v10" />
                                    </svg>
                                    <span>Accessibility</span>
                                </button>
                            </nav>
                        </aside>

                        <main class="settings-content">
                            <!-- Language Tab -->
                            <div class="settings-tab active" id="settings-tab-language">
                                <div class="account-tab-header">
                                    <h1>Language</h1>
                                    <p>Choose your preferred language for the interface</p>
                                </div>
                                <div class="account-section">
                                    <h3 class="section-subtitle">Display Language</h3>
                                    <div class="language-grid">
                                        <label class="lang-sel-card">
                                            <input type="radio" name="language" value="en" checked
                                                onchange="changeLanguage(this.value)">
                                            <div class="lang-sel-box">
                                                <span class="language-code">US</span>
                                                <span class="language-name">English</span>
                                            </div>
                                        </label>
                                        <label class="lang-sel-card">
                                            <input type="radio" name="language" value="vi"
                                                onchange="changeLanguage(this.value)">
                                            <div class="lang-sel-box">
                                                <span class="language-code">VN</span>
                                                <span class="language-name">Tiếng Việt</span>
                                            </div>
                                        </label>
                                        <label class="lang-sel-card">
                                            <input type="radio" name="language" value="ja"
                                                onchange="changeLanguage(this.value)">
                                            <div class="lang-sel-box">
                                                <span class="language-code">JP</span>
                                                <span class="language-name">日本語</span>
                                            </div>
                                        </label>
                                        <label class="lang-sel-card">
                                            <input type="radio" name="language" value="ko"
                                                onchange="changeLanguage(this.value)">
                                            <div class="lang-sel-box">
                                                <span class="language-code">KR</span>
                                                <span class="language-name">한국어</span>
                                            </div>
                                        </label>
                                        <label class="lang-sel-card">
                                            <input type="radio" name="language" value="zh"
                                                onchange="changeLanguage(this.value)">
                                            <div class="lang-sel-box">
                                                <span class="language-code">CN</span>
                                                <span class="language-name">中文</span>
                                            </div>
                                        </label>
                                        <label class="lang-sel-card">
                                            <input type="radio" name="language" value="es"
                                                onchange="changeLanguage(this.value)">
                                            <div class="lang-sel-box">
                                                <span class="language-code">ES</span>
                                                <span class="language-name">Español</span>
                                            </div>
                                        </label>
                                        <label class="lang-sel-card">
                                            <input type="radio" name="language" value="fr"
                                                onchange="changeLanguage(this.value)">
                                            <div class="lang-sel-box">
                                                <span class="language-code">FR</span>
                                                <span class="language-name">Français</span>
                                            </div>
                                        </label>
                                        <label class="lang-sel-card">
                                            <input type="radio" name="language" value="de"
                                                onchange="changeLanguage(this.value)">
                                            <div class="lang-sel-box">
                                                <span class="language-code">DE</span>
                                                <span class="language-name">Deutsch</span>
                                            </div>
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <!-- Display Tab -->
                            <div class="settings-tab" id="settings-tab-display">
                                <div class="account-tab-header">
                                    <h1>Display</h1>
                                    <p>Customize the appearance of the interface</p>
                                </div>
                                <div class="account-section">
                                    <h3 class="section-subtitle">Theme</h3>
                                    <div class="theme-options">
                                        <label class="theme-option">
                                            <input type="radio" name="theme" value="dark" checked
                                                onchange="changeTheme(this.value)">
                                            <div class="theme-preview dark-preview">
                                                <div class="theme-preview-header"></div>
                                                <div class="theme-preview-content"></div>
                                            </div>
                                            <span>Dark (Night Sky)</span>
                                        </label>
                                        <label class="theme-option">
                                            <input type="radio" name="theme" value="light"
                                                onchange="changeTheme(this.value)">
                                            <div class="theme-preview light-preview">
                                                <div class="theme-preview-header"></div>
                                                <div class="theme-preview-content"></div>
                                            </div>
                                            <span>Light</span>
                                        </label>
                                        <label class="theme-option">
                                            <input type="radio" name="theme" value="auto"
                                                onchange="changeTheme(this.value)">
                                            <div class="theme-preview auto-preview">
                                                <div class="theme-preview-header"></div>
                                                <div class="theme-preview-content"></div>
                                            </div>
                                            <span>Auto (System)</span>
                                        </label>
                                    </div>
                                </div>
                                <div class="account-section">
                                    <h3 class="section-subtitle">Font Size</h3>
                                    <div class="font-size-options">
                                        <button class="font-size-btn" onclick="changeFontSize('small')">A</button>
                                        <button class="font-size-btn active"
                                            onclick="changeFontSize('medium')">A</button>
                                        <button class="font-size-btn large" onclick="changeFontSize('large')">A</button>
                                    </div>
                                </div>
                                <div class="account-section">
                                    <div class="setting-row">
                                        <div class="setting-info">
                                            <span class="setting-label">Reduce Animations</span>
                                            <span class="setting-desc">Minimize motion for better accessibility</span>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox" id="toggleReduceMotion"
                                                onchange="toggleReduceMotion(this.checked)">
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                    <div class="setting-row">
                                        <div class="setting-info">
                                            <span class="setting-label">High Contrast</span>
                                            <span class="setting-desc">Increase contrast for better visibility</span>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox" id="toggleHighContrast"
                                                onchange="toggleHighContrast(this.checked)">
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <!-- Sound Tab -->
                            <div class="settings-tab" id="settings-tab-sound">
                                <div class="account-tab-header">
                                    <h1>Sound</h1>
                                    <p>Configure ambient sounds and audio settings</p>
                                </div>
                                <div class="account-section">
                                    <h3 class="section-subtitle">Ambient Sound</h3>
                                    <div class="setting-row">
                                        <div class="setting-info">
                                            <span class="setting-label">Enable Ambient Sound</span>
                                            <span class="setting-desc">Play relaxing background sounds while
                                                studying</span>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox" id="toggleAmbientSound" checked
                                                onchange="toggleAmbientSound(this.checked)">
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                    <div class="form-group" style="margin-top: var(--spacing-lg);">
                                        <label for="ambientSoundUrl">Custom Ambient Sound URL</label>
                                        <input type="url" id="ambientSoundUrl" class="input"
                                            placeholder="https://res.cloudinary.com/..."
                                            onchange="setCustomAmbientSound(this.value)">
                                        <p class="form-hint">Paste a direct link to an MP3 file (e.g., from Cloudinary)
                                        </p>
                                    </div>
                                    <div class="form-group">
                                        <label>Volume</label>
                                        <div class="volume-control">
                                            <svg viewBox="0 0 24 24" width="20" height="20" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path d="M11 5L6 9H2v6h4l5 4V5z" />
                                            </svg>
                                            <input type="range" id="ambientVolumeSlider" class="volume-slider-full"
                                                min="0" max="100" value="30" oninput="setAmbientVolume(this.value)">
                                            <span id="volumeValue">30%</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="account-section">
                                    <h3 class="section-subtitle">Notification Sounds</h3>
                                    <div class="setting-row">
                                        <div class="setting-info">
                                            <span class="setting-label">Timer Complete Sound</span>
                                            <span class="setting-desc">Play a sound when Pomodoro timer ends</span>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox" id="toggleTimerSound" checked>
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                    <div class="setting-row">
                                        <div class="setting-info">
                                            <span class="setting-label">Break Reminder Sound</span>
                                            <span class="setting-desc">Gentle reminder when break time starts</span>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox" id="toggleBreakSound" checked>
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <!-- Accessibility Tab -->
                            <div class="settings-tab" id="settings-tab-accessibility">
                                <div class="account-tab-header">
                                    <h1>Accessibility</h1>
                                    <p>Make the app easier to use for everyone</p>
                                </div>
                                <div class="account-section">
                                    <div class="setting-row">
                                        <div class="setting-info">
                                            <span class="setting-label">Screen Reader Support</span>
                                            <span class="setting-desc">Optimize for screen reader compatibility</span>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox" id="toggleScreenReader">
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                    <div class="setting-row">
                                        <div class="setting-info">
                                            <span class="setting-label">Keyboard Navigation</span>
                                            <span class="setting-desc">Enhanced keyboard navigation support</span>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox" id="toggleKeyboardNav" checked>
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                    <div class="setting-row">
                                        <div class="setting-info">
                                            <span class="setting-label">Focus Indicators</span>
                                            <span class="setting-desc">Show visible focus indicators on interactive
                                                elements</span>
                                        </div>
                                        <label class="toggle-switch">
                                            <input type="checkbox" id="toggleFocusIndicators" checked>
                                            <span class="toggle-slider"></span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </main>
                    </div>
                </section>

                <%@ include file="common/footer.jsp" %>

                    <script>
                        // === Settings Tab Navigation (data-settings-tab delegation) ===
                        document.addEventListener('click', function (e) {
                            var navItem = e.target.closest('[data-settings-tab]');
                            if (navItem && navItem.dataset.settingsTab) {
                                document.querySelectorAll('[data-settings-tab]').forEach(function (item) {
                                    item.classList.remove('active');
                                });
                                navItem.classList.add('active');

                                document.querySelectorAll('.settings-tab').forEach(function (tab) {
                                    tab.classList.remove('active');
                                });
                                var targetTab = document.getElementById('settings-tab-' + navItem.dataset.settingsTab);
                                if (targetTab) targetTab.classList.add('active');
                            }
                        });

                        // === Restore saved settings on page load ===
                        (function () {
                            var savedLang = localStorage.getItem('focusfund_language');
                            if (savedLang) {
                                var radio = document.querySelector('input[name="language"][value="' + savedLang + '"]');
                                if (radio) radio.checked = true;
                            }
                            var savedTheme = localStorage.getItem('focusfund_theme');
                            if (savedTheme) {
                                var themeRadio = document.querySelector('input[name="theme"][value="' + savedTheme + '"]');
                                if (themeRadio) themeRadio.checked = true;
                            }
                            var savedFontSize = localStorage.getItem('focusfund_fontsize');
                            if (savedFontSize) {
                                document.documentElement.style.fontSize = savedFontSize === 'small' ? '14px' : savedFontSize === 'large' ? '18px' : '16px';
                            }
                            var reduceMotion = localStorage.getItem('focusfund_reduce_motion');
                            if (reduceMotion === 'true') {
                                var el = document.getElementById('toggleReduceMotion');
                                if (el) el.checked = true;
                                document.body.classList.add('reduce-motion');
                            }
                            var highContrast = localStorage.getItem('focusfund_high_contrast');
                            if (highContrast === 'true') {
                                var el2 = document.getElementById('toggleHighContrast');
                                if (el2) el2.checked = true;
                                document.body.classList.add('high-contrast');
                            }
                            var ambientUrl = localStorage.getItem('focusfund_ambient_url');
                            if (ambientUrl) {
                                var urlInput = document.getElementById('ambientSoundUrl');
                                if (urlInput) urlInput.value = ambientUrl;
                            }
                        })();
                    </script>
        </body>

        </html>