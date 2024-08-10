RegisterCommand("jailmenu", function()
    if PlayerData.job.name == "police" then
        OpenJailMenu()
    else
        ESX.ShowNotification(TranslateCap("not_officer"))
    end
end)

function LoadAnim(animDict)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(10)
    end
end

function LoadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
end

function HideHUDThisFrame()
    HideHelpTextThisFrame()
    HideHudAndRadarThisFrame()
    HideHudComponentThisFrame(1)
    HideHudComponentThisFrame(2)
    HideHudComponentThisFrame(3)
    HideHudComponentThisFrame(4)
    HideHudComponentThisFrame(6)
    HideHudComponentThisFrame(7)
    HideHudComponentThisFrame(8)
    HideHudComponentThisFrame(9)
    HideHudComponentThisFrame(13)
    HideHudComponentThisFrame(11)
    HideHudComponentThisFrame(12)
    HideHudComponentThisFrame(15)
    HideHudComponentThisFrame(18)
    HideHudComponentThisFrame(19)
end

function Cutscene()
    DoScreenFadeOut(100)

    Wait(250)

    local Male = GetHashKey("mp_m_freemode_01")

    TriggerEvent("skinchanger:getSkin", function(skin)
        if GetHashKey(GetEntityModel(PlayerPedId())) == Male then
            local clothesSkin = {
                ["tshirt_1"] = 20,
                ["tshirt_2"] = 15,
                ["torso_1"] = 33,
                ["torso_2"] = 0,
                ["arms"] = 0,
                ["pants_1"] = 7,
                ["pants_2"] = 0,
                ["shoes_1"] = 34,
                ["shoes_2"] = 0,
            }
            TriggerEvent("skinchanger:loadClothes", skin, clothesSkin)
        else
            local clothesSkin = {
                ["tshirt_1"] = 15,
                ["tshirt_2"] = 0,
                ["torso_1"] = 2,
                ["torso_2"] = 6,
                ["arms"] = 2,
                ["pants_1"] = 2,
                ["pants_2"] = 0,
                ["shoes_1"] = 35,
                ["shoes_2"] = 0,
            }
            TriggerEvent("skinchanger:loadClothes", skin, clothesSkin)
        end
    end)

    LoadModel(-1320879687)

    local PolicePosition = Config.Cutscene["PolicePosition"]
    local Police = CreatePed(5, -1320879687, PolicePosition["x"], PolicePosition["y"], PolicePosition["z"], PolicePosition["h"], false)
    TaskStartScenarioInPlace(Police, "WORLD_HUMAN_PAPARAZZI", 0, false)

    local PlayerPosition = Config.Cutscene["PhotoPosition"]
    local PlayerPed = PlayerPedId()
    SetEntityCoords(PlayerPed, PlayerPosition["x"], PlayerPosition["y"], PlayerPosition["z"] - 1)
    SetEntityHeading(PlayerPed, PlayerPosition["h"])
    FreezeEntityPosition(PlayerPed, true)

    Cam()
    Wait(1000)
    DoScreenFadeIn(100)
    Wait(10000)
    DoScreenFadeOut(250)

    local JailPosition = Config.JailPositions["Cell"]
    SetEntityCoords(PlayerPed, JailPosition["x"], JailPosition["y"], JailPosition["z"])
    DeleteEntity(Police)
    SetModelAsNoLongerNeeded(-1320879687)

    Wait(1000)
    DoScreenFadeIn(250)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "cell", 0.3)
    RenderScriptCams(false, false, 0, true, true)
    FreezeEntityPosition(PlayerPed, false)
    DestroyCam(Config.Cutscene["CameraPos"]["cameraId"])

    InJail()
end

function Cam()
    local CamOptions = Config.Cutscene["CameraPos"]

    CamOptions["cameraId"] = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

    SetCamCoord(CamOptions["cameraId"], CamOptions["x"], CamOptions["y"], CamOptions["z"])
    SetCamRot(CamOptions["cameraId"], CamOptions["rotationX"], CamOptions["rotationY"], CamOptions["rotationZ"])

    RenderScriptCams(true, false, 0, true, true)
end

function TeleportPlayer(pos)
    local Values = pos

    if #Values["goal"] > 1 then
        local elements = {}

        for _, v in pairs(Values["goal"]) do
            table.insert(elements, { label = v, value = v })
        end

        ESX.UI.Menu.Open("default", GetCurrentResourceName(), "teleport_jail", {
            title = "Choose Position",
            align = "center",
            elements = elements,
        }, function(data, menu)
            local action = data.current.value
            local position = Config.Teleports[action]

            if action == "Boiling Broke" or action == "Security" then
                if PlayerData.job.name ~= "police" then
                    ESX.ShowNotification(TranslateCap("not_keys"))
                    return
                end
            end
            menu.close()
            DoScreenFadeOut(100)
            Wait(250)
            SetEntityCoords(PlayerPedId(), position["x"], position["y"], position["z"])
            Wait(250)
            DoScreenFadeIn(100)
        end, function(_, menu)
            menu.close()
        end)
    else
        local position = Config.Teleports[Values["goal"][1]]
        DoScreenFadeOut(100)
        Wait(250)
        SetEntityCoords(PlayerPedId(), position["x"], position["y"], position["z"])
        Wait(250)
        DoScreenFadeIn(100)
    end
end

CreateThread(function()
    local blip = AddBlipForCoord(Config.Teleports["Boiling Broke"]["x"], Config.Teleports["Boiling Broke"]["y"], Config.Teleports["Boiling Broke"]["z"])
    SetBlipSprite(blip, 188)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 49)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Boilingbroke Penitentiary")
    EndTextCommandSetBlipName(blip)
end)
