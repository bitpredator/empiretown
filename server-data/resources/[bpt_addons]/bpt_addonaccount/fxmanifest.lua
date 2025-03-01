fx_version("adamant")
game("gta5")

author("bitpredator")
description("Allows resources to store account data, such as society funds")
lua54("yes")
version("1.0.8")

server_scripts({
    "@es_extended/imports.lua",
    "@oxmysql/lib/MySQL.lua",
    "server/classes/addonaccount.lua",
    "server/main.lua",
})

server_exports({
    "GetSharedAccount",
    "AddSharedAccount",
})

dependency("es_extended")
