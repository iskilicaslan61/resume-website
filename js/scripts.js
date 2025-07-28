// Enhanced JavaScript for Modern Resume Website

// Loading Animation
document.addEventListener('DOMContentLoaded', function () {
  // Create loading screen
  const loading = document.createElement('div');
  loading.className = 'loading';
  loading.innerHTML = '<div class="spinner"></div>';
  document.body.appendChild(loading);

  // Hide loading after page loads
  setTimeout(() => {
    loading.classList.add('hidden');
    setTimeout(() => {
      loading.remove();
    }, 500);
  }, 1000);

  // Initialize all features
  initializeNavigation();
  initializeScrollEffects();
  initializeAnimations();
  initializeScrollToTop();
  initializeTypingEffect();
  initializeParallaxEffect();
  initializeHoverEffects();
});

// Enhanced Navigation with Smooth Scrolling
function initializeNavigation() {
  const nav = document.querySelector('nav');
  const navLinks = document.querySelectorAll('.nav-links a');

  // Navbar scroll effect
  window.addEventListener('scroll', () => {
    if (window.scrollY > 100) {
      nav.classList.add('scrolled');
    } else {
      nav.classList.remove('scrolled');
    }
  });

  // Smooth scrolling for navigation links
  navLinks.forEach(link => {
    link.addEventListener('click', (e) => {
      e.preventDefault();
      const targetId = link.getAttribute('href').substring(1);
      const targetSection = document.getElementById(targetId);

      if (targetSection) {
        const offsetTop = targetSection.offsetTop - 80;
        window.scrollTo({
          top: offsetTop,
          behavior: 'smooth'
        });
      }
    });
  });

  // Active navigation highlighting
  window.addEventListener('scroll', () => {
    const sections = document.querySelectorAll('section');
    const navLinks = document.querySelectorAll('.nav-links a');

    let current = '';
    sections.forEach(section => {
      const sectionTop = section.offsetTop - 100;
      const sectionHeight = section.clientHeight;
      if (window.scrollY >= sectionTop && window.scrollY < sectionTop + sectionHeight) {
        current = section.getAttribute('id');
      }
    });

    navLinks.forEach(link => {
      link.classList.remove('active');
      if (link.getAttribute('href') === `#${current}`) {
        link.classList.add('active');
      }
    });
  });
}

// Enhanced Scroll Effects
function initializeScrollEffects() {
  // Intersection Observer for fade-in animations
  const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
  };

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.style.opacity = '1';
        entry.target.style.transform = 'translateY(0)';
      }
    });
  }, observerOptions);

  // Observe all sections and cards
  document.querySelectorAll('section, .card, .education-card-new').forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(30px)';
    el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
    observer.observe(el);
  });
}

// Enhanced Animations
function initializeAnimations() {
  // Add floating animation to profile image
  const profileImage = document.querySelector('.profile-image');
  if (profileImage) {
    profileImage.addEventListener('mouseenter', () => {
      profileImage.style.animation = 'pulse 1s ease-in-out';
    });

    profileImage.addEventListener('mouseleave', () => {
      profileImage.style.animation = 'float 6s ease-in-out infinite';
    });
  }

  // Add hover effects to cards
  document.querySelectorAll('.card, .education-card-new').forEach(card => {
    card.addEventListener('mouseenter', () => {
      card.style.transform = 'translateY(-10px) scale(1.02)';
    });

    card.addEventListener('mouseleave', () => {
      card.style.transform = 'translateY(0) scale(1)';
    });
  });
}

// Enhanced Scroll to Top Button
function initializeScrollToTop() {
  const scrollToTopBtn = document.getElementById('scrollToTop');

  if (scrollToTopBtn) {
    window.addEventListener('scroll', () => {
      if (window.scrollY > 300) {
        scrollToTopBtn.style.display = 'block';
        scrollToTopBtn.style.opacity = '1';
      } else {
        scrollToTopBtn.style.opacity = '0';
        setTimeout(() => {
          if (window.scrollY <= 300) {
            scrollToTopBtn.style.display = 'none';
          }
        }, 300);
      }
    });

    scrollToTopBtn.addEventListener('click', () => {
      window.scrollTo({
        top: 0,
        behavior: 'smooth'
      });
    });
  }
}

