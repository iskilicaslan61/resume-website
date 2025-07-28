// Smooth scrolling for navigation links
document.addEventListener('DOMContentLoaded', function () {
  // Navigation smooth scrolling
  const navLinks = document.querySelectorAll('.nav-links a[href^="#"]');

  navLinks.forEach(link => {
    link.addEventListener('click', function (e) {
      e.preventDefault();
      const targetId = this.getAttribute('href');
      const targetSection = document.querySelector(targetId);

      if (targetSection) {
        targetSection.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        });
      }
    });
  });

  // Scroll to top button functionality
  const scrollToTopBtn = document.getElementById('scrollToTop');

  // Show/hide scroll to top button
  window.addEventListener('scroll', function () {
    if (window.pageYOffset > 300) {
      scrollToTopBtn.style.display = 'block';
    } else {
      scrollToTopBtn.style.display = 'none';
    }
  });

  // Scroll to top function
  window.scrollToTop = function () {
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    });
  };

  // Active navigation highlighting
  const sections = document.querySelectorAll('section[id]');
  const navItems = document.querySelectorAll('.nav-links a');

  window.addEventListener('scroll', function () {
    let current = '';
    const scrollPosition = window.scrollY + 100;

    sections.forEach(section => {
      const sectionTop = section.offsetTop;
      const sectionHeight = section.offsetHeight;

      if (scrollPosition >= sectionTop && scrollPosition < sectionTop + sectionHeight) {
        current = section.getAttribute('id');
      }
    });

    navItems.forEach(item => {
      item.classList.remove('active');
      if (item.getAttribute('href') === `#${current}`) {
        item.classList.add('active');
      }
    });
  });

  // Add fade-in animation for sections
  const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
  };

  const observer = new IntersectionObserver(function (entries) {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.style.opacity = '1';
        entry.target.style.transform = 'translateY(0)';
      }
    });
  }, observerOptions);

  // Observe all sections
  sections.forEach(section => {
    section.style.opacity = '0';
    section.style.transform = 'translateY(20px)';
    section.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
    observer.observe(section);
  });

  // Add hover effects for cards
  const cards = document.querySelectorAll('.card');
  cards.forEach(card => {
    card.addEventListener('mouseenter', function () {
      this.style.transform = 'translateY(-5px)';
      this.style.boxShadow = '0 8px 25px rgba(0, 0, 0, 0.15)';
    });

    card.addEventListener('mouseleave', function () {
      this.style.transform = 'translateY(0)';
      this.style.boxShadow = '0 4px 8px rgba(0, 0, 0, 0.2)';
    });
  });

  // Add loading animation
  window.addEventListener('load', function () {
    document.body.classList.add('loaded');
  });
});

// Export for module system
export default {};