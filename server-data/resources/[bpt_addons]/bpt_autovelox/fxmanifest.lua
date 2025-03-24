fx_version("bodacious")
game("gta5")
author("bitpredator")

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
