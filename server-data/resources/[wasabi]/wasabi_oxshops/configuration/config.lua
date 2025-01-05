Config = {}
Config.Shops = {
    ["ambulance"] = { -- Job name
        label = "Farmacia Ospedaliera",
        blip = {
            enabled = true,
            coords = vec3(362.492310, -1381.938477, 32.413940),
            sprite = 61,
            color = 8,
            scale = 0.7,
            string = "ambulance",
        },
        locations = {
            stash = {
                string = "[E] - Deposito vendita",
                coords = vec3(362.492310, -1381.938477, 32.413940),
                range = 3.0,
            },
            shop = {
                string = "[E] - Punto di acquisto",
                coords = vec3(358.971436, -1391.380249, 32.413940),
                range = 4.0,
            },
        },
    },

    ["mechanic"] = {
        label = "Mechanic Shop",
        blip = {
            enabled = true,
            coords = vec3(811.147278, -2157.349365, 29.616821),
            sprite = 61,
            color = 8,
            scale = 0.7,
            string = "mechanic",
        },
        locations = {
            stash = {
                string = "[E] - Access Inventory",
                coords = vec3(-350.123077, -170.109894, 39.002197),
                range = 3.0,
            },
            shop = {
                string = "[E] - Access Shop",
                coords = vec3(-314.518677, -122.149445, 39.002197),
                range = 4.0,
            },
        },
    },

    ["import"] = {
        label = "Import Shop",
        blip = {
            enabled = true,
            coords = vec3(1016.149475, -2405.261475, 30.122314),
            sprite = 61,
            color = 8,
            scale = 0.7,
            string = "import",
        },
        locations = {
            stash = {
                string = "[E] - Access Inventory",
                coords = vec3(1016.149475, -2405.261475, 30.122314),
                range = 3.0,
            },
            shop = {
                string = "[E] - Access Shop",
                coords = vec3(1020.830750, -2393.644043, 30.122314),
                range = 4.0,
            },
        },
    },
}
