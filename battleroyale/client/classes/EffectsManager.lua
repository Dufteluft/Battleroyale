--[[

    EffectsManager Klasse (Client)

    Verwaltet visuelle und Audio-Effekte.

]]

EffectsManager = {}
EffectsManager.__index = EffectsManager

-- Konstruktor
function EffectsManager:create()
    local instance = {}
    setmetatable(instance, EffectsManager)

    Utils.Log('EffectsManager initialisiert.')

    return instance
end

-- Spielt einen Effekt ab
function EffectsManager:playEffect(effectName, duration)
    if effectName == 'heal' then
        self:playHealEffect()
    elseif effectName == 'armor' then
        self:playArmorEffect()
    elseif effectName == 'speedboost' then
        self:playSpeedBoostEffect(duration or 5.0)
    elseif effectName == 'damage' then
        self:playDamageEffect()
    end
end

-- Heilungs-Effekt
function EffectsManager:playHealEffect()
    -- Grüner Bildschirm-Flash
    StartScreenEffect("Heal", 500, false)
    PlaySoundFrontend(-1, "HEAL", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

-- Rüstungs-Effekt
function EffectsManager:playArmorEffect()
    -- Blauer Bildschirm-Flash
    StartScreenEffect("MenuMGHeal", 500, false)
    PlaySoundFrontend(-1, "ARMOUR_GRAB", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

-- Geschwindigkeits-Boost-Effekt
function EffectsManager:playSpeedBoostEffect(duration)
    local player = PlayerId()
    SetRunSprintMultiplierForPlayer(player, 1.49)
    StartScreenEffect("RaceTurbo", duration * 1000, false)

    CreateThread(function()
        Wait(duration * 1000)
        SetRunSprintMultiplierForPlayer(player, 1.0)
    end)
end

-- Schaden-Indikator
function EffectsManager:playDamageEffect()
    -- Roter Bildschirm-Flash
    StartScreenEffect("DeathFailOut", 300, false)
end

-- Export-Funktionen
exports('StartSpeedBoostEffect', function(duration)
    if not EffectsManagerInstance then EffectsManagerInstance = EffectsManager:create() end
    EffectsManagerInstance:playSpeedBoostEffect(duration)
end)

exports('EquipArmorEffect', function(armorAmount)
    if not EffectsManagerInstance then EffectsManagerInstance = EffectsManager:create() end
    EffectsManagerInstance:playArmorEffect()
    -- Die Rüstungsmenge wird hier nicht direkt verwendet, könnte aber für
    -- komplexere Effekte nützlich sein.
end)
