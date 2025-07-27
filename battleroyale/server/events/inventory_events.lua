--[[

    Inventory Event Handler (Server)

    Behandelt alle inventarbezogenen Events.

]]

-- Event: Item wird verwendet
AddEventHandler('battleroyale:useItem', function(item)
    local source = source
    if BR_InventoryManager and BR_GameManager:isPlayerInGame(source) then
        BR_InventoryManager:useItem(source, item)
    end
end)

-- Exports für die Interaktion mit dem Inventar-Manager
exports('PreparePlayerForBattleRoyale', function(source)
    if BR_InventoryManager then
        BR_InventoryManager:preparePlayer(source)
    end
end)

exports('RestorePlayerAfterBattleRoyale', function(source)
    if BR_InventoryManager then
        BR_InventoryManager:restorePlayer(source)
    end
end)
