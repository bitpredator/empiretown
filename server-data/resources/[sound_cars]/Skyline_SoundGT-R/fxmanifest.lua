fx_version("adamant")
game("gta5")

files({
    "audioconfig/*.dat151.rel",
    "audioconfig/*.dat54.rel",
    "audioconfig/*.dat10.rel",
    "sfx/**/*.awc",
})

data_file("AUDIO_SYNTHDATA")("audioconfig/kc46nisr34ztune_amp.dat")
data_file("AUDIO_GAMEDATA")("audioconfig/kc46nisr34ztune_game.dat")
data_file("AUDIO_SOUNDDATA")("audioconfig/kc46nisr34ztune_sounds.dat")
data_file("AUDIO_WAVEPACK")("sfx/dlc_kc46nisr34ztune")
