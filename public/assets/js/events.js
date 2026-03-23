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
            
            // Wenn der jeweilige Typ in den Filtern true (checked) ist, anzeigen
            if (filters[cardType]) {
                card.style.display = 'flex';
                // Optional: Kleine Fade-In Animation
                card.style.opacity = '1';
            } else {
                // Ausblenden, wenn Checkbox deaktiviert ist
                card.style.display = 'none';
                card.style.opacity = '0';
            }
        });

        // Alle Zustände im LocalStorage speichern, damit die Auswahl beim Neuladen erhalten bleibt
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