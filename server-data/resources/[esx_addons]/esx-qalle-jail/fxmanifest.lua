fx_version 'adamant'
game 'gta5'
author 'qalle-git; refactor bitpredator'
lua54 'yes'
version '0.0.4'
description "Jail Script With Working Job"

shared_script '@es_extended/imports.lua'

server_scripts {
	'@es_extended/locale.lua',
	"@mysql-async/lib/MySQL.lua",
	"config.lua",
	'locales/*.lua',
	"server/server.lua"
}

client_scripts {
	'@es_extended/locale.lua',
	"config.lua",
	"client/utils.lua",
	'locales/*.lua',
	"client/client.lua"
}