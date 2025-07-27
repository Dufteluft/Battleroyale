Config = {}

-- Basis Einstellungen
Config.MaxPlayers = 100          -- Maximale Spieleranzahl
Config.MinPlayersToStart = 10    -- Minimum zum Starten
Config.GameDuration = 1800       -- Spieldauer in Sekunden
Config.ShrinkInterval = 120      -- Zone schrumpft alle X Sekunden

-- Zone Konfiguration
Config.SafeZone = {
    center = vector3(0.0, 0.0, 72.0),  -- Zentrum der Zone
    radius = 5000.0,                    -- Start-Radius
    shrink_stages = {                   -- Schrumpf-Stufen
        {radius = 4000.0, damage = 5},
        {radius = 3000.0, damage = 10},
        {radius = 2000.0, damage = 15},
        {radius = 1000.0, damage = 20},
        {radius = 500.0, damage = 25},
        {radius = 250.0, damage = 30},
        {radius = 100.0, damage = 40},
        {radius = 50.0, damage = 50},
    }
}

-- Loot System
Config.LootSpawns = {
    weapons = {
        {item = 'WEAPON_PISTOL', rarity = 'common', ammo = 50},
        {item = 'WEAPON_SMG', rarity = 'uncommon', ammo = 100},
        {item = 'WEAPON_ASSAULTRIFLE', rarity = 'rare', ammo = 150},
        {item = 'WEAPON_SNIPERRIFLE', rarity = 'epic', ammo = 30},
        {item = 'WEAPON_HEAVYSNIPER', rarity = 'legendary', ammo = 10},
    },
    items = {
        {item = 'bandage', rarity = 'common', amount = 3},
        {item = 'medkit', rarity = 'uncommon', amount = 1},
        {item = 'armor', rarity = 'rare', amount = 1},
    }
}

-- Anti-Cheat Konfiguration
Config.AntiCheat = {
    checkInterval = 5000, -- Überprüfungsintervall in ms
    maxSpeed = 200.0, -- Maximale erlaubte Geschwindigkeit
    maxTeleportDistance = 150.0, -- Maximale Teleport-Distanz
    autoBan = true, -- Automatisches Bannen bei Verstößen
    banDuration = 24 -- Banndauer in Stunden
}

-- Datenbank Konfiguration
Config.MySQL = {
    database = 'fivem',
    user = 'root',
    password = '',
    host = 'localhost'
}
