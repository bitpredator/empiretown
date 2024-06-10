local IsDead = false
local IsAnimated = false

AddEventHandler("bpt_basicneeds:resetStatus", function()
    TriggerEvent("bpt_status:set", "hunger", 500000)
    TriggerEvent("bpt_status:set", "thirst", 500000)
end)

RegisterNetEvent("bpt_basicneeds:healPlayer")
AddEventHandler("bpt_basicneeds:healPlayer", function()
    -- restore hunger & thirst
    TriggerEvent("bpt_status:set", "hunger", 1000000)
    TriggerEvent("bpt_status:set", "thirst", 1000000)

    -- restore hp
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
end)

AddEventHandler("esx:onPlayerDeath", function()
    IsDead = true
end)

AddEventHandler("esx:onPlayerSpawn", function(spawn)
    if IsDead then
        TriggerEvent("bpt_basicneeds:resetStatus")
    end

    IsDead = false
end)

AddEventHandler("bpt_status:loaded", function(status)
    TriggerEvent("bpt_status:registerStatus", "hunger", 1000000, "#CFAD0F", function()
        return Config.Visible
    end, function()
        status.remove(100)
    end)

    TriggerEvent("bpt_status:registerStatus", "thirst", 1000000, "#0C98F1", function(status)
        return Config.Visible
    end, function()
        status.remove(75)
    end)
end)

AddEventHandler("bpt_status:onTick", function(data)
    local playerPed = PlayerPedId()
    local prevHealth = GetEntityHealth(playerPed)
    local health = prevHealth

    for _, v in pairs(data) do
        if v.name == "hunger" and v.percent == 0 then
            if prevHealth <= 150 then
                health = health - 5
            else
                health = health - 1
            end
        elseif v.name == "thirst" and v.percent == 0 then
            if prevHealth <= 150 then
                health = health - 5
            else
                health = health - 1
            end
        end
    end

    if health ~= prevHealth then
        SetEntityHealth(playerPed, health)
    end
end)

AddEventHandler("bpt_basicneeds:isEating", function(cb)
    cb(IsAnimated)
end)

RegisterNetEvent("bpt_basicneeds:onUse")
AddEventHandler("bpt_basicneeds:onUse", function(type, prop_name)
    if not IsAnimated then
        local anim = {}
        IsAnimated = true
        if type == "food" then
            prop_name = prop_name or "prop_cs_burger_01"
            anim = anim
        elseif type == "drink" then
            prop_name = prop_name or "prop_ld_flow_bottle"
            anim = anim
        end

        CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(joaat(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

            ESX.Streaming.RequestAnimDict(anim.dict, function()
                TaskPlayAnim(playerPed, anim.dict, anim.name, anim.settings[1], anim.settings[2], anim.settings[3], anim.settings[4], anim.settings[5], anim.settings[6], anim.settings[7], anim.settings[8])
                RemoveAnimDict(anim.dict)

                Wait(3000)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end)

-- Backwards compatibility
RegisterNetEvent("bpt_basicneeds:onEat")
AddEventHandler("bpt_basicneeds:onEat", function(prop_name)
    local Invoke = GetInvokingResource()

    print(("[^3WARNING^7] ^5%s^7 used ^5bpt_basicneeds:onEat^7, this method is deprecated and should not be used! Refer to ^5https://bitpredator.github.io/bptdevelopment/docs/FiveM/bpt_basicneeds/events/oneat^7 for more info!"):format(Invoke))

    if not prop_name then
        prop_name = "prop_cs_burger_01"
    end
    TriggerEvent("bpt_basicneeds:onUse", "food", prop_name)
end)

RegisterNetEvent("bpt_basicneeds:onDrink")
AddEventHandler("bpt_basicneeds:onDrink", function(prop_name)
    local Invoke = GetInvokingResource()

    print(("[^3WARNING^7] ^5%s^7 used ^5bpt_basicneeds:onDrink^7, this method is deprecated and should not be used! Refer to ^5https://bitpredator.github.io/bptdevelopment/docs/FiveM/bpt_basicneeds/events/ondrink^7 for more info!"):format(Invoke))

    if not prop_name then
        prop_name = "prop_ld_flow_bottle"
    end
    TriggerEvent("bpt_basicneeds:onUse", "drink", prop_name)
end)
