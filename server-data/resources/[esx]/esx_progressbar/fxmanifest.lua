fx_version("adamant")
game("gta5")
author("BPT-Framework")
lua54("yes")
description("BPT Progressbar")
version("1.0.0")

client_scripts({ "Progress.lua" })
shared_script("@es_extended/imports.lua")
ui_page("nui/index.html")

files({
	"nui/index.html",
	"nui/js/*.js",
	"nui/css/*.css",
})
