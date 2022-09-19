fx_version 'adamant'

game 'gta5'

description 'ESX Accessories'

version '0.0.2'

shared_scripts {
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua'
}

server_scripts {
    'server/main.lua'
}

client_scripts {
    'client/main.lua'
}

dependencies {
    'es_extended',
    'esx_skin',
    'esx_datastore'
}
