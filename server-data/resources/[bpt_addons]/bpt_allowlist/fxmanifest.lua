fx_version("adamant")

game("gta5")

author("bitpredator")
description("Allowlist system that allows you to only allow specific people to access your server")

version("1.0.2")

lua54("yes")
server_only("yes")

server_scripts({
    "@es_extended/imports.lua",
    "@es_extended/locale.lua",
    "config.lua",
    "locales/*.lua",
    "server/main.lua",
})
