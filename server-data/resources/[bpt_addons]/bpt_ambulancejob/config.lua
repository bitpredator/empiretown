Config = {}

Config.DrawDistance = 10.0 -- How close do you need to be in order for the markers to be drawn (in GTA units).

Config.Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }

Config.ReviveReward = 700 -- Revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog = true -- Enable anti-combat logging? (Removes Items when a player logs back after intentionally logging out while dead.)
Config.LoadIpl = false -- Disable if you're using fivem-ipl or other IPL loaders

Config.Locale = "it"

Config.EarlyRespawnTimer = 60000 * 1 -- time til respawn is available
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
    { coords = vector3(341.0, -1397.3, 32.5), heading = 48.5 },
}

Config.Hospitals = {

    CentralLosSantos = {

        Blip = {
            coords = vector3(338.716492, -1394.439575, 32.498169),
            sprite = 61,
            scale = 1.2,
            color = 2,
        },

        AmbulanceActions = {
            vector3(346.589020, -1428.435181, 31.936279),
        },

        Vehicles = {
            {
                Spawner = vector3(390.356049, -1436.822021, 29.431519),
                InsideShop = vector3(393.784607, -1442.624146, 29.397827),
                Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
                SpawnPoints = {
                    { coords = vector3(402.989014, -1426.417603, 29.448364), heading = 227.6, radius = 4.0 },
                },
            },
        },

        Helicopters = {
            {
                Spawner = vector3(299.419769, -1454.004395, 46.500366),
                InsideShop = vector3(299.419769, -1454.004395, 46.500366),
                Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 100, g = 150, b = 150, a = 100, rotate = true },
                SpawnPoints = {
                    { coords = vector3(299.419769, -1454.004395, 46.500366), heading = 142.7, radius = 10.0 },
                },
            },
            {
                Spawner = vector3(313.120880, -1465.661499, 46.500366),
                InsideShop = vector3(313.120880, -1465.661499, 46.500366),
                Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 100, g = 150, b = 150, a = 100, rotate = true },
                SpawnPoints = {
                    { coords = vector3(313.120880, -1465.661499, 46.500366), heading = 142.7, radius = 10.0 },
                },
            },
        },

        FastTravels = {
            -- roof access (ok)
            {
                From = vector3(329.393402, -601.081299, 42.282104),
                To = { coords = vector3(341.076935, -581.604370, 74.150879), heading = 0.0 },
                Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
            },

            -- DW main
            {
                From = vector3(339.454956, -584.175842, 73.150879),
                To = { coords = vector3(331.371429, -595.424194, 43.282104), heading = 0.0 },
                Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
            },

            -- Garage dw
            {
                From = vector3(327.217590, -603.560425, 42.282104),
                To = { coords = vector3(339.283508, -584.479126, 28.791260), heading = 0.0 },
                Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
            },

            -- Garage up
            {
                From = vector3(340.892303, -580.378052, 27.791260),
                To = { coords = vector3(332.175812, -595.569214, 43.282104), heading = 0.0 },
                Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
            },

            -- Roof access end
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
            { model = "frogger2", price = 150000 },
        },

        chief_doctor = {
            { model = "frogger2", price = 150000 },
        },

        boss = {
            { model = "frogger2", price = 10000 },
        },
    },
}
