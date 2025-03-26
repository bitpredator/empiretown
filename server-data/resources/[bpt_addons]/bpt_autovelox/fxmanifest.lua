fx_version("bodacious")
game("gta5")
author("bitpredator")
version("1.0.0")
lua54 "yes"

description("Sistema Autovelox per FiveM con ESX")

server_scripts({
    "@es_extended/locale.lua",
    "server/main.lua",
})

client_scripts({
    "@es_extended/locale.lua",
    "client/main.lua",
})

dependency("es_extended")
