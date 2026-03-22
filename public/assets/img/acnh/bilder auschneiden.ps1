# 1. Zielordner definieren (der Ordner, in dem das Script liegt)
$ZielPfad = $PSScriptRoot

# Falls das Script manuell in der Konsole ohne Speichern ausgeführt wird, 
# nutzen wir das aktuelle Arbeitsverzeichnis
if (-not $ZielPfad) { $ZielPfad = Get-Location }

Write-Host "Suche Bilder in Unterordnern von: $ZielPfad" -ForegroundColor Cyan

# 2. Alle .jpg und .png Dateien aus Unterordnern suchen
# Wir schließen Dateien aus, die bereits im Zielordner liegen
$Bilder = Get-ChildItem -Path $ZielPfad -Recurse -Include *.jpg, *.png, *.jpeg -File | Where-Object { 
    $_.DirectoryName -ne $ZielPfad 
}

# 3. Dateien verschieben
if ($Bilder.Count -eq 0) {
    Write-Host "Keine neuen Bilder in Unterordnern gefunden." -ForegroundColor Yellow
} else {
    foreach ($Bild in $Bilder) {
        Write-Host "Verschiebe: $($Bild.Name)" -ForegroundColor Gray
        
        # Verschieben mit -ErrorAction SilentlyContinue, falls Dateiname im Ziel schon existiert
        try {
            Move-Item -Path $Bild.FullName -Destination $ZielPfad -ErrorAction Stop
        }
        catch {
            Write-Host "Fehler: $($Bild.Name) konnte nicht verschoben werden (evtl. Name bereits vorhanden)." -ForegroundColor Red
        }
    }
    Write-Host "Fertig! $($Bilder.Count) Dateien verarbeitet." -ForegroundColor Green
}

# Verhindert, dass sich das Fenster sofort schließt
Read-Host "Drücke Enter zum Beenden"