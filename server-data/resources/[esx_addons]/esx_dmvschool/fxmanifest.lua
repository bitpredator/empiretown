fx_version 'adamant'

game 'gta5'

description 'ESX DMV School'

version '0.0.3'

shared_script '@es_extended/imports.lua'

server_scripts {
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
	'html/ui_it.html',
	'html/logo.png',
	'html/dmv.png',
	'html/styles.css',
	'html/questions_it.js',
	'html/scripts.js',
	'html/debounce.min.js'
}

dependencies {
	'es_extended',
	'esx_license'
}
