--[[

    Client-Koordinator für das Battle Royale System

]]

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Lädt die Konfiguration und Utility-Funktionen
-- Die Dateien werden nun über das fxmanifest geladen.
-- dofile wird nicht mehr benötigt.

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
