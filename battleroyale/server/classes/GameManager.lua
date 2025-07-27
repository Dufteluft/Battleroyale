--[[

    GameManager Klasse (Server)

    Verwaltet den Spielstatus, die Spieler und den allgemeinen Ablauf des Battle Royale.

]]

GameManager = {}
GameManager.__index = GameManager

-- Konstruktor
function GameManager:create(options)
    local instance = {}
    setmetatable(instance, GameManager)

    instance.maxPlayers = options.maxPlayers or 100
    instance.minPlayersToStart = options.minPlayersToStart or 10
    instance.gameDuration = options.gameDuration or 1800
    instance.shrinkInterval = options.shrinkInterval or 120

    instance.players = {}
    instance.gameState = 'lobby' -- lobby, starting, active, finished
    instance.gameTimer = 0
    instance.shrinkTimer = 0
    instance.zoneStage = 1

    Utils.Log('GameManager initialisiert.')

    return instance
end

-- Fügt einen Spieler zum Spiel hinzu
function GameManager:addPlayer(source)
    if #self.players < self.maxPlayers then
        table.insert(self.players, source)
        Utils.Log('Spieler ' .. GetPlayerName(source) .. ' hinzugefügt. (' .. #self.players .. '/' .. self.maxPlayers .. ')')
        self:preparePlayerForBattleRoyale(source)
        self:updateUI()
        return true
    else
        Utils.Log('Maximale Spieleranzahl erreicht. Spieler ' .. GetPlayerName(source) .. ' kann nicht beitreten.')
        return false
    end
end

-- Entfernt einen Spieler aus dem Spiel
function GameManager:removePlayer(source)
    for i, player in ipairs(self.players) do
        if player == source then
            table.remove(self.players, i)
            Utils.Log('Spieler ' .. GetPlayerName(source) .. ' entfernt.')
            self:restorePlayerAfterBattleRoyale(source)
            self:updateUI()
            break
        end
    end
end

-- Startet das Spiel
function GameManager:startGame()
    if self.gameState == 'lobby' and #self.players >= self.minPlayersToStart then
        self.gameState = 'active'
        self.gameTimer = self.gameDuration
        self.shrinkTimer = self.shrinkInterval
        Utils.Log('Spiel gestartet!')

        for _, player in ipairs(self.players) do
            TriggerClientEvent('battleroyale:gameStarted', player)
        end

        self:startTimers()
    else
        Utils.Log('Nicht genügend Spieler zum Starten des Spiels.')
    end
end

-- Beendet das Spiel
function GameManager:endGame(winner)
    self.gameState = 'finished'
    Utils.Log('Spiel beendet! Gewinner: ' .. (winner and GetPlayerName(winner) or 'Niemand'))

    for _, player in ipairs(self.players) do
        TriggerClientEvent('battleroyale:gameEnded', player, winner)
        self:restorePlayerAfterBattleRoyale(player)
    end

    self.players = {}
    self:updateUI()
end

-- Aktualisiert die Timer und die Zone
function GameManager:update()
    if self.gameState == 'active' then
        self.gameTimer = self.gameTimer - 1
        self.shrinkTimer = self.shrinkTimer - 1

        if self.shrinkTimer <= 0 then
            self:shrinkZone()
            self.shrinkTimer = self.shrinkInterval
        end

        if self.gameTimer <= 0 or #self.players <= 1 then
            local winner = #self.players == 1 and self.players[1] or nil
            self:endGame(winner)
        end

        self:updateUI()
    end
end

-- Startet die Timer-Schleife
function GameManager:startTimers()
    CreateThread(function()
        while self.gameState == 'active' do
            self:update()
            Wait(1000)
        end
    end)
end

-- Schrumpft die Zone
function GameManager:shrinkZone()
    self.zoneStage = self.zoneStage + 1
    if self.zoneStage <= #Config.SafeZone.shrink_stages then
        local zoneData = Config.SafeZone.shrink_stages[self.zoneStage]
        Utils.Log('Zone schrumpft auf Stufe ' .. self.zoneStage)
        for _, player in ipairs(self.players) do
            TriggerClientEvent('battleroyale:zoneShrinking', player, zoneData)
        end
    else
        Utils.Log('Zone hat die kleinste Stufe erreicht.')
    end
end

-- Bereitet einen Spieler auf das BR vor
function GameManager:preparePlayerForBattleRoyale(source)
    -- Logik zum Speichern des Spieler-Inventars etc.
    exports.battleroyale:PreparePlayerForBattleRoyale(source)
end

-- Stellt einen Spieler nach dem BR wieder her
function GameManager:restorePlayerAfterBattleRoyale(source)
    -- Logik zum Wiederherstellen des Spieler-Inventars etc.
    exports.battleroyale:RestorePlayerAfterBattleRoyale(source)
end

-- Aktualisiert die UI für alle Spieler
function GameManager:updateUI()
    local uiData = {
        players = #self.players,
        maxPlayers = self.maxPlayers,
        gameState = self.gameState,
        gameTimer = self.gameTimer,
        shrinkTimer = self.shrinkTimer
    }
    for _, player in ipairs(self.players) do
        TriggerClientEvent('battleroyale:updateUI', player, uiData)
    end
end

-- Behandelt den Tod eines Spielers
function GameManager:handlePlayerDeath(source, killer)
    Utils.Log(GetPlayerName(source) .. ' wurde von ' .. (killer and GetPlayerName(killer) or 'der Zone') .. ' getötet.')
    self:removePlayer(source)
    TriggerClientEvent('battleroyale:enterSpectator', source)

    -- Kill Feed aktualisieren
    for _, player in ipairs(self.players) do
        TriggerClientEvent('battleroyale:updateKillFeed', player, GetPlayerName(killer), GetPlayerName(source))
    end
end
