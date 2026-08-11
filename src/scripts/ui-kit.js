/**
 * ui-kit.js · The DOM helpers both trackers share (SRP: no domain logic).
 *
 * Lives apart from collection-ui.js so the art tracker can use the toast and
 * the progress ring without pulling in the creature store (and its delegated
 * catch-toggle listener). collection-ui.js re-exports both, so its own public
 * API stays exactly as it was.
 */

/* ── Progress ring ───────────────────────────────────────────────────────── */

/** Fill a ProgressRing with real numbers. */
export function updateRing(el, value, total) {
  const circle = el.querySelector('.progress-ring__value');
  const label = el.querySelector('[data-ring-caught]');
  if (label) label.textContent = String(value);
  if (!circle) return;
  const circumference = Number(circle.dataset.circumference) || 0;
  const ratio = total > 0 ? Math.min(value / total, 1) : 0;
  circle.style.strokeDashoffset = String(circumference * (1 - ratio));
  el.classList.toggle('is-complete', total > 0 && value >= total);
}

/* ── Toast with undo ─────────────────────────────────────────────────────── */

let toastTimer = null;

export function showToast(message, undo) {
  let toast = document.getElementById('collection-toast');
  if (!toast) {
    toast = document.createElement('div');
    toast.id = 'collection-toast';
    toast.className = 'collection-toast';
    toast.setAttribute('role', 'status');
    toast.setAttribute('aria-live', 'polite');
    document.body.appendChild(toast);
  }

  toast.replaceChildren();
  const text = document.createElement('span');
  text.textContent = message;              // never innerHTML: names come from the DB
  toast.appendChild(text);

  if (undo) {
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'collection-toast__undo';
    btn.textContent = 'Rückgängig';
    btn.addEventListener('click', () => { undo(); hideToast(); });
    toast.appendChild(btn);
  }

  toast.classList.add('is-visible');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(hideToast, 5000);
}

export function hideToast() {
  document.getElementById('collection-toast')?.classList.remove('is-visible');
}
