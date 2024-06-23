fx_version("adamant")

game("gta5")

description("Adds Command for RP, such as: /me, /do, /OOC and more")
lua54("yes")

version("1.0.1")

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

dependency("es_extended")
