# Nookipedia-Next: Project Initialization Script
# Modularity & MVC Structure

$projectName = "nookipedia-next"

# 1. Verzeichnisstruktur definieren
$directories = @(
    "app/Core",
    "app/Controllers",
    "app/Models",
    "app/Repositories",
    "config",
    "public/assets/css",
    "public/assets/js",
    "public/assets/img",
    "views/partials"
)

# 2. Dateien definieren
$files = @(
    "app/Core/Database.php",
    "app/Core/Router.php",
    "app/Core/Controller.php",
    "app/Controllers/HomeController.php",
    "app/Controllers/CreatureController.php",
    "app/Models/Creature.php",
    "app/Repositories/CreatureRepository.php",
    "config/config.php",
    "public/assets/css/main.css",
    "public/assets/css/themes.css",
    "public/assets/js/theme-switch.js",
    "public/index.php",
    "views/partials/header.php",
    "views/partials/footer.php",
    "views/partials/creature-card.php",
    "views/home.php",
    "views/creature-list.php",
    ".htaccess",
    ".env"
)

Write-Host "--- Initialisiere fabulous ACNH Wiki Struktur ---" -ForegroundColor Cyan

# Verzeichnisse erstellen
foreach ($dir in $directories) {
    if (!(Test-Path $dir)) {
        New-Item -Path $dir -ItemType Directory | Out-Null
        Write-Host "[OK] Ordner erstellt: $dir" -ForegroundColor Green
    }
}

# Dateien erstellen
foreach ($file in $files) {
    if (!(Test-Path $file)) {
        New-Item -Path $file -ItemType File | Out-Null
        Write-Host "[OK] Datei erstellt: $file" -ForegroundColor Green
    }
}

Write-Host "--- Struktur erfolgreich erstellt! Let's get fabulous. ---" -ForegroundColor Magentax