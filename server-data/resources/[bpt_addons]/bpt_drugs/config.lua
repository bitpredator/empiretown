Config = {}

Config.Locale = GetConvar("esx:locale", "it")

Config.DrugDealerItems = {
    marijuana = 91,
}

Config.GiveBlack = true -- give black money? if disabled it'll give regular cash.

Config.CircleZones = {
    WeedField = { coords = vector3(2220.72, 5582.52, 53.81), name = TranslateCap("blip_weedfield"), color = 25, radius = 100.0 },
    DrugDealer = { coords = vector3(-1172.02, -1571.98, 4.66), name = TranslateCap("blip_drugdealer"), color = 6, sprite = 378 },
}

Config.Marker = {
    Distance = 100.0,
    Color = { r = 60, g = 230, b = 60, a = 255 },
    Size = vector3(1.5, 1.5, 1.0),
    Type = 1,
}

-- min amount of Config.DrugDealerItems to sell
-- max amount of Config.DrugDealerItems to sell
Config.SellMenu = {
    Min = 1,
    Max = 100,
}
