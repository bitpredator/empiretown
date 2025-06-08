Config = {}

Config.Locale = "it" -- oppure 'en'

Config.RequiredItems = {
    Rod = "fishing_rod",
    Bait = "bait",
}

Config.FishList = {
    { name = "tuna", chance = 10 },
    { name = "salmon", chance = 15 },
    { name = "trout", chance = 25 },
    { name = "anchovy", chance = 30 },
    { name = "plastic_bag", chance = 20 },
}

Config.WaterZones = {
    ["low"] = 0.5,
    ["medium"] = 0.75,
    ["high"] = 1.0,
}

Config.FishingZones = {
    {
        coords = vector3(-1581.652710, 5201.644043, 3.971436),
        icon = "fa-solid fa-fish",
        name = "fishing_ocean",
    },
    {
        coords = vector3(-1587.956055, 5216.571289, 3.988281),
        icon = "fa-solid fa-water",
        name = "fishing_ocean",
    },
    {
        coords = vector3(1298.584595, 4215.692383, 33.896729),
        icon = "fa-solid fa-water",
        name = "fishing_lake",
    },
    {
        coords = vector3(-285.534058, 6627.336426, 7.139160),
        icon = "fa-solid fa-fish",
        name = "fishing_ocean",
    },
    {
        coords = vector3(33.191212, 855.560425, 197.727417),
        icon = "fa-solid fa-water",
        name = "fishing_lake",
    },
}
