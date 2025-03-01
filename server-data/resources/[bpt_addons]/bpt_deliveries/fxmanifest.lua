fx_version("adamant")
game("gta5")
description("bpt_deliveries")
version("1.0.8")

client_scripts({
    "@es_extended/locale.lua",
    "locales/*.lua",
    "config.lua",
    "client/*.lua",
})

server_scripts({
    "@es_extended/locale.lua",
    "locales/*.lua",
    "config.lua",
    "server/*.lua",
})

dependency("es_extended")
