fx_version("adamant")
game("gta5")

description("bpt_RealisticVehicle")
lua54("yes")
version("1.0.8")

shared_script("@es_extended/imports.lua")

client_scripts({
    "client/*.lua",
    "config.lua",
})

server_scripts({
    "config.lua",
})
