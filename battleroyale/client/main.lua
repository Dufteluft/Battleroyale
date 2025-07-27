--[[

    Client-Koordinator für das Battle Royale System

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
loadFile('client/classes/UIManager.lua')
loadFile('client/classes/ZoneManager.lua')
loadFile('client/classes/EffectsManager.lua')

-- Globale Instanzen der Manager-Klassen
UIManagerInstance = nil
ZoneManagerInstance = nil
EffectsManagerInstance = nil

-- Initialisiert die Client-Seite des Systems
function InitializeClient()
    Utils.Log('Initialisiere Battle Royale Client...')

    UIManagerInstance = UIManager:create()
    EffectsManagerInstance = EffectsManager:create()
    -- ZoneManager wird erst bei Spielstart initialisiert

    Utils.Log('Battle Royale Client initialisiert.')
end

-- Lädt die Event-Handler
-- Die Dateien werden nun über das fxmanifest geladen.

-- Initialisiere den Client beim Start
InitializeClient()

Utils.Log('Battle Royale System (Client) geladen.')
