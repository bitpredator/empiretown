fx_version("bodacious")
game("gta5")

description("vSyncRevamped")
version("1.0.1")

server_scripts({
    "config.lua",
    "locale.lua",
    "locales/*.lua",
    "server/*.lua",
})

client_scripts({
    "config.lua",
    "locale.lua",
    "locales/*.lua",
    "client/*.lua",
})
