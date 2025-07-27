--[[

    UIManager Klasse (Client)

    Verwaltet die Benutzeroberfläche (UI) für das Battle Royale.

]]

UIManager = {}
UIManager.__index = UIManager

-- Konstruktor
function UIManager:create()
    local instance = {}
    setmetatable(instance, UIManager)

    instance.uiVisible = false
    Utils.Log('UIManager initialisiert.')

    return instance
end

-- Zeigt die Battle Royale UI an
function UIManager:showUI()
    if not self.uiVisible then
        SendNUIMessage({ type = 'show' })
        self.uiVisible = true
        Utils.Log('UI angezeigt.')
    end
end

-- Versteckt die Battle Royale UI
function UIManager:hideUI()
    if self.uiVisible then
        SendNUIMessage({ type = 'hide' })
        self.uiVisible = false
        Utils.Log('UI versteckt.')
    end
end

-- Aktualisiert die UI-Daten
function UIManager:update(data)
    if self.uiVisible then
        SendNUIMessage({
            type = 'update',
            data = data
        })
    end
end

-- Fügt einen Eintrag zum Kill Feed hinzu
function UIManager:addKillFeed(killer, victim)
    SendNUIMessage({
        type = 'killFeed',
        killer = killer,
        victim = victim
    })
end

-- Zeigt eine Benachrichtigung an
function UIManager:showNotification(message)
    -- Hier könnte man eine UI-Benachrichtigung anzeigen
    -- Zur Vereinfachung verwenden wir die ESX-eigene Funktion
    ESX.ShowNotification(message)
end

-- Export, um die UI von externen Ressourcen aus zu steuern
exports('ShowBattleRoyaleUI', function(data)
    if not UIManagerInstance then UIManagerInstance = UIManager:create() end
    UIManagerInstance:showUI()
    if data then
        UIManagerInstance:update(data)
    end
end)
