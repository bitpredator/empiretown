fx_version 'adamant'
games { 'gta5' }

version '0.0.4'

client_scripts {
	'client/jaymenu.lua',
	'config.lua',
	'@es_extended/locale.lua',
	'client/client.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'server/server.lua'
}

file 'AllTattoos.json'