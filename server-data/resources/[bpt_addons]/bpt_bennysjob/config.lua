---@diagnostic disable: undefined-global
Config = {}

Config.DrawDistance = 10.0 -- How close do you need to be for the markers to be drawn (in GTA units).
Config.MarkerType = { Bennys = 21, BossActions = 22, Vehicles = 36 }
Config.MarkerSize = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerColor = { r = 50, g = 50, b = 204 }
Config.EnablePlayerManagement = true -- Enable if you want society managing.
Config.EnableBennysManagement = false
Config.EnableESXIdentity = true -- Enable if you're using esx_identity.
Config.EnableESXOptionalneeds = false -- Enable if you're using esx_optionalneeds
Config.EnableLicenses = true -- Enable if you're using esx_license.
Config.EnableHandcuffTimer = true -- Enable handcuff timer? will unrestrain player after the time ends.
Config.HandcuffTimer = 10 * 60000 -- 10 minutes.
Config.Locale = GetConvar("esx:locale", "it")
Config.OxInventory = ESX.GetConfig().OxInventory

Config.Bennys = {

    BENNYS = {

        Blip = {
            Coords = vector3(-197.920883, -1341.494507, 34.890869),
            Sprite = 478,
            Display = 4,
            Scale = 1.0,
            Colour = 21,
        },

        BossActions = {
            vector3(-197.920883, -1341.494507, 34.890869),
        },

        Vehicles = {
            {
                Spawner = vector3(-219.547241, -1294.035156, 31.285034),
                InsideShop = vector3(-219.547241, -1294.035156, 31.285034),
                SpawnPoints = {
                    { coords = vector3(-183.349457, -1303.885742, 31.285034), heading = 90.0, radius = 6.0 },
                },
            },
        },

        --        Bennys = {
        --            vector3(1001.630798, -2403.217529, 30.172852),
        --        },
    },
}

Config.AuthorizedVehicles = {
    car = {
        apprentice = {},

        gunsmith = {},

        bennyschief = {},

        deputydirector = {},

        boss = {
            { model = "slamvan", price = 15000 },
        },
    },
}
