--[[

    Server-Koordinator für das Battle Royale System

]]

-- Globale Instanzen der Manager-Klassen
BR_GameManager = nil
BR_InventoryManager = nil
BR_LootManager = nil
BR_AntiCheatManager = nil

-- Initialisiert das System
function InitializeBattleRoyale()
    Utils.Log('Initialisiere Battle Royale Manager...')

    BR_GameManager = GameManager:create({
        maxPlayers = Config.MaxPlayers,
        minPlayersToStart = Config.MinPlayersToStart,
        gameDuration = Config.GameDuration,
        shrinkInterval = Config.ShrinkInterval
    })

    BR_InventoryManager = InventoryManager:create({})

    BR_LootManager = LootManager:create({
        lootSpawns = Config.LootSpawns
    })

    BR_AntiCheatManager = AntiCheatManager:create({
        antiCheatConfig = Config.AntiCheat
    })

    -- Startet die Anti-Cheat-Überwachung
    if Config.AntiCheat.enabled then
        BR_AntiCheatManager:startMonitoring(BR_GameManager.players)
    end

    Utils.Log('Battle Royale Manager initialisiert.')
end

-- Startet das Battle Royale Spiel
function StartBattleRoyale()
    if not BR_GameManager or BR_GameManager.gameState ~= 'lobby' then
        InitializeBattleRoyale()
    end

    -- Füge alle aktuellen Spieler hinzu (optional, je nach Anwendungsfall)
    -- for _, player in ipairs(GetPlayers()) do
    --     BR_GameManager:addPlayer(player)
    -- end

    -- Spawne initialen Loot
    BR_LootManager:spawnInitialLoot(200) -- Beispiel: 200 Loot-Items

    -- Starte das Spiel (nach einer Wartezeit)
    Utils.Log('Spiel startet in 30 Sekunden...')
    Wait(30000)
    BR_GameManager:startGame()
end

-- Beendet das Battle Royale Spiel
function StopBattleRoyale()
    if BR_GameManager and BR_GameManager.gameState == 'active' then
        BR_GameManager:endGame(nil)
        BR_LootManager:clearAllLoot()
        Utils.Log('Battle Royale wurde manuell beendet.')
    else
        Utils.Log('Kein aktives Battle Royale Spiel zum Beenden.')
    end
end

-- Initialisiere das System beim Start
InitializeBattleRoyale()
