fx_version 'cerulean'
game 'gta5'

author 'bitpredator'
description 'Anticheat per server FiveM basato su ESX'
version '1.0.0'

client_scripts {
    'client/*.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/*.lua',
}

shared_scripts {
    'config.lua'
}