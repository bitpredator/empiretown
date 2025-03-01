fx_version("adamant")

game("gta5")

description("Adds a Hunger & Thrist system")
lua54("yes")
version("1.0.8")

shared_script("@es_extended/imports.lua")

server_scripts({
    "@es_extended/locale.lua",
    "locales/*.lua",
    "config.lua",
    "server/main.lua",
})

client_scripts({
    "@es_extended/locale.lua",
    "locales/*.lua",
    "config.lua",
    "client/main.lua",
})

dependencies({
    "es_extended",
    "bpt_status",
})
