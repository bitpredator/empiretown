local seconds, minutes = 1000, 60000
Config = {}

Config.checkForUpdates = true -- Check for updates?
Config.oldESX = false -- Nothing to do with qb / Essentially when set to true it disables the check of if player can carry item

Config.bait = {
    itemName = "fishbait", -- Item name of bait
    loseChance = 65, -- Chance of loosing bait(Setting to 100 will use bait every cast)
}

Config.fishingRod = {
    itemName = "fishingrod", -- Item name of fishing rod
    breakChance = 25, --Chance of breaking pole when failing skillbar (Setting to 0 means never break)
}

Config.timeForBite = { -- Set min and max random range of time it takes for fish to be on the line.
    min = 2 * seconds,
    max = 20 * seconds,
}

Config.fish = {
    { item = "tuna", label = "Tuna", difficulty = { "easy" } },
    { item = "salmon", label = "Salmon", difficulty = { "easy" } },
    { item = "trout", label = "Trout", difficulty = { "easy" } },
    { item = "anchovy", label = "Anchovy", difficulty = { "easy" } },
    { item = "plastic_bag", label = "Plastic Bag", difficulty = { "easy" } },
}

RegisterNetEvent("wasabi_fishing:notify")
AddEventHandler("wasabi_fishing:notify", function(title, message, msgType)
    -- Place notification system info here, ex: exports['mythic_notify']:SendAlert('inform', message)
    if not msgType then
        lib.notify({
            title = title,
            description = message,
            type = "inform",
        })
    else
        lib.notify({
            title = title,
            description = message,
            type = msgType,
        })
    end
end)
