fx_version 'adamant'

game 'gta5'

description 'ESX Driving School Job - refactor by: bitpredator'

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
	'client/main.lua'
}

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/dmv.png',
	'html/styles.css',
	'html/questions.js',
	'html/scripts.js',
	'html/debounce.min.js'
}