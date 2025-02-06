fx_version("cerulean")
game("gta5")
author("bitpredator")
description("bpt_teleport")
version("1.0.8")

shared_script("@es_extended/imports.lua")

client_scripts({
	"@es_extended/locale.lua",
	"locales/*.lua",
	"config.lua",
	"warehouses.lua",
})

server_scripts({
	"@es_extended/locale.lua",
	"locales/*.lua",
	"config.lua",
})
