Config = {}

Config.CheckVersion = false -- Will let you know in your console if the script is up to date and will let you know of any changelogs and things that are coming soon.

Config.MetalItem = "steel" -- The item required to repair weapons.
Config.ChargePlayer = 5000 -- Set this to false to make it free to repair weapons.
Config.DrawMarker = false -- You may want to disable this if using third-eye (target).
Config.Command = true -- If you want to use Key Mapping, Pressing E, etc. THIS MUST BE ENABLED....

Config.TableItem = {
    Prop = "prop_tool_bench02", -- The table prop that will be placed...
    RequireMetalToPlace = true, -- Enabling this requires the player to have the MetalItem to place.
    Job = true, -- Replace false with a job if you want only specific jobs to place a table.
    TakeOnUse = true,
}

Config.KeyMapping = {
    Enabled = false, -- You'll want to disable keybinds if you're using the third eye.
    Description = "Use a repair bench.", -- Description that will show in the FiveM keybind settings.
    Keybind = "e", -- The key that the repair bench will be binded to, the default and recommended is E.
}

Config.Framework = {
    Type = "auto", --[[ Options: 'auto', 'esx', 'qb', 'ox' ]] --
    Name = "es_extended", --[[ Name of your frameworks core resource for the export. ]] --
    Target = GetResourceState("ox_target") ~= "missing", -- Will determine if you have ox_target, but you can set this to false to completely disable.
    Radius = 1.0, -- The radius for the target, if enabled.
    Icon = "fa-solid fa-gun", -- Icon that will appear on the target.
}

Config.RepairLocations = {
    [1] = {
        Location = vec3(808.945068, -2173.318604, 29.616821), -- The coordinates for the bench (vector3)
        Label = "Ammu Repair Bench", -- Label for the location you're at.
        Jobs = {
            ["ammu"] = true, -- Job required to operate the table, feel free to add more by adding a new line.
        },
    },
}

Config.RestrictedTo = { -- Remove the table and set this to false to allow every gun on the table
    ["WEAPON_APPISTOL"] = true,
    ["WEAPON_PISTOL"] = true,
    ["WEAPON_PISTOL_MK2"] = true,
    ["WEAPON_COMBATPISTOL"] = true,
    ["WEAPON_PISTOL50"] = true,
    ["WEAPON_HEAVYPISTOL"] = true,
    ["WEAPON_SNSPISTOL"] = true,
    ["WEAPON_VINTAGEPISTOL"] = true,
    ["WEAPON_MARKSMANPISTOL"] = true,
    ["WEAPON_REVOLVER"] = true,
    ["WEAPON_DOUBLEACTION"] = true,
    ["WEAPON_NIGHTSTICK"] = true,
    ["WEAPON_STUNGUN"] = true,
    ["WEAPON_FLAREGUN"] = true,
    ["WEAPON_RAYPISTOL"] = true,
    ["WEAPON_RAYCARBINE"] = true,
    ["WEAPON_RAYMINIGUN"] = true,
    ["WEAPON_PUMPSHOTGUN"] = true,
    ["WEAPON_SAWNOFFSHOTGUN"] = true,
    ["WEAPON_BULLPUPSHOTGUN"] = true,
    ["WEAPON_ASSAULTSHOTGUN"] = true,
    ["WEAPON_MUSKET"] = true,
    ["WEAPON_HEAVYSHOTGUN"] = true,
    ["WEAPON_DBSHOTGUN"] = true,
    ["WEAPON_AUTOSHOTGUN"] = true,
    ["WEAPON_ASSAULTRIFLE"] = true,
    ["WEAPON_CARBINERIFLE"] = true,
    ["WEAPON_CARBINERIFLE_MK2"] = true,
    ["WEAPON_ADVANCEDRIFLE"] = true,
    ["WEAPON_MG"] = true,
    ["WEAPON_COMBATMG"] = true,
    ["WEAPON_COMBATMG_MK2"] = true,
    ["WEAPON_SNIPERRIFLE"] = true,
    ["WEAPON_HEAVYSNIPER"] = true,
    ["WEAPON_HEAVYSNIPER_MK2"] = true,
    ["WEAPON_MARKSMANRIFLE"] = true,
    ["WEAPON_GRENADELAUNCHER"] = true,
    ["WEAPON_GRENADELAUNCHER_SMOKE"] = true,
    ["WEAPON_RPG"] = true,
    ["WEAPON_STINGER"] = true,
    ["WEAPON_MINIGUN"] = true,
    ["WEAPON_RAILGUN"] = true,
    ["WEAPON_HOMINGLAUNCHER"] = true,
    ["WEAPON_COMPACTLAUNCHER"] = true,
    ["WEAPON_GRENADE"] = true,
    ["WEAPON_BZGAS"] = true,
    ["WEAPON_SMOKEGRENADE"] = true,
    ["WEAPON_MOLOTOV"] = true,
    ["WEAPON_FIREEXTINGUISHER"] = true,
    ["WEAPON_PETROLCAN"] = true,
    ["WEAPON_SNOWBALL"] = true,
    ["WEAPON_FLARE"] = true,
    ["WEAPON_BALL"] = true,
    ["WEAPON_SNSPISTOL_MK2"] = true,
    ["WEAPON_REVOLVER_MK2"] = true,
    ["WEAPON_DOUBLEACTION_MK2"] = true,
    ["WEAPON_SPECIALCARBINE_MK2"] = true,
    ["WEAPON_BULLPUPRIFLE_MK2"] = true,
    ["WEAPON_PUMPSHOTGUN_MK2"] = true,
    ["WEAPON_MARKSMANRIFLE_MK2"] = true,
    ["WEAPON_ASSAULTRIFLE_MK2"] = true,
    ["WEAPON_SMG_MK2"] = true,
    ["WEAPON_COMBATPDW"] = true,
    ["WEAPON_MG_MK2"] = true,
}

