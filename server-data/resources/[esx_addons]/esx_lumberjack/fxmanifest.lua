fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'map-scripts'
version '1.0.2'

shared_scripts {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua',
	'config.lua',
}

client_scripts {
	'client/utils.lua',
	'client/main.lua',
}

server_scripts {
	'server/main.lua',
}
