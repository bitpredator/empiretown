fx_version("adamant")

game("gta5")

description("Used for storing Data, such as society inventories")

version("1.0.1")

lua54("yes")

server_scripts({
	"@es_extended/imports.lua",
	"@oxmysql/lib/MySQL.lua",
	"server/classes/datastore.lua",
	"server/main.lua",
})
