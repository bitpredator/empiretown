Config = {}

-- Lingua (it / en)
Config.Locale = "it"

-- Zone di pesca
Config.FishingZones = {
    { coords = vec3(-3306.975830, 1014.184631, -0.021973), radius = 5.0, name = "Spiaggia" },
    { coords = vec3(-3307.147217, 1035.283569, 0.315063), radius = 5.0, name = "Spiaggia" },
    { coords = vec3(-3292.984619, 1113.402222, 0.736328), radius = 5.0, name = "Spiaggia" },
    { coords = vec3(1327.265991, 4283.182617, 30.459351), radius = 5.0, name = "Alamo Sea" },
}

-- Lista pesci con probabilità
Config.FishTypes = {
    { item = "anchovy", label = "Acciuga", chance = 30 },
    { item = "trout", label = "Trota", chance = 25 },
    { item = "salmon", label = "Salmone", chance = 20 },
    { item = "tuna", label = "Tonno", chance = 15 },
    { item = "plastic_bag", label = "Sacchetto di plastica", chance = 10 },
}

-- Item richiesti
Config.BaitItem = "bait"
Config.RodItem = "fishing_rod"

-- Tempo minimo/massimo di attesa in ms
Config.MinWait = 5000
Config.MaxWait = 10000

-- Moltiplicatori probabilità per profondità
Config.DepthChances = {
    { depth = 0.5, multiplier = 0.5 },
    { depth = 2.0, multiplier = 1.0 },
    { depth = 10.0, multiplier = 1.5 },
}
