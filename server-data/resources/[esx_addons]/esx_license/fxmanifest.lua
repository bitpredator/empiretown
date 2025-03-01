fx_version("adamant")

game("gta5")

description("ESX License")
lua54("yes")
version("1.0.8")

server_scripts({
    "@es_extended/imports.lua",
    "@oxmysql/lib/MySQL.lua",
    "config.lua",
    "server/main.lua",
})
