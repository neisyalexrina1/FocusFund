// FocusFund - Navigation System
// Handles page transitions with active class toggling

(function () {
  'use strict';

  // Get all page sections
  const pages = document.querySelectorAll('.page');
  const navLinks = document.querySelectorAll('.nav-link');

  // Track current page
  let currentPage = 'landing';

  // Navigate to a page
  function navigateTo(pageId) {
    // Hide all pages
    pages.forEach(page => {
      page.classList.remove('active');
    });

    // Show target page
    const targetPage = document.getElementById(`page-${pageId}`);
    if (targetPage) {
      targetPage.classList.add('active');
      currentPage = pageId;

      // Update nav link active states
      updateNavLinks(pageId);

      // Scroll to top
      window.scrollTo(0, 0);

      // Special handling for study room
      if (pageId === 'study-room') {
        showCheckinModal();
      }

      // Update profile page data if navigating there
      if (pageId === 'profile' || pageId === 'account') {
        updateProfilePage();
      }
    }
  }

  // Update navigation link active states
  function updateNavLinks(pageId) {
    navLinks.forEach(link => {
      link.classList.remove('active');
      if (link.dataset.page === pageId) {
        link.classList.add('active');
      }
    });
  }

  // Event delegation for all navigation clicks
  document.addEventListener('click', function (e) {
    const target = e.target.closest('[data-page]');
    if (target) {
      e.preventDefault();
      const pageId = target.dataset.page;

      // If navigating to study-room from a room card, populate its data
      if (pageId === 'study-room' && target.classList.contains('room-card')) {
        const titleBadge = target.querySelector('.room-type-badge');
        const titleText = target.querySelector('.room-card-title');
        const descText = target.querySelector('.room-card-desc');
        const timerText = target.querySelector('.room-card-timer span:last-child');

        const studyRoomTitle = document.querySelector('.room-info h2');
        const studyRoomBadge = document.querySelector('.room-info .room-status');
        const studyRoomTimer = document.querySelector('#timerMinutes');

        if (studyRoomTitle && titleText) studyRoomTitle.textContent = titleText.textContent;
        // Map room type badge to status (approximate)
        if (studyRoomBadge && titleBadge) {
          const type = titleBadge.className.replace('room-type-badge', '').trim();
          studyRoomBadge.className = `room-status ${type}`;
          studyRoomBadge.textContent = titleBadge.textContent;
        }
        if (studyRoomTimer && timerText) {
          // Extract minutes from text like '25/5 Pomodoro' or '90/20 Deep Work'
          const timerMatch = timerText.textContent.match(/^(\d+)/);
          if (timerMatch) {
            studyRoomTimer.textContent = timerMatch[1];
          }
        }
      }

      navigateTo(pageId);
    }
  });

  // Handle browser back/forward (if needed in future)
  window.addEventListener('popstate', function (e) {
    if (e.state && e.state.page) {
      navigateTo(e.state.page);
    }
  });

  // Expose navigation function globally
  window.navigateTo = navigateTo;

  // Study Rooms - Filter Rooms function (was called from HTML but not defined)
  window.filterRooms = function (filter) {
    if (!window.isLoggedIn()) {
      showLoginRequired();
      return;
    }
    // Update active filter button
    document.querySelectorAll('.filter-btn').forEach(btn => {
      btn.classList.remove('active');
    });
    const clickedBtn = event?.target?.closest('.filter-btn');
    if (clickedBtn) clickedBtn.classList.add('active');

    const allRooms = document.querySelectorAll('.room-card:not(.create-room)');
    allRooms.forEach(card => {
      if (filter === 'all') {
        card.style.display = '';
      } else {
        const badge = card.querySelector('.room-type-badge');
        const type = badge ? badge.className.replace('room-type-badge', '').trim() : '';
        card.style.display = type.includes(filter) ? '' : 'none';
      }
    });
  };

  // Study Rooms - Create Room function (was called from HTML but not defined)
  window.createNewRoom = function (e) {
    e.preventDefault();
    const name = document.getElementById('newRoomName')?.value?.trim();
    if (!name) {
      showToast('Please enter a room name', 'error');
      return;
    }
    closeCreateRoomModal();
    showToast(`Room "${name}" created successfully!`, 'success');
  };

  window.showCreateRoomModal = function () {
    if (!window.isLoggedIn()) {
      showLoginRequired();
      return;
    }
    const modal = document.getElementById('createRoomModal');
    if (modal) modal.classList.remove('hidden');
  };

  window.closeCreateRoomModal = function () {
    const modal = document.getElementById('createRoomModal');
    if (modal) modal.classList.add('hidden');
  };

  // Onboarding step functions
  window.nextStep = function (stepNumber) {
    // Hide all steps
    document.querySelectorAll('.onboarding-step').forEach(step => {
      step.classList.remove('active');
    });

    // Show target step
    const targetStep = document.getElementById(`step-${stepNumber}`);
    if (targetStep) {
      targetStep.classList.add('active');
    }

    // Update progress indicators
    document.querySelectorAll('.progress-step').forEach(indicator => {
      const step = parseInt(indicator.dataset.step);
      indicator.classList.remove('active', 'completed');
      if (step < stepNumber) {
        indicator.classList.add('completed');
      } else if (step === stepNumber) {
        indicator.classList.add('active');
      }
    });
  };

  window.prevStep = function (stepNumber) {
    window.nextStep(stepNumber);
  };

  // Check-in modal functions
  window.showCheckinModal = function () {
    if (!window.isLoggedIn()) {
      showLoginRequired();
      return;
    }
    const modal = document.getElementById('checkinModal');
    if (modal) {
      modal.classList.remove('hidden');
    }
  };

  window.completeCheckin = function () {
    const modal = document.getElementById('checkinModal');
    const input = document.getElementById('checkinInput');
    const goalDisplay = document.getElementById('sessionGoal');

    // Validate that a goal was entered
    if (input && !input.value.trim()) {
      input.style.borderColor = 'var(--color-error, #ef4444)';
      input.placeholder = 'Please enter your focus goal...';
      input.focus();
      showToast('Please enter what you will focus on today', 'error');
      return;
    }

    // Reset border if previously errored
    if (input) input.style.borderColor = '';

    if (modal) {
      modal.classList.add('hidden');
    }

    if (input && goalDisplay && input.value.trim()) {
      goalDisplay.textContent = `Goal: ${input.value.trim()}`;
    }
  };

  // Auth functions
  window.switchAuthTab = function (tab) {
    const loginForm = document.getElementById('loginForm');
    const signupForm = document.getElementById('signupForm');
    const forgotForm = document.getElementById('forgotForm');
    const tabs = document.querySelectorAll('.auth-tab');

    tabs.forEach(t => t.classList.remove('active'));

    // Hide all forms
    loginForm.classList.add('hidden');
    signupForm.classList.add('hidden');
    if (forgotForm) forgotForm.classList.add('hidden');

    if (tab === 'login') {
      tabs[0].classList.add('active');
      loginForm.classList.remove('hidden');
    } else {
      tabs[1].classList.add('active');
      signupForm.classList.remove('hidden');
    }
  };

  window.handleLogin = function (e) {
    e.preventDefault();
    const identifier = document.getElementById('loginEmailOrUsername').value.trim();
    const password = document.getElementById('loginPassword').value;

    if (!identifier) {
      showToast('Please enter your email or username', 'error');
      return;
    }
    if (!password) {
      showToast('Please enter your password', 'error');
      return;
    }

    // Check if logging in with email or username
    let email, name;
    if (identifier.includes('@')) {
      email = identifier;
      name = identifier.split('@')[0];
    } else {
      // Using username (remove @ if present)
      const username = identifier.replace(/^@/, '');
      email = `${username}@email.com`;
      name = username;
    }

    // Simulate login - check stored users or create session
    const storedUser = localStorage.getItem('focusfund_user');
    if (storedUser) {
      const userData = JSON.parse(storedUser);
      updateAuthUI(true, userData.name, userData.email);
    } else {
      localStorage.setItem('focusfund_user', JSON.stringify({
        name,
        email,
        handle: name.toLowerCase().replace(/\s+/g, '_'),
        bio: 'Passionate learner. Focus enthusiast.',
        joinedDate: new Date().toISOString()
      }));
      updateAuthUI(true, name, email);
    }
    navigateTo('dashboard');
    showToast('Welcome back!', 'success');
  };

  window.handleSignup = function (e) {
    e.preventDefault();
    const name = document.getElementById('signupName').value.trim();
    const username = document.getElementById('signupUsername').value.trim().toLowerCase();
    const email = document.getElementById('signupEmail').value.trim();
    const password = document.getElementById('signupPassword').value;
    const confirm = document.getElementById('signupConfirm').value;
    const errorEl = document.getElementById('signupError');

    // Validate passwords match
    if (password !== confirm) {
      errorEl.textContent = 'Passwords do not match';
      errorEl.classList.remove('hidden');
      showToast('Passwords do not match', 'error');
      return;
    }

    // Validate password length
    if (password.length < 8) {
      errorEl.textContent = 'Password must be at least 8 characters';
      errorEl.classList.remove('hidden');
      showToast('Password must be at least 8 characters', 'error');
      return;
    }

    // Validate username
    if (!/^[a-z0-9_]+$/.test(username)) {
      errorEl.textContent = 'Username can only contain lowercase letters, numbers, and underscores';
      errorEl.classList.remove('hidden');
      showToast('Invalid username format', 'error');
      return;
    }

    errorEl.classList.add('hidden');

    // Simulate signup
    localStorage.setItem('focusfund_user', JSON.stringify({
      name,
      email,
      handle: username,
      bio: 'Passionate learner. Focus enthusiast. Building better study habits one Pomodoro at a time. 🎯',
      location: 'Vietnam',
      website: '',
      joinedDate: new Date().toISOString(),
      isGuest: false
    }));
    updateAuthUI(true, name, email);
    navigateTo('onboarding');
    showToast('Account created successfully!', 'success');
  };

  window.showForgotPassword = function () {
    document.getElementById('loginForm').classList.add('hidden');
    document.getElementById('signupForm').classList.add('hidden');
    document.getElementById('forgotForm').classList.remove('hidden');
    document.querySelectorAll('.auth-tab').forEach(t => t.classList.remove('active'));
  };

  window.handleForgotPassword = function (e) {
    e.preventDefault();
    const email = document.getElementById('forgotEmail').value.trim();
    const successEl = document.getElementById('forgotSuccess');
    const errorEl = document.getElementById('forgotError');

    // Simulate sending reset email
    errorEl.classList.add('hidden');
    successEl.textContent = `Password reset link sent to ${email}. Please check your inbox.`;
    successEl.classList.remove('hidden');

    showToast('Reset link sent!', 'success');
  };


  window.socialLogin = function (provider) {
    const name = provider === 'google' ? 'Google User' : 'GitHub User';
    const email = `user@${provider}.com`;
    const handle = provider === 'google' ? 'googleuser' : 'githubuser';
    localStorage.setItem('focusfund_user', JSON.stringify({
      name,
      email,
      handle,
      bio: 'Passionate learner. Focus enthusiast. Building better study habits one Pomodoro at a time. 🎯',
      location: 'Vietnam',
      joinedDate: new Date().toISOString(),
      isGuest: false
    }));
    updateAuthUI(true, name, email);
    navigateTo('dashboard');
    showToast(`Signed in with ${provider}!`, 'success');
  };

  window.logout = function () {
    localStorage.removeItem('focusfund_user');
    localStorage.removeItem('focusfund_settings');
    localStorage.removeItem('focusfund_avatar');
    localStorage.removeItem('focusfund_banner');
    updateAuthUI(false);
    closeProfileDropdown();
    navigateTo('landing');
    showToast('Logged out successfully', 'success');
  };

  function updateAuthUI(isLoggedIn, name = '', email = '') {
    const navAuth = document.getElementById('navAuth');
    const navUser = document.getElementById('navUser');
    const startJourneyBtn = document.getElementById('startJourneyBtn');
    const mobileNavAuth = document.getElementById('mobileNavAuth');
    const mobileNavUser = document.getElementById('mobileNavUser');
    const createPostSection = document.getElementById('createPostSection');

    if (isLoggedIn) {
      navAuth.classList.add('hidden');
      navUser.classList.remove('hidden');

      // Update mobile nav
      if (mobileNavAuth) mobileNavAuth.classList.add('hidden');
      if (mobileNavUser) mobileNavUser.classList.remove('hidden');

      // Hide start journey button when logged in
      if (startJourneyBtn) startJourneyBtn.style.display = 'none';

      const initial = name.charAt(0).toUpperCase();
      const savedAvatar = localStorage.getItem('focusfund_avatar');

      // Update all avatar locations
      updateAllAvatars(initial, savedAvatar);

      // Update dropdown info
      const dropdownUsername = document.getElementById('dropdownUsername');
      const dropdownEmail = document.getElementById('dropdownEmail');
      if (dropdownUsername) dropdownUsername.textContent = name;
      if (dropdownEmail) dropdownEmail.textContent = email;

      // Update FocusFund balance display in dropdown
      updateDropdownBalance();

      // Update profile form fields with actual user data
      const userData = JSON.parse(localStorage.getItem('focusfund_user') || '{}');
      const profileUsername = document.getElementById('profileUsername');
      const profileEmail = document.getElementById('profileEmail');
      const profileHandleInput = document.getElementById('profileHandle');
      const profileBio = document.getElementById('profileBio');
      const profileLocation = document.getElementById('profileLocation');
      const profileWebsite = document.getElementById('profileWebsite');

      if (profileUsername) profileUsername.value = userData.name || name;
      if (profileEmail) profileEmail.value = userData.email || email;
      if (profileHandleInput) profileHandleInput.value = userData.handle || '';
      if (profileBio) profileBio.value = userData.bio || '';
      if (profileLocation) profileLocation.value = userData.location || '';
      if (profileWebsite) profileWebsite.value = userData.website || '';

      // Update create post avatar and visibility for guests
      if (typeof updateCreatePostAvatar === 'function') updateCreatePostAvatar();

      // Hide create post section for guests
      if (createPostSection) {
        if (userData.isGuest) {
          createPostSection.style.display = 'none';
        } else {
          createPostSection.style.display = '';
        }
      }

    } else {
      navAuth.classList.remove('hidden');
      navUser.classList.add('hidden');

      // Update mobile nav
      if (mobileNavAuth) mobileNavAuth.classList.remove('hidden');
      if (mobileNavUser) mobileNavUser.classList.add('hidden');

      // Show start journey button when logged out
      if (startJourneyBtn) startJourneyBtn.style.display = '';

      // Hide create post section when not logged in
      if (createPostSection) createPostSection.style.display = 'none';
    }
  }

  function updateDropdownBalance() {
    const focusfundEnabled = localStorage.getItem('focusfund_enabled') === 'true';
    const balance = parseInt(localStorage.getItem('focusfund_balance') || '0');
    const balanceEl = document.getElementById('dropdownBalance');

    if (balanceEl) {
      if (focusfundEnabled) {
        balanceEl.textContent = `💰 ${formatVND(balance)}`;
        balanceEl.classList.remove('hidden');
      } else {
        balanceEl.classList.add('hidden');
      }
    }
  }

  function formatVND(amount) {
    return new Intl.NumberFormat('vi-VN').format(amount) + ' VND';
  }

  function updateAllAvatars(initial, avatarDataUrl) {
    const avatarLocations = [
      { img: 'navAvatarImage', text: 'navAvatarInitial' },
      { img: 'dropdownAvatarImage', text: 'dropdownAvatarInitial' },
      { img: 'settingsAvatarImage', text: 'settingsAvatarInitial' },
      { img: 'profilePageAvatarImage', text: 'profilePageAvatarInitial' },
      { img: 'roomUserAvatarImg', text: 'roomUserAvatarInitial' }
    ];

    avatarLocations.forEach(({ img, text }) => {
      const imgEl = document.getElementById(img);
      const textEl = document.getElementById(text);

      if (avatarDataUrl) {
        if (imgEl) {
          imgEl.src = avatarDataUrl;
          imgEl.classList.remove('hidden');
        }
        if (textEl) textEl.classList.add('hidden');
      } else {
        if (imgEl) imgEl.classList.add('hidden');
        if (textEl) {
          textEl.classList.remove('hidden');
          textEl.textContent = initial;
        }
      }
    });

    // Update post avatars too
    const postAvatars = document.querySelectorAll('[id^="postAvatar"]');
    postAvatars.forEach(el => {
      if (avatarDataUrl) {
        el.innerHTML = `<img src="${avatarDataUrl}" alt="" class="post-avatar-img" style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">`;
      } else {
        el.textContent = initial;
      }
    });

    // Update create post avatar
    const createPostAvatar = document.getElementById('createPostAvatar');
    if (createPostAvatar) {
      if (avatarDataUrl) {
        createPostAvatar.innerHTML = `<img src="${avatarDataUrl}" alt="" style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">`;
      } else {
        createPostAvatar.textContent = initial;
      }
    }

    // Update room user name
    const userData = JSON.parse(localStorage.getItem('focusfund_user') || '{}');
    const roomUserName = document.getElementById('roomUserName');
    if (roomUserName && userData.name) {
      roomUserName.textContent = userData.name;
    }
  }

  // Profile Dropdown Functions
  window.toggleProfileDropdown = function (e) {
    e.stopPropagation();
    const dropdown = document.getElementById('profileDropdown');
    const notifDropdown = document.getElementById('notificationDropdown');

    // Close notification dropdown if open
    if (notifDropdown) notifDropdown.classList.add('hidden');

    dropdown.classList.toggle('hidden');
  };

  window.closeProfileDropdown = function () {
    const dropdown = document.getElementById('profileDropdown');
    if (dropdown) dropdown.classList.add('hidden');
  };

  // Notification Dropdown Functions
  window.toggleNotificationDropdown = function (e) {
    e.stopPropagation();
    const dropdown = document.getElementById('notificationDropdown');
    const profileDropdown = document.getElementById('profileDropdown');

    // Close profile dropdown if open
    if (profileDropdown) profileDropdown.classList.add('hidden');

    dropdown.classList.toggle('hidden');
  };

  window.closeNotificationDropdown = function () {
    const dropdown = document.getElementById('notificationDropdown');
    if (dropdown) dropdown.classList.add('hidden');
  };

  window.markAllNotificationsRead = function () {
    const items = document.querySelectorAll('.notification-item, .notification-full-item');
    items.forEach(item => item.classList.remove('unread'));

    const badge = document.getElementById('notificationBadge');
    if (badge) {
      badge.textContent = '';
      badge.style.display = 'none';
    }
    // Persist read state
    localStorage.setItem('focusfund_notif_read', 'true');
    showToast('All notifications marked as read', 'success');
  };

  // Break chat send message function
  window.sendBreakMessage = function () {
    const input = document.getElementById('breakChatInput');
    if (!input || !input.value.trim()) return;

    const messagesContainer = document.querySelector('.break-chat-messages');
    if (!messagesContainer) return;

    const msg = document.createElement('div');
    msg.className = 'chat-message';
    msg.innerHTML = `<span class="chat-author">You:</span><p>${input.value.trim()}</p>`;
    messagesContainer.appendChild(msg);
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
    input.value = '';
  };

  // Initialize notification badge from saved state
  (function initNotificationBadge() {
    const badge = document.getElementById('notificationBadge');
    if (!badge) return;
    const isRead = localStorage.getItem('focusfund_notif_read') === 'true';
    if (isRead) {
      badge.textContent = '';
      badge.style.display = 'none';
    } else {
      badge.textContent = '3';
      badge.style.display = '';
    }
  })();

  // Close dropdowns when clicking outside
  document.addEventListener('click', function (e) {
    const profileDropdown = document.getElementById('profileDropdown');
    const profileAvatar = document.getElementById('userAvatarNav');
    const notifDropdown = document.getElementById('notificationDropdown');
    const notifBell = document.getElementById('notificationBell');
    const mobileNav = document.getElementById('mobileNav');
    const mobileToggle = document.getElementById('mobileMenuToggle');

    if (profileDropdown && !profileDropdown.contains(e.target) && e.target !== profileAvatar && !profileAvatar?.contains(e.target)) {
      profileDropdown.classList.add('hidden');
    }

    if (notifDropdown && !notifDropdown.contains(e.target) && e.target !== notifBell && !notifBell?.contains(e.target)) {
      notifDropdown.classList.add('hidden');
    }

    // Close mobile nav when clicking outside
    if (mobileNav && mobileToggle && !mobileNav.contains(e.target) && !mobileToggle.contains(e.target)) {
      mobileNav.classList.remove('active');
    }
  });

  // Account Settings Functions
  window.setAccountTab = function (tabName) {
    // Update nav items
    document.querySelectorAll('.account-nav-item').forEach(item => {
      item.classList.remove('active');
      if (item.dataset.tab === tabName) {
        item.classList.add('active');
      }
    });

    // Update tab content
    document.querySelectorAll('.account-tab').forEach(tab => {
      tab.classList.remove('active');
    });
    const targetTab = document.getElementById(`tab-${tabName}`);
    if (targetTab) targetTab.classList.add('active');
  };

  // Settings Tab (Language & Display page)
  window.setSettingsTab = function (tabName) {
    document.querySelectorAll('.settings-nav-item').forEach(item => {
      item.classList.remove('active');
      if (item.dataset.settingsTab === tabName) {
        item.classList.add('active');
      }
    });

    document.querySelectorAll('.settings-tab').forEach(tab => {
      tab.classList.remove('active');
    });
    const targetTab = document.getElementById(`settings-tab-${tabName}`);
    if (targetTab) targetTab.classList.add('active');
  };

  // Initialize settings nav clicks
  document.addEventListener('click', function (e) {
    const navItem = e.target.closest('.account-nav-item');
    if (navItem && navItem.dataset.tab) {
      setAccountTab(navItem.dataset.tab);
    }

    const settingsNavItem = e.target.closest('.settings-nav-item');
    if (settingsNavItem && settingsNavItem.dataset.settingsTab) {
      setSettingsTab(settingsNavItem.dataset.settingsTab);
    }
  });

  // Avatar Upload - Real implementation with localStorage
  window.handleAvatarUpload = function (e) {
    const file = e.target.files[0];
    if (!file) return;

    // Validate file type
    if (!file.type.startsWith('image/')) {
      showToast('Please select an image file', 'error');
      return;
    }

    // Validate file size (max 5MB)
    if (file.size > 5 * 1024 * 1024) {
      showToast('Image must be less than 5MB', 'error');
      return;
    }

    const reader = new FileReader();
    reader.onload = function (event) {
      const dataUrl = event.target.result;

      // Save to localStorage
      localStorage.setItem('focusfund_avatar', dataUrl);

      // Update all avatar displays
      const userData = JSON.parse(localStorage.getItem('focusfund_user') || '{}');
      const initial = (userData.name || 'U').charAt(0).toUpperCase();
      updateAllAvatars(initial, dataUrl);

      showToast('Avatar updated successfully!', 'success');
    };
    reader.readAsDataURL(file);
  };

  window.removeAvatar = function () {
    localStorage.removeItem('focusfund_avatar');
    const userData = JSON.parse(localStorage.getItem('focusfund_user') || '{}');
    const initial = (userData.name || 'U').charAt(0).toUpperCase();
    updateAllAvatars(initial, null);
    showToast('Avatar removed', 'success');
  };

  // Banner Upload
  window.handleBannerUpload = function (e) {
    const file = e.target.files[0];
    if (!file) return;

    if (!file.type.startsWith('image/')) {
      showToast('Please select an image file', 'error');
      return;
    }

    // Validate file size (max 10MB for banners)
    if (file.size > 10 * 1024 * 1024) {
      showToast('Image must be less than 10MB', 'error');
      return;
    }

    const reader = new FileReader();
    reader.onload = function (event) {
      const dataUrl = event.target.result;
      localStorage.setItem('focusfund_banner', dataUrl);

      // Update all banner locations
      updateAllBanners(dataUrl);

      showToast('Banner updated successfully!', 'success');
    };
    reader.readAsDataURL(file);
  };

  function updateAllBanners(bannerDataUrl) {
    const bannerElements = ['profileBanner', 'settingsBanner'];
    bannerElements.forEach(id => {
      const el = document.getElementById(id);
      if (el) {
        if (bannerDataUrl) {
          el.style.backgroundImage = `url(${bannerDataUrl})`;
        } else {
          el.style.backgroundImage = '';
        }
      }
    });
  }

  // Profile Page Functions
  function updateProfilePage() {
    const userData = JSON.parse(localStorage.getItem('focusfund_user') || '{}');
    const avatar = localStorage.getItem('focusfund_avatar');
    const banner = localStorage.getItem('focusfund_banner');

    // Update display name and handle on public profile
    const displayName = document.getElementById('profileDisplayName');
    const handleDisplay = document.getElementById('profileHandleDisplay');
    const bioText = document.getElementById('profileBioText');

    if (displayName) displayName.textContent = userData.name || 'User';
    if (handleDisplay) handleDisplay.textContent = `@${userData.handle || 'user'}`;
    if (bioText) bioText.textContent = userData.bio || 'No bio yet';

    // Update banner
    if (banner) {
      const bannerEl = document.getElementById('profileBanner');
      if (bannerEl) bannerEl.style.backgroundImage = `url(${banner})`;
    }

    // Update avatar
    const initial = (userData.name || 'U').charAt(0).toUpperCase();
    updateAllAvatars(initial, avatar);

    // Update location display
    const locationDisplay = document.getElementById('profileLocationDisplay');
    if (locationDisplay) {
      const loc = userData.location || 'Vietnam';
      locationDisplay.innerHTML = `
        <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>
        ${loc}
      `;
    }

    // Update website display
    const websiteDisplay = document.getElementById('profileWebsiteDisplay');
    const websiteText = document.getElementById('profileWebsiteText');
    if (websiteDisplay && websiteText) {
      if (userData.website) {
        websiteDisplay.classList.remove('hidden');
        websiteDisplay.href = userData.website;
        websiteText.textContent = userData.websiteName || userData.website.replace(/^https?:\/\//, '').replace(/\/$/, '');
      } else {
        websiteDisplay.classList.add('hidden');
      }
    }

    // Also update settings form fields
    const profileUsername = document.getElementById('profileUsername');
    const profileEmail = document.getElementById('profileEmail');
    const profileHandleInput = document.getElementById('profileHandle');
    const profileBio = document.getElementById('profileBio');
    const profileLocation = document.getElementById('profileLocation');
    const profileWebsite = document.getElementById('profileWebsite');
    const profileWebsiteName = document.getElementById('profileWebsiteName');

    if (profileUsername) profileUsername.value = userData.name || '';
    if (profileEmail) profileEmail.value = userData.email || '';
    if (profileHandleInput) profileHandleInput.value = userData.handle || '';
    if (profileBio) profileBio.value = userData.bio || '';

    // Handle country select dropdown
    if (profileLocation) {
      if (profileLocation.tagName === 'SELECT') {
        const options = Array.from(profileLocation.options);
        const location = userData.location || 'Vietnam';
        const matchingOption = options.find(opt => opt.value === location);
        if (matchingOption) {
          profileLocation.value = location;
        } else if (userData.location) {
          profileLocation.value = 'Other';
        }
      } else {
        profileLocation.value = userData.location || '';
      }
    }
    if (profileWebsite) profileWebsite.value = userData.website || '';
    if (profileWebsiteName) profileWebsiteName.value = userData.websiteName || '';
  }

  window.switchProfileTab = function (tabName) {
    document.querySelectorAll('.profile-tab').forEach(tab => {
      tab.classList.remove('active');
      if (tab.textContent.toLowerCase().includes(tabName)) {
        tab.classList.add('active');
      }
    });

    // Hide all tab contents except create-post-section
    const tabIds = ['tab-posts', 'tab-achievements', 'tab-courses', 'tab-stats'];
    tabIds.forEach(id => {
      const el = document.getElementById(id);
      if (el) el.classList.add('hidden');
    });

    // Show selected tab
    const targetTab = document.getElementById(`tab-${tabName}`);
    if (targetTab) targetTab.classList.remove('hidden');

    // Show/hide create post section (only visible on posts tab)
    const createPostSection = document.getElementById('createPostSection');
    if (createPostSection) {
      const userData = JSON.parse(localStorage.getItem('focusfund_user') || '{}');
      if (tabName === 'posts' && !userData.isGuest) {
        createPostSection.style.display = '';
      } else {
        createPostSection.style.display = 'none';
      }
    }
  };

  window.shareProfile = function () {
    const userData = JSON.parse(localStorage.getItem('focusfund_user') || '{}');
    const handle = userData.handle || 'user';
    const url = `${window.location.origin}/profile/${handle}`;

    if (navigator.share) {
      navigator.share({ title: 'My FocusFund Profile', url });
    } else {
      navigator.clipboard.writeText(url);
      showToast('Profile link copied to clipboard!', 'success');
    }
  };

  window.saveProfile = function (e) {
    e.preventDefault();
    const name = document.getElementById('profileUsername')?.value?.trim() || '';
    const email = document.getElementById('profileEmail')?.value?.trim() || '';
    const bio = document.getElementById('profileBio')?.value?.trim() || '';
    const handle = document.getElementById('profileHandle')?.value?.trim().replace(/^@/, '') || '';
    const location = document.getElementById('profileLocation')?.value?.trim() || '';
    const website = document.getElementById('profileWebsite')?.value?.trim() || '';
    const websiteName = document.getElementById('profileWebsiteName')?.value?.trim() || '';

    if (!name) {
      showToast('Display name is required', 'error');
      return;
    }

    if (!handle) {
      showToast('Username is required', 'error');
      return;
    }

    // Validate handle format
    if (!/^[a-z0-9_]+$/.test(handle)) {
      showToast('Username can only contain lowercase letters, numbers, and underscores', 'error');
      return;
    }

    const existingData = JSON.parse(localStorage.getItem('focusfund_user') || '{}');
    const user = { ...existingData, name, email, bio, handle, location, website, websiteName };
    localStorage.setItem('focusfund_user', JSON.stringify(user));

    // Update UI immediately
    const initial = name.charAt(0).toUpperCase();
    const avatar = localStorage.getItem('focusfund_avatar');
    updateAllAvatars(initial, avatar);
    updateAuthUI(true, name, email);
    updateProfilePage();

    showToast('Profile saved successfully!', 'success');
  };

  // Bio character count
  document.addEventListener('input', function (e) {
    if (e.target.id === 'profileBio') {
      const count = e.target.value.length;
      const countEl = document.getElementById('bioCharCount');
      if (countEl) countEl.textContent = count;
    }
  });

  // Security Functions
  window.updatePasswordStrength = function (password) {
    const bars = document.querySelectorAll('.strength-bar');
    const text = document.querySelector('.strength-text');

    let strength = 0;
    if (password.length >= 8) strength++;
    if (/[A-Z]/.test(password)) strength++;
    if (/[0-9]/.test(password)) strength++;
    if (/[^A-Za-z0-9]/.test(password)) strength++;

    const levels = ['', 'weak', 'fair', 'good', 'strong'];
    const labels = ['Password strength', 'Weak', 'Fair', 'Good', 'Strong'];

    bars.forEach((bar, i) => {
      bar.className = 'strength-bar';
      if (i < strength) {
        bar.classList.add(levels[strength]);
      }
    });

    text.className = 'strength-text';
    if (strength > 0) text.classList.add(levels[strength]);
    text.textContent = labels[strength];
  };

  window.changePassword = function (e) {
    e.preventDefault();
    const current = document.getElementById('currentPassword').value;
    const newPass = document.getElementById('newPassword').value;
    const confirm = document.getElementById('confirmNewPassword').value;

    if (!current) {
      showToast('Please enter your current password', 'error');
      return;
    }

    if (newPass !== confirm) {
      showToast('Passwords do not match', 'error');
      return;
    }

    if (newPass.length < 8) {
      showToast('Password must be at least 8 characters', 'error');
      return;
    }

    // Mock password change
    showToast('Password updated successfully!', 'success');
    document.getElementById('currentPassword').value = '';
    document.getElementById('newPassword').value = '';
    document.getElementById('confirmNewPassword').value = '';
    updatePasswordStrength('');
  };

  window.toggle2FA = function (enabled) {
    showToast(enabled ? '2FA enabled' : '2FA disabled', 'success');
  };

  // Privacy Functions
  window.savePrivacySettings = function () {
    const settings = {
      publicProfile: document.getElementById('togglePublicProfile')?.checked ?? true,
      studyStats: document.getElementById('toggleStudyStats')?.checked ?? true,
      aiInsights: document.getElementById('toggleAIInsights')?.checked ?? true,
      onlineStatus: document.getElementById('toggleOnlineStatus')?.checked ?? true
    };
    localStorage.setItem('focusfund_privacy', JSON.stringify(settings));
    showToast('Privacy settings saved', 'success');
  };

  // Notification Functions
  window.saveNotificationSettings = function () {
    const settings = {
      email: document.getElementById('toggleEmailNotif')?.checked ?? true,
      reminders: document.getElementById('toggleStudyReminders')?.checked ?? true,
      weekly: document.getElementById('toggleWeeklyReports')?.checked ?? false,
      follower: document.getElementById('toggleFollowerNotif')?.checked ?? true,
      course: document.getElementById('toggleCourseNotif')?.checked ?? true,
      achievement: document.getElementById('toggleAchievementNotif')?.checked ?? true
    };
    localStorage.setItem('focusfund_notifications', JSON.stringify(settings));
    showToast('Notification settings saved', 'success');
  };

  // Data Functions
  window.downloadUserData = function () {
    const user = localStorage.getItem('focusfund_user') || '{}';
    const privacy = localStorage.getItem('focusfund_privacy') || '{}';
    const notifications = localStorage.getItem('focusfund_notifications') || '{}';

    const data = {
      user: JSON.parse(user),
      privacy: JSON.parse(privacy),
      notifications: JSON.parse(notifications),
      exportedAt: new Date().toISOString()
    };

    const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'focusfund-data.json';
    a.click();
    URL.revokeObjectURL(url);

    showToast('Data downloaded successfully!', 'success');
  };

  window.clearCache = function () {
    showToast('Cache cleared successfully!', 'success');
  };

  // Deactivate Functions
  window.updateDeactivateButton = function () {
    const checkbox = document.getElementById('confirmDeactivate');
    const btn = document.getElementById('deactivateBtn');
    btn.disabled = !checkbox.checked;
  };

  window.deactivateAccount = function () {
    // Clear all data
    localStorage.removeItem('focusfund_user');
    localStorage.removeItem('focusfund_privacy');
    localStorage.removeItem('focusfund_notifications');
    localStorage.removeItem('focusfund_settings');
    localStorage.removeItem('focusfund_avatar');
    localStorage.removeItem('focusfund_banner');
    localStorage.removeItem('focusfund_language');
    localStorage.removeItem('focusfund_ambient_url');

    updateAuthUI(false);
    navigateTo('landing');
    showToast('Account deactivated', 'success');
  };

  // Language & Display Functions
  window.changeLanguage = function (lang) {
    localStorage.setItem('focusfund_language', lang);
    showToast('Language preference saved (UI translation coming soon)', 'success');
  };

  window.changeTheme = function (theme) {
    localStorage.setItem('focusfund_theme', theme);
    applyTheme(theme);
    showToast('Theme applied!', 'success');
  };

  function applyTheme(theme) {
    // Remove existing theme classes
    document.body.classList.remove('theme-light', 'theme-dark');

    if (theme === 'light') {
      document.body.classList.add('theme-light');
    } else if (theme === 'dark') {
      document.body.classList.add('theme-dark');
    } else if (theme === 'auto') {
      // Check system preference
      const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
      if (!prefersDark) {
        document.body.classList.add('theme-light');
      }
    }
    // dark is default, no class needed
  }

  window.changeFontSize = function (size) {
    document.querySelectorAll('.font-size-btn').forEach(btn => btn.classList.remove('active'));
    event.target.classList.add('active');
    document.documentElement.style.fontSize = size === 'small' ? '14px' : size === 'large' ? '18px' : '16px';
    localStorage.setItem('focusfund_fontsize', size);
  };

  window.toggleReduceMotion = function (enabled) {
    document.body.classList.toggle('reduce-motion', enabled);
    localStorage.setItem('focusfund_reduce_motion', enabled);
  };

  window.toggleHighContrast = function (enabled) {
    document.body.classList.toggle('high-contrast', enabled);
    localStorage.setItem('focusfund_high_contrast', enabled);
  };

  // Sound Settings
  window.toggleAmbientSound = function (enabled) {
    if (window.ambientAudio) {
      if (enabled) {
        window.ambientAudio.start();
      } else {
        window.ambientAudio.stop();
      }
    }
  };

  window.setCustomAmbientSound = function (url) {
    if (url) {
      localStorage.setItem('focusfund_ambient_url', url);
      if (window.ambientAudio && window.ambientAudio.setCustomUrl) {
        window.ambientAudio.setCustomUrl(url);
      }
      showToast('Custom sound URL saved', 'success');
    }
  };

  window.setAmbientVolume = function (value) {
    const volumeDisplay = document.getElementById('volumeValue');
    if (volumeDisplay) volumeDisplay.textContent = `${value}%`;

    if (window.ambientAudio) {
      window.ambientAudio.setVolume(value);
    }
  };

  // FocusFund Mode Functions
  window.setFocusFundTab = function (tabName) {
    document.querySelectorAll('[data-focusfund-tab]').forEach(item => {
      item.classList.remove('active');
      if (item.dataset.focusfundTab === tabName) {
        item.classList.add('active');
      }
    });

    document.querySelectorAll('.focusfund-tab').forEach(tab => {
      tab.classList.remove('active');
    });
    const targetTab = document.getElementById(`focusfund-tab-${tabName}`);
    if (targetTab) targetTab.classList.add('active');
  };

  // Initialize focusfund nav clicks
  document.addEventListener('click', function (e) {
    const navItem = e.target.closest('[data-focusfund-tab]');
    if (navItem && navItem.dataset.focusfundTab) {
      setFocusFundTab(navItem.dataset.focusfundTab);
    }
  });

  window.handleFocusFundToggle = function (checked) {
    const warningEl = document.getElementById('focusfundWarning');
    const toggleEl = document.getElementById('toggleFocusFundMode');

    if (checked) {
      // Show warning first
      warningEl.classList.remove('hidden');
      toggleEl.checked = false; // Reset until confirmed
    } else {
      // Disable FocusFund mode
      localStorage.setItem('focusfund_enabled', 'false');
      updateFocusFundUI();
      updateDropdownBalance();
      showToast('FocusFund Mode disabled. Your balance is safe.', 'success');
    }
  };

  window.cancelFocusFundEnable = function () {
    const warningEl = document.getElementById('focusfundWarning');
    const toggleEl = document.getElementById('toggleFocusFundMode');
    warningEl.classList.add('hidden');
    toggleEl.checked = false;
  };

  window.confirmFocusFundEnable = function () {
    const warningEl = document.getElementById('focusfundWarning');
    const toggleEl = document.getElementById('toggleFocusFundMode');

    localStorage.setItem('focusfund_enabled', 'true');
    warningEl.classList.add('hidden');
    toggleEl.checked = true;
    updateFocusFundUI();
    updateDropdownBalance();
    showToast('FocusFund Mode enabled! Stay focused! 🎯', 'success');
  };

  window.addFocusFundBalance = function () {
    const amountInput = document.getElementById('depositAmount');
    const amount = parseInt(amountInput.value);

    if (!amount || amount < 10000) {
      showToast('Please enter a valid amount (min 10,000 VND)', 'error');
      return;
    }

    const currentBalance = parseInt(localStorage.getItem('focusfund_balance') || '0');
    const newBalance = currentBalance + amount;
    localStorage.setItem('focusfund_balance', newBalance.toString());

    updateFocusFundUI();
    updateDropdownBalance();
    amountInput.value = '';
    showToast(`${formatVND(amount)} added to your balance!`, 'success');
  };

  function updateFocusFundUI() {
    const enabled = localStorage.getItem('focusfund_enabled') === 'true';
    const balance = parseInt(localStorage.getItem('focusfund_balance') || '0');

    const statusEl = document.getElementById('focusfundStatus');
    const balanceDisplay = document.getElementById('focusfundBalanceDisplay');
    const depositBalanceDisplay = document.getElementById('depositBalanceDisplay');
    const withdrawBalanceDisplay = document.getElementById('withdrawBalanceDisplay');
    const toggleEl = document.getElementById('toggleFocusFundMode');
    const statusCard = document.getElementById('focusfundStatusCard');

    if (statusEl) {
      statusEl.textContent = enabled ? 'Enabled' : 'Disabled';
      statusEl.className = `status-value ${enabled ? 'enabled' : 'disabled'}`;
    }
    if (balanceDisplay) balanceDisplay.textContent = formatVND(balance);
    if (depositBalanceDisplay) depositBalanceDisplay.textContent = formatVND(balance);
    if (withdrawBalanceDisplay) withdrawBalanceDisplay.textContent = formatVND(balance);
    if (toggleEl) toggleEl.checked = enabled;
    if (statusCard) {
      statusCard.className = `focusfund-status-card ${enabled ? 'enabled' : ''}`;
    }
  }

  // Withdraw functions
  window.showWithdrawForm = function (method) {
    // Hide all forms
    document.querySelectorAll('.withdraw-form').forEach(form => form.classList.add('hidden'));

    // Show selected form
    const formId = `withdrawForm${method.charAt(0).toUpperCase() + method.slice(1)}`;
    const form = document.getElementById(formId);
    if (form) form.classList.remove('hidden');
  };

  window.processWithdraw = function (method) {
    const balance = parseInt(localStorage.getItem('focusfund_balance') || '0');
    let amount = 0;
    let valid = true;
    let errorMsg = '';

    if (method === 'visa') {
      amount = parseInt(document.getElementById('withdrawAmountVisa')?.value || '0');
      const cardType = document.getElementById('cardType')?.value;

      if (!cardType) {
        errorMsg = 'Please select a card type';
        valid = false;
      } else if (cardType === 'paypal') {
        const paypalEmail = document.getElementById('paypalEmail')?.value?.trim();
        if (!paypalEmail) {
          errorMsg = 'Please enter your PayPal email';
          valid = false;
        }
      } else {
        const cardNumber = document.getElementById('cardNumber')?.value?.trim();
        const cardHolder = document.getElementById('cardHolder')?.value?.trim();
        if (!cardNumber || cardNumber.length < 16) {
          errorMsg = 'Please enter a valid card number';
          valid = false;
        }
        if (!cardHolder) {
          errorMsg = 'Please enter the card holder name';
          valid = false;
        }
      }
    } else if (method === 'momo') {
      amount = parseInt(document.getElementById('withdrawAmountMomo')?.value || '0');
      const momoPhone = document.getElementById('momoPhone')?.value?.trim();
      const momoName = document.getElementById('momoName')?.value?.trim();

      if (!momoPhone || !/^0\d{9}$/.test(momoPhone)) {
        errorMsg = 'Please enter a valid phone number (09xxxxxxxx)';
        valid = false;
      }
      if (!momoName) {
        errorMsg = 'Please enter the account holder name';
        valid = false;
      }
    } else if (method === 'vnpay') {
      amount = parseInt(document.getElementById('withdrawAmountVnpay')?.value || '0');
      const bank = document.getElementById('vnpayBank')?.value;
      const account = document.getElementById('vnpayAccount')?.value?.trim();
      const holder = document.getElementById('vnpayHolder')?.value?.trim();

      if (!bank) {
        errorMsg = 'Please select a bank';
        valid = false;
      }
      if (!account) {
        errorMsg = 'Please enter your account number';
        valid = false;
      }
      if (!holder) {
        errorMsg = 'Please enter the account holder name';
        valid = false;
      }
    }

    if (!valid) {
      showToast(errorMsg, 'error');
      return;
    }

    if (!amount || amount < 10000) {
      showToast('Please enter a valid amount (min 10,000 VND)', 'error');
      return;
    }

    if (amount > balance) {
      showToast('Insufficient balance', 'error');
      return;
    }

    // Process withdrawal (mock)
    const newBalance = balance - amount;
    localStorage.setItem('focusfund_balance', newBalance.toString());
    updateFocusFundUI();
    updateDropdownBalance();

    showToast(`Withdrawal request for ${formatVND(amount)} submitted successfully! You will receive it within 1-3 business days.`, 'success');

    // Clear form
    document.querySelectorAll('.withdraw-form input').forEach(input => input.value = '');
    document.querySelectorAll('.withdraw-form select').forEach(select => select.value = '');
  };

  // Handle card type change for PayPal email field
  document.addEventListener('change', function (e) {
    if (e.target.id === 'cardType') {
      const cardNumberGroup = document.getElementById('cardNumberGroup');
      const paypalEmailGroup = document.getElementById('paypalEmailGroup');
      const cardExpiry = document.getElementById('cardExpiry')?.closest('.form-group');
      const cardHolder = document.getElementById('cardHolder')?.closest('.form-group');

      if (e.target.value === 'paypal') {
        if (cardNumberGroup) cardNumberGroup.style.display = 'none';
        if (cardExpiry) cardExpiry.style.display = 'none';
        if (paypalEmailGroup) paypalEmailGroup.style.display = 'block';
      } else {
        if (cardNumberGroup) cardNumberGroup.style.display = 'block';
        if (cardExpiry) cardExpiry.style.display = 'block';
        if (paypalEmailGroup) paypalEmailGroup.style.display = 'none';
      }
    }
  });

  // Session Checkout functions
  let checkoutTimer = null;
  let checkoutTimeRemaining = 60;

  window.showSessionCheckout = function () {
    const overlay = document.getElementById('sessionCheckoutOverlay');
    if (overlay) {
      overlay.classList.remove('hidden');
      checkoutTimeRemaining = 60;
      updateCheckoutDisplay();
      startCheckoutCountdown();
    }
  };

  function startCheckoutCountdown() {
    checkoutTimer = setInterval(() => {
      checkoutTimeRemaining--;
      updateCheckoutDisplay();

      if (checkoutTimeRemaining <= 0) {
        clearInterval(checkoutTimer);
        handleCheckoutTimeout();
      }
    }, 1000);
  }

  function updateCheckoutDisplay() {
    const countdownEl = document.getElementById('checkoutCountdown');
    const progressEl = document.getElementById('checkoutProgressFill');

    if (countdownEl) countdownEl.textContent = checkoutTimeRemaining;
    if (progressEl) {
      const progress = (checkoutTimeRemaining / 60) * 100;
      progressEl.style.width = `${progress}%`;
    }
  }

  function handleCheckoutTimeout() {
    const overlay = document.getElementById('sessionCheckoutOverlay');
    if (overlay) overlay.classList.add('hidden');

    // Kick user from study room
    showToast('You were removed from the study room due to inactivity. Stay focused! 📚', 'error');
    navigateTo('rooms');

    // Deduct from FocusFund if enabled
    const focusfundEnabled = localStorage.getItem('focusfund_enabled') === 'true';
    if (focusfundEnabled) {
      const balance = parseInt(localStorage.getItem('focusfund_balance') || '0');
      const deduction = Math.min(balance, 10000); // Deduct 10,000 VND or remaining balance
      if (deduction > 0) {
        const newBalance = balance - deduction;
        localStorage.setItem('focusfund_balance', newBalance.toString());
        updateFocusFundUI();
        updateDropdownBalance();
        showToast(`${formatVND(deduction)} was donated to charity due to inactivity.`, 'warning');
      }
    }
  }

  window.confirmSessionCheckout = function () {
    if (checkoutTimer) {
      clearInterval(checkoutTimer);
      checkoutTimer = null;
    }

    const overlay = document.getElementById('sessionCheckoutOverlay');
    if (overlay) overlay.classList.add('hidden');

    showToast('Great! Keep up the good work! 🎯', 'success');
  };

  // Mobile navigation functions
  window.toggleMobileNav = function () {
    const menu = document.getElementById('mobileNavMenu');
    const overlay = document.getElementById('mobileNavOverlay');

    if (menu && overlay) {
      menu.classList.toggle('hidden');
      overlay.classList.toggle('hidden');
      document.body.style.overflow = menu.classList.contains('hidden') ? '' : 'hidden';
    }
  };

  window.closeMobileNav = function () {
    const menu = document.getElementById('mobileNavMenu');
    const overlay = document.getElementById('mobileNavOverlay');

    if (menu) menu.classList.add('hidden');
    if (overlay) overlay.classList.add('hidden');
    document.body.style.overflow = '';
  };

  // Toast notification
  window.showToast = function (message, type = 'info') {
    // Ensure toast container exists
    let container = document.getElementById('toastContainer');
    if (!container) {
      container = document.createElement('div');
      container.id = 'toastContainer';
      container.className = 'toast-container';
      document.body.appendChild(container);
    }

    // Icon map
    const icons = {
      success: '<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M20 6L9 17l-5-5"/></svg>',
      error: '<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>',
      warning: '<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>',
      info: '<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>'
    };

    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    toast.innerHTML = `
      <span class="toast-icon">${icons[type] || icons.info}</span>
      <span class="toast-message">${message}</span>
      <button class="toast-close" onclick="this.parentElement.classList.remove('show'); setTimeout(() => this.parentElement.remove(), 300);">×</button>
    `;
    container.appendChild(toast);

    // Limit to 5 toasts max
    const toasts = container.querySelectorAll('.toast');
    if (toasts.length > 5) {
      toasts[0].remove();
    }

    setTimeout(() => toast.classList.add('show'), 10);
    setTimeout(() => {
      if (toast.parentElement) {
        toast.classList.remove('show');
        setTimeout(() => toast.remove(), 300);
      }
    }, 4000);
  };

  // AI Chat functions
  window.newAIChat = function () {
    const messages = document.getElementById('aiChatMessages');
    messages.innerHTML = `
      <div class="ai-message assistant">
        <div class="ai-message-avatar">🤖</div>
        <div class="ai-message-content">
          <p>Hello! I'm your AI Study Assistant. How can I help you today?</p>
        </div>
      </div>
    `;
  };

  window.loadChat = function (chatId) {
    const items = document.querySelectorAll('.chat-history-item');
    items.forEach(item => item.classList.remove('active'));
    items[chatId - 1].classList.add('active');

    // Mock loading different chats
    const messages = document.getElementById('aiChatMessages');
    const chatContents = {
      1: `<div class="ai-message assistant">
            <div class="ai-message-avatar">🤖</div>
            <div class="ai-message-content">
              <p>Let me help you with Calculus! What specific topic are you working on?</p>
            </div>
          </div>
          <div class="ai-message user">
            <div class="ai-message-avatar">U</div>
            <div class="ai-message-content">
              <p>Can you explain the chain rule?</p>
            </div>
          </div>
          <div class="ai-message assistant">
            <div class="ai-message-avatar">🤖</div>
            <div class="ai-message-content">
              <p>The Chain Rule is used when differentiating composite functions. If you have f(g(x)), the derivative is:</p>
              <p><strong>f'(g(x)) × g'(x)</strong></p>
              <p>Think of it as "derivative of the outside × derivative of the inside".</p>
            </div>
          </div>`,
      2: `<div class="ai-message assistant">
            <div class="ai-message-avatar">🤖</div>
            <div class="ai-message-content">
              <p>Let's review your physics quiz! Here are some key concepts to remember...</p>
            </div>
          </div>`,
      3: `<div class="ai-message assistant">
            <div class="ai-message-avatar">🤖</div>
            <div class="ai-message-content">
              <p>Based on your schedule, I recommend studying 2 hours in the morning and 1 hour in the evening.</p>
            </div>
          </div>`
    };
    messages.innerHTML = chatContents[chatId] || chatContents[1];
  };

  window.quickAIAction = function (action) {
    const input = document.getElementById('aiChatInput');
    const prompts = {
      summarize: 'Summarize the key concepts from my current chapter',
      quiz: 'Generate 5 quiz questions on derivatives',
      explain: 'Explain the concept of limits in calculus',
      schedule: 'Create a study schedule for this week'
    };
    input.value = prompts[action];
    input.focus();
  };

  window.sendAIMessage = function () {
    const input = document.getElementById('aiChatInput');
    const messages = document.getElementById('aiChatMessages');
    const text = input.value.trim();

    if (!text) return;

    // Get user avatar
    const avatar = localStorage.getItem('focusfund_avatar');
    const userData = JSON.parse(localStorage.getItem('focusfund_user') || '{}');
    const initial = (userData.name || 'U').charAt(0).toUpperCase();
    const avatarHtml = avatar
      ? `<img src="${avatar}" alt="" class="ai-avatar-img">`
      : initial;

    // Add user message - escape HTML to prevent XSS
    messages.innerHTML += `
      <div class="ai-message user">
        <div class="ai-message-avatar">${avatarHtml}</div>
        <div class="ai-message-content">
          <p>${escapeHtmlInline(text)}</p>
        </div>
      </div>
    `;

    input.value = '';

    // Simulate AI response
    setTimeout(() => {
      const responses = [
        "That's a great question! Let me break it down for you...",
        "Based on your study progress, I recommend focusing on the fundamentals first.",
        "Here's a helpful way to think about this concept...",
        "I've analyzed your question and here's what I found..."
      ];
      const randomResponse = responses[Math.floor(Math.random() * responses.length)];

      messages.innerHTML += `
        <div class="ai-message assistant">
          <div class="ai-message-avatar">🤖</div>
          <div class="ai-message-content">
            <p>${randomResponse}</p>
            <p>The key points to remember are:</p>
            <ul>
              <li>Practice regularly with focused sessions</li>
              <li>Break complex topics into smaller chunks</li>
              <li>Review your notes within 24 hours</li>
            </ul>
          </div>
        </div>
      `;

      messages.scrollTop = messages.scrollHeight;
    }, 1000);

    messages.scrollTop = messages.scrollHeight;
  };

  window.handleAIChatKeydown = function (e) {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      sendAIMessage();
    }
  };

  // AI Mode Switching
  window.switchAIMode = function (mode) {
    const chatMode = document.getElementById('aiChatMode');
    const callMode = document.getElementById('aiCallMode');
    const chatBtn = document.getElementById('aiModeChatBtn');
    const callBtn = document.getElementById('aiModeCallBtn');

    if (mode === 'chat') {
      chatMode.classList.remove('hidden');
      callMode.classList.add('hidden');
      chatBtn.classList.add('active');
      callBtn.classList.remove('active');
    } else {
      chatMode.classList.add('hidden');
      callMode.classList.remove('hidden');
      chatBtn.classList.remove('active');
      callBtn.classList.add('active');
    }
  };

  // AI Options Menu
  window.toggleAIOptionsMenu = function (e) {
    e.stopPropagation();
    const menu = document.getElementById('aiOptionsMenu');
    menu.classList.toggle('hidden');
  };

  // Close AI options menu when clicking outside
  document.addEventListener('click', function (e) {
    const menu = document.getElementById('aiOptionsMenu');
    const plusBtn = document.querySelector('.ai-plus-btn');
    if (menu && !menu.contains(e.target) && e.target !== plusBtn && !plusBtn?.contains(e.target)) {
      menu.classList.add('hidden');
    }
  });

  window.handleAIOption = function (option) {
    const menu = document.getElementById('aiOptionsMenu');
    menu.classList.add('hidden');

    switch (option) {
      case 'upload':
        document.getElementById('aiFileUpload').click();
        break;
      case 'create-image':
        showToast('Image generation feature coming soon!', 'info');
        break;
      case 'thinking':
        showToast('Deep thinking mode activated', 'success');
        break;
      case 'research':
        showToast('Deep research feature coming soon!', 'info');
        break;
      case 'quizzes':
        quickAIAction('quiz');
        break;
      case 'more':
        showToast('More options coming soon!', 'info');
        break;
    }
  };

  window.handleAIFileUpload = function (e) {
    const file = e.target.files[0];
    if (!file) return;

    const messages = document.getElementById('aiChatMessages');
    const userData = JSON.parse(localStorage.getItem('focusfund_user') || '{}');
    const avatar = localStorage.getItem('focusfund_avatar');
    const initial = (userData.name || 'U').charAt(0).toUpperCase();
    const avatarHtml = avatar
      ? `<img src="${avatar}" alt="" class="ai-avatar-img">`
      : initial;

    // Show uploaded file
    const reader = new FileReader();
    reader.onload = function (event) {
      if (file.type.startsWith('image/')) {
        messages.innerHTML += `
          <div class="ai-message user">
            <div class="ai-message-avatar">${avatarHtml}</div>
            <div class="ai-message-content">
              <img src="${event.target.result}" alt="Uploaded image" style="max-width: 200px; border-radius: 8px;">
              <p>I uploaded this image for analysis.</p>
            </div>
          </div>
        `;
      } else {
        messages.innerHTML += `
          <div class="ai-message user">
            <div class="ai-message-avatar">${avatarHtml}</div>
            <div class="ai-message-content">
              <p>📎 Uploaded: ${file.name}</p>
            </div>
          </div>
        `;
      }

      // AI response
      setTimeout(() => {
        messages.innerHTML += `
          <div class="ai-message assistant">
            <div class="ai-message-avatar">🤖</div>
            <div class="ai-message-content">
              <p>I've received your file. Let me analyze it for you...</p>
              <p>This looks like study material! Would you like me to summarize it or create quiz questions from it?</p>
            </div>
          </div>
        `;
        messages.scrollTop = messages.scrollHeight;
      }, 1000);

      messages.scrollTop = messages.scrollHeight;
    };
    reader.readAsDataURL(file);
    e.target.value = '';
  };

  // Voice Input
  let isRecording = false;
  let recognition = null;

  window.toggleVoiceInput = function () {
    const micBtn = document.getElementById('aiMicBtn');

    if (!('webkitSpeechRecognition' in window) && !('SpeechRecognition' in window)) {
      showToast('Voice recognition is not supported in your browser', 'error');
      return;
    }

    if (isRecording) {
      if (recognition) recognition.stop();
      isRecording = false;
      micBtn.classList.remove('recording');
      return;
    }

    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
    recognition = new SpeechRecognition();
    recognition.continuous = false;
    recognition.interimResults = false;
    recognition.lang = 'en-US';

    recognition.onstart = function () {
      isRecording = true;
      micBtn.classList.add('recording');
      showToast('Listening... Speak now', 'info');
    };

    recognition.onresult = function (event) {
      const transcript = event.results[0][0].transcript;
      document.getElementById('aiChatInput').value = transcript;
      sendAIMessage();
    };

    recognition.onerror = function (event) {
      showToast('Voice recognition error: ' + event.error, 'error');
      isRecording = false;
      micBtn.classList.remove('recording');
    };

    recognition.onend = function () {
      isRecording = false;
      micBtn.classList.remove('recording');
    };

    recognition.start();
  };

  // AI Call Functions
  let callTimer = null;
  let callSeconds = 0;

  window.startAICall = function () {
    const startBtn = document.getElementById('callStartBtn');
    const endBtn = document.getElementById('callEndBtn');
    const status = document.getElementById('aiCallStatus');
    const timer = document.getElementById('callTimer');
    const ring = document.getElementById('callAvatarRing');

    startBtn.classList.add('hidden');
    endBtn.classList.remove('hidden');
    status.textContent = 'Connected';
    timer.classList.remove('hidden');
    ring.classList.add('active');

    callSeconds = 0;
    callTimer = setInterval(() => {
      callSeconds++;
      const mins = Math.floor(callSeconds / 60).toString().padStart(2, '0');
      const secs = (callSeconds % 60).toString().padStart(2, '0');
      timer.textContent = `${mins}:${secs}`;
    }, 1000);

    showToast('Connected to AI Assistant!', 'success');
  };

  window.endAICall = function () {
    const startBtn = document.getElementById('callStartBtn');
    const endBtn = document.getElementById('callEndBtn');
    const status = document.getElementById('aiCallStatus');
    const timer = document.getElementById('callTimer');
    const ring = document.getElementById('callAvatarRing');

    if (callTimer) clearInterval(callTimer);

    startBtn.classList.remove('hidden');
    endBtn.classList.add('hidden');
    status.textContent = 'Call ended';
    showToast(`Call ended. Duration: ${timer.textContent}`, 'info');
    timer.classList.add('hidden');
    ring.classList.remove('active');

    setTimeout(() => {
      status.textContent = 'Ready to call';
    }, 2000);
  };

  let isMuted = false;
  let isVideoOn = false;
  let isCaptionsOn = false;

  window.toggleCallMute = function () {
    const btn = document.getElementById('callMuteBtn');
    isMuted = !isMuted;
    btn.classList.toggle('active', isMuted);
    showToast(isMuted ? 'Muted' : 'Unmuted', 'info');
  };

  window.toggleCallVideo = function () {
    const btn = document.getElementById('callVideoBtn');
    isVideoOn = !isVideoOn;
    btn.classList.toggle('active', isVideoOn);
    showToast(isVideoOn ? 'Video on' : 'Video off', 'info');
  };

  window.toggleCallChat = function () {
    switchAIMode('chat');
    showToast('Switched to chat mode', 'info');
  };

  window.shareCallScreen = function () {
    showToast('Screen sharing feature coming soon!', 'info');
  };

  window.toggleCallCaptions = function () {
    const captions = document.getElementById('callCaptions');
    const btn = document.getElementById('callCaptionsBtn');
    isCaptionsOn = !isCaptionsOn;
    captions.classList.toggle('hidden', !isCaptionsOn);
    btn.classList.toggle('active', isCaptionsOn);
    showToast(isCaptionsOn ? 'Captions on' : 'Captions off', 'info');
  };

  window.showCallReactions = function () {
    const reactions = ['👍', '❤️', '😂', '👏', '🎉'];
    const reaction = reactions[Math.floor(Math.random() * reactions.length)];
    showToast(`Reaction: ${reaction}`, 'info');
  };

  // Create Room Modal
  window.showCreateRoomModal = function () {
    const modal = document.getElementById('createRoomModal');
    if (modal) modal.classList.remove('hidden');
  };

  window.closeCreateRoomModal = function () {
    const modal = document.getElementById('createRoomModal');
    if (modal) modal.classList.add('hidden');
  };

  window.createNewRoom = function (e) {
    e.preventDefault();
    const nameInput = document.getElementById('newRoomName');
    const name = nameInput?.value?.trim();
    if (!name) {
      showToast('Please enter a room name', 'error');
      return;
    }
    const desc = document.getElementById('newRoomDesc')?.value?.trim() || '';
    const roomTypeInput = document.querySelector('input[name="roomType"]:checked');
    const pomodoroInput = document.querySelector('input[name="pomodoro"]:checked');
    const roomType = roomTypeInput?.value || 'public';
    const pomodoro = pomodoroInput?.value || '25-5';
    const maxParticipants = document.getElementById('newRoomMax')?.value || '10';

    // Save room to localStorage
    const rooms = JSON.parse(localStorage.getItem('focusfund_rooms') || '[]');
    const newRoom = { id: Date.now(), name, desc, roomType, pomodoro, maxParticipants, createdAt: new Date().toISOString() };
    rooms.push(newRoom);
    localStorage.setItem('focusfund_rooms', JSON.stringify(rooms));

    // Add the room card to the rooms grid
    const roomsGrid = document.querySelector('.rooms-grid');
    if (!roomsGrid) { closeCreateRoomModal(); return; }
    const createCard = roomsGrid.querySelector('.room-card.create-room');
    const typeEmoji = roomType === 'silent' ? '🤫' : roomType === 'public' ? '👥' : '🔒';
    const typeName = roomType.charAt(0).toUpperCase() + roomType.slice(1);
    const pomodoroLabel = pomodoro === '25-5' ? '25/5 Pomodoro' : pomodoro === '50-10' ? '50/10 Extended' : '90/20 Deep Work';

    const userData = JSON.parse(localStorage.getItem('focusfund_user') || '{}');
    const initial = (userData.name || 'U').charAt(0).toUpperCase();

    const roomCard = document.createElement('div');
    roomCard.className = 'room-card';
    roomCard.setAttribute('data-page', 'study-room');
    roomCard.innerHTML = `
      <div class="room-card-header">
        <span class="room-type-badge ${roomType}">${typeEmoji} ${typeName}</span>
        <span class="room-users">1/${maxParticipants}</span>
      </div>
      <h3 class="room-card-title">${escapeHtml(name)}</h3>
      <p class="room-card-desc">${escapeHtml(desc || 'No description')}</p>
      <div class="room-card-timer">
        <span class="timer-icon">⏱</span>
        <span>${pomodoroLabel}</span>
      </div>
      <div class="room-card-members">
        <div class="member-avatar">${initial}</div>
      </div>
    `;
    if (createCard) {
      roomsGrid.insertBefore(roomCard, createCard);
    } else {
      roomsGrid.appendChild(roomCard);
    }

    // Update the Study Room page UI with the new room data before navigating
    // This fixes the bug where new rooms default to "Deep Focus Zone"
    const studyRoomTitle = document.querySelector('.room-info h2');
    const studyRoomBadge = document.querySelector('.room-info .room-status');
    const studyRoomTimer = document.querySelector('#timerMinutes');

    if (studyRoomTitle) studyRoomTitle.textContent = name;
    if (studyRoomBadge) {
      studyRoomBadge.className = `room-status ${roomType}`;
      studyRoomBadge.textContent = `${typeEmoji} ${typeName}`;
    }
    if (studyRoomTimer && pomodoro) {
      const minutes = pomodoro.split('-')[0];
      studyRoomTimer.textContent = minutes;
    }

    showToast(`Room "${name}" created successfully!`, 'success');
    closeCreateRoomModal();

    // Auto-join the room
    navigateTo('study-room');
  };

  // Create Mindmap
  window.createNewMindmap = function () {
    if (!window.isLoggedIn()) {
      showLoginRequired();
      return;
    }
    showToast('Mindmap creator coming soon!', 'info');
  };

  // Create Post Modal
  window.openCreatePostModal = function () {
    const modal = document.getElementById('createPostModal');
    const avatar = document.getElementById('postModalAvatar');
    const userName = document.getElementById('postModalUserName');

    const userData = JSON.parse(localStorage.getItem('focusfund_user') || '{}');
    const savedAvatar = localStorage.getItem('focusfund_avatar');

    if (savedAvatar) {
      avatar.innerHTML = `<img src="${savedAvatar}" alt="" style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">`;
    } else {
      avatar.textContent = (userData.name || 'U').charAt(0).toUpperCase();
    }
    userName.textContent = userData.name || 'User';

    if (modal) modal.classList.remove('hidden');
  };

  window.closeCreatePostModal = function () {
    const modal = document.getElementById('createPostModal');
    const textarea = document.getElementById('postContent');

    if (modal) modal.classList.add('hidden');
    if (textarea) textarea.value = '';

    // Reset uploaded images
    postUploadedImages = [];
    const preview = document.getElementById('postImagePreview');
    const container = document.getElementById('postPreviewImages');
    if (preview) preview.classList.add('hidden');
    if (container) container.innerHTML = '';
  };

  // Track uploaded post images
  let postUploadedImages = [];

  window.handlePostImageUpload = function (e) {
    const files = Array.from(e.target.files);
    if (!files.length) return;

    files.forEach(file => {
      const reader = new FileReader();
      reader.onload = function (event) {
        postUploadedImages.push(event.target.result);
        updatePostImagePreview();
      };
      reader.readAsDataURL(file);
    });
    e.target.value = '';
  };

  function updatePostImagePreview() {
    const preview = document.getElementById('postImagePreview');
    const container = document.getElementById('postPreviewImages');

    if (postUploadedImages.length > 0) {
      preview.classList.remove('hidden');
      container.innerHTML = postUploadedImages.map((src, i) =>
        `<img src="${src}" alt="Preview ${i + 1}">`
      ).join('');
    } else {
      preview.classList.add('hidden');
      container.innerHTML = '';
    }
  }

  window.removePostPreview = function () {
    postUploadedImages = [];
    const preview = document.getElementById('postImagePreview');
    const container = document.getElementById('postPreviewImages');
    preview.classList.add('hidden');
    container.innerHTML = '';
  };

  // Generate unique post ID
  let postIdCounter = 100;
  function generatePostId() {
    return ++postIdCounter;
  }

  window.submitPost = function (e) {
    e.preventDefault();
    const content = document.getElementById('postContent').value.trim();

    if (!content && postUploadedImages.length === 0) {
      showToast('Please write something or add an image to post', 'error');
      return;
    }

    // Get user data
    const userData = JSON.parse(localStorage.getItem('focusfund_user') || '{}');
    const savedAvatar = localStorage.getItem('focusfund_avatar');
    const initial = (userData.name || 'U').charAt(0).toUpperCase();
    const postId = generatePostId();

    const postsContainer = document.getElementById('tab-posts');
    const avatarHtml = savedAvatar
      ? `<img src="${savedAvatar}" alt="" class="post-avatar-img" style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">`
      : initial;

    // Build images HTML
    let imagesHtml = '';
    if (postUploadedImages.length === 1) {
      imagesHtml = `<div class="post-images-grid single">
        <img src="${postUploadedImages[0]}" alt="" onclick="openImageGallery(${JSON.stringify(postUploadedImages).replace(/"/g, '&quot;')}, 0)">
      </div>`;
    } else if (postUploadedImages.length > 1) {
      imagesHtml = `<div class="post-images-grid">
        ${postUploadedImages.map((src, i) => `<img src="${src}" alt="" onclick="openImageGallery(${JSON.stringify(postUploadedImages).replace(/"/g, '&quot;')}, ${i})">`).join('')}
      </div>`;
    }

    const newPost = document.createElement('div');
    newPost.className = 'post-item';
    newPost.dataset.postId = postId;
    newPost.innerHTML = `
      <div class="post-header">
        <div class="post-avatar">${avatarHtml}</div>
        <div class="post-meta">
          <span class="post-author">${userData.name || 'You'}</span>
          <span class="post-time clickable" onclick="openPostDetail(${postId})">Just now</span>
        </div>
      </div>
      ${content ? `<p class="post-content">${escapeHtml(content)}</p>` : ''}
      ${imagesHtml}
      <div class="post-actions">
        <div class="like-btn-wrapper" onmouseenter="showReactionPicker(this.querySelector('.like-btn'))" onmouseleave="hideReactionPicker(this)">
          <button class="post-action like-btn" onclick="toggleLike(this)" data-post-id="${postId}">❤️ 0</button>
          <div class="reaction-picker hidden">
            <button class="reaction-item" onclick="reactToPost(this, '❤️')">❤️</button>
            <button class="reaction-item" onclick="reactToPost(this, '👍')">👍</button>
            <button class="reaction-item" onclick="reactToPost(this, '😂')">😂</button>
            <button class="reaction-item" onclick="reactToPost(this, '😮')">😮</button>
            <button class="reaction-item" onclick="reactToPost(this, '😢')">😢</button>
            <button class="reaction-item" onclick="reactToPost(this, '😡')">😡</button>
          </div>
        </div>
        <button class="post-action" onclick="openPostDetail(${postId})">💬 0</button>
        <button class="post-action" onclick="sharePost(${postId})">🔄 Share</button>
      </div>
    `;

    // Insert after create-post-section
    const createPostSection = postsContainer.querySelector('.create-post-section');
    if (createPostSection && createPostSection.nextSibling) {
      postsContainer.insertBefore(newPost, createPostSection.nextSibling);
    } else {
      postsContainer.insertBefore(newPost, postsContainer.firstChild);
    }

    // Initialize comments for this post
    mockComments[postId] = [];

    // Reset uploaded images
    postUploadedImages = [];

    closeCreatePostModal();
    showToast('Post published successfully!', 'success');
  };

  // Helper function to escape HTML (used also inline for XSS prevention)
  function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }

  // Alias for use in template literals where the name is clearer
  function escapeHtmlInline(text) {
    return escapeHtml(text);
  }

  // Hide reaction picker
  window.hideReactionPicker = function (wrapper) {
    setTimeout(() => {
      const picker = wrapper.querySelector('.reaction-picker');
      if (picker) picker.classList.add('hidden');
    }, 300);
  };

  // Update create post avatar
  function updateCreatePostAvatar() {
    const avatar = document.getElementById('createPostAvatar');
    const userData = JSON.parse(localStorage.getItem('focusfund_user') || '{}');
    const savedAvatar = localStorage.getItem('focusfund_avatar');

    if (avatar) {
      if (savedAvatar) {
        avatar.innerHTML = `<img src="${savedAvatar}" alt="" style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">`;
      } else {
        avatar.textContent = (userData.name || 'U').charAt(0).toUpperCase();
      }
    }
  }

  // Initialize
  document.addEventListener('DOMContentLoaded', function () {
    // Set initial page
    navigateTo('landing');

    // Initialize check-in modal as hidden
    const checkinModal = document.getElementById('checkinModal');
    if (checkinModal) {
      checkinModal.classList.add('hidden');
    }

    // Check for existing user session
    const userData = localStorage.getItem('focusfund_user');
    if (userData) {
      const { name, email } = JSON.parse(userData);
      updateAuthUI(true, name, email || `${name.toLowerCase().replace(' ', '.')}@email.com`);
    }

    // Load saved avatar
    const savedAvatar = localStorage.getItem('focusfund_avatar');
    if (savedAvatar && userData) {
      const { name } = JSON.parse(userData);
      const initial = (name || 'U').charAt(0).toUpperCase();
      updateAllAvatars(initial, savedAvatar);
    }

    // Load saved settings
    loadSavedSettings();

    // Load ambient sound URL
    const ambientUrl = localStorage.getItem('focusfund_ambient_url');
    if (ambientUrl) {
      const urlInput = document.getElementById('ambientSoundUrl');
      if (urlInput) urlInput.value = ambientUrl;
    }
  });

  function loadSavedSettings() {
    // Load privacy settings
    const privacy = localStorage.getItem('focusfund_privacy');
    if (privacy) {
      const settings = JSON.parse(privacy);
      const publicProfile = document.getElementById('togglePublicProfile');
      const studyStats = document.getElementById('toggleStudyStats');
      const aiInsights = document.getElementById('toggleAIInsights');
      const onlineStatus = document.getElementById('toggleOnlineStatus');
      if (publicProfile) publicProfile.checked = settings.publicProfile ?? true;
      if (studyStats) studyStats.checked = settings.studyStats ?? true;
      if (aiInsights) aiInsights.checked = settings.aiInsights ?? true;
      if (onlineStatus) onlineStatus.checked = settings.onlineStatus ?? true;
    }

    // Load notification settings
    const notifications = localStorage.getItem('focusfund_notifications');
    if (notifications) {
      const settings = JSON.parse(notifications);
      const emailNotif = document.getElementById('toggleEmailNotif');
      const reminders = document.getElementById('toggleStudyReminders');
      const weekly = document.getElementById('toggleWeeklyReports');
      if (emailNotif) emailNotif.checked = settings.email ?? true;
      if (reminders) reminders.checked = settings.reminders ?? true;
      if (weekly) weekly.checked = settings.weekly ?? false;
    }

    // Load language
    const language = localStorage.getItem('focusfund_language');
    if (language) {
      const langRadio = document.querySelector(`input[name="language"][value="${language}"]`);
      if (langRadio) langRadio.checked = true;
    }

    // Load font size
    const fontSize = localStorage.getItem('focusfund_fontsize');
    if (fontSize) {
      document.documentElement.style.fontSize = fontSize === 'small' ? '14px' : fontSize === 'large' ? '18px' : '16px';
    }

    // Load theme
    const theme = localStorage.getItem('focusfund_theme') || 'dark';
    applyTheme(theme);
    const themeRadio = document.querySelector(`input[name="theme"][value="${theme}"]`);
    if (themeRadio) themeRadio.checked = true;

    // Load banner
    const savedBanner = localStorage.getItem('focusfund_banner');
    if (savedBanner) {
      updateAllBanners(savedBanner);
    }

    // Load FocusFund settings
    updateFocusFundUI();
  }

  // Protected routes check
  window.isLoggedIn = function () {
    return localStorage.getItem('focusfund_user') !== null;
  };

  window.showLoginRequired = function () {
    const modal = document.createElement('div');
    modal.className = 'login-required-modal';
    modal.id = 'loginRequiredModal';
    modal.innerHTML = `
      <div class="login-required-content">
        <h3>🔒 Login Required</h3>
        <p>Please log in to access this feature.</p>
        <div class="login-required-actions">
          <button class="btn btn-ghost" onclick="closeLoginRequired()">Cancel</button>
          <button class="btn btn-primary" onclick="closeLoginRequired(); navigateTo('login');">Log In</button>
        </div>
      </div>
    `;
    document.body.appendChild(modal);
  };

  window.closeLoginRequired = function () {
    const modal = document.getElementById('loginRequiredModal');
    if (modal) modal.remove();
  };

  // Override navigateTo for protected routes
  const protectedPages = ['dashboard', 'rooms', 'study-room', 'profile', 'account', 'notifications', 'ai-chat', 'focusfund'];
  const originalNavigateTo = window.navigateTo;

  window.navigateTo = function (pageId) {
    if (protectedPages.includes(pageId) && !isLoggedIn()) {
      showLoginRequired();
      return;
    }
    originalNavigateTo(pageId);
  };

  // ===== Reaction Picker for Posts =====
  let reactionTimeout = null;

  window.showReactionPicker = function (btn) {
    const picker = btn.parentElement.querySelector('.reaction-picker');
    if (picker) {
      picker.classList.remove('hidden');
      clearTimeout(reactionTimeout);
    }
  };

  document.addEventListener('mouseover', function (e) {
    const wrapper = e.target.closest('.like-btn-wrapper');
    if (!wrapper) {
      // Close all pickers after delay
      reactionTimeout = setTimeout(() => {
        document.querySelectorAll('.reaction-picker').forEach(p => p.classList.add('hidden'));
      }, 500);
    }
  });

  window.toggleLike = function (btn) {
    const text = btn.textContent;
    const match = text.match(/(\d+)/);
    if (match) {
      const count = parseInt(match[1]);
      const isLiked = btn.classList.contains('liked');
      btn.classList.toggle('liked');
      btn.textContent = `❤️ ${isLiked ? count - 1 : count + 1}`;
    }
  };

  window.reactToPost = function (btn, emoji) {
    const likeBtn = btn.closest('.like-btn-wrapper').querySelector('.like-btn');
    const match = likeBtn.textContent.match(/(\d+)/);
    const count = match ? parseInt(match[1]) : 0;
    likeBtn.textContent = `${emoji} ${count + 1}`;
    likeBtn.classList.add('liked');
    btn.closest('.reaction-picker').classList.add('hidden');
    showToast(`Reacted with ${emoji}!`, 'success');
  };

  // ===== Following/Followers Modal =====
  const mockFollowers = [
    { name: 'Sarah Miller', handle: 'sarah_m', avatar: 'S' },
    { name: 'Alex Chen', handle: 'alex_chen', avatar: 'A' },
    { name: 'Emily Davis', handle: 'emily_d', avatar: 'E' },
    { name: 'James Wilson', handle: 'james_w', avatar: 'J' },
    { name: 'Lisa Park', handle: 'lisa_p', avatar: 'L' },
    { name: 'Mike Johnson', handle: 'mike_j', avatar: 'M' },
    { name: 'Nina Rose', handle: 'nina_r', avatar: 'N' },
    { name: 'Peter Kim', handle: 'peter_k', avatar: 'P' }
  ];

  const mockFollowing = [
    { name: 'David Brown', handle: 'david_b', avatar: 'D' },
    { name: 'Sophia Lee', handle: 'sophia_l', avatar: 'S' },
    { name: 'Ryan Taylor', handle: 'ryan_t', avatar: 'R' },
    { name: 'Olivia White', handle: 'olivia_w', avatar: 'O' },
    { name: 'Chris Martin', handle: 'chris_m', avatar: 'C' },
    { name: 'Hannah Clark', handle: 'hannah_c', avatar: 'H' },
    { name: 'Kevin Lee', handle: 'kevin_l', avatar: 'K' }
  ];

  window.openFollowModal = function (type) {
    const modal = document.getElementById('followModal');
    const title = document.getElementById('followModalTitle');
    const list = document.getElementById('followList');
    const searchInput = document.getElementById('followSearchInput');

    title.textContent = type === 'followers' ? 'Followers' : 'Following';
    searchInput.value = '';

    const users = type === 'followers' ? mockFollowers : mockFollowing;
    renderFollowList(users);

    modal.classList.remove('hidden');
  };

  function renderFollowList(users) {
    const list = document.getElementById('followList');
    list.innerHTML = users.map(user => `
      <div class="follow-item">
        <div class="follow-avatar">${user.avatar}</div>
        <div class="follow-info">
          <span class="follow-name">${user.name}</span>
          <span class="follow-handle">@${user.handle}</span>
        </div>
        <button class="btn btn-ghost btn-sm follow-btn" onclick="toggleFollow(this)">Following</button>
      </div>
    `).join('');
  }

  window.filterFollowList = function () {
    const search = document.getElementById('followSearchInput').value.toLowerCase();
    const title = document.getElementById('followModalTitle').textContent;
    const users = title === 'Followers' ? mockFollowers : mockFollowing;
    const filtered = users.filter(u =>
      u.name.toLowerCase().includes(search) ||
      u.handle.toLowerCase().includes(search)
    );
    renderFollowList(filtered);
  };

  window.closeFollowModal = function () {
    document.getElementById('followModal').classList.add('hidden');
  };

  window.toggleFollow = function (btn) {
    if (btn.textContent === 'Following') {
      btn.textContent = 'Follow';
      btn.classList.remove('btn-ghost');
      btn.classList.add('btn-primary');
    } else {
      btn.textContent = 'Following';
      btn.classList.remove('btn-primary');
      btn.classList.add('btn-ghost');
    }
  };

  // ===== Post Detail Modal =====
  const mockComments = {
    1: [
      { author: 'Sarah M.', avatar: 'S', text: 'Congrats! Keep it up!', time: '1 hour ago' },
      { author: 'Alex C.', avatar: 'A', text: 'Incredible dedication!', time: '45 min ago' },
      { author: 'Emily D.', avatar: 'E', text: '🔥🔥🔥', time: '30 min ago' }
    ],
    2: [
      { author: 'James W.', avatar: 'J', text: 'The chain rule is tricky! Well done.', time: '20 hours ago' },
      { author: 'Lisa P.', avatar: 'L', text: 'AI assistant is a game changer', time: '18 hours ago' },
      { author: 'Mike J.', avatar: 'M', text: 'Can you share some tips?', time: '15 hours ago' },
      { author: 'Nina R.', avatar: 'N', text: 'Awesome progress!', time: '10 hours ago' }
    ]
  };

  let currentPostId = null;
  let postInteractions = {}; // Track likes/reactions per post

  window.openPostDetail = function (postId) {
    currentPostId = postId;
    const modal = document.getElementById('postDetailModal');
    const main = document.getElementById('postDetailMain');
    const commentsList = document.getElementById('postCommentsList');

    // Get post content
    const postEl = document.querySelector(`[data-post-id="${postId}"]`);
    if (postEl) {
      // Clone the post content excluding post-actions
      const postHeader = postEl.querySelector('.post-header');
      const postContent = postEl.querySelector('.post-content');
      const postImage = postEl.querySelector('.post-image');

      let html = '';
      if (postHeader) html += postHeader.outerHTML;
      if (postContent) html += `<p class="post-content" style="margin: var(--spacing-md) 0;">${postContent.textContent}</p>`;
      if (postImage) html += `<img src="${postImage.src}" alt="" class="post-image" style="width: 100%; max-height: 400px; object-fit: cover; border-radius: 8px; cursor: pointer;" onclick="openImageGallery(['${postImage.src}'])">`;

      // Add like/comment stats
      const likeBtn = postEl.querySelector('.like-btn');
      const likeCount = likeBtn ? likeBtn.textContent.match(/(\d+)/)?.[1] || '0' : '0';
      const commentCount = mockComments[postId]?.length || 0;

      html += `
        <div class="post-detail-stats" style="display: flex; gap: var(--spacing-lg); margin-top: var(--spacing-md); padding-top: var(--spacing-md); border-top: var(--border-subtle); color: var(--color-text-muted); font-size: 0.9rem;">
          <span>❤️ ${likeCount} likes</span>
          <span>💬 ${commentCount} comments</span>
        </div>
      `;

      main.innerHTML = html;
    }

    // Render comments
    const comments = mockComments[postId] || [];
    commentsList.innerHTML = comments.map(c => `
      <div class="comment-item">
        <div class="comment-avatar">${c.avatar}</div>
        <div class="comment-content">
          <span class="comment-author">${c.author}</span>
          <p class="comment-text">${c.text}</p>
          <span class="comment-time">${c.time}</span>
        </div>
      </div>
    `).join('') || '<p class="empty-state">No comments yet. Be the first to comment!</p>';

    modal.classList.remove('hidden');
  };

  window.closePostDetail = function () {
    const modal = document.getElementById('postDetailModal');
    modal.classList.add('hidden');

    // Sync comment count back to the original post
    if (currentPostId) {
      const commentCount = mockComments[currentPostId]?.length || 0;
      const postEl = document.querySelector(`[data-post-id="${currentPostId}"]`);
      if (postEl) {
        const commentBtn = postEl.querySelector('.post-action:nth-child(2)');
        if (commentBtn && !commentBtn.classList.contains('like-btn')) {
          commentBtn.textContent = `💬 ${commentCount}`;
        }
      }
    }

    currentPostId = null;
  };

  window.submitComment = function () {
    const input = document.getElementById('postCommentInput');
    const text = input.value.trim();
    if (!text) return;

    const userData = JSON.parse(localStorage.getItem('focusfund_user') || '{}');
    const initial = (userData.name || 'U').charAt(0).toUpperCase();

    const commentsList = document.getElementById('postCommentsList');
    const emptyState = commentsList.querySelector('.empty-state');
    if (emptyState) emptyState.remove();

    // Add to mockComments
    if (!mockComments[currentPostId]) {
      mockComments[currentPostId] = [];
    }
    mockComments[currentPostId].push({
      author: userData.name || 'You',
      avatar: initial,
      text: text,
      time: 'Just now'
    });

    const commentHtml = `
      <div class="comment-item">
        <div class="comment-avatar">${initial}</div>
        <div class="comment-content">
          <span class="comment-author">${userData.name || 'You'}</span>
          <p class="comment-text">${escapeHtml(text)}</p>
          <span class="comment-time">Just now</span>
        </div>
      </div>
    `;
    commentsList.insertAdjacentHTML('beforeend', commentHtml);
    input.value = '';

    // Update the detail stats
    const stats = document.querySelector('.post-detail-stats');
    if (stats) {
      const commentSpan = stats.querySelector('span:last-child');
      if (commentSpan) {
        commentSpan.textContent = `💬 ${mockComments[currentPostId].length} comments`;
      }
    }

    showToast('Comment added!', 'success');
  };

  window.sharePost = function (postId) {
    showToast('Post link copied to clipboard!', 'success');
  };

  // ===== Image Gallery =====
  let galleryImages = [];
  let galleryIndex = 0;

  window.openImageGallery = function (images, startIndex = 0) {
    galleryImages = images;
    galleryIndex = startIndex;
    updateGalleryImage();
    document.getElementById('imageGalleryModal').classList.remove('hidden');
  };

  window.closeImageGallery = function () {
    document.getElementById('imageGalleryModal').classList.add('hidden');
  };

  window.prevGalleryImage = function () {
    galleryIndex = (galleryIndex - 1 + galleryImages.length) % galleryImages.length;
    updateGalleryImage();
  };

  window.nextGalleryImage = function () {
    galleryIndex = (galleryIndex + 1) % galleryImages.length;
    updateGalleryImage();
  };

  function updateGalleryImage() {
    const img = document.getElementById('galleryImage');
    const counter = document.getElementById('galleryCounter');
    if (galleryImages.length > 0) {
      img.src = galleryImages[galleryIndex];
      counter.textContent = `${galleryIndex + 1} / ${galleryImages.length}`;
    }
  }

  // ===== AI Call Reactions =====
  window.toggleCallReactions = function () {
    const picker = document.getElementById('callReactionPicker');
    picker.classList.toggle('hidden');
  };

  window.sendCallReaction = function (emoji) {
    const floatingReaction = document.getElementById('callFloatingReaction');
    floatingReaction.textContent = emoji;
    floatingReaction.style.left = `${Math.random() * 60 + 20}%`;
    floatingReaction.style.bottom = '100px';
    floatingReaction.classList.remove('hidden');

    // Reset animation
    floatingReaction.style.animation = 'none';
    setTimeout(() => {
      floatingReaction.style.animation = '';
    }, 10);

    setTimeout(() => {
      floatingReaction.classList.add('hidden');
    }, 2000);

    document.getElementById('callReactionPicker').classList.add('hidden');
  };

  // Close call reaction picker on outside click
  document.addEventListener('click', function (e) {
    const picker = document.getElementById('callReactionPicker');
    const reactBtn = e.target.closest('.call-reactions-wrapper');
    if (picker && !reactBtn) {
      picker.classList.add('hidden');
    }
  });

  // ===== AI Call Fullscreen Mode =====
  const originalSwitchAIMode = window.switchAIMode;
  window.switchAIMode = function (mode) {
    if (typeof originalSwitchAIMode === 'function') {
      originalSwitchAIMode(mode);
    } else {
      const chatMode = document.getElementById('aiChatMode');
      const callMode = document.getElementById('aiCallMode');
      const chatBtn = document.getElementById('aiModeChatBtn');
      const callBtn = document.getElementById('aiModeCallBtn');

      if (mode === 'chat') {
        chatMode.classList.remove('hidden');
        callMode.classList.add('hidden');
        chatBtn.classList.add('active');
        callBtn.classList.remove('active');
      } else {
        chatMode.classList.add('hidden');
        callMode.classList.remove('hidden');
        chatBtn.classList.remove('active');
        callBtn.classList.add('active');
      }
    }

    // Toggle fullscreen for call mode
    if (mode === 'call') {
      document.body.classList.add('ai-call-fullscreen');
    } else {
      document.body.classList.remove('ai-call-fullscreen');
    }
  };

  // Apply accessibility settings on load
  function applyAccessibilitySettings() {
    const reduceMotion = localStorage.getItem('focusfund_reduce_motion') === 'true';
    const highContrast = localStorage.getItem('focusfund_high_contrast') === 'true';

    if (reduceMotion) {
      document.body.classList.add('reduce-motion');
      const toggleEl = document.getElementById('toggleReduceMotion');
      if (toggleEl) toggleEl.checked = true;
    }

    if (highContrast) {
      document.body.classList.add('high-contrast');
      const toggleEl = document.getElementById('toggleHighContrast');
      if (toggleEl) toggleEl.checked = true;
    }
  }

  // Ensure settings are applied
  setTimeout(applyAccessibilitySettings, 100);

  // ===== Online Status Indicator =====
  function updateOnlineStatus() {
    const privacy = JSON.parse(localStorage.getItem('focusfund_privacy') || '{}');
    const showOnline = privacy.onlineStatus !== false; // default true

    // Update profile avatar dot
    const profileAvatar = document.getElementById('profilePageAvatar');
    if (profileAvatar) {
      let dot = document.getElementById('onlineStatusDot');
      if (!dot) {
        dot = document.createElement('div');
        dot.id = 'onlineStatusDot';
        profileAvatar.appendChild(dot);
      }
      dot.className = `online-status-dot ${showOnline ? 'online' : 'offline'}`;
    }

    // Update nav avatar dot
    const navAvatar = document.getElementById('userAvatarNav');
    if (navAvatar) {
      let navDot = navAvatar.querySelector('.nav-online-dot');
      if (!navDot) {
        navDot = document.createElement('div');
        navDot.className = 'nav-online-dot';
        navAvatar.appendChild(navDot);
      }
      navDot.className = `nav-online-dot ${showOnline ? 'online' : 'offline'}`;
    }
  }

  // Override savePrivacySettings to also update online status dot
  const origSavePrivacy = window.savePrivacySettings;
  window.savePrivacySettings = function () {
    origSavePrivacy();
    updateOnlineStatus();
  };

  // Update online status when navigating to profile
  const origNavigateTo2 = window.navigateTo;
  window.navigateTo = function (pageId) {
    origNavigateTo2(pageId);
    if (pageId === 'profile' || pageId === 'dashboard') {
      setTimeout(updateOnlineStatus, 50);
    }
  };

  // Also call on init after login
  setTimeout(updateOnlineStatus, 300);

  // ===== Blocked Users / Unblock =====
  let pendingUnblockUser = null;
  let pendingUnblockName = null;

  window.confirmUnblock = function (userId, userName) {
    pendingUnblockUser = userId;
    pendingUnblockName = userName;

    const modal = document.getElementById('unblockConfirmModal');
    const nameEl = document.getElementById('unblockUserName');
    if (nameEl) nameEl.textContent = userName;
    if (modal) modal.classList.remove('hidden');
  };

  window.cancelUnblock = function () {
    pendingUnblockUser = null;
    pendingUnblockName = null;
    const modal = document.getElementById('unblockConfirmModal');
    if (modal) modal.classList.add('hidden');
  };

  window.executeUnblock = function () {
    if (!pendingUnblockUser) return;

    // Remove from UI
    const item = document.querySelector(`.blocked-user-item[data-user="${pendingUnblockUser}"]`);
    if (item) item.remove();

    // Check if list is empty
    const list = document.getElementById('blockedUsersList');
    if (list && list.children.length === 0) {
      list.innerHTML = '<p class="empty-state">No blocked users</p>';
    }

    showToast(`${pendingUnblockName} has been unblocked. You cannot block them again for 30 days.`, 'success');

    cancelUnblock();
  };

  // Load saved rooms on init
  function loadSavedRooms() {
    const rooms = JSON.parse(localStorage.getItem('focusfund_rooms') || '[]');
    const roomsGrid = document.querySelector('.rooms-grid');
    const createCard = roomsGrid?.querySelector('.room-card.create-room');

    if (!roomsGrid || !createCard || rooms.length === 0) return;

    const userData = JSON.parse(localStorage.getItem('focusfund_user') || '{}');
    const initial = (userData.name || 'U').charAt(0).toUpperCase();

    rooms.forEach(room => {
      const typeEmoji = room.roomType === 'silent' ? '🤫' : room.roomType === 'public' ? '👥' : '🔒';
      const typeName = room.roomType.charAt(0).toUpperCase() + room.roomType.slice(1);
      const pomodoroLabel = room.pomodoro === '25-5' ? '25/5 Pomodoro' : room.pomodoro === '50-10' ? '50/10 Extended' : '90/20 Deep Work';

      const roomCard = document.createElement('div');
      roomCard.className = 'room-card';
      roomCard.setAttribute('data-page', 'study-room');
      roomCard.innerHTML = `
        <div class="room-card-header">
          <span class="room-type-badge ${room.roomType}">${typeEmoji} ${typeName}</span>
          <span class="room-users">1/${room.maxParticipants}</span>
        </div>
        <h3 class="room-card-title">${room.name}</h3>
        <p class="room-card-desc">${room.desc || 'No description'}</p>
        <div class="room-card-timer">
          <span class="timer-icon">⏱</span>
          <span>${pomodoroLabel}</span>
        </div>
        <div class="room-card-members">
          <div class="member-avatar">${initial}</div>
        </div>
      `;
      roomsGrid.insertBefore(roomCard, createCard);
    });
  }

  setTimeout(loadSavedRooms, 200);

})();
// Notifications Dropdown Logic
window.toggleNotificationsDropdown = function (event) {
    event.stopPropagation();
    const dropdown = document.getElementById("notificationsDropdown");
    if (dropdown) {
        dropdown.classList.toggle("hidden");
    }
    // Close other dropdowns
    const profileDropdown = document.getElementById("profileDropdown");
    if (profileDropdown && !profileDropdown.classList.contains("hidden")) {
        profileDropdown.classList.add("hidden");
    }
};

window.closeNotificationsDropdown = function () {
    const dropdown = document.getElementById("notificationsDropdown");
    if (dropdown && !dropdown.classList.contains("hidden")) {
        dropdown.classList.add("hidden");
    }
};

// Add global click listener to close notifications dropdown when clicking outside
document.addEventListener("click", function (event) {
    const notificationsDropdown = document.getElementById("notificationsDropdown");
    const notificationBell = document.getElementById("notificationBell");
    
    if (notificationsDropdown && !notificationsDropdown.classList.contains("hidden")) {
        if (!notificationsDropdown.contains(event.target) && event.target !== notificationBell && !notificationBell.contains(event.target)) {
            closeNotificationsDropdown();
        }
    }
});

