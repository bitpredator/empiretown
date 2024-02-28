fx_version("adamant")

game("gta5")
author("bitpredator")
description("bitpredator HUD")
version("1.0.1")

ui_page("html/ui.html")

shared_script("@es_extended/imports.lua")

files({
	"html/*.css",
	"html/*.js",
	"html/*.png",
	"html/ui.html",
})

client_scripts({
	"client/*.lua",
	"config.lua",
})
