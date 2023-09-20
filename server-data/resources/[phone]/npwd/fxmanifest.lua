fx_version("cerulean")
game("gta5")
description("js runtime monkaW")
authors({ "itschip", "erik-sn", "TasoOneAsia", "kidz", "RockySouthpaw", "SamShanks", "c-wide", "mojito" })
version("v1.7.4")
client_scripts({
	"dist/game/client/client.js",
	"dist/game/client/*.lua",
})

server_script({
	"dist/game/server/server.js",
})

ui_page("dist/html/index.html")

files({
	"config.json",
	"dist/html/index.html",
	"dist/html/**/*",
})

dependency({
	"screenshot-basic",
	"pma-voice",
})
