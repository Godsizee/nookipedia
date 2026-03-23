/**
 * Event Filter Logic
 * SRP: Blendet Event-Karten (Turniere, Feiertage etc.) weich ein und aus.
 */

export function initEventFilters() {
    const filterCheckboxes = document.querySelectorAll('.event-filter-checkbox');
    const eventCards = document.querySelectorAll('.event-card');

    if (!filterCheckboxes.length || !eventCards.length) return;

    // State aus localStorage laden (falls vorhanden)
    filterCheckboxes.forEach(checkbox => {
        const savedState = localStorage.getItem(`nook_event_filter_${checkbox.id}`);
        if (savedState !== null) {
            checkbox.checked = savedState === 'true';
        }
    });

const applyFilters = () => {
        // Zustand aller Checkboxen ermitteln
        const filters = {
            'tournament': document.getElementById('filter-tournament').checked,
            'holiday': document.getElementById('filter-holiday').checked,
            'season': document.getElementById('filter-season').checked,
            'event': document.getElementById('filter-event').checked
        };

        // Sichtbarkeit der Karten steuern
        eventCards.forEach(card => {
            const cardType = card.getAttribute('data-type');
            
            if (filters[cardType]) {
                card.style.display = 'flex';
                card.style.opacity = '1';
                card.classList.remove('is-hidden');
            } else {
                card.style.display = 'none';
                card.style.opacity = '0';
                card.classList.add('is-hidden');
            }
        });

        // SMART FEATURE: Verstecke die ganze Monats-Überschrift (Collapsible), 
        // wenn durch den Filter alle darin enthaltenen Events unsichtbar wurden!
        document.querySelectorAll('.month-group').forEach(group => {
            const allCards = group.querySelectorAll('.event-card');
            const hiddenCards = group.querySelectorAll('.event-card.is-hidden');
            
            // Wenn alle Karten in diesem Monat die Klasse 'is-hidden' haben -> Monat ausblenden
            if (allCards.length > 0 && allCards.length === hiddenCards.length) {
                group.style.display = 'none';
            } else {
                group.style.display = 'block';
            }
        });

        // Alle Zustände im LocalStorage speichern
        filterCheckboxes.forEach(checkbox => {
            localStorage.setItem(`nook_event_filter_${checkbox.id}`, checkbox.checked);
        });
    };

    // Event Listener für alle Checkboxen hinzufügen
    filterCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', applyFilters);
    });

    // Direkt beim Laden einmal anwenden
    applyFilters();
}

// Initialisierung bei DOMContentLoaded
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initEventFilters);
} else {
    initEventFilters();
}