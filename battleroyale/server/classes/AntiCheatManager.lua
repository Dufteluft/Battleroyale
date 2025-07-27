--[[

    AntiCheatManager Klasse (Server)

    Überwacht Spieler auf verdächtiges Verhalten.

]]

AntiCheatManager = {}
AntiCheatManager.__index = AntiCheatManager

-- Konstruktor
function AntiCheatManager:create(options)
    local instance = {}
    setmetatable(instance, AntiCheatManager)

    instance.config = options.antiCheatConfig or {}
    instance.violations = {}

    Utils.Log('AntiCheatManager initialisiert.')

    return instance
end

-- Startet die Überwachungsschleife
function AntiCheatManager:startMonitoring(players)
    CreateThread(function()
        while true do
            Wait(self.config.checkInterval or 5000)
            for _, source in ipairs(players) do
                self:checkPlayer(source)
            end
        end
    end)
end

-- Überprüft einen einzelnen Spieler
function AntiCheatManager:checkPlayer(source)
    local ped = GetPlayerPed(source)
    local playerName = GetPlayerName(source)
    local identifier = ESX.GetPlayerFromId(source).identifier

    -- Anti-Speed-Hack
    local speed = GetEntitySpeed(ped)
    if speed > self.config.maxSpeed then
        self:flagPlayer(source, 'Speed Hack', { speed = speed })
    end

    -- Anti-Teleport
    local lastPosition = self.lastPositions and self.lastPositions[source]
    if lastPosition then
        local distance = Utils.GetDistance(GetEntityCoords(ped), lastPosition)
        if distance > self.config.maxTeleportDistance then
            self:flagPlayer(source, 'Teleport', { distance = distance })
        end
    end
    if not self.lastPositions then self.lastPositions = {} end
    self.lastPositions[source] = GetEntityCoords(ped)

    -- Weitere Checks hier...
end

-- Markiert einen Spieler für einen Verstoß
function AntiCheatManager:flagPlayer(source, violationType, data)
    local identifier = ESX.GetPlayerFromId(source).identifier
    if not self.violations[identifier] then
        self.violations[identifier] = 0
    end
    self.violations[identifier] = self.violations[identifier] + 1

    local message = string.format("Anti-Cheat: %s hat einen Verstoß ausgelöst (%s). Verstöße: %d",
        GetPlayerName(source), violationType, self.violations[identifier])
    Utils.Log(message)
    TriggerEvent('battleroyale:anticheat', source, violationType, data)

    -- Log in die Datenbank schreiben
    self:logViolation(source, violationType, data)

    if self.config.autoBan and self.violations[identifier] >= 3 then
        self:banPlayer(source, "Wiederholte Anti-Cheat Verstöße")
    end
end

-- Bannt einen Spieler
function AntiCheatManager:banPlayer(source, reason)
    local player = ESX.GetPlayerFromId(source)
    local banUntil = os.time() + (self.config.banDuration * 3600)

    MySQL.Async.execute(
        'INSERT INTO battleroyale_bans (identifier, player_name, reason, banned_until, banned_by) VALUES (@identifier, @player_name, @reason, @banned_until, @banned_by)',
        {
            ['@identifier'] = player.identifier,
            ['@player_name'] = player.name,
            ['@reason'] = reason,
            ['@banned_until'] = os.date("%Y-%m-%d %H:%M:%S", banUntil),
            ['@banned_by'] = 'Anti-Cheat System'
        },
        function(rowsChanged)
            if rowsChanged > 0 then
                Utils.Log(player.name .. ' wurde für ' .. self.config.banDuration .. ' Stunden gebannt.')
                DropPlayer(source, 'Du wurdest vom Battle Royale gebannt: ' .. reason)
            end
        end
    )
end

-- Schreibt einen Verstoß in die Log-Tabelle
function AntiCheatManager:logViolation(source, violationType, data)
    local player = ESX.GetPlayerFromId(source)
    MySQL.Async.execute(
        'INSERT INTO battleroyale_anticheat_logs (identifier, player_name, violation_type, violation_data) VALUES (@identifier, @player_name, @violation_type, @violation_data)',
        {
            ['@identifier'] = player.identifier,
            ['@player_name'] = player.name,
            ['@violation_type'] = violationType,
            ['@violation_data'] = Utils.ToJson(data)
        }
    )
end
