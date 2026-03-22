/**
 * Faunapedia Native ES Module
 * SRP: Filtering & Smooth Scroll Navigation
 */

export function initFaunapediaFilter() {
    const section = document.querySelector('.faunapedia-section');
    if (!section) return;

    const category = section.dataset.category; 
    const filterMonth = document.getElementById('filter-month');
    const filterNow = document.getElementById('filter-now');
    const btnClear = document.getElementById('clear-filters');
    const miniCards = document.querySelectorAll('.mini-card');

    const keyMonth = `nook_filter_${category}_month`;
    const keyNow = `nook_filter_${category}_now`;

    if (filterMonth) filterMonth.checked = localStorage.getItem(keyMonth) === 'true';
    if (filterNow) filterNow.checked = localStorage.getItem(keyNow) === 'true';

    const applyFilters = () => {
        const date = new Date();
        const currentMonth = (date.getMonth() + 1).toString();
        const currentHour = date.getHours();

        if (filterMonth) localStorage.setItem(keyMonth, filterMonth.checked);
        if (filterNow) localStorage.setItem(keyNow, filterNow.checked);

        miniCards.forEach(card => {
            let isVisible = true;
            const months = card.dataset.months ? card.dataset.months.split(',') : [];
            const timeStr = card.dataset.time ? card.dataset.time.toLowerCase() : '';

            // 1. Month Filter
            if (filterMonth && filterMonth.checked) {
                if (months.length > 0 && !months.includes(currentMonth)) {
                    isVisible = false;
                }
            }

            // 2. Time Filter
            if (filterNow && filterNow.checked && isVisible) {
                if (!timeStr.includes('immer') && !timeStr.includes('ganzjährig')) {
                    const hours = timeStr.match(/\d+/g);
                    if (hours && hours.length >= 2) {
                        const start = parseInt(hours[0], 10);
                        const end = parseInt(hours[1], 10);

                        if (start < end) {
                            if (currentHour < start || currentHour >= end) isVisible = false;
                        } else {
                            if (currentHour < start && currentHour >= end) isVisible = false;
                        }
                    }
                }
            }

            // Grid Items ausblenden
            if (isVisible) {
                card.classList.remove('faded');
            } else {
                card.classList.add('faded');
            }

            // Große Creature-Cards ausblenden
            const mainCard = document.getElementById('creature-' + card.dataset.id);
            if (mainCard) {
                mainCard.style.display = isVisible ? 'flex' : 'none';
            }
        });
    };

    // Events
    if (filterMonth) filterMonth.addEventListener('change', applyFilters);
    if (filterNow) filterNow.addEventListener('change', applyFilters);
    
    if (btnClear) {
        btnClear.addEventListener('click', () => {
            filterMonth.checked = false;
            filterNow.checked = false;
            applyFilters();
        });
    }

    // ✨ Fabulous Smooth Scrolling to Cards
    miniCards.forEach(card => {
        card.addEventListener('click', (e) => {
            const href = card.getAttribute('href');
            
            // NUR abfangen, wenn es ein In-Page Anchor Link (#) ist
            if (href && href.startsWith('#')) {
                e.preventDefault(); 
                
                const targetId = href.substring(1);
                const targetElement = document.getElementById(targetId);
                
                if (targetElement) {
                
                window.scrollTo({
                    top: offsetPosition,
                    behavior: "smooth"
                });
                
                // Sexy Highlight-Effekt der Zielkarte
                targetElement.style.transition = "transform 0.4s ease, box-shadow 0.4s ease";
                targetElement.style.transform = "scale(1.03)";
                targetElement.style.boxShadow = "0 0 25px var(--ac-green)";
                
                setTimeout(() => {
                    targetElement.style.transform = "";
                    targetElement.style.boxShadow = "var(--ac-shadow)";
                }, 1000);
            }
        });
    });

    applyFilters();
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initFaunapediaFilter);
} else {
    initFaunapediaFilter();
}