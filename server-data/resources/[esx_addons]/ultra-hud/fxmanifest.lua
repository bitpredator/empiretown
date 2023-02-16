fx_version 'adamant'

game 'gta5'

description 'bitpredator HUD UI'
version '0.0.4'

ui_page 'html/ui.html'
files {
	'html/style.css',
	'html/style.js',
	'html/*.png',
	'html/ui.html'
}


client_scripts {
    'cl.lua',
	'client/carhud.lua' 
}
