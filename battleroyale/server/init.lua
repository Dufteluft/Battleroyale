--[[

    Initialisierung des Battle Royale Systems (Server)

]]

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local resourcePath = get_resource_path(GetCurrentResourceName())

local function loadFile(path)
    local fullPath = resourcePath .. '/' .. path
    print('Lade Datei: ' .. fullPath)
    local success, err = pcall(dofile, fullPath)
    if not success then
        print('Fehler beim Laden von ' .. path .. ': ' .. err)
    else
        print(path .. ' erfolgreich geladen.')
    end
end

-- Lädt die Konfiguration und Utility-Funktionen
loadFile('shared/config.lua')
loadFile('shared/utils.lua')

-- Lädt die Klassen
loadFile('server/classes/GameManager.lua')
loadFile('server/classes/InventoryManager.lua')
loadFile('server/classes/LootManager.lua')
loadFile('server/classes/AntiCheatManager.lua')

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
-- Die Dateien werden nun über das fxmanifest geladen.

Utils.Log('Battle Royale System (Server) geladen.')
