fx_version("adamant")
game("gta5")

this_is_a_map("yes")

version("2.0.0")
description("Mappa MLO Ajaxon Burton LSC")
author("BPTNetwork")

files({
    "stream/**/*.ytyp",
    "stream/**/*.ydr",
    "stream/**/*.ymap",
    "stream/**/*.ybn",
    "stream/**/*.ymf",
    "interiorproxies.meta",
})

data_file("INTERIOR_PROXY_ORDER_FILE")("interiorproxies.meta")