// Typing Effect for Profile Text
function initializeTypingEffect() {
  const profileText = document.querySelector('.profile-text h1');
  if (profileText) {
    const text = profileText.textContent;
    profileText.textContent = '';

    let i = 0;
    const typeWriter = () => {
      if (i < text.length) {
        profileText.textContent += text.charAt(i);
        i++;
        setTimeout(typeWriter, 100);
      }
    };

    // Start typing effect after page loads
    setTimeout(typeWriter, 1500);
  }
}

// Parallax Effect for Background
function initializeParallaxEffect() {
  const header = document.querySelector('header');

  window.addEventListener('scroll', () => {
    const scrolled = window.pageYOffset;
    const rate = scrolled * -0.5;

    if (header) {
      header.style.transform = `translateY(${rate}px)`;
    }
  });
}

// Enhanced Hover Effects
function initializeHoverEffects() {
  // Social icons hover effect
  document.querySelectorAll('.social-icons img').forEach(icon => {
    icon.addEventListener('mouseenter', () => {
      icon.style.transform = 'scale(1.3) rotate(10deg)';
    });

    icon.addEventListener('mouseleave', () => {
      icon.style.transform = 'scale(1) rotate(0deg)';
    });
  });

  // Project images hover effect
  document.querySelectorAll('.project-image').forEach(img => {
    img.addEventListener('mouseenter', () => {
      img.style.transform = 'scale(1.05)';
      img.style.boxShadow = '0 10px 30px rgba(0,0,0,0.3)';
    });

    img.addEventListener('mouseleave', () => {
      img.style.transform = 'scale(1)';
      img.style.boxShadow = '0 4px 20px rgba(0,0,0,0.15)';
    });
  });

  // Contact values hover effect
  document.querySelectorAll('.contact-value').forEach(contact => {
    contact.addEventListener('mouseenter', () => {
      contact.style.transform = 'translateX(10px)';
      contact.style.background = 'linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%)';
    });

    contact.addEventListener('mouseleave', () => {
      contact.style.transform = 'translateX(0)';
      contact.style.background = '#ffffff';
    });
  });
}

// Enhanced Form Validation (if contact form exists)
function initializeFormValidation() {
  const contactForm = document.querySelector('form');
  if (contactForm) {
    contactForm.addEventListener('submit', (e) => {
      e.preventDefault();

      // Add success animation
      const submitBtn = contactForm.querySelector('button[type="submit"]');
      const originalText = submitBtn.textContent;

      submitBtn.textContent = 'Gönderiliyor...';
      submitBtn.style.background = 'linear-gradient(135deg, #28a745 0%, #20c997 100%)';

      setTimeout(() => {
        submitBtn.textContent = 'Gönderildi!';
        submitBtn.style.background = 'linear-gradient(135deg, #28a745 0%, #20c997 100%)';

        setTimeout(() => {
          submitBtn.textContent = originalText;
          submitBtn.style.background = 'linear-gradient(45deg, #252C64, #2E398D)';
        }, 2000);
      }, 1500);
    });
  }
}

// Enhanced Mobile Menu (if needed)
function initializeMobileMenu() {
  const mobileMenuBtn = document.querySelector('.mobile-menu-btn');
  const navLinks = document.querySelector('.nav-links');

  if (mobileMenuBtn && navLinks) {
    mobileMenuBtn.addEventListener('click', () => {
      navLinks.classList.toggle('active');
      mobileMenuBtn.classList.toggle('active');
    });
  }
}

// Performance Optimization
function optimizePerformance() {
  // Lazy loading for images
  const images = document.querySelectorAll('img[data-src]');
  const imageObserver = new IntersectionObserver((entries, observer) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const img = entry.target;
        img.src = img.dataset.src;
        img.classList.remove('lazy');
        imageObserver.unobserve(img);
      }
    });
  });

  images.forEach(img => imageObserver.observe(img));
}

// Enhanced Error Handling
window.addEventListener('error', (e) => {
  console.error('JavaScript Error:', e.error);
});

// Enhanced Console Logging
console.log('%c🚀 Resume Website Loaded Successfully!', 'color: #FFD700; font-size: 16px; font-weight: bold;');
console.log('%c👨‍💻 Developed with ❤️ by Ismail Kilicaslan', 'color: #252C64; font-size: 14px;');

// Export functions for potential external use
window.ResumeWebsite = {
  initializeNavigation,
  initializeScrollEffects,
  initializeAnimations,
  initializeScrollToTop,
  initializeTypingEffect,
  initializeParallaxEffect,
  initializeHoverEffects
};