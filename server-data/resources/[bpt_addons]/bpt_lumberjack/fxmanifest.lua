fx_version("cerulean")
game("gta5")
lua54("yes")
author("bitpredator")
version("1.0.1")

server_scripts({
	"@oxmysql/lib/MySQL.lua",
	"@es_extended/locale.lua",
	"locales/*.lua",
	"config.lua",
	"server/*.lua",
})

client_scripts({
	"@es_extended/locale.lua",
	"locales/*.lua",
	"config.lua",
	"client/*.lua",
})

dependencies({
	"es_extended",
})
