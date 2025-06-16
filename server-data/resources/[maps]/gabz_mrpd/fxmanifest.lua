fx_version("adamant")
game("gta5")

this_is_a_map("yes")

version("2.0.0")
description("MLO Police Map")
author("BPTNetwork")

files({
    "stream/**/*.ytyp",
    "stream/**/*.ydr",
    "stream/**/*.ymap",
    "stream/**/*.ybn",
    "stream/**/*.ymf",
    "gabz_mrpd_timecycle.xml",
    "interiorproxies.meta",
    "interiorproxies.meta",
})

data_file("TIMECYCLEMOD_FILE")("gabz_mrpd_timecycle.xml")
data_file("INTERIOR_PROXY_ORDER_FILE")("interiorproxies.meta")

client_script({
    "gabz_mrpd_entitysets.lua",
})
