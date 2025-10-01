return {
    ["bandage"] = {
        label = "Benda",
        weight = 30,
        client = {
            anim = { dict = "missheistdockssetup1clipboard@idle_a", clip = "idle_a", flag = 49 },
            prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0) },
            disable = { move = true, car = true, combat = true },
            usetime = 2500,
        },
    },

    ["black_money"] = {
        label = "Dirty Money",
    },

    ["parkingcard"] = {
        label = "Tessera parcheggio",
    },

    ["burger"] = {
        label = "Burger",
        weight = 150,
        client = {
            status = { hunger = 33000 },
            anim = "eating",
            prop = "burger",
            usetime = 2500,
            notification = "Stai mangiando un burger",
        },
    },

    ["fries"] = {
        label = "patatine fritte",
        weight = 120,
        client = {
            status = { hunger = 250000 },
            anim = "eating",
            prop = "burger",
            usetime = 2500,
            notification = "Stai mangiando delle patatine fritte",
        },
    },

    ["cupcake"] = {
        label = "Cupcake",
        weight = 80,
        client = {
            status = { hunger = 100000 },
            anim = {
                dict = "mp_player_inteat@burger",
                clip = "mp_player_int_eat_burger",
            },
            prop = {
                model = "pata_christmasfood8",
                bone = 60309,
                pos = vec3(0.0200, 0.0, -0.0100),
                rot = vec3(9.3608, -90.1809, 66.3689),
            },
            usetime = 2500,
            notification = "Stai mangiando un cupcake 🎂",
        },
    },

    ["apple"] = {
        label = "Mele",
        weight = 80,
        stack = true,
        client = {
            status = { hunger = 100000 },
            anim = {
                dict = "mp_player_inteat@burger",
                clip = "mp_player_int_eat_burger",
            },
            prop = {
                model = "sf_prop_sf_apple_01b",
                bone = 60309,
                pos = vec3(0.0, 0.0150, -0.0200),
                rot = vec3(-124.6964, -166.5760, 8.4572),
            },
            usetime = 2500,
            notification = "Stai mangiando una mela 🍎",
        },
    },

    ["grilled_salmon"] = {
        label = "salmone grigliato",
        weight = 250,
        client = {
            status = { hunger = 500000 },
            anim = "eating",
            prop = "burger",
            usetime = 2500,
            notification = "Stai mangiando del salmone grigliato",
        },
    },

    ["tuna_sandwich"] = {
        label = "panino al tonno",
        weight = 200,
        client = {
            status = { hunger = 500000 },
            anim = "eating",
            prop = "burger",
            usetime = 2500,
            notification = "Stai mangiando un panino al tonno",
        },
    },

    ["mixed_fried_fish"] = {
        label = "pesce fritto misto",
        weight = 110,
        client = {
            status = { hunger = 400000 },
            anim = "eating",
            prop = "burger",
            usetime = 2500,
            notification = "Stai mangiando del pesce fritto misto",
        },
    },

    ["grilled_trout"] = {
        label = "trota grigliata",
        weight = 220,
        client = {
            status = { hunger = 500000 },
            anim = "eating",
            prop = "burger",
            usetime = 2500,
            notification = "Stai mangiando della trota grigliata",
        },
    },

    ["bread_deer"] = {
        label = "panino con carne di cervo",
        weight = 220,
        client = {
            status = { hunger = 200000 },
            anim = "eating",
            prop = "burger",
            usetime = 2500,
            notification = "Hai mangiato un panino con carne di cervo",
        },
    },

    ["cola"] = {
        label = "eCola",
        weight = 150,
        client = {
            status = { thirst = 250000 },
            anim = { dict = "mp_player_intdrink", clip = "loop_bottle" },
            prop = { model = `prop_ecola_can`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
            usetime = 2500,
            notification = "You quenched your thirst with cola",
        },
    },

    ["appledrink"] = {
        label = "AppleDrink",
        weight = 300,
        client = {
            status = { thirst = 300000 },
            anim = { dict = "mp_player_intdrink", clip = "loop_bottle" },
            prop = { model = `prop_ecola_can`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
            usetime = 2500,
            notification = "Stai usando un drink alla mela",
        },
    },

    ["parachute"] = {
        label = "Parachute",
        weight = 3000,
        stack = false,
        client = {
            anim = { dict = "clothingshirt", clip = "try_shirt_positive_d" },
            usetime = 1500,
        },
    },

    ["paper"] = {
        label = "carta",
        weight = 5,
        stack = true,
        consume = 0,
    },

    ["fags"] = {
        label = "pacchetto di sigarette usato",
        weight = 5,
        stack = true,
        consume = 0,
    },

    ["newspaper"] = {
        label = "giornale rovinato",
        weight = 30,
        stack = true,
        consume = 0,
    },

    ["trash_burgershot"] = {
        label = "scatola di burgershot usata",
        weight = 50,
        stack = true,
        consume = 0,
    },

    ["paperbag"] = {
        label = "Paper Bag",
        weight = 20,
        stack = true,
        close = false,
        consume = 0,
    },

    ["recycled_paper"] = {
        label = "carta riciclata",
        weight = 10,
        stack = true,
        close = false,
        consume = 0,
    },

    ["trash_can"] = {
        label = "lattina usata",
        weight = 30,
        stack = true,
        close = false,
        consume = 0,
    },

    ["trash_chips"] = {
        label = "busta di patatine usata",
        weight = 40,
        stack = true,
        close = false,
        consume = 0,
    },

    ["cotton"] = {
        label = "cotone",
        weight = 10,
        stack = true,
        close = false,
        consume = 0,
    },

    ["cloth"] = {
        label = "stoffa",
        weight = 50,
        stack = true,
        close = false,
        consume = 0,
    },

    ["cottonforbandages"] = {
        label = "cotone per bende",
        weight = 20,
        stack = true,
        close = false,
        consume = 0,
    },

    ["gold"] = {
        label = "Oro",
        weight = 10,
        stack = true,
        close = false,
        consume = 0,
    },

    ["diamond"] = {
        label = "Diamante",
        weight = 30,
        stack = true,
        close = false,
        consume = 0,
    },

    ["diamond_tip"] = {
        label = "Punta di diamante",
        weight = 20,
        stack = true,
        close = false,
        consume = 0,
    },

    ["emerald"] = {
        label = "Smeraldo",
        weight = 30,
        stack = true,
        close = false,
        consume = 0,
    },

    ["copper"] = {
        label = "Rame",
        weight = 100,
        stack = true,
        close = false,
        consume = 0,
    },

    ["iron"] = {
        label = "Ferro",
        weight = 150,
        stack = true,
        close = false,
        consume = 0,
    },

    ["steel"] = {
        label = "Acciaio",
        weight = 125,
        stack = true,
        close = false,
        consume = 0,
    },

    ["steelsheet"] = {
        label = "lamiera di acciaio",
        weight = 200,
        stack = true,
        close = false,
        consume = 0,
    },

    ["identification"] = {
        label = "Identification",
    },

    ["panties"] = {
        label = "Knickers",
        weight = 50,
        consume = 0,
        client = {
            status = { thirst = -100000, stress = -25000 },
            anim = { dict = "mp_player_intdrink", clip = "loop_bottle" },
            prop = { model = `prop_cs_panties_02`, pos = vec3(0.03, 0.0, 0.02), rot = vec3(0.0, -13.5, -1.5) },
            usetime = 2500,
        },
    },

    ["lockpick"] = {
        label = "Lockpick",
        weight = 20,
        consume = 0,
        client = {
            anim = { dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", clip = "machinic_loop_mechandplayer" },
            disable = { move = true, car = true, combat = true },
            usetime = 5000,
            cancel = true,
        },
    },

    ["phone"] = {
        label = "Phone",
        weight = 300,
        stack = false,
        consume = 0,
        client = {
            add = function(total)
                if total > 0 then
                    pcall(function()
                        return exports.npwd:setPhoneDisabled(false)
                    end)
                end
            end,

            remove = function(total)
                if total < 1 then
                    pcall(function()
                        return exports.npwd:setPhoneDisabled(true)
                    end)
                end
            end,
        },
    },

    ["sim"] = {
        label = "Sim Card",
    },

    ["money"] = {
        label = "Money",
    },

    ["mustard"] = {
        label = "Mustard",
        weight = 100,
        client = {
            status = { hunger = 25000, thirst = 25000 },
            anim = { dict = "mp_player_intdrink", clip = "loop_bottle" },
            prop = { model = `prop_food_mustard`, pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
            usetime = 2500,
            notification = "You.. drank mustard",
        },
    },

    ["water"] = {
        label = "Water",
        weight = 200,
        client = {
            status = { thirst = 200000 },
            anim = { dict = "mp_player_intdrink", clip = "loop_bottle" },
            prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
            usetime = 2500,
            cancel = true,
            notification = "You drank some refreshing water",
        },
    },

    ["radio"] = {
        label = "Radio",
        weight = 600,
        stack = false,
        consume = 0,
        allowArmed = true,
    },

    ["armour"] = {
        label = "Bulletproof Vest",
        weight = 4000,
        stack = false,
        client = {
            anim = { dict = "clothingshirt", clip = "try_shirt_positive_d" },
            usetime = 3500,
        },
    },

    ["clothing"] = {
        label = "Clothing",
        consume = 0,
    },

    ["ironsheet"] = {
        label = "lamiera di ferro",
        stack = true,
        weight = 500,
    },

    ["wood"] = {
        label = "Legna",
        weight = 400,
        stack = true,
        close = true,
    },

    ["choppedwood"] = {
        label = "legno tagliato",
        weight = 250,
        stack = true,
        close = false,
        consume = 0,
    },

    ["hammer"] = {
        label = "martello",
        consume = 0,
        weight = 200,
    },

    ["fixkit"] = {
        label = "kit di riparazione",
        weight = 300,
        stack = true,
        close = true,
    },

    ["almonds"] = {
        label = "mandorla",
        weight = 20,
        stack = true,
    },

    ["ice"] = {
        label = "Ghiaccio",
        weight = 200,
        stack = true,
    },

    ["milk"] = {
        label = "latte",
        weight = 600,
        stack = true,
    },

    ["potato"] = {
        label = "Patate",
        weight = 100,
        stack = true,
    },

    ["chips"] = {
        label = "Patatine fritte",
        weight = 120,
        stack = true,
    },

    ["fishing_rod"] = {
        label = "Canna da pesca",
        weight = 800,
        stack = false, -- non impilabile
        close = true,
        description = "Usata per pescare. Ha una durata limitata.",
        durability = 100, -- personalizzato
    },

    ["bait"] = {
        label = "esca",
        weight = 5,
        stack = true,
    },

    ["anchovy"] = {
        label = "acciuga",
        weight = 80,
        stack = true,
    },

    ["trout"] = {
        label = "trota",
        weight = 500,
        stack = true,
    },

    ["salmon"] = {
        label = "salmone",
        weight = 800,
        stack = true,
    },

    ["tuna"] = {
        label = "tonno",
        weight = 1200,
        stack = true,
    },

    ["cigarette_paper"] = {
        label = "cartina per sigarette",
        weight = 5,
        stack = true,
    },

    ["almondmilk"] = {
        label = "Latte di mandorla",
        weight = 400,
        client = {
            status = { thirst = 200000 },
            anim = { dict = "mp_player_intdrink", clip = "loop_bottle" },
            prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
            usetime = 2500,
            cancel = true,
            notification = "hai bevuto una bibita fresca",
        },
    },

    ["backpack"] = {
        label = "Backpack",
        weight = 1000,
        stack = false,
        consume = 0,
        client = {
            export = "bpt_backpack.openBackpack",
        },
    },

    ["boar_meat"] = {
        label = "carne di cinghiale",
        weight = 1200,
        stack = true,
    },

    ["pelt_mtnlion"] = {
        label = "Pelle di leone di montagna",
        weight = 800,
        stack = true,
    },

    ["deer_meat"] = {
        label = "carne di cervo",
        weight = 1200,
        stack = true,
    },

    ["pelt_coyote"] = {
        label = "Pelle di coyote",
        weight = 700,
        stack = true,
    },

    ["rabbit_meat"] = {
        label = "carne di coniglio",
        weight = 600,
        stack = true,
    },

    ["gunpowder"] = {
        label = "polvere da sparo",
        weight = 50,
        stack = true,
    },

    ["grain"] = {
        label = "grano",
        weight = 50,
        stack = true,
    },

    ["bread"] = {
        label = "panino vuoto",
        weight = 200,
        stack = true,
    },

    ["flour"] = {
        label = "farina",
        weight = 300,
        stack = true,
    },

    ["fry_oil"] = {
        label = "olio per friggere",
        weight = 200,
        stack = true,
    },

    ["idcard"] = {
        label = "carta d'identità",
        weight = 5,
        stack = false,
    },

    ["jobcard"] = {
        label = "documento lavorativo",
        weight = 5,
        stack = false,
    },

    ["dmvcard"] = {
        label = "patente di guida",
        weight = 5,
        stack = false,
    },

    ["licensecard"] = {
        label = "porto d'armi",
        weight = 5,
        stack = false,
    },

    ["wallet"] = {
        label = "portafoglio",
        weight = 80,
        stack = false,
        consume = 0,
        client = {
            export = "bpt_wallet.openWallet",
        },
    },

    ["medikit"] = {
        label = "Medikit",
        weight = 500,
        stack = true,
        close = true,
    },

    ["alive_chicken"] = {
        label = "Living chicken",
        weight = 800,
        stack = true,
        close = true,
    },

    ["blowpipe"] = {
        label = "Blowtorch",
        weight = 500,
        stack = true,
        close = true,
    },

    ["carokit"] = {
        label = "Body Kit",
        weight = 1500,
        stack = true,
        close = true,
    },

    ["carotool"] = {
        label = "Tools",
        weight = 500,
        stack = true,
        close = true,
    },

    ["clothe"] = {
        label = "Cloth",
        weight = 100,
        stack = true,
        close = true,
    },

    ["cutted_wood"] = {
        label = "Cut wood",
        weight = 800,
        stack = true,
        close = true,
    },

    ["essence"] = {
        label = "Gas",
        weight = 800,
        stack = true,
        close = true,
    },

    ["fabric"] = {
        label = "Fabric",
        weight = 200,
        stack = true,
        close = true,
    },

    ["fish"] = {
        label = "Fish",
        weight = 400,
        stack = true,
        close = true,
    },

    ["fixtool"] = {
        label = "Repair Tools",
        weight = 800,
        stack = true,
        close = true,
    },

    ["gazbottle"] = {
        label = "Gas Bottle",
        weight = 1200,
        stack = true,
        close = true,
    },

    ["packaged_chicken"] = {
        label = "Chicken fillet",
        weight = 500,
        stack = true,
        close = true,
    },

    ["packaged_plank"] = {
        label = "Packaged wood",
        weight = 1000,
        stack = true,
        close = true,
    },

    ["petrol"] = {
        label = "Oil",
        weight = 1000,
        stack = true,
        close = true,
    },

    ["petrol_raffin"] = {
        label = "Processed oil",
        weight = 1000,
        stack = true,
        close = true,
    },

    ["slaughtered_chicken"] = {
        label = "Slaughtered chicken",
        weight = 1000,
        stack = true,
        close = true,
    },

    ["stone"] = {
        label = "Pietra",
        weight = 200,
        stack = true,
        close = true,
    },

    ["diamond_hammer"] = {
        label = "Martello in diamante",
        weight = 750,
        stack = true,
        close = true,
    },

    ["stone_mortar"] = {
        label = "Mortaio in pietra",
        weight = 1500,
        stack = true,
        close = true,
    },

    ["wool"] = {
        label = "Wool",
        weight = 100,
        stack = true,
        close = true,
    },

    ["plastic_bag"] = {
        label = "Plastica usata",
        weight = 20,
        stack = true,
        close = true,
    },

    ["recycled_plastic"] = {
        label = "Plastica riciclata",
        weight = 20,
        stack = true,
        close = true,
    },

    ["marijuana_extract"] = {
        label = "Estratto di marijuana",
        weight = 50,
        stack = true,
        close = true,
    },

    ["stevo_policebadge"] = {
        label = "Police Badge",
        weight = 200,
        stack = false,
    },

    ["contract"] = {
        label = "Contratto",
        weight = 10,
        stack = true,
    },

    ["kitchen_knife"] = {
        label = "Coltello da cucina",
        weight = 200,
        consume = 1,
        stack = true,
        description = "Coltello da cucina",
    },

    ["weed_seed"] = {
        label = "Seed",
        weight = 5,
        stack = true,
        close = true,
        description = "Seme di Marijuana",
    },

    ["axe"] = {
        label = "Ascia",
        weight = 2000,
        stack = false,
        close = true,
        description = "Un’ascia utile per tagliare la legna",
        consume = 100, -- non si consuma in automatico
    },

    ["weed_pooch"] = {
        label = "Marijuana",
        weight = 100,
        stack = true,
        close = true,
        description = "Foglia di Marijuana",
    },

    ["weed"] = {
        label = "bustina di marijuana",
        weight = 50,
        stack = true,
        close = true,
        description = "sacchetto di marijuana",
    },

    ["laptop"] = {
        label = "Laptop",
        weight = 1500,
        stack = false,
        description = "Laptop",
    },

    ["microchip"] = {
        label = "Microchip",
        weight = 20,
        stack = true,
        description = "Microchip",
    },
}
