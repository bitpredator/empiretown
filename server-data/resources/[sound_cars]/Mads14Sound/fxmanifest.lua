fx_version("adamant")
game("gta5")

files({
    "audioconfig/*.dat151.rel",
    "audioconfig/*.dat54.rel",
    "audioconfig/*.dat10.rel",
    "sfx/**/*.awc",
})

data_file("AUDIO_SYNTHDATA")("audioconfig/kc28sr180_amp.dat")
data_file("AUDIO_GAMEDATA")("audioconfig/kc28sr180_game.dat")
data_file("AUDIO_SOUNDDATA")("audioconfig/kc28sr180_sounds.dat")
data_file("AUDIO_WAVEPACK")("sfx/dlc_kc28sr180")
