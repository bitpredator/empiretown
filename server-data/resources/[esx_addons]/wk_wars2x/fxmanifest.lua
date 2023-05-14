-- Define the FX Server version and game type
fx_version "cerulean"
game "gta5"

-- Define the resource metadata
name "Wraith ARS 2X"
description "Police radar and plate reader system for FiveM"
author "WolfKnight"
version "1.3.1"

-- Include the files
files {
	"nui/radar.html",
	"nui/radar.css",
	"nui/radar.js",
	"nui/images/*.png",
	"nui/images/plates/*.png",
	"nui/fonts/*.ttf",
	"nui/fonts/Segment7Standard.otf",
	"nui/sounds/*.ogg"
}

-- Set the NUI page
ui_page "nui/radar.html"

-- Run the server scripts
server_script "sv_exports.lua"
server_script "sv_sync.lua"
server_export "TogglePlateLock"

-- Run the client scripts
client_script "config.lua"
client_script "cl_utils.lua"
client_script "cl_player.lua"
client_script "cl_radar.lua"
client_script "cl_plate_reader.lua"
client_script "cl_sync.lua"