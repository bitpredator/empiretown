Config = {}

Config.DrawDistance = 10.0 -- How close do you need to be in order for the markers to be drawn (in GTA units).
Config.Debug = ESX.GetConfig().EnableDebug
Config.Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }

Config.ReviveReward = 8000 -- Revive reward, set to 0 if you don't want it enabled
Config.LoadIpl = false -- Disable if you're using fivem-ipl or other IPL loaders

Config.Locale = GetConvar("esx:locale", "it")

Config.DistressBlip = {
    Sprite = 310,
    Color = 48,
    Scale = 2.0,
}

Config.zoom = {
    min = 1,
    max = 6,
    step = 0.5,
}

Config.EarlyRespawnTimer = 60000 * 10 -- time til respawn is available
Config.BleedoutTimer = 60000 * 10 -- time til the player bleeds out

Config.EnablePlayerManagement = true -- Enable society managing (If you are using bpt_society).

Config.RemoveWeaponsAfterRPDeath = false
Config.RemoveCashAfterRPDeath = false
Config.RemoveItemsAfterRPDeath = false

-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine = true
Config.EarlyRespawnFineAmount = 5000

Config.OxInventory = ESX.GetConfig().OxInventory
Config.RespawnPoints = {
    { coords = vector3(357.217590, -593.538452, 28.774414), heading = 48.5 },
}

Config.Hospitals = {

    CentralLosSantos = {

        Blip = {
            coords = vector3(292.05, -582.39, 43.18),
            sprite = 61,
            scale = 1.2,
            color = 2,
        },

        AmbulanceActions = {
            vector3(301.925293, -598.549438, 42.282104),
        },

        Vehicles = {
            {
                Spawner = vector3(338.123077, -575.947266, 28.791260),
                InsideShop = vector3(328.021973, -576.553833, 28.791260),
                Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
                SpawnPoints = {
                    { coords = vector3(328.021973, -576.553833, 28.791260), heading = 227.6, radius = 4.0 },
                },
            },
        },

        Helicopters = {
            {
                Spawner = vector3(317.5, -1449.5, 46.5),
                InsideShop = vector4(343.7769, -1423.0913, 76.1742, 322.8178),
                Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 100, g = 150, b = 150, a = 100, rotate = true },
                SpawnPoints = {
                    { coords = vector3(313.5, -1465.1, 46.5), heading = 142.7, radius = 10.0 },
                    { coords = vector3(299.5, -1453.2, 46.5), heading = 142.7, radius = 10.0 },
                },
            },
        },

        FastTravels = {
            {
                From = vector3(294.7, -1448.1, 29.0),
                To = { coords = vector3(272.8, -1358.8, 23.5), heading = 0.0 },
                Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
            },

            {
                From = vector3(275.3, -1361, 23.5),
                To = { coords = vector3(295.8, -1446.5, 28.9), heading = 0.0 },
                Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
            },

            {
                From = vector3(247.3, -1371.5, 23.5),
                To = { coords = vector3(333.1, -1434.9, 45.5), heading = 138.6 },
                Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
            },

            {
                From = vector3(335.5, -1432.0, 45.50),
                To = { coords = vector3(249.1, -1369.6, 23.5), heading = 0.0 },
                Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
            },

            {
                From = vector3(234.5, -1373.7, 20.9),
                To = { coords = vector3(320.9, -1478.6, 28.8), heading = 0.0 },
                Marker = { type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false },
            },

            {
                From = vector3(317.9, -1476.1, 28.9),
                To = { coords = vector3(238.6, -1368.4, 23.5), heading = 0.0 },
                Marker = { type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false },
            },
        },

        FastTravelsPrompt = {
            {
                From = vector3(237.4, -1373.8, 26.0),
                To = { coords = vector3(251.9, -1363.3, 38.5), heading = 0.0 },
                Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
                Prompt = TranslateCap("fast_travel"),
            },

            {
                From = vector3(256.5, -1357.7, 36.0),
                To = { coords = vector3(235.4, -1372.8, 26.3), heading = 0.0 },
                Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
                Prompt = TranslateCap("fast_travel"),
            },
        },
    },
}

Config.AuthorizedVehicles = {
    car = {
        ambulance = {
            { model = "ambulance", price = 5000 },
        },

        doctor = {
            { model = "ambulance", price = 4500 },
        },

        chief_doctor = {
            { model = "ambulance", price = 3000 },
        },

        boss = {
            { model = "ambulance", price = 2000 },
        },
    },

    helicopter = {
        ambulance = {},

        doctor = {
            { model = "buzzard2", price = 150000 },
        },

        chief_doctor = {
            { model = "buzzard2", price = 150000 },
            { model = "seasparrow", price = 300000 },
        },

        boss = {
            { model = "buzzard2", price = 10000 },
            { model = "seasparrow", price = 250000 },
        },
    },
}
