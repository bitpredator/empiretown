fx_version("adamant")

game("gta5")

description("bpt_tridente criminal work for fivem esx server")
lua54("yes")
version("1.0.9")

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
