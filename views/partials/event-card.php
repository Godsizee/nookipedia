<article class="creature-card event-card" id="event-<?= $event->id ?>">
    <div class="card-header">
        <div class="img-container event-img-container">
            <img src="<?= htmlspecialchars($event->getImageUrl()) ?>" 
                 alt="<?= htmlspecialchars($event->name) ?>"
                 loading="lazy"
                 onerror="this.src='/assets/img/acnh/koeder.png'">
        </div>
        
        <div class="title-price-wrap">
            <span class="name"><?= htmlspecialchars($event->name) ?></span>
            
            <span class="event-badge <?= htmlspecialchars($event->getTypeCssClass()) ?>">
                <?= htmlspecialchars($event->getFormattedType()) ?>
            </span>
        </div>
    </div>

    <div class="creature-info event-info">
        <div class="info-row">
            <span class="info-label">📅 Wann:</span>
            <span class="info-value" style="font-weight: 900; color: var(--ac-green);">
                <?= htmlspecialchars($event->date_description) ?>
            </span>
        </div>
        
        <p class="event-desc">
            <?= htmlspecialchars($event->description) ?>
        </p>
    </div>
</article>