-- EXAMPLE TO ALLOW ALL GUNS BELOW. REPLACE LINES 26-30 WITH THIS IF THATS WHAT YOU WANT.

--[[
Config.RestrictedTo = {}
]]

Config.Repairing = {
    InstantRepair = false, -- Do you want the weapon to repair instantly? Setting to false will use a progress bar and optional animation.
    TimeEach = 5, -- How long each stage should take in seconds, default is 150 seconds meaning it takes 5 minutes to repeir a weapon.
    Fixing = {
        AnimDict = "anim@heists@prison_heiststation@cop_reactions",
        AnimClip = "cop_b_idle",
    },
    Cleaning = {
        AnimDict = "timetable@floyd@clean_kitchen@base",
        AnimClip = "base",
    },
}

Config.Requirements = { -- The amount of metal required to fix a gun based on its durability.
    [99.9] = 1,
    [75] = 3,
    [50] = 6,
    [25] = 9,
    [10] = 12,
    [5] = 14,
    [0] = 15,
}

Config.MenuOptions = {
    UseMenu = false, -- --[[ OPTIONS: true (will use ox_lib menu), false (will use built-in UI) ]]--
    Title = "Repair Bench", -- Will show in the menu header.
    Position = "bottom-right", -- Menu position, read ox_lib docs for more positions.
}

Config.Notification = "built-in" --[[ OPTIONS: 'built-in', 'framework', 'print', none ]] --
function Config.Notify(message)
    if Config.Notification == "built-in" then
        SendNUIMessage({
            type = "notification",
            data = {
                message = message,
                time = 5000,
            },
        })
    elseif Config.Notification == "framework" then
        if ESX then
            ESX.ShowNotification(message)
        elseif QBCore then
            QBCore.Funcions.Notify(message)
        end
    elseif Config.Notification == "print" then
        print(message)
    else
        return
    end
end

Config.Debug = false -- Will print data you can use for debugging if you modify the script, also registers some commands that'll help you test stuff. See functions file for more information.
