'use strict';

document.documentElement.classList.add('has-js');

// Mobile navigation
const menuButton = document.querySelector('.menu-toggle');
const navigation = document.querySelector('#site-nav');
function closeMenu() {
  if (!menuButton || !navigation) return;
  menuButton.setAttribute('aria-expanded', 'false');
  navigation.classList.remove('is-open');
}
if (menuButton && navigation) {
  menuButton.addEventListener('click', () => {
    const opened = menuButton.getAttribute('aria-expanded') !== 'true';
    menuButton.setAttribute('aria-expanded', String(opened));
    navigation.classList.toggle('is-open', opened);
  });
  navigation.addEventListener('click', event => {
    if (event.target.closest('a')) closeMenu();
  });
  document.addEventListener('keydown', event => {
    if (event.key === 'Escape' && menuButton.getAttribute('aria-expanded') === 'true') {
      closeMenu();
      menuButton.focus();
    }
  });
  document.addEventListener('click', event => {
    if (!event.target.closest('.site-header')) closeMenu();
  });
  window.matchMedia('(min-width: 861px)').addEventListener('change', closeMenu);
}

// Copy email
const copyButton = document.querySelector('.copy-email');
if (copyButton) {
  copyButton.addEventListener('click', async () => {
    const status = document.querySelector('.copy-status');
    try {
      await navigator.clipboard.writeText(copyButton.dataset.email);
      status.textContent = 'Email copied. Talk soon.';
    } catch {
      status.textContent = 'You can reach me at ' + copyButton.dataset.email;
    }
  });
}

document.querySelectorAll('[data-year]').forEach(element => {
  element.textContent = String(new Date().getFullYear());
});

// Chart tooltips: value first, then series and category. Every value is also a
// direct label and in the table view, so the tooltip only adds the system name.
document.querySelectorAll('[data-chart]').forEach(chart => {
  const tip = document.createElement('div');
  tip.className = 'tooltip';
  tip.hidden = true;
  tip.setAttribute('aria-hidden', 'true');
  const value = document.createElement('strong');
  const series = document.createElement('span');
  const key = document.createElement('span');
  const name = document.createElement('span');
  const detail = document.createElement('span');
  series.style.display = 'block';
  detail.style.display = 'block';
  series.append(key, name);
  tip.append(value, series, detail);
  chart.append(tip);

  function show(bar) {
    value.textContent = bar.dataset.value;
    name.textContent = bar.dataset.series;
    detail.textContent = bar.dataset.detail;
    key.className = 'key ' + ([...bar.classList].find(c => c.startsWith('s-')) || '');
    tip.hidden = false;
    const box = chart.getBoundingClientRect();
    const mark = bar.getBoundingClientRect();
    const half = tip.offsetWidth / 2;
    const x = Math.min(Math.max(mark.right - box.left, half + 8), box.width - half - 8);
    tip.style.left = x + 'px';
    tip.style.top = (mark.top - box.top) + 'px';
  }
  const hide = () => { tip.hidden = true; };

  chart.querySelectorAll('.bar-row').forEach(row => {
    const bar = row.querySelector('.bar');
    if (!bar) return;
    row.addEventListener('pointerenter', () => show(bar));
    row.addEventListener('pointerleave', hide);
    bar.addEventListener('focus', () => show(bar));
    bar.addEventListener('blur', hide);
  });
});

// Mark the section in view; anchor links work without JavaScript.
const sectionLinks = Array.from(document.querySelectorAll('.site-nav a[href^="#"]'));
if ('IntersectionObserver' in window && sectionLinks.length) {
  const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => {
      if (!entry.isIntersecting) return;
      sectionLinks.forEach(link => {
        if (link.hash === '#' + entry.target.id) link.setAttribute('aria-current', 'location');
        else link.removeAttribute('aria-current');
      });
    });
  }, { rootMargin: '-20% 0px -60% 0px', threshold: 0 });
  sectionLinks.forEach(link => {
    const section = document.getElementById(link.hash.slice(1));
    if (section) observer.observe(section);
  });
}
