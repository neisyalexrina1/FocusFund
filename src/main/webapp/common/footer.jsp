<%@ page contentType="text/html;charset=UTF-8" language="java" %>

    <!-- Load ALL Design JavaScript files -->
    <script src="${pageContext.request.contextPath}/js/navigation.js"></script>
    <script src="${pageContext.request.contextPath}/js/ai.js"></script>
    <script src="${pageContext.request.contextPath}/js/timer.js"></script>
    <script src="${pageContext.request.contextPath}/js/audio.js"></script>
    <script src="${pageContext.request.contextPath}/js/animations.js"></script>

    <script>
        // =====================================================
        // MPA OVERRIDES - applied AFTER navigation.js loads
        // Override SPA functions for multi-page JSP mode
        // =====================================================

        (function () {
            var ctx = '${pageContext.request.contextPath}';

            // Override SPA navigateTo with real page redirects
            window.navigateTo = function (pageId) {
                var pageMap = {
                    'landing': ctx + '/index.jsp',
                    'login': ctx + '/AuthServlet',
                    'courses': ctx + '/CourseServlet',
                    'rooms': ctx + '/StudyRoomServlet',
                    'dashboard': ctx + '/DashboardServlet',
                    'profile': ctx + '/ProfileServlet',
                    'account': ctx + '/AccountServlet',
                    'ai-chat': ctx + '/ai_chat.jsp',
                    'language': ctx + '/language.jsp',
                    'focusfund': ctx + '/focusfund.jsp',
                    'challenges': ctx + '/challenges.jsp',
                    'flashcards': ctx + '/flashcards.jsp',
                    'notifications': ctx + '/notifications.jsp',
                    'onboarding': ctx + '/onboarding.jsp'
                };
                if (pageMap[pageId]) {
                    window.location.href = pageMap[pageId];
                }
            };

            // Override isLoggedIn to check server-side session
            window.isLoggedIn = function () {
                return ${ sessionScope.user != null };
            };

            // Override showLoginRequired to redirect to login page
            window.showLoginRequired = function () {
                window.location.href = ctx + '/AuthServlet';
            };

            // Override setAccountTab for MPA - navigate to account page with tab parameter
            var originalSetAccountTab = window.setAccountTab;
            window.setAccountTab = function (tabName) {
                // If we're already on the account page, use the original function
                if (document.getElementById('page-account')) {
                    if (typeof originalSetAccountTab === 'function') {
                        originalSetAccountTab(tabName);
                    }
                } else {
                    // Navigate to account page with tab parameter
                    window.location.href = ctx + '/AccountServlet?tab=' + tabName;
                }
            };

            // =====================================================
            // Re-attach data-page click delegation for MPA
            // (navigation.js uses data-page for SPA, override for MPA)
            // =====================================================
            document.addEventListener('click', function (e) {
                var target = e.target.closest('[data-page]');
                if (target) {
                    e.preventDefault();
                    e.stopImmediatePropagation();
                    var pageId = target.dataset.page;
                    window.navigateTo(pageId);
                }
            }, true); // Use capture phase to run BEFORE navigation.js handler

            // =====================================================
            // Profile dropdown toggle
            // =====================================================
            window.toggleProfileDropdown = function (event) {
                event.stopPropagation();
                var dropdown = document.getElementById('profileDropdown');
                if (dropdown) dropdown.classList.toggle('hidden');
            };

            document.addEventListener('click', function (e) {
                var dropdown = document.getElementById('profileDropdown');
                var wrapper = document.querySelector('.user-profile-wrapper');
                if (dropdown && wrapper && !wrapper.contains(e.target)) {
                    dropdown.classList.add('hidden');
                }
            });

            // =====================================================
            // Study Room stubs
            // =====================================================
            window.leaveRoom = function () {
                window.location.href = ctx + '/StudyRoomServlet';
            };

            window.toggleSettings = function () {
                showToast('Settings coming soon!', 'info');
            };

            window.resetTimer = function () {
                if (typeof window.timerReset === 'function') window.timerReset();
            };

            window.skipPhase = function () {
                if (typeof window.timerSkip === 'function') window.timerSkip();
            };
        })();
    </script>