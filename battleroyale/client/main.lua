--[[

    Client-Koordinator für das Battle Royale System

]]

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Die Dateien werden nun über das fxmanifest geladen.

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
