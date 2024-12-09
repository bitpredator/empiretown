Config = {}
Config.Locale = GetConvar("esx:locale", "it")

Config.DrawDistance = 10.0

Config.Markers = {
    EntryPoint = {
        Type = 21,
        Size = {
            x = 1.0,
            y = 1.0,
            z = 0.5,
        },
        Color = {
            r = 50,
            g = 200,
            b = 50,
        },
    },
    GetOutPoint = {
        Type = 21,
        Size = {
            x = 1.0,
            y = 1.0,
            z = 0.5,
        },
        Color = {
            r = 200,
            g = 51,
            b = 51,
        },
    },
}

Config.Garages = {
    VespucciBoulevard = {
        EntryPoint = {
            x = 394.865936,
            y = -1637.657104,
            z = 29.279907,
        },
        Sprite = 357,
        Scale = 0.8,
        Colour = 3,
        ImpoundedName = "LosSantos",
    },
}

Config.Impounds = {
    LosSantos = {
        GetOutPoint = {
            x = 400.7,
            y = -1630.5,
            z = 29.3,
        },
        SpawnPoint = {
            x = 401.9,
            y = -1647.4,
            z = 30.2,
            heading = 323.3,
        },
        Sprite = 524,
        Scale = 0.8,
        Colour = 1,
        Cost = 3000,
    },
}

exports("getGarages", function()
    return Config.Garages
end)

exports("getImpounds", function()
    return Config.Impounds
end)
