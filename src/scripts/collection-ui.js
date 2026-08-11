/**
 * collection-ui.js · The bridge between the catch log and the DOM
 * (SRP: no domain logic here — it only mirrors the store into the page).
 *
 * One delegated listener serves every [data-catch-toggle] on the page, so
 * newly rendered lists (Sammlung sections) need no re-binding.
 */

import { toggle, isCaught, subscribe, isPersistent, caughtCount } from '../lib/collection.js';
import { showToast, updateRing } from './ui-kit.js';

// Re-exported so every page that already imports them from here keeps working.
export { showToast, updateRing };

const MILESTONES = [25, 50, 75, 100];
let bound = false;
let lastPercent = -1;

/* ── Mirroring state into markup ─────────────────────────────────────────── */

export function syncDom(root = document) {
  root.querySelectorAll('[data-creature-id]').forEach((el) => {
    const caught = isCaught(el.getAttribute('data-creature-id'));
    el.classList.toggle('is-caught', caught);
    if (el.hasAttribute('data-catch-toggle')) el.setAttribute('aria-pressed', String(caught));
  });
  updateCounters(root);
}

/** Counts straight off the page: every card carries data-collection-item. */
function updateCounters(root = document) {
  const items = [...root.querySelectorAll('[data-collection-item]')];
  if (!items.length) return;

  const tally = { total: items.length, caught: 0 };
  for (const el of items) {
    const cat = el.getAttribute('data-category') || 'other';
    tally[`total-${cat}`] = (tally[`total-${cat}`] || 0) + 1;
    if (!isCaught(el.getAttribute('data-creature-id'))) continue;
    tally.caught++;
    tally[`caught-${cat}`] = (tally[`caught-${cat}`] || 0) + 1;
  }
  tally.missing = tally.total - tally.caught;

  root.querySelectorAll('[data-collection-count]').forEach((el) => {
    const key = el.getAttribute('data-collection-count');
    el.textContent = String(tally[key] ?? 0);
  });
  root.querySelectorAll('[data-collection-bar]').forEach((el) => {
    const pct = tally.total ? Math.round((tally.caught / tally.total) * 100) : 0;
    el.style.setProperty('--pct', `${pct}%`);
    el.setAttribute('aria-valuenow', String(pct));
  });
}

/* ── Milestones (quiet by default, loud at the round numbers) ────────────── */

function currentPercent() {
  const host = document.querySelector('[data-collection-total]');
  const total = Number(host?.getAttribute('data-collection-total')) || 0;
  return total ? { percent: Math.floor((caughtCount() / total) * 100), total } : null;
}

/** Returns a message only when this catch crossed a round number. */
function checkMilestone() {
  const now = currentPercent();
  if (!now) return null;
  const crossed = MILESTONES.find((m) => now.percent >= m && lastPercent < m);
  lastPercent = now.percent;
  if (crossed == null) return null;
  return crossed === 100
    ? '🏆 Alles gefangen — die Faunapädie ist komplett!'
    : `🎉 ${crossed} % geschafft — ${caughtCount()} von ${now.total}!`;
}

/** Keep the milestone baseline honest after un-catching, without a message. */
function resyncMilestone() {
  lastPercent = currentPercent()?.percent ?? -1;
}

/* ── Wiring ──────────────────────────────────────────────────────────────── */

function onToggleClick(event) {
  const btn = event.target.closest('[data-catch-toggle]');
  if (!btn) return;
  event.preventDefault();
  event.stopPropagation();

  const name = btn.getAttribute('data-creature-name') || 'Kreatur';
  const { caught, undo } = toggle(btn.getAttribute('data-creature-id'));

  let message;
  if (caught) message = checkMilestone() || `${name} eingetragen`;
  else { resyncMilestone(); message = `${name} wieder offen`; }
  showToast(message, undo);

  if (!isPersistent()) {
    showToast('Speichern im Browser ist blockiert — die Auswahl gilt nur bis zum Neuladen.');
  }
}

export function initCollectionUI() {
  if (!bound) {
    bound = true;
    document.addEventListener('click', onToggleClick);
    subscribe(() => syncDom());
  }
  syncDom();
  resyncMilestone();
}

// Fires on the first load and after every View-Transition swap.
document.addEventListener('astro:page-load', initCollectionUI);
