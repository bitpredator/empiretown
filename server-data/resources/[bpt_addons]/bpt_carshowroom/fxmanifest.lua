fx_version("adamant")
game("gta5")

description("bpt_carshowroom")
lua54("yes")
version("2.0.0")

shared_script("@es_extended/imports.lua")

client_scripts({
    "@es_extended/locale.lua",
    "locales/*.lua",
    "config.lua",
    "client/*.lua",
})
