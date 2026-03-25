<!DOCTYPE html>
<html lang="de" data-theme="light">
<head>
    <!-- Anti-FOUC Script: Wird sofort ausgeführt und setzt das Theme vor dem ersten Rendern -->
    <script>
        const savedTheme = localStorage.getItem('theme') || 'light';
        document.documentElement.setAttribute('data-theme', savedTheme);
    </script>
    
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="theme-color" content="#76b041">
    <title><?= $title ?? 'Nookipedia Next' ?> - ACNH Wiki</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    
    <!-- CSS - Nutzt ASSET_PATH um Assets immer zu finden -->
    <link rel="stylesheet" href="<?= ASSET_PATH ?>/assets/css/main.css">
    
    <link rel="icon" type="image/png" href="<?= ASSET_PATH ?>/assets/img/acnh/leaf_icon.png">
</head>
<body>
    <header>
        <div class="container" style="display:flex; justify-content:space-between; align-items:center; width:100%; padding:0;">
            <a href="<?= ASSET_PATH ?>/" class="logo">
                <span>🍃</span> Nookipedia
            </a>
            <button id="theme-toggle" title="Design umschalten">
                🌓
            </button>
        </div>
    </header>
    <main class="container">