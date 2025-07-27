--[[

    Zone Event Handler (Client)

    Behandelt zonenspezifische Events.

]]

-- Event: Zone schrumpft
RegisterNetEvent('battleroyale:zoneShrinking')
AddEventHandler('battleroyale:zoneShrinking', function(zoneData)
    if ZoneManagerInstance then
        ZoneManagerInstance:updateZone(zoneData)
        UIManagerInstance:showNotification("Die Zone schrumpft!")
    end
end)

-- Thread zum Zeichnen der Zone (optional)
CreateThread(function()
    while true do
        Wait(0)
        if ZoneManagerInstance then
            -- ZoneManagerInstance:drawZone()
        end
    end
end)
