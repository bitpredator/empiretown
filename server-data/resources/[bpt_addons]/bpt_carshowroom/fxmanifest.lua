fx_version("adamant")
game("gta5")

description("esx_carshowroom")
lua54("yes")
version("1.0.2")

shared_script("@es_extended/imports.lua")

client_scripts({
    "@es_extended/locale.lua",
    "locales/*.lua",
    "config.lua",
    "client/main.lua",
})
