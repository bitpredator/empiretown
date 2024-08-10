ESX = exports["es_extended"]:getSharedObject()

local oPlayer, playerpos = false, false

CreateThread(function()
    while true do
        oPlayer = PlayerPedId()
        playerpos = GetEntityCoords(oPlayer)
        Wait(500)
    end
end)

CreateThread(function()
    while true do
        Wait(1)
        local handle, ped = FindFirstPed()
        local success
        repeat
            success, ped = FindNextPed(handle)
            local pos = GetEntityCoords(ped)
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, playerpos.x, playerpos.y, playerpos.z, true)
            if distance < 2 and CanSlaughterPed(ped) then
                drawText3D(pos.x, pos.y, pos.z + 0.6, "[H] ~b~Skin Animal ~s~")
                while IsControlPressed(0, 30) do
                    break
                end
                if IsControlJustPressed(1, 74) then
                    if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("WEAPON_KNIFE") then
                        local oldped = ped
                        SetEntityHeading(ped, GetHeadingFromVector_2d(pos.x - playerpos.x - playerpos.y) + 180)
                        SetEntityHeading(oPlayer, GetHeadingFromVector_2d(pos.x - playerpos.x, pos.y - playerpos.y))

                        exports.rprogress:Custom({
                            Async = true,
                            x = 0.5,
                            y = 0.5,
                            From = 0,
                            To = 100,
                            Duration = 5000,
                            Radius = 60,
                            Stroke = 10,
                            MaxAngle = 360,
                            Rotation = 0,
                            Easing = "easeLinear",
                            Label = "SKINNING",
                            LabelPosition = "right",
                            Color = "rgba(255, 255, 255, 1.0)",
                            BGColor = "rgba(107, 109, 110, 0.95)",
                            Animation = {
                                animationDictionary = "anim@heists@narcotics@funding@gang_idle",
                                animationName = "gang_chatting_idle01",
                            },
                            DisableControls = {
                                Mouse = false,
                                Player = true,
                                Vehicle = true,
                            },
                        })
                        Wait(5000)
                        ClearPedTasks(PlayerPedId())
                        if GetEntityModel(ped) == GetHashKey("a_c_boar") then
                            local item = "boar_meat"
                            local p_name = TranslateCap("boar_meat")
                            TriggerServerEvent("bpt_hunting:getPelt", item, p_name)
                        elseif GetEntityModel(ped) == GetHashKey("a_c_mtlion") then
                            local item = "pelt_mtnlion"
                            local p_name = TranslateCap("pelt_mtnlion")
                            TriggerServerEvent("bpt_hunting:getPelt", item, p_name)
                        elseif GetEntityModel(ped) == GetHashKey("a_c_deer") then
                            local item = "deer_meat"
                            local p_name = TranslateCap("deer_meat")
                            TriggerServerEvent("bpt_hunting:getPelt", item, p_name)
                        elseif GetEntityModel(ped) == GetHashKey("a_c_coyote") then
                            local item = "pelt_coyote"
                            local p_name = TranslateCap("pelt_coyote")
                            TriggerServerEvent("bpt_hunting:getPelt", item, p_name)
                        elseif GetEntityModel(ped) == GetHashKey("a_c_rabbit_01") then
                            local item = "rabbit_meat"
                            local p_name = TranslateCap("rabbit_meat")
                            TriggerServerEvent("bpt_hunting:getPelt", item, p_name)
                        end
                        Wait(10)
                        SetPedAsNoLongerNeeded(oldped)
                        if DoesEntityExist(ped) then
                            DeleteEntity(ped)
                        end
                        Wait(1000)
                        break
                    else
                        ESX.ShowNotification(TranslateCap("knife_uses"))
                    end
                end
            end
        until not success
        EndFindPed(handle)
    end
end)

local oldped = {}
function CanSlaughterPed(ped)
    if
        not IsPedAPlayer(ped) and not IsPedInAnyVehicle(ped, false) and not IsPedHuman(ped) and IsEntityDead(ped) and ped ~= oldped and GetEntityModel(ped) == GetHashKey("a_c_boar")
        or GetEntityModel(ped) == GetHashKey("a_c_coyote")
        or GetEntityModel(ped) == GetHashKey("a_c_deer")
        or GetEntityModel(ped) == GetHashKey("a_c_mtlion")
        or GetEntityModel(ped) == GetHashKey("a_c_rabbit_01")
    then
        return true
    end
    return false
end

local blips = {
    { title = "Hunters Den", colour = 4, id = 463, x = -1132.93, y = 4948.42, z = 221.87 },
}

CreateThread(function()
    for _, info in pairs(blips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 0.8)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
    end
end)
