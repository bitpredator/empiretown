fx_version("adamant")

game("gta5")

description("bpt_streetfight")

version("1.0.8")

server_script({
	"@es_extended/locale.lua",
	"server/server.lua",
	"locales/*.lua",
	"config.lua",
})

client_script({
	"@es_extended/locale.lua",
	"client/client.lua",
	"locales/*.lua",
	"config.lua",
})

dependencies({
	"es_extended",
})
