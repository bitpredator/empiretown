ESX = {}
ESX.Players = {}
ESX.Jobs = {}
ESX.JobsPlayerCount = {}
ESX.Items = {}
Core = {}
Core.UsableItemsCallbacks = {}
Core.RegisteredCommands = {}
Core.Pickups = {}
Core.PickupId = 0
Core.PlayerFunctionOverrides = {}
Core.DatabaseConnected = false
Core.playersByIdentifier = {}

Core.vehicleTypesByModel = {}

RegisterNetEvent("esx:onPlayerSpawn", function()
    ESX.Players[source].spawned = true
end)

AddEventHandler("esx:getSharedObject", function()
    local Invoke = GetInvokingResource()
    print(("[^1ERROR^7] Resource ^5%s^7 Used the ^5getSharedObject^7 Event, this event ^1no longer exists!^7 Visit https://bitpredator.github.io/bptdevelopment/docs/esx-tutorial/sharedevent for how to fix!"):format(Invoke))
end)

exports("getSharedObject", function()
    return ESX
end)

if Config.OxInventory then
    Config.PlayerFunctionOverride = "OxInventory"
    SetConvarReplicated("inventory:framework", "esx")
    SetConvarReplicated("inventory:weight", Config.MaxWeight * 1000)
end

local function StartDBSync()
    CreateThread(function()
        local interval <const> = 10 * 60 * 1000
        while true do
            Wait(interval)
            Core.SavePlayers()
        end
    end)
end

MySQL.ready(function()
    Core.DatabaseConnected = true
    if not Config.OxInventory then
        local items = MySQL.query.await("SELECT * FROM items")
        for _, v in ipairs(items) do
            ESX.Items[v.name] = { label = v.label, weight = v.weight, rare = v.rare, canRemove = v.can_remove }
        end
    else
        TriggerEvent("__cfx_export_ox_inventory_Items", function(ref)
            if ref then
                ESX.Items = ref()
            end
        end)

        AddEventHandler("ox_inventory:itemList", function(items)
            ESX.Items = items
        end)

        while not next(ESX.Items) do
            Wait(0)
        end
    end

    ESX.RefreshJobs()

    print(("[^2INFO^7] BPT ^5FRAMEWORK %s^0 initialized!"):format(GetResourceMetadata(GetCurrentResourceName(), "version", 0)))

    StartDBSync()
    if Config.EnablePaycheck then
        StartPayCheck()
    end
end)

RegisterServerEvent("esx:clientLog")
AddEventHandler("esx:clientLog", function(msg)
    if Config.EnableDebug then
        print(("[^2TRACE^7] %s^7"):format(msg))
    end
end)

RegisterNetEvent("esx:ReturnVehicleType", function(Type, Request)
    if Core.ClientCallbacks[Request] then
        Core.ClientCallbacks[Request](Type)
        Core.ClientCallbacks[Request] = nil
    end
end)
