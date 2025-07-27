fx_version 'cerulean'
game 'gta5'

author 'Jules, The AI Software Engineer'
description 'Battle Royale System für FiveM'
version '2.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
    'shared/utils.lua',
    'shared/events.lua'
}

server_scripts {
    'server/init.lua',
    'server/main.lua',
    'server/commands.lua',
    'server/classes/*.lua',
    'server/events/*.lua'
}

client_scripts {
    'client/main.lua',
    'client/loot_system.lua',
    'client/classes/*.lua',
    'client/events/*.lua'
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
