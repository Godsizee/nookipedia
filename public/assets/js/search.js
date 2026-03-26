/**
 * Nookipedia Intelligent Spotlight Search
 * SRP: Handhabt Overlay-Sichtbarkeit, Fetch-API und DOM-Updates.
 */

// Helper: Debounce zur Reduzierung der Server-Anfragen beim schnellen Tippen
function debounce(func, delay) {
    let timeoutId;
    return function (...args) {
        clearTimeout(timeoutId);
        timeoutId = setTimeout(() => func.apply(this, args), delay);
    };
}

export function initSpotlightSearch() {
    const triggerBtn = document.getElementById('search-trigger');
    const overlay = document.getElementById('spotlight-overlay');
    const closeBtn = document.getElementById('spotlight-close');
    const input = document.getElementById('spotlight-input');
    const resultsContainer = document.getElementById('spotlight-results');

    if (!triggerBtn || !overlay) return;

    // --- Sichtbarkeits-Logik ---
    const openSearch = () => {
        overlay.classList.remove('spotlight-hidden');
        input.value = ''; // Reset beim Öffnen
        resultsContainer.innerHTML = '<div class="spotlight-empty-state">Tippe, um die Nook-Datenbank zu durchsuchen...</div>';
        // Kurzer Delay, damit der Browser den Fokus setzen kann, wenn CSS Transition startet
        setTimeout(() => input.focus(), 100);
        document.body.style.overflow = 'hidden'; // Verhindert Scrollen im Hintergrund
    };

    const closeSearch = () => {
        overlay.classList.add('spotlight-hidden');
        input.blur();
        document.body.style.overflow = ''; 
    };

    triggerBtn.addEventListener('click', openSearch);
    closeBtn.addEventListener('click', closeSearch);

    // Overlay schließen beim Klick auf den unscharfen Hintergrund
    overlay.addEventListener('click', (e) => {
        if (e.target === overlay || e.target.classList.contains('spotlight-backdrop')) {
            closeSearch();
        }
    });

    // Globaler Shortcut: Cmd+K oder Ctrl+K sowie ESC
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && !overlay.classList.contains('spotlight-hidden')) {
            closeSearch();
        }
        if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
            e.preventDefault();
            if (overlay.classList.contains('spotlight-hidden')) {
                openSearch();
            } else {
                closeSearch();
            }
        }
    });

    // --- Intelligente API Fetch Logik ---
    const performSearch = async (query) => {
        if (query.length < 2) {
            resultsContainer.innerHTML = '<div class="spotlight-empty-state">Tippe mindestens 2 Zeichen...</div>';
            return;
        }

        resultsContainer.innerHTML = '<div class="spotlight-empty-state">Lade Daten von Nook Inc. 📡...</div>';

        try {
            // Sichere Basis-URL Ermittlung (verhindert den "//api/search" CORS-Bug)
            let basePath = '';
            const publicIndex = window.location.pathname.indexOf('/public');
            if (publicIndex !== -1) {
                // Wir befinden uns lokal im Unterordner (z.B. /files/nookipedia/public)
                basePath = window.location.pathname.substring(0, publicIndex + 7);
            }
            
            const url = `${basePath}/api/search?q=${encodeURIComponent(query)}`;
            
            const response = await fetch(url);
            if (!response.ok) throw new Error('Netzwerk-Fehler');
            
            const data = await response.json();
            renderResults(data.results);
            
        } catch (error) {
            console.error('Search Error:', error);
            resultsContainer.innerHTML = '<div class="spotlight-empty-state" style="color: #d81b60;">Fehler bei der Nook-Verbindung!</div>';
        }
    };

    // --- DOM Rendering (XSS Sicher durch document.createElement) ---
    const renderResults = (items) => {
        resultsContainer.innerHTML = ''; // Leeren

        if (!items || items.length === 0) {
            resultsContainer.innerHTML = '<div class="spotlight-empty-state">Keine passenden Einträge gefunden. 🦝</div>';
            return;
        }

        const fragment = document.createDocumentFragment();

        items.forEach(item => {
            // A-Tag erstellen
            const a = document.createElement('a');
            a.href = item.url;
            a.className = 'search-result-item';
            
            // Klick-Listener um Modal direkt zu schließen
            a.addEventListener('click', closeSearch);

            // Icon/Bild Box
            const imgBox = document.createElement('div');
            imgBox.className = 'search-result-img';
            const img = document.createElement('img');
            img.src = item.image;
            img.alt = item.title;
            // Fallback Image handling
            img.onerror = () => { img.src = '/assets/img/acnh/koeder.png'; };
            imgBox.appendChild(img);

            // Info Box (Titel + Subtitle)
            const infoBox = document.createElement('div');
            infoBox.className = 'search-result-info';
            
            const titleSpan = document.createElement('span');
            titleSpan.className = 'search-result-title';
            titleSpan.textContent = item.title; // Sicheres Text-Einfügen (verhindert XSS)
            
            const subtitleSpan = document.createElement('span');
            subtitleSpan.className = 'search-result-subtitle';
            subtitleSpan.textContent = item.subtitle;
            
            infoBox.appendChild(titleSpan);
            infoBox.appendChild(subtitleSpan);

            // Type Badge
            const badgeSpan = document.createElement('span');
            badgeSpan.className = 'search-result-badge';
            badgeSpan.textContent = item.type;

            // Alles zusammensetzen
            a.appendChild(imgBox);
            a.appendChild(infoBox);
            a.appendChild(badgeSpan);
            
            fragment.appendChild(a);
        });

        resultsContainer.appendChild(fragment);
    };

    // Input-Event mit Debounce (300ms Verzögerung) verknüpfen
    const debouncedSearch = debounce((e) => performSearch(e.target.value.trim()), 300);
    input.addEventListener('input', debouncedSearch);
}

// Initialisieren
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initSpotlightSearch);
} else {
    initSpotlightSearch();
}