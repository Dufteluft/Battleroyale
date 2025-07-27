--[[

    Admin-Commands für das Battle Royale System

]]

-- Command: /startbr
RegisterCommand('startbr', function(source, args, rawCommand)
    if Utils.IsAdmin(source) then
        StartBattleRoyale()
        TriggerClientEvent('chat:addMessage', source, {
            color = { 0, 255, 0 },
            args = { "Battle Royale", "Das Spiel wird gestartet..." }
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 0, 0 },
            args = { "Battle Royale", "Du hast keine Berechtigung für diesen Befehl." }
        })
    end
end, false)

-- Command: /stopbr
RegisterCommand('stopbr', function(source, args, rawCommand)
    if Utils.IsAdmin(source) then
        StopBattleRoyale()
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 165, 0 },
            args = { "Battle Royale", "Das Spiel wird beendet..." }
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 0, 0 },
            args = { "Battle Royale", "Du hast keine Berechtigung für diesen Befehl." }
        })
    end
end, false)

-- Command: /brbans
RegisterCommand('brbans', function(source, args, rawCommand)
    if Utils.IsAdmin(source) then
        MySQL.Async.fetchAll('SELECT * FROM battleroyale_bans WHERE banned_until > NOW()', {}, function(bans)
            if #bans > 0 then
                TriggerClientEvent('chat:addMessage', source, {
                    color = { 255, 255, 0 },
                    multiline = true,
                    args = { "Battle Royale Bans", "Aktive Bans:" }
                })
                for _, ban in ipairs(bans) do
                    local message = string.format("- %s (%s): %s (Bis: %s)",
                        ban.player_name, ban.identifier, ban.reason, ban.banned_until)
                    TriggerClientEvent('chat:addMessage', source, {
                        color = { 255, 255, 255 },
                        args = { "", message }
                    })
                end
            else
                TriggerClientEvent('chat:addMessage', source, {
                    color = { 0, 255, 0 },
                    args = { "Battle Royale", "Es gibt keine aktiven Bans." }
                })
            end
        end)
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 0, 0 },
            args = { "Battle Royale", "Du hast keine Berechtigung für diesen Befehl." }
        })
    end
end, false)
