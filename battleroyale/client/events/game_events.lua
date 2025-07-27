--[[

    Game Event Handler (Client)

    Behandelt spielbezogene Events auf dem Client.

]]

local inGame = false

-- Event: Spiel gestartet
RegisterNetEvent('battleroyale:gameStarted')
AddEventHandler('battleroyale:gameStarted', function()
    inGame = true
    UIManagerInstance:showUI()
    UIManagerInstance:showNotification("Das Battle Royale hat begonnen! Viel Glück!")

    -- Initialisiere den ZoneManager mit den Startwerten aus der Config
    ZoneManagerInstance = ZoneManager:create({
        center = Config.SafeZone.center,
        radius = Config.SafeZone.radius
    })
end)

-- Event: Spiel beendet
RegisterNetEvent('battleroyale:gameEnded')
AddEventHandler('battleroyale:gameEnded', function(winner)
    inGame = false
    UIManagerInstance:hideUI()
    if winner and GetPlayerName(winner) == GetPlayerName(PlayerId()) then
        UIManagerInstance:showNotification("Sieg! Du hast das Battle Royale gewonnen!")
    else
        UIManagerInstance:showNotification("Das Spiel ist vorbei. Besser Glück beim nächsten Mal!")
    end

    -- Setze den Spieler zurück
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
    SetPedArmour(playerPed, 0)
    -- Weitere Aufräumarbeiten...
end)

-- Event: UI aktualisieren
RegisterNetEvent('battleroyale:updateUI')
AddEventHandler('battleroyale:updateUI', function(data)
    if inGame then
        UIManagerInstance:update(data)
    end
end)

-- Event: Kill Feed aktualisieren
RegisterNetEvent('battleroyale:updateKillFeed')
AddEventHandler('battleroyale:updateKillFeed', function(killer, victim)
    if inGame then
        UIManagerInstance:addKillFeed(killer, victim)
    end
end)

-- Event: Spectator-Modus betreten
RegisterNetEvent('battleroyale:enterSpectator')
AddEventHandler('battleroyale:enterSpectator', function()
    inGame = false -- Nicht mehr aktiv am Spiel beteiligt
    UIManagerInstance:showNotification("Du wurdest eliminiert und bist jetzt im Spectator-Modus.")
    -- Hier müsste die Spectator-Logik implementiert werden
    -- z.B. mit DoScreenFadeOut, Spieler unsichtbar machen, etc.
end)

-- Event: Effekt abspielen
RegisterNetEvent('battleroyale:playEffect')
AddEventHandler('battleroyale:playEffect', function(effectName, duration)
    EffectsManagerInstance:playEffect(effectName, duration)
end)
