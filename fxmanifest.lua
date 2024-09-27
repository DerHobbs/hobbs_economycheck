fx_version 'cerulean'
game 'gta5'

author 'Derhobbs'
description 'Richest Players Command'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

ui_page 'nui/richest_players.html'

files {
    'nui/richest_players.html',
    'nui/config.json'
}