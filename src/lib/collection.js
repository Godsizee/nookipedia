/**
 * collection.js · The player's own catch log (SRP: state + persistence only).
 *
 * The only module in the codebase that touches localStorage for collection
 * data. Everything client-side reads through here, so the UI can never drift
 * apart from the stored truth.
 *
 * Deliberately account-free: the log lives in the browser, works offline in the
 * PWA and needs no write path into Directus. When storage is unavailable
 * (private mode, locked-down iOS) the store degrades to memory — the UI keeps
 * working, it just forgets on reload.
 */

import {
  isCatchableNow, isLastChance, isNewThisMonth, isYearRound,
  isAvailableInMonth, nextAvailability,
} from './catch-window.js';

const KEY = 'nook_collection_v1';
const CATEGORIES = ['fish', 'insect', 'sea'];

let state = null;         // { v, caught: Set<number>, hemisphere, updated }
let persistent = true;    // false once a write has failed
const listeners = new Set();

const emptyState = () => ({ v: 1, caught: new Set(), hemisphere: 'north', updated: null });

function read() {
  if (state) return state;
  state = emptyState();
  try {
    const raw = localStorage.getItem(KEY);
    if (raw) {
      const parsed = JSON.parse(raw);
      if (Array.isArray(parsed?.caught)) {
        state.caught = new Set(parsed.caught.map(Number).filter(Number.isFinite));
        state.updated = parsed.updated || null;
      }
      if (parsed?.hemisphere === 'south') state.hemisphere = 'south';
    }
  } catch {
    persistent = false;   // unreadable or blocked — start empty, keep going
  }
  return state;
}

function write() {
  state.updated = new Date().toISOString();
  try {
    localStorage.setItem(KEY, JSON.stringify({
      v: state.v,
      caught: [...state.caught].sort((a, b) => a - b),
      hemisphere: state.hemisphere,
      updated: state.updated,
    }));
  } catch {
    persistent = false;
  }
  listeners.forEach((fn) => fn(state));
}

/** False once persisting has failed — the UI says so once, then stays quiet. */
export const isPersistent = () => persistent;

export const isCaught = (id) => read().caught.has(Number(id));
export const caughtCount = () => read().caught.size;
export const caughtIds = () => [...read().caught].sort((a, b) => a - b);

export function setCaught(id, value) {
  const n = Number(id);
  if (!Number.isFinite(n)) return;
  const s = read();
  if (value) s.caught.add(n); else s.caught.delete(n);
  write();
}

/** Toggle one creature. Returns the new state plus a one-shot undo. */
export function toggle(id) {
  const next = !isCaught(id);
  setCaught(id, next);
  return { caught: next, undo: () => setCaught(id, !next) };
}

/** Bulk edit (category complete / undo of a bulk edit) — one write, one event. */
export function setMany(ids, value) {
  const s = read();
  const changed = [];
  for (const id of ids) {
    const n = Number(id);
    if (!Number.isFinite(n) || s.caught.has(n) === value) continue;
    if (value) s.caught.add(n); else s.caught.delete(n);
    changed.push(n);
  }
  if (!changed.length) return { changed: [], undo: () => {} };
  write();
  return { changed, undo: () => setMany(changed, !value) };
}

/** 'north' | 'south' — the southern hemisphere shifts every season by 6 months. */
export const getHemisphere = () => read().hemisphere;

export function setHemisphere(value) {
  const next = value === 'south' ? 'south' : 'north';
  if (read().hemisphere === next) return;
  state.hemisphere = next;
  write();
}

export function reset() {
  const hemisphere = read().hemisphere;   // a setting, not collected data
  state = emptyState();
  state.hemisphere = hemisphere;
  write();
}

/** Subscribe to every change (also fires for edits made in another tab). */
export function subscribe(fn) {
  listeners.add(fn);
  return () => listeners.delete(fn);
}

// Keep two open tabs in sync — cheap, and avoids a stale tab overwriting fresh data.
if (typeof window !== 'undefined') {
  window.addEventListener('storage', (e) => {
    if (e.key !== KEY) return;
    state = null;
    read();
    listeners.forEach((fn) => fn(state));
  });
}

/**
 * Every derived view in one pass — the single place that turns
 * "creatures + catch log + clock" into the numbers the pages render.
 */
export function stats(creatures, now = new Date(), hemisphere = getHemisphere()) {
  const month = now.getMonth() + 1;
  const byCategory = {};
  for (const c of CATEGORIES) byCategory[c] = { caught: 0, total: 0 };

  const missingNow = [];
  const laterToday = [];
  const lastChance = [];
  const newThisMonth = [];
  const byNextMonth = new Map();
  const missingOther = [];
  const matrix = {};
  for (const c of CATEGORIES) matrix[c] = new Array(12).fill(0);

  let caught = 0;
  for (const creature of creatures) {
    const bucket = byCategory[creature.category];
    if (bucket) bucket.total++;

    if (isCaught(creature.id)) {
      caught++;
      if (bucket) bucket.caught++;
      continue;                       // caught → out of sight, that is the point
    }

    if (matrix[creature.category]) {
      for (let m = 1; m <= 12; m++) {
        if (isAvailableInMonth(creature, m, hemisphere)) matrix[creature.category][m - 1]++;
      }
    }

    // Highlights — overlapping views on top of the buckets below.
    if (isLastChance(creature, now, hemisphere)) lastChance.push(creature);
    if (isNewThisMonth(creature, now, hemisphere)) newThisMonth.push(creature);

    // Buckets — every missing creature lands in exactly one, so nothing
    // silently falls off the page.
    if (isCatchableNow(creature, now, hemisphere)) {
      missingNow.push(creature);
    } else if (isAvailableInMonth(creature, month, hemisphere)) {
      laterToday.push(creature);                      // right month, wrong hour
    } else {
      const next = nextAvailability(creature, now, hemisphere);
      if (!next || next.monthsAway === 0 || isYearRound(creature, hemisphere)) {
        missingOther.push(creature);
      } else {
        if (!byNextMonth.has(next.month)) byNextMonth.set(next.month, []);
        byNextMonth.get(next.month).push(creature);
      }
    }
  }

  // Groups ordered by how soon they open up, not by calendar number.
  const sortedNextMonths = [...byNextMonth.keys()].sort(
    (a, b) => ((a - month + 12) % 12) - ((b - month + 12) % 12)
  );

  return {
    total: creatures.length,
    caught,
    missing: creatures.length - caught,
    byCategory,
    missingNow,
    laterToday,
    lastChance,
    newThisMonth,
    byNextMonth,
    sortedNextMonths,
    missingOther,
    matrix,
  };
}

export { CATEGORIES };
