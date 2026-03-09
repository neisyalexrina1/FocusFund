// FocusFund - Pomodoro Timer
// Synchronized timer with study/break phases

(function () {
  'use strict';

  // Timer state
  const state = {
    isRunning: false,
    isStudyPhase: true,
    currentSession: 1,
    totalSessions: 4,
    studyDuration: 25 * 60, // 25 minutes in seconds
    breakDuration: 5 * 60,  // 5 minutes in seconds
    longBreakDuration: 15 * 60, // 15 minutes in seconds
    timeRemaining: 25 * 60,
    intervalId: null
  };

  // DOM elements cache
  let elements = {};

  // Initialize DOM elements
  function cacheElements() {
    elements = {
      timerMinutes: document.getElementById('timerMinutes'),
      timerSeconds: document.getElementById('timerSeconds'),
      timerProgress: document.getElementById('timerProgress'),
      timerToggle: document.getElementById('timerToggle'),
      sessionPhase: document.getElementById('sessionPhase'),
      breakTime: document.getElementById('breakTime'),
      chatStatus: document.getElementById('chatStatus'),
      chatInput: document.getElementById('chatInput'),
      chatSend: document.getElementById('chatSend'),
      chatInputContainer: document.getElementById('chatInputContainer'),
      chatMessages: document.getElementById('chatMessages'),
      roomStatus: document.querySelector('.room-status')
    };
  }

  // Format time as MM:SS
  function formatTime(seconds) {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return {
      minutes: mins.toString().padStart(2, '0'),
      seconds: secs.toString().padStart(2, '0')
    };
  }

  // Update timer display
  function updateDisplay() {
    const time = formatTime(state.timeRemaining);

    if (elements.timerMinutes) {
      elements.timerMinutes.textContent = time.minutes;
    }
    if (elements.timerSeconds) {
      elements.timerSeconds.textContent = time.seconds;
    }
    if (elements.breakTime) {
      elements.breakTime.textContent = `${time.minutes}:${time.seconds}`;
    }

    // Update progress ring
    updateProgressRing();

    // Update session phase display
    updatePhaseDisplay();
  }

  // Update circular progress ring
  function updateProgressRing() {
    if (!elements.timerProgress) return;

    const totalDuration = state.isStudyPhase ? state.studyDuration : state.breakDuration;
    const progress = state.timeRemaining / totalDuration;
    const circumference = 2 * Math.PI * 90; // r = 90
    const offset = circumference * (1 - progress);

    // Always ensure strokeDasharray is set (may not exist before setupTimerGradient runs)
    if (!elements.timerProgress.style.strokeDasharray) {
      elements.timerProgress.style.strokeDasharray = circumference;
    }
    elements.timerProgress.style.strokeDashoffset = offset;
  }

  // Update phase display text
  function updatePhaseDisplay() {
    if (elements.sessionPhase) {
      if (state.isStudyPhase) {
        elements.sessionPhase.textContent = `Focus Session ${state.currentSession}/${state.totalSessions}`;
      } else {
        elements.sessionPhase.textContent = 'Break Time';
      }
    }

    // Update room status badge
    if (elements.roomStatus) {
      if (state.isStudyPhase) {
        elements.roomStatus.textContent = '🎯 Study Time';
        elements.roomStatus.className = 'room-status studying';
      } else {
        elements.roomStatus.textContent = '☕ Break Time';
        elements.roomStatus.className = 'room-status break';
      }
    }
  }

  // Update chat availability based on phase
  function updateChatAvailability() {
    const isEnabled = !state.isStudyPhase;

    if (elements.chatStatus) {
      elements.chatStatus.textContent = isEnabled
        ? '💬 Chat is open!'
        : '🔒 Chat opens during break';
    }

    if (elements.chatInput) {
      elements.chatInput.disabled = !isEnabled;
      elements.chatInput.placeholder = isEnabled
        ? 'Type a message...'
        : 'Chat available during breaks...';
    }

    if (elements.chatSend) {
      elements.chatSend.disabled = !isEnabled;
    }

    if (elements.chatInputContainer) {
      elements.chatInputContainer.classList.toggle('disabled', !isEnabled);
    }

    // Update chat messages
    if (elements.chatMessages && state.isStudyPhase) {
      const systemMessage = elements.chatMessages.querySelector('.chat-message.system');
      if (systemMessage) {
        systemMessage.innerHTML = '<p>Chat is disabled during study time. Focus on your work! 🎯</p>';
      }
    }
  }

  // Timer tick
  function tick() {
    if (state.timeRemaining > 0) {
      state.timeRemaining--;
      updateDisplay();
    } else {
      // Phase complete
      handlePhaseComplete();
    }
  }

  // Handle phase completion
  function handlePhaseComplete() {
    pauseTimer();
    playNotificationSound();

    if (state.isStudyPhase) {
      // Show session checkout overlay before break
      if (window.showSessionCheckout) {
        window.showSessionCheckout();
      }

      // Switch to break
      state.isStudyPhase = false;

      // Check if it's time for a long break
      if (state.currentSession === state.totalSessions) {
        state.timeRemaining = state.longBreakDuration;
      } else {
        state.timeRemaining = state.breakDuration;
      }

      // Show break notification
      showNotification('Break Time!', 'Take a moment to rest and recharge.');

    } else {
      // Switch to study
      state.isStudyPhase = true;
      state.timeRemaining = state.studyDuration;

      // Increment session if not at max
      if (state.currentSession < state.totalSessions) {
        state.currentSession++;
      } else {
        // Reset sessions
        state.currentSession = 1;
      }

      // Show study notification
      showNotification('Focus Time!', 'Let\'s get back to work.');
    }

    updateDisplay();
    updateChatAvailability();
  }

  // Play notification sound (simple beep)
  function playNotificationSound() {
    try {
      const audioContext = new (window.AudioContext || window.webkitAudioContext)();
      const oscillator = audioContext.createOscillator();
      const gainNode = audioContext.createGain();

      oscillator.connect(gainNode);
      gainNode.connect(audioContext.destination);

      oscillator.frequency.value = 440;
      oscillator.type = 'sine';

      gainNode.gain.setValueAtTime(0.3, audioContext.currentTime);
      gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.5);

      oscillator.start(audioContext.currentTime);
      oscillator.stop(audioContext.currentTime + 0.5);
    } catch (e) {
      // Audio not available
      console.log('Audio notification not available');
    }
  }

  // Show browser notification
  function showNotification(title, body) {
    if ('Notification' in window && Notification.permission === 'granted') {
      new Notification(title, { body, icon: '✦' });
    }
  }

  // Request notification permission
  function requestNotificationPermission() {
    if ('Notification' in window && Notification.permission === 'default') {
      Notification.requestPermission();
    }
  }

  // Toggle timer (start/pause)
  function toggleTimer() {
    if (state.isRunning) {
      pauseTimer();
    } else {
      startTimer();
    }
  }

  // Start timer
  function startTimer() {
    if (state.isRunning) return;

    state.isRunning = true;
    state.intervalId = setInterval(tick, 1000);

    // Update toggle button appearance
    if (elements.timerToggle) {
      elements.timerToggle.classList.add('running');
    }

    // Request notification permission on first start
    requestNotificationPermission();
  }

  // Pause timer
  function pauseTimer() {
    if (!state.isRunning) return;

    state.isRunning = false;
    if (state.intervalId) {
      clearInterval(state.intervalId);
      state.intervalId = null;
    }

    // Update toggle button appearance
    if (elements.timerToggle) {
      elements.timerToggle.classList.remove('running');
    }
  }

  // Reset timer
  function resetTimer() {
    pauseTimer();
    state.timeRemaining = state.isStudyPhase ? state.studyDuration : state.breakDuration;
    updateDisplay();
  }

  // Skip current phase
  function skipPhase() {
    pauseTimer();
    state.timeRemaining = 0;
    handlePhaseComplete();
  }

  // Initialize
  function init() {
    cacheElements();
    updateDisplay();
    updateChatAvailability();

    // Set up SVG gradient for timer ring
    setupTimerGradient();
  }

  // Soft re-initialize on navigation (prevents resetting custom room data passed by navigation.js)
  function reinit() {
    cacheElements();
    updateProgressRing();
    updatePhaseDisplay();
    updateChatAvailability();
    setupTimerGradient();
  }

  // Set up timer gradient
  function setupTimerGradient() {
    const svg = document.querySelector('.timer-ring svg');
    if (!svg) return;

    // Check if gradient already exists
    if (document.getElementById('timer-gradient')) return;

    const defs = document.createElementNS('http://www.w3.org/2000/svg', 'defs');
    defs.innerHTML = `
      <linearGradient id="timer-gradient" x1="0%" y1="0%" x2="100%" y2="0%">
        <stop offset="0%" style="stop-color:hsl(210, 60%, 55%);stop-opacity:1" />
        <stop offset="100%" style="stop-color:hsl(280, 50%, 60%);stop-opacity:1" />
      </linearGradient>
    `;
    svg.insertBefore(defs, svg.firstChild);

    // Apply gradient to progress circle
    const progressCircle = document.getElementById('timerProgress');
    if (progressCircle) {
      progressCircle.style.stroke = 'url(#timer-gradient)';
      progressCircle.style.strokeDasharray = 2 * Math.PI * 90;
    }
  }

  // Initialize when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  // Expose functions globally
  window.toggleTimer = toggleTimer;
  window.resetTimer = resetTimer;
  window.skipPhase = skipPhase;

  // Re-initialize on page navigation
  document.addEventListener('click', function (e) {
    const target = e.target.closest('[data-page]');
    if (target && target.dataset.page === 'study-room') {
      setTimeout(reinit, 100);
    }
  });

})();
