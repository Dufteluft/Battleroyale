--[[

    Game Event Handler (Server)

    Behandelt alle spielbezogenen Events.

]]

-- Event: Spieler tritt dem Battle Royale bei
AddEventHandler('battleroyale:requestJoin', function()
    local source = source
    if BR_GameManager then
        BR_GameManager:addPlayer(source)
    end
end)

-- Event: Spieler verlässt das Battle Royale
AddEventHandler('battleroyale:requestLeave', function()
    local source = source
    if BR_GameManager then
        BR_GameManager:removePlayer(source)
    end
end)

-- Event: Spieler wird getötet
AddEventHandler('playerDropped', function(reason)
    local source = source
    if BR_GameManager and BR_GameManager:isPlayerInGame(source) then
        BR_GameManager:removePlayer(source)
        Utils.Log('Spieler ' .. GetPlayerName(source) .. ' hat das Spiel verlassen (' .. reason .. ').')
    end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    local source = data.victim
    local killer = data.killer

    if BR_GameManager and BR_GameManager:isPlayerInGame(source) then
        BR_GameManager:handlePlayerDeath(source, killer)

        -- Update Statistiken
        if killer and BR_GameManager:isPlayerInGame(killer) then
            updatePlayerStats(killer, { kills = 1 })
        end
        updatePlayerStats(source, { deaths = 1 })
    end
end)

-- Event: Anti-Cheat-Verstoß
AddEventHandler('battleroyale:anticheat', function(source, violationType, data)
    -- Diese Informationen können hier weiterverarbeitet werden,
    -- z.B. an Admins gesendet werden.
    local adminMessage = string.format("Anti-Cheat: %s | Verstoß: %s | Daten: %s",
        GetPlayerName(source), violationType, Utils.ToJson(data))

    -- Sende Nachricht an alle Admins
    local players = GetPlayers()
    for _, player in ipairs(players) do
        if Utils.IsAdmin(player) then
            TriggerClientEvent('chat:addMessage', player, {
                color = { 255, 0, 0 },
                multiline = true,
                args = { "Battle Royale", adminMessage }
            })
        end
    end
end)

-- Hilfsfunktion: Überprüft, ob ein Spieler im Spiel ist
function GameManager:isPlayerInGame(source)
    for _, player in ipairs(self.players) do
        if player == source then
            return true
        end
    end
    return false
end

-- Hilfsfunktion: Aktualisiert die Spielerstatistiken
function updatePlayerStats(source, stats)
    local player = ESX.GetPlayerFromId(source)
    if not player then return end

    local identifier = player.identifier

    MySQL.Async.fetchAll(
        'SELECT * FROM battleroyale_stats WHERE identifier = @identifier',
        { ['@identifier'] = identifier },
        function(result)
            if result[1] then
                -- Update
                local newKills = (result[1].kills or 0) + (stats.kills or 0)
                local newDeaths = (result[1].deaths or 0) + (stats.deaths or 0)
                -- Weitere Stats hier...

                MySQL.Async.execute(
                    'UPDATE battleroyale_stats SET kills = @kills, deaths = @deaths WHERE identifier = @identifier',
                    {
                        ['@identifier'] = identifier,
                        ['@kills'] = newKills,
                        ['@deaths'] = newDeaths
                    }
                )
            else
                -- Insert
                MySQL.Async.execute(
                    'INSERT INTO battleroyale_stats (identifier, kills, deaths) VALUES (@identifier, @kills, @deaths)',
                    {
                        ['@identifier'] = identifier,
                        ['@kills'] = stats.kills or 0,
                        ['@deaths'] = stats.deaths or 0
                    }
                )
            end
        end
    )
end
