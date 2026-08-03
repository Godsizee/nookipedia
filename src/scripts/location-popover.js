/**
 * location-popover.js · Erklärt einen Fundort im Kontext (SRP: nur Overlay-Logik).
 * Ein Popover pro Seite, per Delegation an jeden [data-location]-Trigger gebunden.
 */
import { locationInfo } from '../lib/locations.js';

// Module-scope singleton state: the listeners below are attached to `document`
// exactly once and outlive every Astro view-transition swap (the document
// itself persists across those), so `initLocationPopover()` must stay a no-op
// after the first call rather than re-arming — re-adding the same listeners
// on every page's init function would stack duplicate handlers forever.
let initialized = false;
let popover = null;
let scrim = null;
let currentTrigger = null;

export function initLocationPopover() {
  if (initialized) return;
  initialized = true;

  const closePopover = () => {
    if (!popover) return;
    popover.remove();
    popover = null;
    if (scrim) {
      scrim.remove();
      scrim = null;
    }
    if (currentTrigger) {
      currentTrigger.setAttribute('aria-expanded', 'false');
      currentTrigger.focus();
      currentTrigger = null;
    }
  };

  const openPopover = (trigger) => {
    const name = trigger.getAttribute('data-location');
    const info = locationInfo(name);
    if (!info) return;

    if (currentTrigger === trigger) {
      closePopover();
      return;
    }

    closePopover();
    currentTrigger = trigger;
    trigger.setAttribute('aria-expanded', 'true');

    const isMobile = window.matchMedia('(max-width: 559px)').matches;

    popover = document.createElement('div');
    popover.className = 'loc-pop';
    popover.setAttribute('role', 'dialog');
    popover.setAttribute('aria-label', name);
    popover.innerHTML = `
      <div class="loc-pop__header">
        <strong>${info.emoji} ${name}</strong>
        <button type="button" class="loc-pop__close" aria-label="Schließen">✕</button>
      </div>
      <div class="loc-pop__body">${info.text}</div>
    `;

    document.body.appendChild(popover);

    if (isMobile) {
      scrim = document.createElement('div');
      scrim.className = 'loc-pop__scrim';
      document.body.appendChild(scrim);
      // Ensure scrim is behind popover
      document.body.insertBefore(scrim, popover);
    } else {
      const rect = trigger.getBoundingClientRect();
      popover.style.position = 'absolute';
      const popoverRect = popover.getBoundingClientRect();
      
      let top = rect.bottom + window.scrollY + 8;
      let left = rect.left + window.scrollX;
      
      if (left + popoverRect.width > window.innerWidth - 16) {
        left = window.innerWidth - popoverRect.width - 16;
      }
      
      popover.style.top = `${top}px`;
      popover.style.left = `${Math.max(16, left)}px`;
    }

    popover.querySelector('.loc-pop__close').addEventListener('click', closePopover);
  };

  document.addEventListener('click', (e) => {
    const trigger = e.target.closest('[data-location]');
    if (trigger) {
      openPopover(trigger);
    } else if (popover && !e.target.closest('.loc-pop')) {
      closePopover();
    }
  });

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && popover) {
      closePopover();
    }
  });

  document.addEventListener('astro:before-swap', () => {
    closePopover();
  });
}
