fx_version 'adamant'

game 'gta5'

author 'ESX-Framework'
description 'An Allow-list system for ESX that lets you only allow specific people join your server.'

version '1.0.1'

lua54 'yes'
server_only 'yes'

server_scripts {
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'config.lua',
	'locales/*.lua',
	'server/main.lua'
}
