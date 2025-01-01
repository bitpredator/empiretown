fx_version("adamant")

game("gta5")

description("bpt_ammunation job RP server")
lua54("yes")
version("1.0.7")

shared_script("@es_extended/imports.lua")

server_scripts({
    "@oxmysql/lib/MySQL.lua",
    "@es_extended/locale.lua",
    "locales/*.lua",
    "config.lua",
    "server/*.lua",
})

client_scripts({
    "@es_extended/locale.lua",
    "locales/*.lua",
    "config.lua",
    "client/*.lua",
})
