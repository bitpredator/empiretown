fx_version("adamant")

game("gta5")

files({
    "audioconfig/ktm1290r_game.dat151.rel",
    "audioconfig/ktm1290r_sounds.dat54.rel",
    "sfx/dlc_ktm1290r/ktm1290r.awc",
    "sfx/dlc_ktm1290r/ktm1290r_npc.awc",
})

data_file("AUDIO_GAMEDATA")("audioconfig/ktm1290r_game.dat")
data_file("AUDIO_SOUNDDATA")("audioconfig/ktm1290r_sounds.dat")
data_file("AUDIO_WAVEPACK")("sfx/dlc_ktm1290r")
