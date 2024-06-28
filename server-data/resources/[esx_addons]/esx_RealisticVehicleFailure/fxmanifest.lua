fx_version("adamant")
game("gta5")

description("esx_realisticvehicle")
lua54("yes")
version("1.0.1")

shared_script("@es_extended/imports.lua")

client_scripts({
    "config.lua",
    "client.lua",
})

server_scripts({
    "config.lua",
})
