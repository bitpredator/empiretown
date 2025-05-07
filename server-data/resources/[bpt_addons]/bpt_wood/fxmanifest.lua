fx_version("cerulean")
game("gta5")
lua54("yes")

description("Lavoro libero raccolta legna con ox_target")

client_scripts({
    "client/*.lua",
})

server_scripts({
    "server/*.lua",
})

shared_script("@ox_lib/init.lua")

dependency("ox_target")
