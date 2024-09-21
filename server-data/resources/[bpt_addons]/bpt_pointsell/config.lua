Config = {}

Config.Locale = GetConvar("esx:locale", "it")

Config.DealerItems = {
    emerald = 50,
    diamond = 150,
}

Config.GiveBlack = true -- give black money? if disabled it'll give regular cash.

Config.CircleZones = {
    Dealer = { coords = vector3(-429.257141, -1728.778076, 19.776611), name = TranslateCap("dealer"), color = 6, sprite = 378 },
}

Config.Marker = {
    Distance = 100.0,
    Color = { r = 60, g = 230, b = 60, a = 255 },
    Size = vector3(1.5, 1.5, 1.0),
    Type = 1,
}

-- min amount of Config.DealerItems to sell
-- max amount of Config.DealerItems to sell
Config.SellMenu = {
    Min = 1,
    Max = 50,
}
