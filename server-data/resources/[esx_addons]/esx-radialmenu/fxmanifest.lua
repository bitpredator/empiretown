fx_version 'cerulean'
game 'gta5'
lua54 'yes'
description 'esx-radialmenu'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
    '@es_extended/imports.lua',    
    'config.lua',
}

client_scripts {
    'locales/*.lua',
    'client/main.lua',
    'client/clothing.lua',
    'client/trunk.lua',
    'client/stretcher.lua'
}

server_scripts {
    'locales/*.lua',
    'server/trunk.lua',
    'server/stretcher.lua'
}

files {
    'html/index.html',
    'html/css/main.css',
    'html/js/main.js',
    'html/js/RadialMenu.js',
}

