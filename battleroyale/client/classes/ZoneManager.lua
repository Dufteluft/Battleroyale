--[[

    ZoneManager Klasse (Client)

    Verwaltet die sichere Zone und den Schaden außerhalb der Zone.

]]

ZoneManager = {}
ZoneManager.__index = ZoneManager

-- Konstruktor
function ZoneManager:create(options)
    local instance = {}
    setmetatable(instance, ZoneManager)

    instance.center = options.center or vector3(0.0, 0.0, 72.0)
    instance.radius = options.radius or 5000.0
    instance.damage = 0
    instance.blip = nil
    instance.isInside = true

    Utils.Log('ZoneManager initialisiert.')
    instance:createBlip()
    instance:startZoneCheck()

    return instance
end

-- Erstellt den Blip für die Zone auf der Karte
function ZoneManager:createBlip()
    if self.blip then
        RemoveBlip(self.blip)
    end
    self.blip = AddBlipForRadius(self.center, self.radius)
    SetBlipColour(self.blip, 2)
    SetBlipAlpha(self.blip, 128)
    SetBlipAsShortRange(self.blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Sichere Zone")
    EndTextCommandSetBlipName(self.blip)
end

-- Aktualisiert die Zone mit neuen Daten
function ZoneManager:updateZone(data)
    self.radius = data.radius
    self.damage = data.damage
    self.center = data.center or self.center -- Zentrum kann sich optional ändern

    self:createBlip()
    Utils.Log('Zone aktualisiert: Radius ' .. self.radius .. 'm, Schaden ' .. self.damage)
end

-- Startet die Überprüfung, ob der Spieler in der Zone ist
function ZoneManager:startZoneCheck()
    CreateThread(function()
        while true do
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = Utils.GetDistance(playerCoords, self.center)

            if distance > self.radius then
                if self.isInside then
                    self.isInside = false
                    UIManagerInstance:showNotification("Du verlässt die sichere Zone!")
                end
                ApplyDamageToPed(playerPed, self.damage, true)
            else
                if not self.isInside then
                    self.isInside = true
                    UIManagerInstance:showNotification("Du bist wieder in der sicheren Zone.")
                end
            end

            Wait(1000)
        end
    end)
end

-- Zeichnet die Zone in der 3D-Welt (optional, für Debugging)
function ZoneManager:drawZone()
    DrawMarker(
        1, -- markerType
        self.center.x, self.center.y, self.center.z - 100.0, -- pos
        0.0, 0.0, 0.0, -- dir
        0.0, 0.0, 0.0, -- rot
        self.radius * 2.0, self.radius * 2.0, 200.0, -- scale
        0, 0, 255, 50, -- color
        false, -- bobUpAndDown
        true, -- faceCamera
        2, -- p19
        false, -- rotate
        nil, nil, -- textureDict, textureName
        false -- drawOnEnts
    )
end
