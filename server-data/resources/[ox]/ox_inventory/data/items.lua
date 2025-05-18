return {
    ["bandage"] = {
        label = "Bandage",
        weight = 115,
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

    ["gun_table"] = {
        label = "Gun Table",
        weight = 10000,
        stack = false,
        close = true,
        description = "Tavolo portatile da sistemare mentre sei in movimento...",
        client = {
            event = "alv_repairtable:placeTable",
        },
    },

    ["burger"] = {
        label = "Burger",
        weight = 220,
        client = {
            status = { hunger = 33000 },
            anim = "eating",
            prop = "burger",
            usetime = 2500,
            notification = "You ate a delicious burger",
        },
    },

    ["fries"] = {
        label = "patatine fritte",
        weight = 220,
        client = {
            status = { hunger = 400000 },
            anim = "eating",
            prop = "burger",
            usetime = 2500,
            notification = "Stai mangiando delle patatine fritte",
        },
    },

    ["grilled_salmon"] = {
        label = "salmone grigliato",
        weight = 140,
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
        weight = 140,
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
        weight = 140,
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
        weight = 140,
        client = {
            status = { hunger = 60000 },
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
        weight = 60,
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
        weight = 50,
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
        weight = 8000,
        stack = false,
        client = {
            anim = { dict = "clothingshirt", clip = "try_shirt_positive_d" },
            usetime = 1500,
        },
    },

    ["paper"] = {
        label = "carta",
        weight = 100,
        stack = true,
        consume = 0,
    },

    ["fags"] = {
        label = "pacchetto di sigarette usato",
        weight = 100,
        stack = true,
        consume = 0,
    },

    ["newspaper"] = {
        label = "giornale rovinato",
        weight = 100,
        stack = true,
        consume = 0,
    },

    ["trash_burgershot"] = {
        label = "scatola di burgershot usata",
        weight = 100,
        stack = true,
        consume = 0,
    },

    ["paperbag"] = {
        label = "Paper Bag",
        weight = 1,
        stack = true,
        close = false,
        consume = 0,
    },

    ["recycled_paper"] = {
        label = "carta riciclata",
        weight = 1,
        stack = true,
        close = false,
        consume = 0,
    },

    ["trash_can"] = {
        label = "lattina usata",
        weight = 50,
        stack = true,
        close = false,
        consume = 0,
    },

    ["trash_chips"] = {
        label = "busta di patatine usata",
        weight = 100,
        stack = true,
        close = false,
        consume = 0,
    },

    ["cotton"] = {
        label = "cotone",
        weight = 1,
        stack = true,
        close = false,
        consume = 0,
    },

    ["cloth"] = {
        label = "stoffa",
        weight = 1,
        stack = true,
        close = false,
        consume = 0,
    },

    ["clothes"] = {
        label = "abiti",
        weight = 1,
        stack = true,
        close = false,
        consume = 0,
    },

    ["cottonforbandages"] = {
        label = "cotone per bende",
        weight = 5,
        stack = true,
        close = false,
        consume = 0,
    },

    ["gold"] = {
        label = "Oro",
        weight = 2,
        stack = true,
        close = false,
        consume = 0,
    },

    ["diamond"] = {
        label = "Diamante",
        weight = 2,
        stack = true,
        close = false,
        consume = 0,
    },

    ["diamond_tip"] = {
        label = "Punta di diamante",
        weight = 3,
        stack = true,
        close = false,
        consume = 0,
    },

    ["emerald"] = {
        label = "Smeraldo",
        weight = 3,
        stack = true,
        close = false,
        consume = 0,
    },

    ["copper"] = {
        label = "Rame",
        weight = 2,
        stack = true,
        close = false,
        consume = 0,
    },

    ["iron"] = {
        label = "Ferro",
        weight = 2,
        stack = true,
        close = false,
        consume = 0,
    },

    ["steel"] = {
        label = "Acciaio",
        weight = 5,
        stack = true,
        close = false,
        consume = 0,
    },

    ["steelsheet"] = {
        label = "lamiera di acciaio",
        weight = 60,
        stack = true,
        close = false,
        consume = 0,
    },

    ["identification"] = {
        label = "Identification",
    },

    ["panties"] = {
        label = "Knickers",
        weight = 10,
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
        weight = 160,
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
        weight = 190,
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

    ["money"] = {
        label = "Money",
    },

    ["mustard"] = {
        label = "Mustard",
        weight = 500,
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
        weight = 150,
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
        weight = 300,
        stack = false,
        consume = 0,
        allowArmed = true,
    },

    ["armour"] = {
        label = "Bulletproof Vest",
        weight = 3000,
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
        weight = 1,
    },

    ["wood"] = {
        label = "Legna",
        weight = 50,
        stack = true,
        close = false,
        consume = 0,
    },

    ["choppedwood"] = {
        label = "legno tagliato",
        weight = 25,
        stack = true,
        close = false,
        consume = 0,
    },

    ["hammer"] = {
        label = "martello",
        consume = 0,
        weight = 28,
    },

    ["fixkit"] = {
        label = "kit di riparazione",
        weight = 3,
        stack = true,
        close = true,
    },

    ["almonds"] = {
        label = "mandorla",
        weight = 10,
        stack = true,
    },

    ["ice"] = {
        label = "Ghiaccio",
        weight = 12,
        stack = true,
    },

    ["cannabis"] = {
        label = "cannabis",
        weight = 70,
        stack = true,
    },

    ["marijuana"] = {
        label = "marijuana",
        weight = 75,
        stack = true,
    },

    ["apple"] = {
        label = "Mele",
        weight = 20,
        stack = true,
    },

    ["milk"] = {
        label = "latte",
        weight = 100,
        stack = true,
    },

    ["potato"] = {
        label = "Patate",
        weight = 20,
        stack = true,
    },

    ["chips"] = {
        label = "Patatine fritte",
        weight = 25,
        stack = true,
    },

    ["fishingrod"] = {
        label = "canna da pesca",
        weight = 100,
        stack = true,
    },

    ["fishbait"] = {
        label = "esca per pesci",
        weight = 3,
        stack = true,
    },

    ["anchovy"] = {
        label = "acciuga",
        weight = 30,
        stack = true,
    },

    ["trout"] = {
        label = "trota",
        weight = 20,
        stack = true,
    },

    ["salmon"] = {
        label = "salmone",
        weight = 20,
        stack = true,
    },

    ["tuna"] = {
        label = "tonno",
        weight = 50,
        stack = true,
    },

    ["cigarette_paper"] = {
        label = "cartina per sigarette",
        weight = 100,
        stack = true,
    },

    ["almondmilk"] = {
        label = "Latte di mandorla",
        weight = 80,
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
        weight = 200,
        stack = false,
        consume = 0,
        client = {
            export = "bpt_backpack.openBackpack",
        },
    },

    ["boar_meat"] = {
        label = "carne di cinghiale",
        weight = 500,
        stack = true,
    },

    ["pelt_mtnlion"] = {
        label = "Pelle di leone di montagna",
        weight = 400,
        stack = true,
    },

    ["deer_meat"] = {
        label = "carne di cervo",
        weight = 100,
        stack = true,
    },

    ["pelt_coyote"] = {
        label = "Pelle di coyote",
        weight = 400,
        stack = true,
    },

    ["rabbit_meat"] = {
        label = "carne di coniglio",
        weight = 300,
        stack = true,
    },

    ["gunpowder"] = {
        label = "polvere da sparo",
        weight = 10,
        stack = true,
    },

    ["grain"] = {
        label = "grano",
        weight = 5,
        stack = true,
    },

    ["bread"] = {
        label = "panino vuoto",
        weight = 20,
        stack = true,
    },

    ["flour"] = {
        label = "farina",
        weight = 10,
        stack = true,
    },

    ["fry_oil"] = {
        label = "olio per friggere",
        weight = 8,
        stack = true,
    },

    ["idcard"] = {
        label = "carta d'identità",
        weight = 1,
        stack = false,
    },

    ["jobcard"] = {
        label = "documento lavorativo",
        weight = 1,
        stack = false,
    },

    ["dmvcard"] = {
        label = "patente di guida",
        weight = 1,
        stack = false,
    },

    ["licensecard"] = {
        label = "porto d'armi",
        weight = 1,
        stack = false,
    },

    ["wallet"] = {
        label = "portafoglio",
        weight = 45,
        stack = false,
        consume = 0,
        client = {
            export = "bpt_wallet.openWallet",
        },
    },

    ["medikit"] = {
        label = "Medikit",
        weight = 120,
        stack = true,
        close = true,
    },

    ["alive_chicken"] = {
        label = "Living chicken",
        weight = 1,
        stack = true,
        close = true,
    },

    ["blowpipe"] = {
        label = "Blowtorch",
        weight = 2,
        stack = true,
        close = true,
    },

    ["carokit"] = {
        label = "Body Kit",
        weight = 3,
        stack = true,
        close = true,
    },

    ["carotool"] = {
        label = "Tools",
        weight = 2,
        stack = true,
        close = true,
    },

    ["clothe"] = {
        label = "Cloth",
        weight = 1,
        stack = true,
        close = true,
    },

    ["cutted_wood"] = {
        label = "Cut wood",
        weight = 1,
        stack = true,
        close = true,
    },

    ["essence"] = {
        label = "Gas",
        weight = 1,
        stack = true,
        close = true,
    },

    ["fabric"] = {
        label = "Fabric",
        weight = 1,
        stack = true,
        close = true,
    },

    ["fish"] = {
        label = "Fish",
        weight = 1,
        stack = true,
        close = true,
    },

    ["fixtool"] = {
        label = "Repair Tools",
        weight = 2,
        stack = true,
        close = true,
    },

    ["gazbottle"] = {
        label = "Gas Bottle",
        weight = 2,
        stack = true,
        close = true,
    },

    ["packaged_chicken"] = {
        label = "Chicken fillet",
        weight = 1,
        stack = true,
        close = true,
    },

    ["packaged_plank"] = {
        label = "Packaged wood",
        weight = 1,
        stack = true,
        close = true,
    },

    ["petrol"] = {
        label = "Oil",
        weight = 1,
        stack = true,
        close = true,
    },

    ["petrol_raffin"] = {
        label = "Processed oil",
        weight = 1,
        stack = true,
        close = true,
    },

    ["slaughtered_chicken"] = {
        label = "Slaughtered chicken",
        weight = 1,
        stack = true,
        close = true,
    },

    ["stone"] = {
        label = "Pietra",
        weight = 150,
        stack = true,
        close = true,
    },

    ["diamond_hammer"] = {
        label = "Martello in diamante",
        weight = 70,
        stack = true,
        close = true,
    },

    ["stone_mortar"] = {
        label = "Mortaio in pietra",
        weight = 45,
        stack = true,
        close = true,
    },

    ["wool"] = {
        label = "Wool",
        weight = 1,
        stack = true,
        close = true,
    },

    ["plastic_bag"] = {
        label = "Plastica usata",
        weight = 10,
        stack = true,
        close = true,
    },

    ["recycled_plastic"] = {
        label = "Plastica riciclata",
        weight = 10,
        stack = true,
        close = true,
    },

    ["marijuana_extract"] = {
        label = "Estratto di marijuana",
        weight = 10,
        stack = true,
        close = true,
    },

    ["stevo_policebadge"] = {
        label = "Police Badge",
        weight = 250,
        stack = false,
    },

    ["halloween"] = {
        label = "Halloween",
        weight = 00,
        stack = true,
    },

    ["contract"] = {
        label = "Contratto",
        weight = 3,
        stack = true,
    },

    ["fattura"] = {
        label = "fattura",
        weight = 1,
        stack = false,
        close = true,
        description = "Fattura da pagare",
    },

    ["kitchen_knife"] = {
        label = "Coltello da cucina",
        weight = 100,
        consume = 1,
        stack = true,
        description = "Coltello da cucina",
    },
}
