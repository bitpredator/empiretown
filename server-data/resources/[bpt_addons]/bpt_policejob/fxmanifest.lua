fx_version("adamant")

game("gta5")

description("Allows Players to RP as Police Officers (cars, outfits, handcuffing etc)")
lua54("yes")
version("2.0.0")

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

dependencies({
    "es_extended",
    "esx_billing",
    "esx_vehicleshop",
})
