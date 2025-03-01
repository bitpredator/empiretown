fx_version("adamant")

game("gta5")
author("bitpredator")
lua54("yes")
version("1.0.8")
description("Progressbar")

client_scripts({ "Progress.lua" })
shared_script("@es_extended/imports.lua")
ui_page("nui/index.html")

files({
	"nui/index.html",
	"nui/js/*.js",
	"nui/css/*.css",
})
