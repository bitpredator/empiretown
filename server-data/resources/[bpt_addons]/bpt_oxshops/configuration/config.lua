Config = {}
Config.Shops = {
    ["ambulance"] = {
        label = "Farmacia Ospedale",
        blip = {
            enabled = true,
            coords = vec3(309.283508, -561.507690, 43.282104),
            sprite = 61,
            color = 8,
            scale = 0.7,
            string = "ambulance",
        },
        locations = {
            stash = {
                string = "[E] - Deposito vendita",
                coords = vec3(309.283508, -561.507690, 43.282104),
                range = 3.0,
            },
            shop = {
                string = "[E] - Punto di acquisto",
                coords = vec3(308.281311, -592.588989, 43.282104),
                range = 4.0,
            },
        },
    },

    ["mechanic"] = {
        label = "Negozio Meccanico",
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
                string = "[E] - Deposito vendita",
                coords = vec3(-350.123077, -170.109894, 39.002197),
                range = 3.0,
            },
            shop = {
                string = "[E] - Punto di acquisto",
                coords = vec3(-314.518677, -122.149445, 39.002197),
                range = 4.0,
            },
        },
    },

    ["ammu"] = {
        label = "Negozio Armeria",
        blip = {
            enabled = true,
            coords = vec3(811.147278, -2157.349365, 29.616821),
            sprite = 61,
            color = 8,
            scale = 0.7,
            string = "ammu",
        },
        locations = {
            stash = {
                string = "[E] - Deposito vendita",
                coords = vec3(826.641785, -2157.019775, 29.616821),
                range = 3.0,
            },
            shop = {
                string = "[E] - Punto di acquisto",
                coords = vec3(812.584595, -2153.063721, 29.616821),
                range = 4.0,
            },
        },
    },
}
