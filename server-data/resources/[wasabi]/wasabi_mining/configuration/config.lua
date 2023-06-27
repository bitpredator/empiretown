Config = {}
Config.axe = {
    prop = `prop_tool_pickaxe`, --Default: `prop_tool_pickaxe`
    breakChance = 20 -- When failing to mine rock, this is the percentage of a chance that your pickaxe will 'break'
}

Config.rocks = { -- Items obtained from mining
    { item = 'emerald', label = 'Emerald', difficulty = {'easy'} },
    { item = 'diamond', label = 'Diamond', difficulty = {'easy'} },
    { item = 'copper', label = 'Copper',  difficulty = {'easy'} },
    { item = 'iron', label = 'Iron',  difficulty = {'easy'} },
    { item = 'steel', label = 'Steel',  difficulty = {'easy'} },
    { item = 'gunpowder', label = 'polvere da sparo', difficulty = {'easy'}},
}


Config.miningAreas = {
    vec3(2977.45, 2741.62, 44.62), -- vec3 of locations for mining stones
    vec3(2982.64, 2750.89, 42.99),
    vec3(2994.92, 2750.43, 44.04),
    vec3(2958.21, 2725.44, 50.16),
    vec3(2946.3, 2725.36, 47.94),
    vec3(3004.01, 2763.27, 43.56),
    vec3(3001.79, 2791.01, 44.82)
}

RegisterNetEvent('wasabi_mining:notify')
AddEventHandler('wasabi_mining:notify', function(title, message, msgType)
    -- Place notification system info here, ex: exports['mythic_notify']:SendAlert('inform', message)
    if not msgType then
        lib.notify({
            title = title,
            description = message,
            type = 'inform'
        })
    else
        lib.notify({
            title = title,
            description = message,
            type = msgType
        })
    end
end)