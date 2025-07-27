--[[

    Client-Koordinator für das Battle Royale System

]]

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Lädt die Konfiguration und Utility-Funktionen
dofile('shared/config.lua')
dofile('shared/utils.lua')

-- Lädt die Klassen
dofile('client/classes/UIManager.lua')
dofile('client/classes/ZoneManager.lua')
dofile('client/classes/EffectsManager.lua')

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
dofile('client/events/game_events.lua')
dofile('client/events/zone_events.lua')
dofile('client/events/inventory_events.lua')

-- Lädt das Loot-System
dofile('client/loot_system.lua')

-- Initialisiere den Client beim Start
InitializeClient()

Utils.Log('Battle Royale System (Client) geladen.')
