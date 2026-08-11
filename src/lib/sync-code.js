/**
 * sync-code.js · Sharing a catch log between devices without an account
 * (SRP: encoding only — it never touches storage or the DOM).
 *
 * 200 creatures = 200 bits = 25 bytes = ~34 characters. The code carries a
 * short fingerprint of the dataset it was built from, so a code from a
 * different (re-synced, renumbered) dataset is rejected instead of silently
 * ticking off the wrong animals.
 *
 * Format: AC1-<base64url bitmask>-<fingerprint>
 */

const PREFIX = 'AC1';
const PREFIX_STATES = 'AC2';   // two bits per entry, for the art log

/** FNV-1a over the sorted id list — 4 chars, enough to catch a mismatch. */
export function fingerprint(ids) {
  let h = 0x811c9dc5;
  const text = [...ids].sort((a, b) => a - b).join(',');
  for (let i = 0; i < text.length; i++) {
    h ^= text.charCodeAt(i);
    h = Math.imul(h, 0x01000193) >>> 0;
  }
  return h.toString(36).slice(-4).padStart(4, '0');
}

const toBase64Url = (bytes) => {
  let binary = '';
  for (const b of bytes) binary += String.fromCharCode(b);
  return btoa(binary).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
};

const fromBase64Url = (text) => {
  const padded = text.replace(/-/g, '+').replace(/_/g, '/');
  const binary = atob(padded + '='.repeat((4 - (padded.length % 4)) % 4));
  return Uint8Array.from(binary, (ch) => ch.charCodeAt(0));
};

/** Build a shareable code from the ids the player has caught. */
export function encode(allIds, caughtIds) {
  const ids = [...allIds].sort((a, b) => a - b);
  const caught = new Set([...caughtIds].map(Number));
  const bytes = new Uint8Array(Math.ceil(ids.length / 8));
  ids.forEach((id, index) => {
    if (caught.has(Number(id))) bytes[index >> 3] |= 1 << (index % 8);
  });
  return `${PREFIX}-${toBase64Url(bytes)}-${fingerprint(ids)}`;
}

/**
 * Read a code back into a list of ids.
 * → { ok: true, ids } · { ok: false, reason } — never a partial import.
 */
export function decode(code, allIds) {
  const parts = String(code || '').trim().split('-');
  if (parts.length !== 3 || parts[0] !== PREFIX) {
    return { ok: false, reason: 'Das sieht nicht nach einem Sammlungs-Code aus.' };
  }
  const ids = [...allIds].sort((a, b) => a - b);
  if (parts[2] !== fingerprint(ids)) {
    return { ok: false, reason: 'Der Code stammt aus einem anderen Datenbestand und passt nicht zu dieser Tierliste.' };
  }
  let bytes;
  try {
    bytes = fromBase64Url(parts[1]);
  } catch {
    return { ok: false, reason: 'Der Code ist beschädigt.' };
  }
  if (bytes.length !== Math.ceil(ids.length / 8)) {
    return { ok: false, reason: 'Der Code hat die falsche Länge.' };
  }
  return { ok: true, ids: ids.filter((_, index) => bytes[index >> 3] & (1 << (index % 8))) };
}

/* ── Tri-state codes (art log) ───────────────────────────────────────────────
   Open-Closed: the same idea one bit wider. Two bits per entry carry 0–3, which
   covers the art states (fehlt / Besitz / gespendet) without touching the
   creature format above — an AC1 code stays an AC1 code forever.

   Format: AC2-<base64url 2-bit-mask>-<fingerprint>                            */

/** Build a shareable code from a `id → 0|1|2` lookup. */
export function encodeStates(allIds, stateOf) {
  const ids = [...allIds].sort((a, b) => a - b);
  const bytes = new Uint8Array(Math.ceil(ids.length / 4));
  ids.forEach((id, index) => {
    const value = Number(stateOf(id)) & 0b11;
    bytes[index >> 2] |= value << ((index % 4) * 2);
  });
  return `${PREFIX_STATES}-${toBase64Url(bytes)}-${fingerprint(ids)}`;
}

/**
 * Read a tri-state code back.
 * → { ok: true, states: Map<id, 0|1|2> } · { ok: false, reason } — never partial.
 */
export function decodeStates(code, allIds) {
  const parts = String(code || '').trim().split('-');
  if (parts.length !== 3 || parts[0] !== PREFIX_STATES) {
    return { ok: false, reason: 'Das sieht nicht nach einem Kunst-Code aus.' };
  }
  const ids = [...allIds].sort((a, b) => a - b);
  if (parts[2] !== fingerprint(ids)) {
    return { ok: false, reason: 'Der Code stammt aus einem anderen Datenbestand und passt nicht zu dieser Kunstliste.' };
  }
  let bytes;
  try {
    bytes = fromBase64Url(parts[1]);
  } catch {
    return { ok: false, reason: 'Der Code ist beschädigt.' };
  }
  if (bytes.length !== Math.ceil(ids.length / 4)) {
    return { ok: false, reason: 'Der Code hat die falsche Länge.' };
  }
  const states = new Map();
  ids.forEach((id, index) => {
    const value = (bytes[index >> 2] >> ((index % 4) * 2)) & 0b11;
    if (value === 1 || value === 2) states.set(id, value);
  });
  return { ok: true, states };
}
