fx_version("adamant")

game("gta5")

description("Allows players to RP as a mechanic (repair and modify vehicles)")
lua54("yes")
version("1.0.8")

shared_script("@es_extended/imports.lua")

client_scripts({
    "@es_extended/locale.lua",
    "locales/*.lua",
    "config.lua",
    "client/main.lua",
})

server_scripts({
    "@es_extended/locale.lua",
    "locales/*.lua",
    "config.lua",
    "server/main.lua",
})

dependencies({
    "es_extended",
    "bpt_society",
    "bpt_billing",
})
