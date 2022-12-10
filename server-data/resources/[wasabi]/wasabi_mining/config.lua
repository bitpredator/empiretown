Config = {}

Config.DiscordMiningLogs = false --Set true to enable discord logs for mined ore. (Can set webhooks in wasabi_mining/server/discordwebhook.lua)
Config.DiscordCheatLogs = true --Set true to enable possible cheater logs. (Can set webhooks in wasabi_mining/server/discordwebhook.lua)

Config.OldESX = false --Getting 'canCarryItem' error? Set this to true if you're using limit system.

Config.Axe = `prop_tool_pickaxe` --Default: `prop_tool_pickaxe`

Config.AxeBreakPercent = 50 --When failing to mine rock, this is the percentage of a chance that your pickaxe will 'break'

Config.Rocks = { -- Items obtained from mining rocks
    'emerald',
    'diamond',
    'copper',
    'iron',
    'steel',
    'gunpowder'
}

Config.MiningAreas = {
    vector3(2977.45, 2741.62, 44.62), -- vector3 of locations for mining stones
    vector3(2982.64, 2750.89, 42.99),
    vector3(2994.92, 2750.43, 44.04),
    vector3(2958.21, 2725.44, 50.16),
    vector3(2946.3, 2725.36, 47.94),
    vector3(3004.01, 2763.27, 43.56),
    vector3(3001.79, 2791.01, 44.82)
}

Language = {
    --Blips
    ['mining_blips'] = 'Miniere',
    --Help Text
    ['intro_instruction'] = 'Premi ~INPUT_ATTACK~ per estrarre, ~INPUT_FRONTEND_RRIGHT~ per cancellare.',
    --3D Text
    ['mine_rock'] = 'PREMI[~g~E~s~] PER MINARE',
    --Notifications(Success)
    ['rewarded'] = 'hai ricevuto 1x',
    --Notifications(Failed)
    ['failed_mine'] = 'Non sei riuscito ad estrarre il minerale!',
    ['no_pickaxe'] = 'Non hai un piccone!',
    ['axe_broke'] = 'Hai colpito male la roccia e il piccone si è rotto!',
    ['cantcarry'] = 'Non c\'è più spazio per il trasporto 1x',
    ['possible_cheater'] = 'Sei stato segnalato allo staff del server.',
    --Kicked Message
    ['kicked'] = 'Sei stato espulso e segnalato allo staff per possibile utilizzo di hack.'
}

RegisterNetEvent('wasabi_mining:notify')
AddEventHandler('wasabi_mining:notify', function(message)	
	
-- Place notification system info here, ex: exports['mythic_notify']:SendAlert('inform', message)
    ESX.ShowNotification(message)


end)
