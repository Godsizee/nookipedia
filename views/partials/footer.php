</main>
    
    <footer style="margin-top: 50px; padding: 40px 0; text-align: center; border-top: 1px solid rgba(0,0,0,0.05);">
        <div class="container">
            <p style="font-weight: 700; color: var(--nook-green);">🍃 Nookipedia Next</p>
            <p style="font-size: 0.9rem; color: var(--text-muted);">
                Alle Bilder und Daten stammen aus Animal Crossing: New Horizons.<br>
                &copy; <?= date('Y') ?> - Mit Liebe zum Detail entwickelt.
            </p>
        </div>
    </footer>

    <!-- Fabulous Theme Switcher & Interaction Logic -->
    <script>
        const root = document.documentElement;
        const toggleBtn = document.getElementById('theme-toggle');

        toggleBtn.addEventListener('click', () => {
            const currentTheme = root.getAttribute('data-theme');
            const newTheme = currentTheme === 'light' ? 'dark' : 'light';
            
            root.setAttribute('data-theme', newTheme);
            localStorage.setItem('theme', newTheme);
            
            // Kleine Feedback-Animation
            toggleBtn.style.transform = 'scale(0.8)';
            setTimeout(() => toggleBtn.style.transform = 'scale(1)', 100);
        });
    </script>
</body>
</html>