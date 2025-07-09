fx_version("cerulean")
game("gta5")

author("BPTNetwork")
description("Vanilla unicorn map for EmpireTownRP")
version("2.0.0")
this_is_a_map("yes")

files({
    "stream/*.yft",
    "stream/*.ydr",
    "stream/*.ytd",
    "stream/*.ymf",
})(
{ "stream/v_strip3_game.dat151.rel", "stream/v_strip3_mix.dat15.rel" })
data_file("AUDIO_GAMEDATA")("stream/v_strip3_game.dat")
data_file("AUDIO_DYNAMIXDATA")("stream/rel/v_strip3_mix.dat")
