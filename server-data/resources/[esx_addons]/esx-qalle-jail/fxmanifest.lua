fx_version 'adamant'
game 'gta5'
author 'qalle-git; refactor bitpredator'
lua54 'yes'
version '0.0.4'
description "Jail Script With Working Job"
shared_script '@es_extended/imports.lua'

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	"config.lua",
	"server/server.lua"
}

client_scripts {
	"config.lua",
	"client/utils.lua",
	"client/client.lua"
}