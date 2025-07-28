// filepath: /cv-website/cv-website/src/js/scripts.js

document.addEventListener('DOMContentLoaded', function () {
  // Profile image loading with fallback
  loadProfileImage();

  // Load content from src files
  loadSrcContent();

  // Smooth scrolling for internal links
  const links = document.querySelectorAll('a[href^="#"]');
  for (const link of links) {
    link.addEventListener('click', function (e) {
      e.preventDefault();
      const targetId = this.getAttribute('href');
      const targetElement = document.querySelector(targetId);
      if (targetElement) {
        targetElement.scrollIntoView({
          behavior: 'smooth'
        });
      }
    });
  }

  // Form submission handling (example)
  const contactForm = document.getElementById('contact-form');
  if (contactForm) {
    contactForm.addEventListener('submit', function (e) {
      e.preventDefault();
      // Handle form submission logic here
      alert('Form submitted!'); // Placeholder for actual submission logic
    });
  }
});

// Profile image loading function with fallback
function loadProfileImage() {
  const profileImage = document.querySelector('.profile-image');
  if (!profileImage) return;

  const imageUrl = 'assets/images/ismail-profile.jpg';
  const placeholderUrl = 'assets/images/profile-placeholder.svg';

  // Try to load the actual profile image first
  const img = new Image();
  img.onload = function () {
    profileImage.src = imageUrl;
    profileImage.style.background = 'none';
  };

  img.onerror = function () {
    // If actual image fails, use placeholder
    profileImage.src = placeholderUrl;
    console.log('Profile image not found, using placeholder');
  };

  img.src = imageUrl;
}

// Load content from src files
function loadSrcContent() {
  const contentMap = {
    'berufserfahrungen': 'src/berufserfahrungen.html',
    'kompetenzen': 'src/kompetenzen.html',
    'projekte': 'src/projekte.html',
    'bildungs': 'src/bildungs.html',
    'kontakt': 'src/kontakt.html'
  };

  Object.keys(contentMap).forEach(sectionId => {
    const section = document.getElementById(sectionId);
    if (section) {
      fetch(contentMap[sectionId])
        .then(response => response.text())
        .then(html => {
          // Extract content from the src file
          const parser = new DOMParser();
          const doc = parser.parseFromString(html, 'text/html');
          const content = doc.querySelector('.section, .kompetenzen-section, section');

          if (content) {
            // Replace the section content
            section.innerHTML = content.innerHTML;
          }
        })
        .catch(error => {
          console.log(`Could not load ${contentMap[sectionId]}:`, error);
        });
    }
  });
}

// Dark mode toggle
window.addEventListener('DOMContentLoaded', function () {
  const toggle = document.getElementById('darkModeToggle');
  const body = document.body;
  // Load preference
  if (localStorage.getItem('darkMode') === 'true') {
    body.classList.add('dark-mode');
    if (toggle) toggle.checked = true;
  }
  if (toggle) {
    toggle.addEventListener('change', function () {
      if (toggle.checked) {
        body.classList.add('dark-mode');
        localStorage.setItem('darkMode', 'true');
      } else {
        body.classList.remove('dark-mode');
        localStorage.setItem('darkMode', 'false');
      }
    });
  }
});