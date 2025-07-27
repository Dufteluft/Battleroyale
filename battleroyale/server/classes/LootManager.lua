--[[

    LootManager Klasse (Server)

    Verwaltet das Spawnen von Loot auf der Karte.

]]

LootManager = {}
LootManager.__index = LootManager

-- Konstruktor
function LootManager:create(options)
    local instance = {}
    setmetatable(instance, LootManager)

    instance.lootSpawns = options.lootSpawns or {}
    instance.spawnedLoot = {}

    Utils.Log('LootManager initialisiert.')

    return instance
end

-- Spawnt Loot an einer zufälligen Position
function LootManager:spawnLoot()
    -- Diese Funktion sollte mit einer Liste von vordefinierten Spawn-Punkten arbeiten
    -- Zur Vereinfachung spawnen wir hier zufällig
    local spawnPoint = Config.SafeZone.center + vector3(Utils.Random(-4000, 4000), Utils.Random(-4000, 4000), 0)
    local lootTable = self:getLootByRarity()
    local loot = lootTable[Utils.Random(1, #lootTable)]

    if loot then
        self:spawnLootAtPosition(spawnPoint, loot)
        Utils.Log('Loot gespawnt: ' .. loot.item .. ' an ' .. tostring(spawnPoint))
    end
end

-- Spawnt eine bestimmte Anzahl an Loot-Items
function LootManager:spawnInitialLoot(amount)
    Utils.Log('Spawne ' .. amount .. ' Loot-Items...')
    for i = 1, amount do
        self:spawnLoot()
        Wait(10)
    end
    Utils.Log('Initiales Loot-Spawning abgeschlossen.')
end

-- Spawnt ein bestimmtes Item an einer Position
function LootManager:spawnLootAtPosition(position, lootData)
    local lootId = 'loot_' .. Utils.Random(1000, 9999)
    self.spawnedLoot[lootId] = {
        item = lootData.item,
        type = lootData.type, -- 'weapon' or 'item'
        rarity = lootData.rarity,
        amount = lootData.amount,
        ammo = lootData.ammo,
        position = position
    }

    -- Trigger Client-Event, um das Loot-Objekt zu erstellen und anzuzeigen
    TriggerClientEvent('battleroyale:spawnLootObject', -1, lootId, lootData, position)
end

-- Wählt Loot basierend auf der Seltenheit aus
function LootManager:getLootByRarity()
    local lootTable = {}
    local rand = Utils.Random(1, 100)

    local rarity
    if rand <= 50 then rarity = 'common'
    elseif rand <= 75 then rarity = 'uncommon'
    elseif rand <= 90 then rarity = 'rare'
    elseif rand <= 98 then rarity = 'epic'
    else rarity = 'legendary' end

    for _, weapon in ipairs(self.lootSpawns.weapons) do
        if weapon.rarity == rarity then
            weapon.type = 'weapon'
            table.insert(lootTable, weapon)
        end
    end

    for _, item in ipairs(self.lootSpawns.items) do
        if item.rarity == rarity then
            item.type = 'item'
            table.insert(lootTable, item)
        end
    end

    return lootTable
end

-- Behandelt das Aufsammeln von Loot
function LootManager:handlePickup(source, lootId)
    if self.spawnedLoot[lootId] then
        local loot = self.spawnedLoot[lootId]
        local player = ESX.GetPlayerFromId(source)

        if loot.type == 'weapon' then
            InventoryManager:giveWeapon(source, loot.item, loot.ammo)
        else
            InventoryManager:giveItem(source, loot.item, loot.amount)
        end

        self.spawnedLoot[lootId] = nil
        Utils.Log(player.name .. ' hat ' .. loot.item .. ' aufgesammelt.')

        -- Entferne das Loot-Objekt auf den Clients
        TriggerClientEvent('battleroyale:removeLootObject', -1, lootId)
    end
end

-- Löscht allen gespawnten Loot
function LootManager:clearAllLoot()
    for object, _ in pairs(self.spawnedLoot) do
        DeleteEntity(object)
    end
    self.spawnedLoot = {}
    TriggerClientEvent('battleroyale:clearAllLootObjects', -1)
    Utils.Log('Aller Loot wurde entfernt.')
end
