// Import Alpine.js
import Alpine from 'alpinejs';
import collapse from '@alpinejs/collapse'

// Import aos
import AOS from 'aos';

document.addEventListener('DOMContentLoaded', function() {
  // Initialize Alpine
  window.Alpine = Alpine;
  Alpine.start();
  Alpine.plugin(collapse);

  AOS.init({
    once: true,
    disable: 'phone',
    duration: 600,
    easing: 'ease-out-sine',
  });
});

// import component from './components/component';
