fx_version("adamant")

game("gta5")

description("bpt_ammunation job RP server")
lua54("yes")
version("2.0.0")

shared_script({
    "@es_extended/imports.lua",
    "@es_extended/locale.lua",
    "config.lua",
    "locales/*.lua",
})

server_scripts({
    "@oxmysql/lib/MySQL.lua",
    "server/*.lua",
})

client_scripts({
    "client/*.lua",
})
