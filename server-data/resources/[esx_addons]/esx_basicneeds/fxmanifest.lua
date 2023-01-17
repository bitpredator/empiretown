fx_version 'adamant'

game 'gta5'

description 'ESX Basic Needs'

version '0.0.4'

server_scripts {
    '@es_extended/locale.lua',
    'config.lua',
    'server/main.lua'
}

client_scripts {
    '@es_extended/locale.lua',
    'config.lua',
    'client/main.lua'
}

dependencies {
    'es_extended',
    'esx_status'
}
