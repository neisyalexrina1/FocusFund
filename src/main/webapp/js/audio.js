// FocusFund - Ambient Audio
// Background music with rain and nature sounds

(function () {
  'use strict';

  const state = {
    isPlaying: false,       // true = audio nodes are actually running
    pendingResume: false,   // true = we WANT to play but haven't started yet
    volume: localStorage.getItem('focusfund_ambient_volume') ? parseFloat(localStorage.getItem('focusfund_ambient_volume')) : 0.3,
    audioContext: null,
    gainNode: null,
    noiseNode: null,
    rainOscillators: [],
    customAudio: null,
    customUrl: null
  };

  // DOM elements
  let audioToggle = null;
  let volumeSlider = null;

  // Initialize Web Audio API
  function initAudio() {
    if (state.audioContext) return;

    try {
      state.audioContext = new (window.AudioContext || window.webkitAudioContext)();
      state.gainNode = state.audioContext.createGain();
      state.gainNode.connect(state.audioContext.destination);
      state.gainNode.gain.value = state.volume;
    } catch (e) {
      console.log('Web Audio API not supported');
    }
  }

  // Create pink noise (rain-like sound)
  function createPinkNoise() {
    if (!state.audioContext) return null;

    const bufferSize = 4096;
    const pinkNoise = state.audioContext.createScriptProcessor(bufferSize, 1, 1);

    let b0 = 0, b1 = 0, b2 = 0, b3 = 0, b4 = 0, b5 = 0, b6 = 0;

    pinkNoise.onaudioprocess = function (e) {
      const output = e.outputBuffer.getChannelData(0);
      for (let i = 0; i < bufferSize; i++) {
        const white = Math.random() * 2 - 1;
        b0 = 0.99886 * b0 + white * 0.0555179;
        b1 = 0.99332 * b1 + white * 0.0750759;
        b2 = 0.96900 * b2 + white * 0.1538520;
        b3 = 0.86650 * b3 + white * 0.3104856;
        b4 = 0.55000 * b4 + white * 0.5329522;
        b5 = -0.7616 * b5 - white * 0.0168980;
        output[i] = (b0 + b1 + b2 + b3 + b4 + b5 + b6 + white * 0.5362) * 0.05;
        b6 = white * 0.115926;
      }
    };

    return pinkNoise;
  }

  // Create gentle ambient pad
  function createAmbientPad() {
    if (!state.audioContext) return [];

    const oscillators = [];
    const frequencies = [110, 165, 220, 330]; // A2, E3, A3, E4 - peaceful chord

    frequencies.forEach((freq, index) => {
      const osc = state.audioContext.createOscillator();
      const oscGain = state.audioContext.createGain();

      osc.type = 'sine';
      osc.frequency.value = freq;

      // Very low volume for ambient background
      oscGain.gain.value = 0.02 * (1 - index * 0.15);

      // Add slight detuning for warmth
      osc.detune.value = (Math.random() - 0.5) * 10;

      osc.connect(oscGain);
      oscGain.connect(state.gainNode);

      oscillators.push({ osc, gain: oscGain });
    });

    return oscillators;
  }

  // Create low frequency rumble (distant thunder)
  function createLowRumble() {
    if (!state.audioContext) return null;

    const osc = state.audioContext.createOscillator();
    const oscGain = state.audioContext.createGain();
    const filter = state.audioContext.createBiquadFilter();

    osc.type = 'sawtooth';
    osc.frequency.value = 40;

    filter.type = 'lowpass';
    filter.frequency.value = 100;
    filter.Q.value = 1;

    oscGain.gain.value = 0.03;

    osc.connect(filter);
    filter.connect(oscGain);
    oscGain.connect(state.gainNode);

    return { osc, gain: oscGain, filter };
  }

  // Kill any existing audio resources without changing state flags
  function cleanupAudioResources() {
    if (state.customAudio) {
      try { state.customAudio.pause(); } catch (e) { }
      state.customAudio = null;
    }
    if (state.noiseNode) {
      try { state.noiseNode.disconnect(); } catch (e) { }
      state.noiseNode = null;
    }
    state.rainOscillators.forEach(({ osc }) => {
      try { osc.stop(); osc.disconnect(); } catch (e) { }
    });
    state.rainOscillators = [];
  }

  function startCustomAudio() {
    const url = state.customUrl || localStorage.getItem('focusfund_ambient_url');

    if (!url) return false;

    try {
      state.customAudio = new Audio(url);
      state.customAudio.loop = true;
      state.customAudio.volume = state.volume;
      state.customAudio.crossOrigin = 'anonymous';

      state.customAudio.play().then(() => {
        state.isPlaying = true;
        state.pendingResume = false;
        localStorage.setItem('focusfund_ambient_playing', 'true');
        updateUI();
      }).catch(err => {
        console.log('Custom audio failed, falling back to generated audio:', err);
        state.customAudio = null;
        startGeneratedAudio();
      });

      return true;
    } catch (e) {
      console.log('Error loading custom audio:', e);
      return false;
    }
  }

  // Start generated audio (Web Audio API)
  function startGeneratedAudio() {
    initAudio();
    if (!state.audioContext) return;

    try {
      // Resume audio context if suspended
      if (state.audioContext.state === 'suspended') {
        state.audioContext.resume().catch(e => console.log('Audio context resume blocked:', e));
      }

      // Create rain sound (pink noise)
      state.noiseNode = createPinkNoise();
      if (state.noiseNode) {
        const noiseGain = state.audioContext.createGain();
        noiseGain.gain.value = 0.4;
        state.noiseNode.connect(noiseGain);
        noiseGain.connect(state.gainNode);
      }

      // Create ambient pad
      state.rainOscillators = createAmbientPad();
      state.rainOscillators.forEach(({ osc }) => {
        try { osc.start(); } catch (e) { }
      });

      // Create low rumble
      const rumble = createLowRumble();
      if (rumble) {
        try { rumble.osc.start(); } catch (e) { }
        state.rainOscillators.push(rumble);
      }

      state.isPlaying = true;
      state.pendingResume = false;
      localStorage.setItem('focusfund_ambient_playing', 'true');
      updateUI();
    } catch (err) {
      console.log('Failed to start generated audio:', err);
    }
  }

  // Start ambient audio
  function startAudio() {
    // Clean up any leftover resources first to prevent duplicates
    cleanupAudioResources();

    // Try custom URL first
    const hasCustom = startCustomAudio();

    // If no custom audio or it failed, use generated
    if (!hasCustom) {
      startGeneratedAudio();
    }
  }

  // Stop ambient audio
  function stopAudio() {
    cleanupAudioResources();

    state.isPlaying = false;
    state.pendingResume = false;
    localStorage.setItem('focusfund_ambient_playing', 'false');
    updateUI();
  }

  // Toggle audio
  function toggleAudio() {
    if (state.isPlaying) {
      stopAudio();
    } else {
      startAudio();
    }
  }

  function setVolume(value) {
    state.volume = value / 100;
    localStorage.setItem('focusfund_ambient_volume', state.volume);

    // Update Web Audio API gain
    if (state.gainNode) {
      state.gainNode.gain.setValueAtTime(state.volume, state.audioContext.currentTime);
    }

    // Update custom audio volume
    if (state.customAudio) {
      state.customAudio.volume = state.volume;
    }
  }

  // Set custom audio URL
  function setCustomUrl(url) {
    state.customUrl = url;
    localStorage.setItem('focusfund_ambient_url', url);

    // If currently playing, restart with new URL
    if (state.isPlaying) {
      stopAudio();
      startAudio();
    }
  }

  // Update UI — handles both old icon-button toggles and settings page toggle
  function updateUI() {
    // "Active" means either actually playing OR pending resume
    const isActive = state.isPlaying || state.pendingResume;

    // Update settings page toggle if it exists
    const settingsToggle = document.getElementById('toggleAmbientSound');
    if (settingsToggle) {
      settingsToggle.checked = isActive;
    }

    // Update legacy audio icon buttons if they exist
    if (audioToggle) {
      const audioOn = audioToggle.querySelector('.audio-on');
      const audioOff = audioToggle.querySelector('.audio-off');
      if (audioOn && audioOff) {
        if (isActive) {
          audioOn.classList.remove('hidden');
          audioOff.classList.add('hidden');
        } else {
          audioOn.classList.add('hidden');
          audioOff.classList.remove('hidden');
        }
      }
    }
  }

  // Initialize
  function init() {
    // Load saved custom URL
    const savedUrl = localStorage.getItem('focusfund_ambient_url');
    if (savedUrl) {
      state.customUrl = savedUrl;
    }

    // Check if it was playing previously
    const wasPlaying = localStorage.getItem('focusfund_ambient_playing') === 'true';
    if (wasPlaying) {
      // Mark as "pending" — we WANT to play but haven't started actual audio yet
      state.pendingResume = true;

      // Auto-play might be blocked, so we add a one-time interaction listener
      const resumeAudio = () => {
        if (!state.pendingResume) return; // User turned it off before interacting

        startAudio(); // This will cleanupAudioResources first, then start fresh

        // Remove listeners once activated
        document.removeEventListener('click', resumeAudio);
        document.removeEventListener('keydown', resumeAudio);
      };

      // Add listeners to catch first user interaction
      document.addEventListener('click', resumeAudio);
      document.addEventListener('keydown', resumeAudio);

      // Try auto-play immediately just in case browser allows it
      setTimeout(() => {
        if (state.pendingResume && !state.isPlaying) {
          startAudio();
        }
      }, 500);
    }

    updateUI();
  }

  // Clean up on page unload
  window.addEventListener('beforeunload', () => {
    // Don't update localStorage here — we want the saved state to persist
    // so it resumes on the next page.
    if (state.customAudio) {
      try { state.customAudio.pause(); } catch (e) { }
    }
    if (state.audioContext) {
      try { state.audioContext.close(); } catch (e) { }
    }
  });

  // Initialize when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  // Expose for external control
  window.ambientAudio = {
    toggle: toggleAudio,
    start: startAudio,
    stop: stopAudio,
    setVolume: setVolume,
    setCustomUrl: setCustomUrl
  };

})();