fx_version("cerulean")
game("gta5")

description("Sistema di riciclaggio denaro - ESX + oxmysql + ox_target")

shared_script({
    "@es_extended/imports.lua",
    "@es_extended/locale.lua",
    "config.lua",
})

client_script({
    "client/*.lua",
    "config.lua",
})

server_script({
    "@oxmysql/lib/MySQL.lua",
    "server/*.lua",
})

lua54("yes")
