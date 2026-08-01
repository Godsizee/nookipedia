/**
 * catch-window.js · Pure catch-window logic (SRP: no DOM, no storage, no fetching).
 *
 * Single source of truth for "kann ich dieses Tier gerade fangen?" — previously
 * this lived inline (and duplicated) in faunapaedie.astro and tier/[id].astro.
 *
 * Two data fields drive everything:
 *   • months_northern → [7, 8]                (empty/12 entries = ganzjährig)
 *   • time_active     → "09:00 – 16:00 & 21:00 – 04:00" | "Ganztägig (Regen)"
 *
 * Fail-open by design: anything unparsable counts as "verfügbar", so a data
 * quirk never hides a creature the player could actually catch.
 */

export const MONTHS_LONG = ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'];

/** Wrap any integer into the 1–12 month range (13 → 1, 0 → 12). */
export const wrapMonth = (m) => (((m - 1) % 12) + 12) % 12 + 1;

/**
 * Months a creature is available in, for the given hemisphere.
 * ACNH mirrors the southern hemisphere by exactly six months; time-of-day
 * windows are identical in both, so no extra data is needed.
 */
export function monthsFor(creature, hemisphere = 'north') {
  const months = creature?.months_northern || [];
  if (hemisphere !== 'south') return months;
  return months.map((m) => wrapMonth(m + 6)).sort((a, b) => a - b);
}

/**
 * Parse a time string into [startHour, endHour] windows.
 * An empty result means "ganztägig" — both for literal "Ganztägig" values and
 * for anything we cannot make sense of.
 */
export function parseWindows(timeStr) {
  const t = String(timeStr || '').toLowerCase();
  if (!t || /ganzt|immer|all day/.test(t)) return [];
  const hours = (t.match(/(\d{1,2}):/g) || []).map((h) => parseInt(h, 10));
  const windows = [];
  for (let i = 0; i + 1 < hours.length; i += 2) windows.push([hours[i], hours[i + 1]]);
  return windows;
}

export const isAllDay = (timeStr) => parseWindows(timeStr).length === 0;

/** Does `hour` fall inside a window? Handles windows crossing midnight (17–04). */
const inWindow = ([start, end], hour) =>
  start < end ? hour >= start && hour < end : hour >= start || hour < end;

export function isActiveAtHour(timeStr, hour) {
  const windows = parseWindows(timeStr);
  return windows.length === 0 || windows.some((w) => inWindow(w, hour));
}

/** The window currently running, or null (all-day creatures included). */
export function currentWindow(creature, now = new Date()) {
  return parseWindows(creature?.time_active).find((w) => inWindow(w, now.getHours())) || null;
}

/** Hour at which the running window closes ("noch bis 19:00 Uhr"), or null. */
export function currentWindowEnd(creature, now = new Date()) {
  const w = currentWindow(creature, now);
  return w ? w[1] : null;
}

/** Hour at which the next window of the day opens ("ab 16:00 Uhr"), or null. */
export function nextWindowStart(creature, now = new Date()) {
  const windows = parseWindows(creature?.time_active);
  if (!windows.length || currentWindow(creature, now)) return null;
  const hour = now.getHours();
  const starts = windows.map((w) => w[0]).sort((a, b) => a - b);
  return starts.find((s) => s > hour) ?? starts[0];
}

export function isAvailableInMonth(creature, month, hemisphere = 'north') {
  const months = monthsFor(creature, hemisphere);
  return months.length === 0 || months.includes(month);
}

export function isCatchableNow(creature, now = new Date(), hemisphere = 'north') {
  return (
    isAvailableInMonth(creature, now.getMonth() + 1, hemisphere) &&
    isActiveAtHour(creature?.time_active, now.getHours())
  );
}

export function isYearRound(creature, hemisphere = 'north') {
  const months = monthsFor(creature, hemisphere);
  return months.length === 0 || months.length === 12;
}

/** Available this month, gone next month — the urgency signal of the module. */
export function isLastChance(creature, now = new Date(), hemisphere = 'north') {
  if (isYearRound(creature, hemisphere)) return false;
  const months = monthsFor(creature, hemisphere);
  const month = now.getMonth() + 1;
  return months.includes(month) && !months.includes(wrapMonth(month + 1));
}

/** Available this month, absent last month. */
export function isNewThisMonth(creature, now = new Date(), hemisphere = 'north') {
  if (isYearRound(creature, hemisphere)) return false;
  const months = monthsFor(creature, hemisphere);
  const month = now.getMonth() + 1;
  return months.includes(month) && !months.includes(wrapMonth(month - 1));
}

/**
 * Next month the creature shows up, counted from the current month.
 * → { month, monthsAway } with monthsAway === 0 when it is available right now.
 * → null for year-round creatures (always available, nothing to wait for).
 */
export function nextAvailability(creature, now = new Date(), hemisphere = 'north') {
  if (isYearRound(creature, hemisphere)) return null;
  const months = monthsFor(creature, hemisphere);
  if (!months.length) return null;
  const current = now.getMonth() + 1;
  for (let away = 0; away < 12; away++) {
    const month = wrapMonth(current + away);
    if (months.includes(month)) return { month, monthsAway: away };
  }
  return null;
}

/** Days remaining in the current month, today included. */
export function daysLeftInMonth(now = new Date()) {
  const lastDay = new Date(now.getFullYear(), now.getMonth() + 1, 0).getDate();
  return lastDay - now.getDate() + 1;
}
