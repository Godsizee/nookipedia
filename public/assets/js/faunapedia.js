/**
 * Faunapedia Native ES Module
 * SRP: Zuständig für das Frontend-Filtering des Critter-Grids.
 * Wird asynchron und isoliert geladen.
 */

// Exportiert die Hauptfunktion, falls wir sie später programmatisch triggern wollen
export function initFaunapediaFilter() {
    const section = document.querySelector('.faunapedia-section');
    if (!section) return;

    const category = section.dataset.category; // "insect", "fish" oder "sea"
    const filterMonth = document.getElementById('filter-month');
    const filterNow = document.getElementById('filter-now');
    const btnClear = document.getElementById('clear-filters');
    const miniCards = document.querySelectorAll('.mini-card');

    // LocalStorage Keys für Persistenz pro Kategorie
    const keyMonth = `nook_filter_${category}_month`;
    const keyNow = `nook_filter_${category}_now`;

    // Persistierten Zustand laden
    if (filterMonth) filterMonth.checked = localStorage.getItem(keyMonth) === 'true';
    if (filterNow) filterNow.checked = localStorage.getItem(keyNow) === 'true';

    const applyFilters = () => {
        const date = new Date();
        const currentMonth = (date.getMonth() + 1).toString();
        const currentHour = date.getHours();

        // Zustand speichern
        if (filterMonth) localStorage.setItem(keyMonth, filterMonth.checked);
        if (filterNow) localStorage.setItem(keyNow, filterNow.checked);

        miniCards.forEach(card => {
            let isVisible = true;
            const months = card.dataset.months ? card.dataset.months.split(',') : [];
            const timeStr = card.dataset.time ? card.dataset.time.toLowerCase() : '';

            // 1. Monats-Filter
            if (filterMonth && filterMonth.checked) {
                if (months.length > 0 && !months.includes(currentMonth)) {
                    isVisible = false;
                }
            }

            // 2. Uhrzeit-Filter
            if (filterNow && filterNow.checked && isVisible) {
                if (!timeStr.includes('immer') && !timeStr.includes('ganzjährig')) {
                    const hours = timeStr.match(/\d+/g);
                    if (hours && hours.length >= 2) {
                        const start = parseInt(hours[0], 10);
                        const end = parseInt(hours[1], 10);

                        if (start < end) {
                            // Normale Zeitspanne, z.B. 8 - 17 Uhr
                            if (currentHour < start || currentHour >= end) isVisible = false;
                        } else {
                            // Zeitspanne über Mitternacht, z.B. 17 - 8 Uhr
                            if (currentHour < start && currentHour >= end) isVisible = false;
                        }
                    }
                }
            }

            // Visuelles Feedback anwenden (Klasse für das gestrichelte "Uncaught"-Design)
            if (isVisible) {
                card.classList.remove('faded');
            } else {
                card.classList.add('faded');
            }

            // Fallback: Blendet auch die großen Karten in der Liste darunter aus, falls vorhanden
            const mainCard = document.getElementById('creature-' + card.dataset.id);
            if (mainCard) {
                mainCard.style.display = isVisible ? 'flex' : 'none';
            }
        });
    };

    // Event Listener binden
    if (filterMonth) filterMonth.addEventListener('change', applyFilters);
    if (filterNow) filterNow.addEventListener('change', applyFilters);
    
    if (btnClear) {
        btnClear.addEventListener('click', () => {
            filterMonth.checked = false;
            filterNow.checked = false;
            applyFilters();
        });
    }

    // Initiale Ausführung
    applyFilters();
}

// Durch Native ES Modules (type="module") können wir bedenkenlos auf DOMContentLoaded warten
// oder es direkt ausführen, da das Skript ohnehin erst nach dem Parsing des HTMLs anläuft.
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initFaunapediaFilter);
} else {
    initFaunapediaFilter();
}