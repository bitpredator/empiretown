fx_version 'adamant'

game 'gta5'

description 'ESX Ambulance Job'

version '0.0.2'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'client/main.lua',
	'client/job.lua',
	'client/vehicle.lua',
}

shared_script '@es_extended/imports.lua'

dependencies {
	'es_extended',
	'esx_skin'
}
server_scripts { '@mysql-async/lib/MySQL.lua' }server_scripts { '@mysql-async/lib/MySQL.lua' }server_scripts { '@mysql-async/lib/MySQL.lua' }server_scripts { '@mysql-async/lib/MySQL.lua' }