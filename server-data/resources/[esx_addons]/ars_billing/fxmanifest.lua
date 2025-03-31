fx_version("cerulean")
use_fxv2_oal("yes")
lua54("yes")
game("gta5")
version("1.0.8")

name("ars_billing")
author("Arius Development")
description("A simple script for realistic billing")

client_scripts({
    "client/*.lua",
    "client/functions/*.lua",
})

server_scripts({
    "server/*.lua",
})

shared_scripts({
    "@ox_lib/init.lua",
    "config.lua",
})
