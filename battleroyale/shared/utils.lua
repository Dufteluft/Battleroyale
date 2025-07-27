--[[

    Utility-Funktionen für das Battle Royale System

]]

Utils = {}

-- Gibt eine zufällige Zahl zwischen min and max zurück
function Utils.Random(min, max)
    return math.random(min, max)
end

-- Berechnet die Distanz zwischen zwei Vektoren
function Utils.GetDistance(vec1, vec2)
    return #(vec1 - vec2)
end

-- Schreibt eine Log-Nachricht in die Konsole
function Utils.Log(message)
    print('[BattleRoyale] ' .. message)
end

-- Konvertiert einen String zu JSON
function Utils.ToJson(data)
    return json.encode(data)
end

-- Konvertiert JSON zu einem String
function Utils.FromJson(jsonString)
    return json.decode(jsonString)
end

-- Überprüft, ob ein Spieler ein Admin ist
function Utils.IsAdmin(source)
    -- Hier sollte eine Überprüfung der Admin-Rechte stattfinden
    -- z.B. über eine Whitelist oder ein Rechtesystem
    return true -- Platzhalter
end
