Config = {}

-- Punti di raccolta legna
Config.WoodSpots = {
    { coords = vec3(-534.7, 5373.6, 70.5) }, -- foresta Paleto
    { coords = vec3(-527.578003, 5369.604492, 70.662964) }, -- foresta Paleto
}

-- Item che ricevi
Config.WoodItem = "wood"
Config.WoodAmount = { 1, 3 } -- range min/max legna per raccolta

-- Item richiesto (ascia) + durabilità massima
Config.AxeItem = "axe"
Config.AxeMaxUses = 100

-- Modelli prop dell’ascia da usare in mano
Config.AxeModels = { `prop_ld_fireaxe`, `w_me_hatchet` }

-- Durata raccolta (ms)
Config.ChopDuration = 5000

-- Blip
Config.Blip = {
    sprite = 1,
    color = 25,
    scale = 0.9,
    label = "Taglio Legna",
}
