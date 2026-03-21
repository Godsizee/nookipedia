<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="theme-color" content="#76b041">
    <title><?= $title ?? 'Nookipedia Next' ?> - ACNH Wiki</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    
    <!-- CSS - Dynamischer Pfad über BASE_PATH -->
    <link rel="stylesheet" href="<?= BASE_PATH ?>/public/assets/css/main.css">
    
    <!-- Favicon Placeholder -->
    <link rel="icon" type="image/png" href="<?= BASE_PATH ?>/public/assets/img/acnh/leaf_icon.png">
</head>
<body data-theme="light">
    <header>
        <div class="container" style="display:flex; justify-content:space-between; align-items:center; width:100%; padding:0;">
            <a href="<?= BASE_PATH ?>/" class="logo">
                <span>🍃</span> Nookipedia
            </a>
            <button id="theme-toggle" title="Design umschalten">
                🌓
            </button>
        </div>
    </header>
    <main class="container">