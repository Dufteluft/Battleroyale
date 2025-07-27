fx_version 'cerulean'
game 'gta5'

author 'Jules, The AI Software Engineer'
description 'Battle Royale System für FiveM'
version '2.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
    'shared/utils.lua'
}

server_scripts {
    'server/classes/GameManager.lua',
    'server/classes/InventoryManager.lua',
    'server/classes/LootManager.lua',
    'server/classes/AntiCheatManager.lua',
    'server/events/game_events.lua',
    'server/events/inventory_events.lua',
    'server/events/loot_events.lua',
    'server/main.lua',
    'server/commands.lua',
    'server/init.lua'
}

client_scripts {
    'client/classes/UIManager.lua',
    'client/classes/ZoneManager.lua',
    'client/classes/EffectsManager.lua',
    'client/events/game_events.lua',
    'client/events/zone_events.lua',
    'client/events/inventory_events.lua',
    'client/loot_system.lua',
    'client/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

lua54 'yes'

dependencies {
    'es_extended',
    'ox_inventory',
    'oxmysql'
}
