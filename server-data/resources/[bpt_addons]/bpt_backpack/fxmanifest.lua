fx_version("cerulean")
game("gta5")
lua54("yes")

description("bpt_backpack for Ox Inventory")
version("2.0.0")

client_scripts({
    "client/**.lua",
})

server_scripts({
    "server/**.lua",
})

shared_scripts({
    "@ox_lib/init.lua",
    "config.lua",
})

dependencies({
    "ox_inventory",
})
