/**
 * art-collection-ui.js · The bridge between the art log and the DOM
 * (SRP: no domain logic here — it only mirrors the store into the page).
 *
 * One delegated listener serves every art control on the page:
 *   [data-art-set]    · a segment of the tri-state control (Fehlt/Besitz/Museum)
 *   [data-art-cycle]  · a single button that walks through the three states
 * Both resolve their artwork through the closest [data-art-id], so gallery
 * cards, the tracker grid and the detail page all share the same wiring.
 */

import {
  statusOf, apply, cycle, subscribe, isPersistent, STATE_LABEL, MISSING, OWNED, DONATED,
} from '../lib/art-collection.js';
import { showToast } from './ui-kit.js';

let bound = false;

/** Wording that reads like the game, not like a database. */
const TOAST = {
  [MISSING]: (name) => `${name} wieder als fehlend markiert`,
  [OWNED]: (name) => `${name} als Besitz eingetragen`,
  [DONATED]: (name) => `${name} ans Museum gespendet 🏛️`,
};

/* ── Mirroring state into markup ─────────────────────────────────────────── */

export function syncArtDom(root = document) {
  root.querySelectorAll('[data-art-id]').forEach((el) => {
    const status = statusOf(el.getAttribute('data-art-id'));
    el.setAttribute('data-art-status', String(status));
    el.querySelectorAll('[data-art-set]').forEach((btn) => {
      btn.setAttribute('aria-pressed', String(Number(btn.getAttribute('data-art-set')) === status));
    });
    el.querySelectorAll('[data-art-state-label]').forEach((label) => {
      label.textContent = STATE_LABEL[status];
    });
  });
  updateArtCounters(root);
}

/**
 * Counts straight off the page: every card carries data-art-item, so a
 * filtered or partial page still counts exactly what it shows.
 */
function updateArtCounters(root = document) {
  const items = [...root.querySelectorAll('[data-art-item]')];
  if (!items.length) return;

  const tally = { total: items.length, missing: 0, owned: 0, donated: 0, collected: 0 };
  for (const el of items) {
    const status = statusOf(el.getAttribute('data-art-id'));
    const type = el.getAttribute('data-art-type') || 'Sonstige';
    tally[`total-${type}`] = (tally[`total-${type}`] || 0) + 1;
    if (status === MISSING) { tally.missing++; continue; }
    tally.collected++;
    if (status === OWNED) tally.owned++; else tally.donated++;
    if (status === DONATED) tally[`donated-${type}`] = (tally[`donated-${type}`] || 0) + 1;
  }

  root.querySelectorAll('[data-art-count]').forEach((el) => {
    el.textContent = String(tally[el.getAttribute('data-art-count')] ?? 0);
  });
  return tally;
}

export { updateArtCounters };

/* ── Wiring ──────────────────────────────────────────────────────────────── */

function onArtClick(event) {
  const control = event.target.closest('[data-art-set], [data-art-cycle]');
  if (!control) return;
  const host = control.closest('[data-art-id]');
  if (!host) return;

  event.preventDefault();
  event.stopPropagation();

  const id = host.getAttribute('data-art-id');
  const name = host.getAttribute('data-art-name') || 'Kunstwerk';
  const result = control.hasAttribute('data-art-cycle')
    ? cycle(id)
    : apply(id, Number(control.getAttribute('data-art-set')));

  if (result.changed) showToast(TOAST[result.status](name), result.undo);

  if (!isPersistent()) {
    showToast('Speichern im Browser ist blockiert — die Auswahl gilt nur bis zum Neuladen.');
  }
}

export function initArtCollectionUI() {
  if (!bound) {
    bound = true;
    document.addEventListener('click', onArtClick);
    subscribe(() => syncArtDom());
  }
  syncArtDom();
}

// Fires on the first load and after every View-Transition swap.
document.addEventListener('astro:page-load', initArtCollectionUI);
