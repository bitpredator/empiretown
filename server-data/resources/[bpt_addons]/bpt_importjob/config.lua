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
            Coords = vector3(902.505493, -1032.000000, 34.958252),
            Sprite = 478,
            Display = 4,
            Scale = 1.0,
            Colour = 21,
        },

        BossActions = {
            vector3(903.520874, -1042.325317, 35.244629),
        },

        Vehicles = {
            {
                Spawner = vector3(901.872559, -1056.079102, 32.818359),
                InsideShop = vector3(901.872559, -1056.079102, 32.818359),
                SpawnPoints = {
                    { coords = vector3(901.872559, -1056.079102, 32.818359), heading = 90.0, radius = 6.0 },
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
        apprentice = {
            { model = "rumpo3", price = 15000 },
        },

        gunsmith = {
            { model = "rumpo3", price = 15000 },
        },

        importchief = {
            { model = "rumpo3", price = 15000 },
        },

        deputydirector = {
            { model = "rumpo3", price = 15000 },
        },

        boss = {
            { model = "rumpo3", price = 15000 },
        },
    },
}
