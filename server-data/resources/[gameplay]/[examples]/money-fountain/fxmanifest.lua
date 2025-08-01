-- This resource is part of the default Cfx.re asset pack (cfx-server-data)
-- Altering or recreating for local use only is strongly discouraged.

version("2.0.0")
description("An example money system client containing a money fountain.")
repository("https://github.com/citizenfx/cfx-server-data")
author("Cfx.re <root@cfx.re>")

fx_version("bodacious")
game("gta5")

client_script("client.lua")
server_script("server.lua")

shared_script("mapdata.lua")

dependencies({
    "mapmanager",
    "money",
})

lua54("yes")
