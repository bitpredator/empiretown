fx_version("adamant")

game("gta5")

description("Allows players to RP as a mechanic (repair and modify vehicles)")
lua54("yes")
version("1.0.9")

shared_script("@es_extended/imports.lua")

client_scripts({
    "@es_extended/locale.lua",
    "config.lua",
    "client/main.lua",
    "locales/*.lua"
})

server_scripts({
    "@es_extended/locale.lua",
    "config.lua",
    "server/main.lua",
    "locales/*.lua"
})

dependencies({
    "es_extended",
    "bpt_society",
})
