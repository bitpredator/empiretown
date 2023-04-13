fx_version 'adamant'
game 'gta5'
description 'bpt_deliveries'
version '1.0'

client_scripts {
	'@es_extended/locale.lua',
	"locales/en.lua",
	"locales/fr.lua",
	"config.lua",
	"client/main.lua",
}

server_scripts {
	'@es_extended/locale.lua',
	"locales/en.lua",
	"locales/fr.lua",
	"config.lua",
	"server/main.lua",
}

dependency 'es_extended'