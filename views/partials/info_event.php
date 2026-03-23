<div class="faunapedia-header" style="border-left-color: #ff9800;">
    <h2>🎉 Lass uns feiern!</h2>
    <p>
        Das ganze Jahr über finden in <i>Animal Crossing: New Horizons</i> aufregende Feiertage, Turniere und saisonale Events statt.
        Über die Filter kannst du ganz einfach ausblenden, was dich gerade nicht interessiert!
    </p>
</div>

<link rel="stylesheet" href="/assets/css/faunapedia.css">
<link rel="stylesheet" href="/assets/css/events.css">

<!-- Event Filter Controls -->
<div class="faunapedia-section" style="margin-bottom: 0; padding-bottom: 0; background: transparent; border: none; box-shadow: none;">
    <div class="filter-controls" style="border-bottom: none;">
        <label class="ac-checkbox">
            <!-- Checkboxen sind standardmäßig aktiviert (= Element wird angezeigt) -->
            <input type="checkbox" id="filter-tournament" class="event-filter-checkbox" checked>
            <span class="checkmark"></span>
            <span class="label-text">🏆 Turniere</span>
        </label>
        
        <label class="ac-checkbox">
            <input type="checkbox" id="filter-holiday" class="event-filter-checkbox" checked>
            <span class="checkmark"></span>
            <span class="label-text">🎈 Feiertage</span>
        </label>
        
        <label class="ac-checkbox">
            <input type="checkbox" id="filter-season" class="event-filter-checkbox" checked>
            <span class="checkmark"></span>
            <span class="label-text">🌸 Saisons</span>
        </label>
        
        <label class="ac-checkbox">
            <input type="checkbox" id="filter-event" class="event-filter-checkbox" checked>
            <span class="checkmark"></span>
            <span class="label-text">🛍️ Nook Shopping & Events</span>
        </label>
    </div>
</div>

<script type="module" src="/assets/js/events.js"></script>