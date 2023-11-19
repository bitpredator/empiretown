local inTrunk = false
local isKidnapped = false
local isKidnapping = false
local cam = nil
local disabledTrunk = {
    [`penetrator`] = "penetrator",
    [`vacca`] = "vacca",
    [`monroe`] = "monroe",
    [`turismor`] = "turismor",
    [`osiris`] = "osiris",
    [`comet`] = "comet",
    [`ardent`] = "ardent",
    [`jester`] = "jester",
    [`nero`] = "nero",
    [`nero2`] = "nero2",
    [`vagner`] = "vagner",
    [`infernus`] = "infernus",
    [`zentorno`] = "zentorno",
    [`comet2`] = "comet2",
    [`comet3`] = "comet3",
    [`comet4`] = "comet4",
    [`bullet`] = "bullet",
}

-- Functions
local function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function getNearestVeh()
    local pos = GetEntityCoords(PlayerPedId())
    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
    local vehicleHandle = GetRaycastResult(rayHandle)
    return vehicleHandle
end

local function TrunkCam(bool)
    local vehicle = GetEntityAttachedTo(PlayerPedId())
    local drawPos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -5.5, 0)
    local vehHeading = GetEntityHeading(vehicle)
    if bool then
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        if not DoesCamExist(cam) then
            cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
            SetCamActive(cam, true)
            SetCamCoord(cam, drawPos.x, drawPos.y, drawPos.z + 2)
            SetCamRot(cam, -2.5, 0.0, vehHeading, 0.0)
            RenderScriptCams(true, false, 0, true, true)
        end
    else
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        cam = nil
    end
end

-- Events
RegisterNetEvent('esx_kidnapping:client:SetKidnapping', function(bool)
    isKidnapping = bool
end)

RegisterNetEvent('esx-trunk:client:KidnapTrunk', function()
    local closestPlayer, distance = ESX.Game.GetClosestPlayer()
    if distance ~= -1 and distance < 2 then
        if isKidnapping then
            local closestVehicle = getNearestVeh()
            if closestVehicle ~= 0 then
                TriggerEvent('police:client:KidnapPlayer')
                TriggerServerEvent("police:server:CuffPlayer", GetPlayerServerId(closestPlayer), false)
                Wait(50)
                TriggerServerEvent("esx-trunk:server:KidnapTrunk", GetPlayerServerId(closestPlayer), closestVehicle)
            end
        else
            ESX.ShowNotification( _U("not_kidnapped"), 'error')
        end
    end
end)

