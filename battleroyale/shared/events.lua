--[[

    Event-Definitionen für das Battle Royale System

]]

-- Server Events
RegisterNetEvent('battleroyale:playerKilled')
RegisterNetEvent('battleroyale:pickupLoot')
RegisterNetEvent('battleroyale:useItem')
RegisterNetEvent('battleroyale:anticheat')
RegisterNetEvent('battleroyale:requestJoin')
RegisterNetEvent('battleroyale:requestLeave')
RegisterNetEvent('battleroyale:syncStats')
RegisterNetEvent('battleroyale:adminCommand')

-- Client Events
RegisterNetEvent('battleroyale:gameStarted')
RegisterNetEvent('battleroyale:gameEnded')
RegisterNetEvent('battleroyale:zoneShrinking')
RegisterNetEvent('battleroyale:enterSpectator')
RegisterNetEvent('battleroyale:updateUI')
RegisterNetEvent('battleroyale:showNotification')
RegisterNetEvent('battleroyale:playEffect')
RegisterNetEvent('battleroyale:updateKillFeed')
