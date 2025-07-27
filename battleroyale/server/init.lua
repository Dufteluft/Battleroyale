--[[

    Initialisierung des Battle Royale Systems (Server)

]]

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Lädt die Konfiguration und Utility-Funktionen
dofile('shared/config.lua')
dofile('shared/utils.lua')

-- Lädt die Klassen
dofile('server/classes/GameManager.lua')
dofile('server/classes/InventoryManager.lua')
dofile('server/classes/LootManager.lua')
dofile('server/classes/AntiCheatManager.lua')

-- Initialisiert die Datenbank
CreateThread(function()
    Utils.Log('Initialisiere Datenbank...')
    MySQL.Async.execute(
        [[
            CREATE TABLE IF NOT EXISTS `battleroyale_stats` (
                `identifier` VARCHAR(50) PRIMARY KEY,
                `games_played` INT DEFAULT 0,
                `wins` INT DEFAULT 0,
                `kills` INT DEFAULT 0,
                `deaths` INT DEFAULT 0,
                `best_placement` INT DEFAULT 0
            );
        ]], {}, function() Utils.Log('Tabelle battleroyale_stats erstellt/überprüft.') end
    )
    MySQL.Async.execute(
        [[
            CREATE TABLE IF NOT EXISTS `battleroyale_anticheat_logs` (
                `id` INT AUTO_INCREMENT PRIMARY KEY,
                `identifier` VARCHAR(50) NOT NULL,
                `player_name` VARCHAR(100) NOT NULL,
                `violation_type` VARCHAR(50) NOT NULL,
                `violation_data` TEXT,
                `timestamp` DATETIME DEFAULT CURRENT_TIMESTAMP
            );
        ]], {}, function() Utils.Log('Tabelle battleroyale_anticheat_logs erstellt/überprüft.') end
    )
    MySQL.Async.execute(
        [[
            CREATE TABLE IF NOT EXISTS `battleroyale_bans` (
                `id` INT AUTO_INCREMENT PRIMARY KEY,
                `identifier` VARCHAR(50) NOT NULL,
                `player_name` VARCHAR(100) NOT NULL,
                `reason` TEXT NOT NULL,
                `banned_until` DATETIME NOT NULL,
                `banned_by` VARCHAR(100) NOT NULL,
                `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
            );
        ]], {}, function() Utils.Log('Tabelle battleroyale_bans erstellt/überprüft.') end
    )
end)

-- Lädt die Event-Handler
dofile('server/events/game_events.lua')
dofile('server/events/inventory_events.lua')
dofile('server/events/loot_events.lua')

-- Lädt den Koordinator und die Commands
dofile('server/main.lua')
dofile('server/commands.lua')

Utils.Log('Battle Royale System (Server) geladen.')
