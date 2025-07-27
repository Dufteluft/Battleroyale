--[[

    Client-seitiges Loot-System

    Verwaltet die Anzeige und Interaktion mit Loot-Objekten.

]]

local spawnedLoot = {}
local isNearLoot = false

-- Event: Loot-Objekt spawnen
RegisterNetEvent('battleroyale:spawnLootObject')
AddEventHandler('battleroyale:spawnLootObject', function(object, lootId, rarity)
    spawnedLoot[object] = {
        id = lootId,
        rarity = rarity
    }
end)

-- Event: Loot-Objekt entfernen
RegisterNetEvent('battleroyale:removeLootObject')
AddEventHandler('battleroyale:removeLootObject', function(object)
    spawnedLoot[object] = nil
end)

-- Event: Alle Loot-Objekte entfernen
RegisterNetEvent('battleroyale:clearAllLootObjects')
AddEventHandler('battleroyale:clearAllLootObjects', function()
    spawnedLoot = {}
end)

-- Thread zur Überprüfung der Nähe zu Loot-Objekten
CreateThread(function()
    while true do
        Wait(500)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        isNearLoot = false

        for object, data in pairs(spawnedLoot) do
            if DoesEntityExist(object) then
                local lootCoords = GetEntityCoords(object)
                local distance = Utils.GetDistance(playerCoords, lootCoords)

                if distance < 2.0 then
                    isNearLoot = true
                    ESX.ShowHelpNotification("Drücke [E], um Loot aufzuheben.")
                    if IsControlJustReleased(0, 38) then -- E-Taste
                        TriggerServerEvent('battleroyale:pickupLoot', ObjToNet(object))
                    end
                    break -- Verlasse die Schleife, da wir nur eine Meldung anzeigen wollen
                end
            else
                -- Entferne das Objekt aus der Tabelle, wenn es nicht mehr existiert
                spawnedLoot[object] = nil
            end
        end
    end
end)

-- Thread zum Zeichnen von Text über Loot-Objekten
CreateThread(function()
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())

        for object, data in pairs(spawnedLoot) do
            if DoesEntityExist(object) then
                local lootCoords = GetEntityCoords(object)
                local distance = Utils.GetDistance(playerCoords, lootCoords)

                if distance < 20.0 then
                    -- Zeichne 3D-Text über dem Objekt
                    DrawText3D(lootCoords.x, lootCoords.y, lootCoords.z + 0.5, GetRarityLabel(data.rarity), GetRarityColor(data.rarity))
                end
            end
        end
    end
end)

-- Hilfsfunktion: 3D-Text zeichnen
function DrawText3D(x, y, z, text, color)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(pX, pY, pZ, x, y, z, 1)
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.35 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(color.r, color.g, color.b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

-- Hilfsfunktion: Seltenheits-Label
function GetRarityLabel(rarity)
    local labels = {
        common = "Gewöhnlich",
        uncommon = "Ungewöhnlich",
        rare = "Selten",
        epic = "Episch",
        legendary = "Legendär"
    }
    return labels[rarity] or "Unbekannt"
end

-- Hilfsfunktion: Seltenheits-Farbe
function GetRarityColor(rarity)
    local colors = {
        common = { r = 255, g = 255, b = 255 },
        uncommon = { r = 0, g = 255, b = 0 },
        rare = { r = 0, g = 150, b = 255 },
        epic = { r = 150, g = 0, b = 255 },
        legendary = { r = 255, g = 150, b = 0 }
    }
    return colors[rarity] or { r = 255, g = 255, b = 255 }
end
