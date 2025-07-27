--[[

    Inventory Event Handler (Client)

    Behandelt inventarbezogene Events auf dem Client.

]]

-- Dieser Handler fängt das Benutzen eines Items aus ox_inventory ab
-- und leitet es an den Server weiter, wenn es ein BR-relevantes Item ist.
RegisterNetEvent('ox_inventory:useItem', function(item)
    local relevantItems = { 'bandage', 'medkit', 'armor' }

    for _, relevantItem in ipairs(relevantItems) do
        if item.name == relevantItem then
            -- Verhindere die Standard-Aktion von ox_inventory
            -- (Dies ist ein konzeptioneller Ansatz, die genaue Implementierung
            -- kann von der ox_inventory Version abhängen)
            -- Callback(false)

            -- Sende das Event an den Server
            TriggerServerEvent('battleroyale:useItem', item.name)
            return
        end
    end
end)
