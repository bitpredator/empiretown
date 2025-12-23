Config = {}

Config.Shops = {
    ["ambulance"] = {
        label = "Farmacia Ospedale",

        blip = {
            shop = {
                enabled = true,
                coords = vec3(308.281311, -592.588989, 43.282104),
                sprite = 61,
                color = 8,
                scale = 0.7,
                label = "Farmacia Ospedale",
            },
            stash = {
                enabled = true,
                coords = vec3(309.283508, -561.507690, 43.282104),
                sprite = 473,
                color = 1,
                scale = 0.6,
                label = "Deposito Ospedale",
            },
        },

        locations = {
            stash = {
                string = "[E] - Deposito vendita",
                coords = vec3(309.283508, -561.507690, 43.282104),
                range = 1.0,
            },
            shop = {
                string = "[E] - Punto di acquisto",
                coords = vec3(308.281311, -592.588989, 43.282104),
                range = 1.0,
            },
        },
    },

    ["ammu"] = {
        label = "Negozio Armeria",

        blip = {
            shop = {
                enabled = true,
                coords = vec3(811.147278, -2157.349365, 29.616821),
                sprite = 110,
                color = 8,
                scale = 0.7,
                label = "Armeria",
            },
            stash = {
                enabled = true,
                coords = vec3(826.641785, -2157.019775, 29.616821),
                sprite = 473,
                color = 1,
                scale = 0.6,
                label = "Deposito Armeria",
            },
        },

        locations = {
            stash = {
                string = "[E] - Deposito vendita",
                coords = vec3(826.641785, -2157.019775, 29.616821),
                range = 1.0,
            },
            shop = {
                string = "[E] - Punto di acquisto",
                coords = vec3(812.584595, -2153.063721, 29.616821),
                range = 1.0,
            },
        },
    },

    ["unicorn"] = {
        label = "Negozio Unicorn",

        blip = {
            shop = {
                enabled = true,
                coords = vec3(131.076920, -1286.136230, 29.263062),
                sprite = 59,
                color = 8,
                scale = 0.7,
                label = "Unicorn",
            },
            stash = {
                enabled = true,
                coords = vec3(131.076920, -1286.136230, 29.263062),
                sprite = 59,
                color = 1,
                scale = 0.6,
                label = "Deposito Unicorn",
            },
        },

        locations = {
            stash = {
                string = "[E] - Deposito vendita",
                coords = vec3(131.076920, -1286.136230, 29.263062),
                range = 1.0,
            },
            shop = {
                string = "[E] - Punto di acquisto",
                coords = vec3(126.791214, -1282.905518, 29.263062),
                range = 1.0,
            },
        },
    },

    ["import"] = {
        label = "Negozio Import",

        blip = {
            shop = {
                enabled = true,
                coords = vec3(899.723083, -1043.723022, 35.244629),
                sprite = 59,
                color = 8,
                scale = 0.7,
                label = "Import",
            },
            stash = {
                enabled = true,
                coords = vec3(899.723083, -1043.723022, 35.244629),
                sprite = 59,
                color = 1,
                scale = 0.6,
                label = "Deposito Import",
            },
        },

        locations = {
            stash = {
                string = "[E] - Deposito vendita",
                coords = vec3(892.852722, -1031.789063, 35.244629),
                range = 1.0,
            },
            shop = {
                string = "[E] - Punto di acquisto",
                coords = vec3(899.564819, -1043.683472, 35.244629),
                range = 1.0,
            },
        },
    },

    ["mechanic"] = {
        label = "Negozio Meccanico",

        blip = {
            shop = {
                enabled = true,
                coords = vec3(-328.575806, -157.582413, 39.002197),
                sprite = 59,
                color = 8,
                scale = 0.7,
                label = "Meccanico",
            },
            stash = {
                enabled = true,
                coords = vec3(-328.575806, -157.582413, 39.002197),
                sprite = 59,
                color = 1,
                scale = 0.6,
                label = "Deposito Meccanico",
            },
        },

        locations = {
            stash = {
                string = "[E] - Deposito vendita",
                coords = vec3(-328.575806, -157.582413, 39.002197),
                range = 1.0,
            },
            shop = {
                string = "[E] - Punto di acquisto",
                coords = vec3(-330.039551, -162.567032, 39.002197),
                range = 1.0,
            },
        },
    },
}
