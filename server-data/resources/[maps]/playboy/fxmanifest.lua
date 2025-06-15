fx_version("adamant")
game("gta5")

this_is_a_map("yes")

version("2.0.0")
description("Mappa MLO Playboy Mansion")
author("BPTNetwork")

files({
    "stream/**/*.ytyp",
    "stream/**/*.ydr",
    "stream/**/*.ymap",
    "stream/**/*.ybn",
    "stream/**/*.ymf",
    "*.xml",
})

data_file("DLC_ITYP_REQUEST")("stream/**/*.ytyp")
data_file("DLC_ITYP_REQUEST")("stream/**/*.ymf")

data_file("DLC_ITYP_REQUEST")("stream/**/*.ybn")
data_file("DLC_ITYP_REQUEST")("stream/**/*.ymap")
