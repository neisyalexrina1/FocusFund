// FocusFund - Background Animations
// Stars, Rain, and Shooting Stars

(function() {
  'use strict';

  // Configuration
  const config = {
    stars: {
      count: 150,
      sizes: ['small', 'medium', 'large'],
      sizeWeights: [0.6, 0.3, 0.1] // 60% small, 30% medium, 10% large
    },
    rain: {
      count: 100,
      minDuration: 0.8,
      maxDuration: 1.5,
      minHeight: 15,
      maxHeight: 30
    },
    shootingStars: {
      interval: { min: 4000, max: 10000 }, // Random interval between shooting stars
      duration: { min: 1.5, max: 2.5 }
    }
  };

  // Utility functions
  function random(min, max) {
    return Math.random() * (max - min) + min;
  }

  function randomInt(min, max) {
    return Math.floor(random(min, max + 1));
  }

  function weightedRandom(items, weights) {
    const totalWeight = weights.reduce((sum, weight) => sum + weight, 0);
    let random = Math.random() * totalWeight;
    
    for (let i = 0; i < items.length; i++) {
      random -= weights[i];
      if (random <= 0) {
        return items[i];
      }
    }
    return items[items.length - 1];
  }

  // Create stars
  function createStars() {
    const container = document.getElementById('stars');
    if (!container) return;

    // Clear existing stars
    container.innerHTML = '';

    for (let i = 0; i < config.stars.count; i++) {
      const star = document.createElement('div');
      star.className = 'star';
      
      // Random size
      const size = weightedRandom(config.stars.sizes, config.stars.sizeWeights);
      star.classList.add(size);
      
      // Random position
      star.style.left = `${random(0, 100)}%`;
      star.style.top = `${random(0, 100)}%`;
      
      // Random animation delay and duration
      star.style.setProperty('--delay', `${random(0, 5)}s`);
      star.style.setProperty('--duration', `${random(2, 5)}s`);
      
      container.appendChild(star);
    }
  }

  // Create rain drops
  function createRain() {
    const container = document.getElementById('rain');
    if (!container) return;

    // Clear existing rain
    container.innerHTML = '';

    for (let i = 0; i < config.rain.count; i++) {
      const drop = document.createElement('div');
      drop.className = 'raindrop';
      
      // Random position
      drop.style.left = `${random(0, 100)}%`;
      
      // Random height
      const height = random(config.rain.minHeight, config.rain.maxHeight);
      drop.style.height = `${height}px`;
      
      // Random animation
      const duration = random(config.rain.minDuration, config.rain.maxDuration);
      drop.style.setProperty('--duration', `${duration}s`);
      drop.style.setProperty('--delay', `${random(0, 2)}s`);
      
      container.appendChild(drop);
    }
  }

  // Create a shooting star
  function createShootingStar() {
    const container = document.getElementById('shooting-stars');
    if (!container) return;

    const shootingStar = document.createElement('div');
    shootingStar.className = 'shooting-star';
    
    // Random starting position (top portion of screen)
    shootingStar.style.left = `${random(10, 70)}%`;
    shootingStar.style.top = `${random(5, 40)}%`;
    
    // Random duration
    const duration = random(
      config.shootingStars.duration.min,
      config.shootingStars.duration.max
    );
    shootingStar.style.setProperty('--duration', `${duration}s`);
    
    container.appendChild(shootingStar);
    
    // Remove after animation
    setTimeout(() => {
      shootingStar.remove();
    }, duration * 1000 + 100);
  }

  // Schedule shooting stars
  function scheduleShootingStar() {
    const delay = random(
      config.shootingStars.interval.min,
      config.shootingStars.interval.max
    );
    
    setTimeout(() => {
      createShootingStar();
      scheduleShootingStar();
    }, delay);
  }

  // Handle visibility change (pause animations when tab is hidden)
  function handleVisibilityChange() {
    const rain = document.getElementById('rain');
    const stars = document.getElementById('stars');
    
    if (document.hidden) {
      if (rain) rain.style.animationPlayState = 'paused';
      if (stars) stars.style.animationPlayState = 'paused';
    } else {
      if (rain) rain.style.animationPlayState = 'running';
      if (stars) stars.style.animationPlayState = 'running';
    }
  }

  // Initialize animations
  function init() {
    createStars();
    createRain();
    scheduleShootingStar();
    
    // Listen for visibility changes
    document.addEventListener('visibilitychange', handleVisibilityChange);
    
    // Recreate on window resize (debounced)
    let resizeTimeout;
    window.addEventListener('resize', function() {
      clearTimeout(resizeTimeout);
      resizeTimeout = setTimeout(() => {
        createStars();
        createRain();
      }, 250);
    });
  }

  // Start when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  // Expose for external control if needed
  window.backgroundAnimations = {
    createStars,
    createRain,
    createShootingStar
  };

})();
