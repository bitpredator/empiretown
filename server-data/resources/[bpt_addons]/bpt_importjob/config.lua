---@diagnostic disable: undefined-global
Config = {}

Config.DrawDistance = 10.0 -- How close do you need to be for the markers to be drawn (in GTA units).
Config.MarkerType = { Import = 21, BossActions = 22, Vehicles = 36 }
Config.MarkerSize = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerColor = { r = 50, g = 50, b = 204 }
Config.EnablePlayerManagement = true -- Enable if you want society managing.
Config.EnableImportManagement = false
Config.EnableESXIdentity = true -- Enable if you're using esx_identity.
Config.EnableESXOptionalneeds = false -- Enable if you're using esx_optionalneeds
Config.EnableLicenses = true -- Enable if you're using esx_license.
Config.EnableHandcuffTimer = true -- Enable handcuff timer? will unrestrain player after the time ends.
Config.HandcuffTimer = 10 * 60000 -- 10 minutes.
Config.Locale = GetConvar("esx:locale", "it")
Config.OxInventory = ESX.GetConfig().OxInventory

Config.Import = {

    IMPORT = {

        Blip = {
            Coords = vector3(1006.799988, -2404.127441, 30.122314),
            Sprite = 478,
            Display = 4,
            Scale = 1.0,
            Colour = 21,
        },

        BossActions = {
            vector3(1006.799988, -2404.127441, 30.122314),
        },

        Vehicles = {
            {
                Spawner = vector3(1021.912109, -2372.043945, 30.526733),
                InsideShop = vector3(1012.720886, -2341.279053, 30.493042),
                SpawnPoints = {
                    { coords = vector3(1015.740662, -2366.624268, 31.593042), heading = 90.0, radius = 6.0 },
                },
            },
        },

        --        Import = {
        --            vector3(1001.630798, -2403.217529, 30.172852),
        --        },
    },
}

Config.AuthorizedVehicles = {
    car = {
        apprentice = {},

        gunsmith = {},

        importchief = {},

        deputydirector = {},

        boss = {
            { model = "rumpo3", price = 15000 },
        },
    },
}
