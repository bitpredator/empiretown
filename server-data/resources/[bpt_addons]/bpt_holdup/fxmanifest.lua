fx_version("adamant")

game("gta5")

description("ESX Holdup")

version("1.0.1")

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
