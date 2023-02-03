fx_version 'adamant'
game 'gta5'
description 'ESX UteKnark by DemmyDemon'
version '0.0.4'

shared_scripts {
    '@es_extended/locale.lua',
    'locales/*.lua',
    'config.lua',
    'lib/octree.lua',
    'lib/growth.lua',
    'lib/cropstate.lua',
}
client_scripts {
    'lib/debug.lua',
    'cl_uteknark.lua',
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'sv_uteknark.lua',
}

dependencies {
    'es_extended',
    'oxmysql'
}
