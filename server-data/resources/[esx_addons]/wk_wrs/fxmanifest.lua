fx_version 'adamant'
game 'gta5'
description 'police radar'
version '0.0.4'

ui_page 'nui/radar.html'

files {
	'nui/digital-7.regular.ttf', 
	'nui/radar.html',
	'nui/radar.css',
	'nui/radar.j'
}

client_script {
  'cl_radar.lua'
}