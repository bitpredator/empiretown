fx_version 'adamant'
games { 'gta5' }

author 'Bob code reconstruction by: bitpredator'
description 'Bobs Hunting'
version '0.0.4'

shared_script '@es_extended/imports.lua'

client_scripts {
    '@es_extended/locale.lua',
    'client/functions.lua',
    'locales/*.lua',
    'config.lua',
    'client/main.lua'
}

server_scripts {
    '@es_extended/locale.lua',
    'locales/*.lua',
    'config.lua',
    'server/main.lua'
}