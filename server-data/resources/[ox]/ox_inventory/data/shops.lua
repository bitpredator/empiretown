return {

    General = {
        name = "Shop",
        blip = {
            id = 59,
            colour = 69,
            scale = 0.8,
        },
        inventory = {
            { name = "burger", price = 10 },
            { name = "water", price = 10 },
            { name = "cola", price = 10 },
            { name = "fishingrod", price = 100 },
            { name = "fishbait", price = 80 },
        },
        locations = {
            vec3(25.7, -1347.3, 29.49),
            vec3(-3038.71, 585.9, 7.9),
            vec3(-3241.47, 1001.14, 12.83),
            vec3(1728.66, 6414.16, 35.03),
            vec3(1697.99, 4924.4, 42.06),
            vec3(1961.48, 3739.96, 32.34),
            vec3(547.79, 2671.79, 42.15),
            vec3(2679.25, 3280.12, 55.24),
            vec3(2557.94, 382.05, 108.62),
            vec3(373.55, 325.56, 103.56),
        },
        targets = {
            { loc = vec3(25.06, -1347.32, 29.5), length = 0.7, width = 0.5, heading = 0.0, minZ = 29.5, maxZ = 29.9, distance = 1.5 },
            { loc = vec3(-3039.18, 585.13, 7.91), length = 0.6, width = 0.5, heading = 15.0, minZ = 7.91, maxZ = 8.31, distance = 1.5 },
            { loc = vec3(-3242.2, 1000.58, 12.83), length = 0.6, width = 0.6, heading = 175.0, minZ = 12.83, maxZ = 13.23, distance = 1.5 },
            { loc = vec3(1728.39, 6414.95, 35.04), length = 0.6, width = 0.6, heading = 65.0, minZ = 35.04, maxZ = 35.44, distance = 1.5 },
            { loc = vec3(1698.37, 4923.43, 42.06), length = 0.5, width = 0.5, heading = 235.0, minZ = 42.06, maxZ = 42.46, distance = 1.5 },
            { loc = vec3(1960.54, 3740.28, 32.34), length = 0.6, width = 0.5, heading = 120.0, minZ = 32.34, maxZ = 32.74, distance = 1.5 },
            { loc = vec3(548.5, 2671.25, 42.16), length = 0.6, width = 0.5, heading = 10.0, minZ = 42.16, maxZ = 42.56, distance = 1.5 },
            { loc = vec3(2678.29, 3279.94, 55.24), length = 0.6, width = 0.5, heading = 330.0, minZ = 55.24, maxZ = 55.64, distance = 1.5 },
            { loc = vec3(2557.19, 381.4, 108.62), length = 0.6, width = 0.5, heading = 0.0, minZ = 108.62, maxZ = 109.02, distance = 1.5 },
            { loc = vec3(373.13, 326.29, 103.57), length = 0.6, width = 0.5, heading = 345.0, minZ = 103.57, maxZ = 103.97, distance = 1.5 },
        },
    },

    Unicorn = {
        name = "Negozio unicorn",
        groups = {
            ["unicorn"] = 0,
        },
        blip = {
            id = 403,
            colour = 69,
            scale = 0.8,
        },
        inventory = {
            { name = "water", price = 30 },
            { name = "ice", price = 5 },
            { name = "fry_oil", price = 60 },
            { name = "almonds", price = 10 },
        },
        locations = {
            vec3(132.408798, -1286.439575, 29.263062),
        },
        targets = {},
    },

    VendingMachineDrinks = {
        name = "Vending Machine",
        inventory = {
            { name = "water", price = 10 },
            { name = "cola", price = 10 },
        },
        model = {
            `prop_vend_soda_02`,
            `prop_vend_fridge01`,
            `prop_vend_water_01`,
            `prop_vend_soda_01`,
        },
    },

    DigitalStore = {
        name = "Digital Store",
        blip = {
            id = 59,
            colour = 69,
            scale = 0.8,
        },
        inventory = {
            { name = "phone", price = 3000 },
            { name = "radio", price = 1600 },
        },
        locations = {
            vec3(385.885712, -826.523071, 29.296753),
        },
        targets = {},
    },

    Backpacks = {
        name = "Backpacks",
        blip = {
            id = 59,
            colour = 69,
            scale = 0.8,
        },
        inventory = {
            { name = "backpack", price = 800 },
            { name = "wallet", price = 300 },
        },
        locations = {
            vec3(-1131.481323, -1635.652710, 4.359009),
        },
        targets = {},
    },

    Government = {
        name = "Governo",
        blip = {
            id = 419,
            scale = 0.8,
        },
        inventory = {
            { name = "idcard", price = 3000 },
            { name = "dmvcard", price = 5000 },
            { name = "licensecard", price = 5000 },
        },
        locations = {
            vec3(-554.887939, -187.252747, 38.277710),
        },
        targets = {},
    },

    Mineshop = {
        name = "Mine shop",
        blip = {
            id = 68,
            colour = 69,
            scale = 0.8,
        },
        inventory = {
            { name = "pickaxe", price = 30 },
            { name = "water", price = 100 },
            { name = "burger", price = 70 },
        },
        locations = {
            vec3(2571.151611, 2720.690186, 42.911377),
        },
    },
}
