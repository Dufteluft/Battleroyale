--[[

    InventoryManager Klasse (Server)

    Verwaltet das Inventar der Spieler im Battle Royale.

]]

InventoryManager = {}
InventoryManager.__index = InventoryManager

-- Konstruktor
function InventoryManager:create(options)
    local instance = {}
    setmetatable(instance, InventoryManager)

    Utils.Log('InventoryManager initialisiert.')

    return instance
end

-- Bereitet das Inventar eines Spielers für das BR vor
function InventoryManager:preparePlayer(source)
    local player = ESX.GetPlayerFromId(source)
    local inventory = exports.ox_inventory:GetInventory(source)

    -- Speichere das aktuelle Inventar
    -- HINWEIS: Dies ist eine vereinfachte Darstellung.
    -- In einer echten Umgebung müsste das Inventar in der Datenbank gespeichert werden.
    player.set('br_inventory_backup', inventory)

    -- Leere das Inventar
    exports.ox_inventory:ClearInventory(source)
    Utils.Log('Inventar von ' .. player.name .. ' für BR vorbereitet.')
end

-- Stellt das Inventar eines Spielers nach dem BR wieder her
function InventoryManager:restorePlayer(source)
    local player = ESX.GetPlayerFromId(source)
    local backup = player.get('br_inventory_backup')

    if backup then
        -- Leere das aktuelle Inventar
        exports.ox_inventory:ClearInventory(source)
        -- Stelle das Backup wieder her
        exports.ox_inventory:SetInventory(source, backup)
        player.set('br_inventory_backup', nil)
        Utils.Log('Inventar von ' .. player.name .. ' wiederhergestellt.')
    else
        Utils.Log('Kein Inventar-Backup für ' .. player.name .. ' gefunden.')
    end
end

-- Gibt einem Spieler ein Item
function InventoryManager:giveItem(source, item, amount)
    local player = ESX.GetPlayerFromId(source)
    local success = exports.ox_inventory:AddItem(source, item, amount)

    if success then
        Utils.Log(player.name .. ' hat ' .. amount .. 'x ' .. item .. ' erhalten.')
    else
        Utils.Log('Fehler beim Geben von ' .. item .. ' an ' .. player.name)
    end
end

-- Gibt einem Spieler eine Waffe
function InventoryManager:giveWeapon(source, weapon, ammo)
    local player = ESX.GetPlayerFromId(source)
    local success = exports.ox_inventory:AddItem(source, weapon, 1, { ammo = ammo })

    if success then
        Utils.Log(player.name .. ' hat ' .. weapon .. ' mit ' .. ammo .. ' Munition erhalten.')
    else
        Utils.Log('Fehler beim Geben von ' .. weapon .. ' an ' .. player.name)
    end
end

-- Verwendet ein Item aus dem Inventar
function InventoryManager:useItem(source, item)
    local player = ESX.GetPlayerFromId(source)
    local ped = GetPlayerPed(source)

    if item == 'bandage' then
        SetEntityHealth(ped, GetEntityHealth(ped) + 25)
        TriggerClientEvent('battleroyale:playEffect', source, 'heal')
    elseif item == 'medkit' then
        SetEntityHealth(ped, GetEntityHealth(ped) + 100)
        TriggerClientEvent('battleroyale:playEffect', source, 'heal')
    elseif item == 'armor' then
        SetPedArmour(ped, 100)
        TriggerClientEvent('battleroyale:playEffect', source, 'armor')
    end

    exports.ox_inventory:RemoveItem(source, item, 1)
    Utils.Log(player.name .. ' hat ' .. item .. ' benutzt.')
end
