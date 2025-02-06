fx_version("cerulean")
game("gta5")
lua54("yes")
author("map-scripts rework by: bitpredator")
version("1.0.8")

shared_scripts({
    "@es_extended/imports.lua",
    "@ox_lib/init.lua",
    "config.lua",
})

client_scripts({
	"@es_extended/locale.lua",
    "client/*.lua",
	"locales/*.lua",
})

server_scripts({
	"@es_extended/locale.lua",
    "server/*.lua",
	"locales/*.lua",
})
