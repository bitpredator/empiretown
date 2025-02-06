fx_version("adamant")
games({ "gta5" })

author("bitpredator")
description("bpt_hunting")
version("1.0.8")

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
    "server/*.lua",
})
