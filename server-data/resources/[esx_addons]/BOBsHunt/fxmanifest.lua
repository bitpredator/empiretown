fx_version("adamant")
games({ "gta5" })

author("Bob code reconstruction by: bitpredator")
description("Bobs Hunting")
version("1.0.0")

shared_script("@es_extended/imports.lua")

client_scripts({
    "@es_extended/locale.lua",
    "client/*.lua",
    "locales/*.lua",
    "config.lua",
})

server_scripts({
    "@es_extended/locale.lua",
    "locales/*.lua",
    "config.lua",
    "server/main.lua",
})
