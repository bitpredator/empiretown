fx_version("cerulean")
game("gta5")
lua54("yes")

author("wasabirobby rework by bitpredator")
description("Wasabi fork of fivem-appearance rework by bitpredator")
version("1.0.8")

files({
	"web/dist/index.html",
	"web/dist/assets/*.js",
	"locales/*.json",
	"files/*.json",
})

ui_page("web/dist/index.html")

client_scripts({
	"game/dist/index.js",
	"client/*.lua",
})

server_scripts({
	"@oxmysql/lib/MySQL.lua",
	"server/*.lua",
})

shared_scripts({
	"@ox_lib/init.lua",
	"configuration/*.lua",
})

dependencies({
	"es_extended",
	"oxmysql",
	"ox_lib",
})

provides({
	"skinchanger",
	"esx_skin",
})
