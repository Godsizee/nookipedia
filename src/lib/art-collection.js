/**
 * art-collection.js · The player's own art log (SRP: state + persistence only).
 *
 * Sibling of collection.js, deliberately kept as its own module and its own
 * storage key: art is not caught, it is bought from Reiner and then donated to
 * Eugen. That is two steps, not one, so a piece has three states instead of the
 * creatures' caught / not caught:
 *
 *   0 MISSING  · fehlt noch
 *   1 OWNED    · gekauft und echt, liegt aber noch zu Hause
 *   2 DONATED  · im Museum abgegeben (schließt "besitzt" mit ein)
 *
 * Same guarantees as the catch log: browser-local, account-free, offline-safe,
 * and degrading to memory when storage is blocked instead of breaking the UI.
 */

const KEY = 'nook_art_v1';

export const MISSING = 0;
export const OWNED = 1;
export const DONATED = 2;

/** Order the tri-state control (and the cycle) walks through. */
export const STATES = [MISSING, OWNED, DONATED];

export const STATE_LABEL = {
  [MISSING]: 'Fehlt',
  [OWNED]: 'Im Besitz',
  [DONATED]: 'Gespendet',
};

let state = null;         // { v, items: Map<number, 1|2>, updated }
let persistent = true;    // false once a write has failed
const listeners = new Set();

const emptyState = () => ({ v: 1, items: new Map(), updated: null });

function read() {
  if (state) return state;
  state = emptyState();
  try {
    const raw = localStorage.getItem(KEY);
    if (raw) {
      const parsed = JSON.parse(raw);
      // Donated is written last so it wins for an id that (wrongly) appears in
      // both lists — the stronger state is the safer one to keep.
      for (const id of parsed?.owned || []) addId(state.items, id, OWNED);
      for (const id of parsed?.donated || []) addId(state.items, id, DONATED);
      state.updated = parsed?.updated || null;
    }
  } catch {
    persistent = false;   // unreadable or blocked — start empty, keep going
  }
  return state;
}

function addId(map, id, value) {
  const n = Number(id);
  if (Number.isFinite(n)) map.set(n, value);
}

const idsWith = (value) =>
  [...read().items.entries()].filter(([, v]) => v === value).map(([id]) => id).sort((a, b) => a - b);

function write() {
  state.updated = new Date().toISOString();
  try {
    localStorage.setItem(KEY, JSON.stringify({
      v: state.v,
      owned: idsWith(OWNED),
      donated: idsWith(DONATED),
      updated: state.updated,
    }));
  } catch {
    persistent = false;
  }
  listeners.forEach((fn) => fn(state));
}

/** False once persisting has failed — the UI says so once, then stays quiet. */
export const isPersistent = () => persistent;

/** 0 | 1 | 2 for one artwork. */
export const statusOf = (id) => read().items.get(Number(id)) ?? MISSING;

/** Everything the player holds, donated or not — "hab ich schon". */
export const isCollected = (id) => statusOf(id) !== MISSING;

export const ownedIds = () => idsWith(OWNED);
export const donatedIds = () => idsWith(DONATED);
export const collectedCount = () => read().items.size;

export function setStatus(id, status) {
  const n = Number(id);
  if (!Number.isFinite(n) || !STATES.includes(status)) return;
  const s = read();
  if ((s.items.get(n) ?? MISSING) === status) return;
  if (status === MISSING) s.items.delete(n); else s.items.set(n, status);
  write();
}

/** Set one artwork, with a one-shot undo back to where it was. */
export function apply(id, status) {
  const before = statusOf(id);
  setStatus(id, status);
  return { status, changed: before !== status, undo: () => setStatus(id, before) };
}

/** Fehlt → Besitz → Museum → Fehlt. Used by the compact card control. */
export function cycle(id) {
  const next = STATES[(STATES.indexOf(statusOf(id)) + 1) % STATES.length];
  return apply(id, next);
}

/** Bulk edit (type complete / undo of a bulk edit) — one write, one event. */
export function setMany(ids, status) {
  if (!STATES.includes(status)) return { changed: [], undo: () => {} };
  const s = read();
  const before = [];
  for (const id of ids) {
    const n = Number(id);
    const current = s.items.get(n) ?? MISSING;
    if (!Number.isFinite(n) || current === status) continue;
    before.push([n, current]);
    if (status === MISSING) s.items.delete(n); else s.items.set(n, status);
  }
  if (!before.length) return { changed: [], undo: () => {} };
  write();
  return {
    changed: before.map(([id]) => id),
    undo: () => {
      const cur = read();
      for (const [id, old] of before) {
        if (old === MISSING) cur.items.delete(id); else cur.items.set(id, old);
      }
      write();
    },
  };
}

export function reset() {
  state = emptyState();
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
 * "artworks + art log" into the numbers the page renders.
 *
 * `forgeable` is the part players actually plan around: a piece that has a fake
 * variant can be bought wrong, so the missing ones are worth listing with their
 * tell before the next visit from Reiner.
 */
export function stats(artworks) {
  const byType = {};
  const missingForgeable = [];
  let owned = 0;
  let donated = 0;

  for (const art of artworks) {
    const type = art.type || 'Sonstige';
    const bucket = byType[type] || (byType[type] = { total: 0, owned: 0, donated: 0 });
    bucket.total++;

    const status = statusOf(art.id);
    if (status === OWNED) { owned++; bucket.owned++; }
    else if (status === DONATED) { donated++; bucket.donated++; }
    else if (!art.always_genuine && (art.image_fake || art.forgery_description)) {
      missingForgeable.push(art);
    }
  }

  const collected = owned + donated;
  return {
    total: artworks.length,
    owned,                              // gekauft, noch nicht gespendet
    donated,                            // im Museum
    collected,                          // alles, was der Spieler hat
    missing: artworks.length - collected,
    byType,
    missingForgeable,
  };
}
