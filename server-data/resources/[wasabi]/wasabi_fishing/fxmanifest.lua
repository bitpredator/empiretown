fx_version("cerulean")
game("gta5")
lua54("yes")

version("2.0.7")
author("wasabirobby")
description("Wasabi ESX/QBCore Skill Based Fishing")

shared_scripts({ "@ox_lib/init.lua", "configuration/*.lua" })

client_scripts({ "bridge/**/client.lua", "client/*.lua" })

server_scripts({ "bridge/**/server.lua", "server/*.lua" })

dependencies({ "ox_lib" })
