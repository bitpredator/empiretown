fx_version 'cerulean'
game 'gta5'

lua54 'yes'

description 'ESX Framework Slot Machines'
version '1.0.1'

ui_page 'html/ui.html'

shared_scripts {
    '@es_extended/imports.lua', -- Necessario per ESX
    '@es_extended/locale.lua',  -- Necessario per ESX
    'config.lua'                -- Configurazione
}

client_scripts {
    'locales/*.lua',            -- File di localizzazione
    'client.lua'                -- Script client
}

server_scripts {
    'locales/*.lua',            -- File di localizzazione
    '@oxmysql/lib/MySQL.lua',    -- Se usi OXMySQL
    'server.lua'                -- Script server
}

files {
    'html/ui.html',
    'html/*.js',
    'html/*.json',
    'html/design.css',
    'html/img/*.png',
    'html/audio/*.mp3'
}

dependencies {
    'es_extended'
}

escrow_ignore {
    'locales/*.lua',
    'config.lua'
}
