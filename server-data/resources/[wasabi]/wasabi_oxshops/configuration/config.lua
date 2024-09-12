Config = {}
Config.Shops = {
    ["ambulance"] = { -- Job name
        label = "Hospital Shop",
        blip = {
            enabled = true,
            coords = vec3(309.415375, -561.784607, 43.282104),
            sprite = 61,
            color = 8,
            scale = 0.7,
            string = "ambulance",
        },
        locations = {
            stash = {
                string = "[E] - Access Inventory",
                coords = vec3(309.415375, -561.784607, 43.282104),
                range = 3.0,
            },
            shop = {
                string = "[E] - Access Shop",
                coords = vec3(308.782410, -592.061523, 43.282104),
                range = 4.0,
            },
        },
    }, -- Copy and paste this shop to create more

    ["ammu"] = {
        label = "Ammunation Shop",
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
                string = "[E] - Access Inventory",
                coords = vec3(819.665955, -2155.542969, 29.616821),
                range = 3.0,
            },
            shop = {
                string = "[E] - Access Shop",
                coords = vec3(812.663757, -2152.364746, 29.616821),
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
}
