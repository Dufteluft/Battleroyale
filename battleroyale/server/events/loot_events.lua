--[[

    Loot Event Handler (Server)

    Behandelt alle lootbezogenen Events.

]]

-- Event: Loot wird aufgesammelt
AddEventHandler('battleroyale:pickupLoot', function(lootId)
    local source = source

    if BR_LootManager and BR_GameManager:isPlayerInGame(source) then
        BR_LootManager:handlePickup(source, lootId)
    end
end)

-- Export zum Spawnen von Loot an einer bestimmten Position
exports('SpawnLootAtPosition', function(position, itemType, rarity)
    if BR_LootManager then
        local lootData = {
            item = itemType,
            rarity = rarity,
            -- Hier müssten die Details des Items aus der Config geholt werden
        }
        -- Diese Funktion ist vereinfacht. Eine vollständige Implementierung
        -- würde die lootData-Tabelle basierend auf itemType und rarity aus der
        -- Config.LootSpawns zusammensetzen.
        -- BR_LootManager:spawnLootAtPosition(position, lootData)
    end
end)