RegisterNetEvent('esx-trunk:client:KidnapGetIn', function(veh)
    local ped = PlayerPedId()
    local closestVehicle = veh
    local vehClass = GetVehicleClass(closestVehicle)
    local plate = GetVehicleNumberPlateText(closestVehicle)
    if Config.TrunkClasses[vehClass].allowed then
        ESX.TriggerServerCallback('esx-trunk:server:getTrunkBusy', function(isBusy)
            if not disabledTrunk[GetEntityModel(closestVehicle)] then
                if not inTrunk then
                    if not isBusy then
                        if not isKidnapped then
                            if GetVehicleDoorAngleRatio(closestVehicle, 5) > 0 then
                                local offset = {
                                    x = Config.TrunkClasses[vehClass].x,
                                    y = Config.TrunkClasses[vehClass].y,
                                    z = Config.TrunkClasses[vehClass].z,
                                }
                                RequestAnimDict("fin_ext_p1-7")
                                while not HasAnimDictLoaded("fin_ext_p1-7") do
                                    Wait(0)
                                end
                                TaskPlayAnim(ped, "fin_ext_p1-7", "cs_devin_dual-7", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
                                AttachEntityToEntity(ped, closestVehicle, 0, offset.x, offset.y, offset.z, 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
                                TriggerServerEvent('esx-trunk:server:setTrunkBusy', plate, true)
                                inTrunk = true
                                Wait(500)
                                SetVehicleDoorShut(closestVehicle, 5, false)
                                ESX.ShowNotification( _U("entered_trunk"), 'success', 4000)
                                TrunkCam(true)
                                isKidnapped = true
                            else
                                ESX.ShowNotification( _U("trunk_closed"), 'error', 2500)
                            end
                        else
                            local vehicle = GetEntityAttachedTo(ped)
                            plate = GetVehicleNumberPlateText(vehicle)
                            if GetVehicleDoorAngleRatio(vehicle, 5) > 0 then
                                local vehCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0, -5.0, 0)
                                DetachEntity(ped, true, true)
                                ClearPedTasks(ped)
                                inTrunk = false
                                TriggerServerEvent('esx_smallresources:trunk:server:setTrunkBusy', plate, nil)
                                SetEntityCoords(ped, vehCoords.x, vehCoords.y, vehCoords.z)
                                SetEntityCollision(PlayerPedId(), true, true)
                                TrunkCam(false)
                            else
                                ESX.ShowNotification( _U("trunk_closed"), 'error', 2500)
                            end
                        end
                    else
                        ESX.ShowNotification( _U("someone_in_trunk"), 'error', 2500)
                    end
                else
                    ESX.ShowNotification( _U("already_in_trunk"), 'error', 2500)
                end
            else
                ESX.ShowNotification( _U("cant_enter_trunk"), 'error', 2500)
            end
        end, plate)
    else
        ESX.ShowNotification( _U("cant_enter_trunk"), 'error', 2500)
    end
end)

RegisterNetEvent('esx-trunk:client:GetIn', function()
    local ped = PlayerPedId()
    local closestVehicle = getNearestVeh()
    if closestVehicle ~= 0 then
        local vehClass = GetVehicleClass(closestVehicle)
        local plate = GetVehicleNumberPlateText(closestVehicle)
        if Config.TrunkClasses[vehClass].allowed then
            ESX.TriggerServerCallback('esx-trunk:server:getTrunkBusy', function(isBusy)
                if not disabledTrunk[GetEntityModel(closestVehicle)] then
                    if not inTrunk then
                        if not isBusy then
                            if GetVehicleDoorAngleRatio(closestVehicle, 5) > 0 then
                                local offset = {
                                    x = Config.TrunkClasses[vehClass].x,
                                    y = Config.TrunkClasses[vehClass].y,
                                    z = Config.TrunkClasses[vehClass].z,
                                }
                                RequestAnimDict("fin_ext_p1-7")
                                while not HasAnimDictLoaded("fin_ext_p1-7") do
                                    Wait(0)
                                end
                                TaskPlayAnim(ped, "fin_ext_p1-7", "cs_devin_dual-7", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
                                AttachEntityToEntity(ped, closestVehicle, 0, offset.x, offset.y, offset.z, 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
                                TriggerServerEvent('esx-trunk:server:setTrunkBusy', plate, true)
                                inTrunk = true
                                Wait(500)
                                SetVehicleDoorShut(closestVehicle, 5, false)
                                ESX.ShowNotification( _U("entered_trunk"), 'success', 4000)
                                TrunkCam(true)
                            else
                                ESX.ShowNotification( _U("trunk_closed"), 'error', 2500)
                            end
                        else
                            ESX.ShowNotification( _U("someone_in_trunk"), 'error', 2500)
                        end
                    else
                        ESX.ShowNotification( _U("already_in_trunk"), 'error', 2500)
                    end
                else
                    ESX.ShowNotification( _U("cant_enter_trunk"), 'error', 2500)
                end
            end, plate)
        else
            ESX.ShowNotification( _U("cant_enter_trunk"), 'error', 2500)
        end
    else
        ESX.ShowNotification( _U("no_vehicle_found"), 'error', 2500)
    end
end)

-- Threads
CreateThread(function()
    while true do
        local sleep = 1000
        local vehicle = GetEntityAttachedTo(PlayerPedId())
        local drawPos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -5.5, 0)
        local vehHeading = GetEntityHeading(vehicle)
        if cam then
            sleep = 0
            SetCamRot(cam, -2.5, 0.0, vehHeading, 0.0)
            SetCamCoord(cam, drawPos.x, drawPos.y, drawPos.z + 2)
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        if inTrunk then
            if not isKidnapped then
                local ped = PlayerPedId()
                local vehicle = GetEntityAttachedTo(ped)
                local drawPos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                local plate = GetVehicleNumberPlateText(vehicle)
                if DoesEntityExist(vehicle) then
                    sleep = 0
                    DrawText3Ds(drawPos.x, drawPos.y, drawPos.z + 0.75,  _U("get_out_trunk_button"))
                    if IsControlJustPressed(0, 38) then
                        if GetVehicleDoorAngleRatio(vehicle, 5) > 0 then
                            local vehCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0, -5.0, 0)
                            DetachEntity(ped, true, true)
                            ClearPedTasks(ped)
                            inTrunk = false
                            TriggerServerEvent('esx-trunk:server:setTrunkBusy', plate, false)
                            SetEntityCoords(ped, vehCoords.x, vehCoords.y, vehCoords.z)
                            SetEntityCollision(ped, true, true)
                            TrunkCam(false)
                        else
                            ESX.ShowNotification( _U("trunk_closed"), 2500, 'error')
                        end
                        Wait(100)
                    end
                    if GetVehicleDoorAngleRatio(vehicle, 5) > 0 then
                        DrawText3Ds(drawPos.x, drawPos.y, drawPos.z + 0.5,  _U("close_trunk_button"))
                        if IsControlJustPressed(0, 47) then
                            if not IsVehicleSeatFree(vehicle, -1) then
                                TriggerServerEvent('esx-radialmenu:trunk:server:Door', false, plate, 5)
                            else
                                SetVehicleDoorShut(vehicle, 5, false)
                            end
                            Wait(100)
                        end
                    else
                        DrawText3Ds(drawPos.x, drawPos.y, drawPos.z + 0.5,  _U("open_trunk_button"))
                        if IsControlJustPressed(0, 47) then
                            if not IsVehicleSeatFree(vehicle, -1) then
                                TriggerServerEvent('esx-radialmenu:trunk:server:Door', true, plate, 5)
                            else
                                SetVehicleDoorOpen(vehicle, 5, false, false)
                            end
                            Wait(100)
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)