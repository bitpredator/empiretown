function GetShapeTestResultSync(shape)
    local handle, hit, coords, normal, entity
    repeat
        handle, hit, coords, normal, entity = GetShapeTestResult(shape)
    until handle ~= 1 or Wait(0)
    return hit, coords, normal, entity
end

local camera = nil
local x, y = 0.0, 0.0
local camera_radius = 5.0
local zoom = {min = 2.5, max = 7.5, step = 0.5}
local playerPed = nil
local camThreadRunning = false

function StartDeathCam()
    playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    camera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x, coords.y, coords.z + 2.0, 0.0, 0.0, 0.0, 50.0, false, 0)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 1000, true, false)

    camThreadRunning = true
    Citizen.CreateThread(function()
        while camThreadRunning do
            Wait(0)
            ProcessCamControls()
        end
    end)
end

function EndDeathCam()
    camThreadRunning = false
    Wait(100)

    if camera then
        RenderScriptCams(false, true, 1000, true, false)
        DestroyCam(camera, false)
        camera = nil
    end

    ClearFocus()
    ClearTimecycleModifier() -- rimuove eventuali effetti visuali
end

function ProcessCamControls()
    local playerCoords = GetEntityCoords(playerPed)
    if IsDisabledControlPressed(0, 14) and camera_radius < zoom.max then
        camera_radius += zoom.step
    elseif IsDisabledControlPressed(0, 15) and camera_radius > zoom.min then
        camera_radius -= zoom.step
    end

    x -= GetDisabledControlNormal(0, 1)
    y -= GetDisabledControlNormal(0, 2)

    if y < math.rad(15) then y = math.rad(15) end
    if y > math.rad(90) then y = math.rad(90) end

    local normal = vector3(math.sin(y) * math.cos(x), math.sin(y) * math.sin(x), math.cos(y))
    local pos = playerCoords + normal * camera_radius
    local hit, coords = GetShapeTestResultSync(StartShapeTestLosProbe(playerCoords, pos, -1, playerPed))
    local camCoords = (hit == 1 and playerCoords + normal * (#(playerCoords - coords) - 1)) or pos

    SetCamCoord(camera, camCoords)
    PointCamAtCoord(camera, playerCoords.x, playerCoords.y, playerCoords.z)
end

function GetShapeTestResultSync(shape)
    local handle, hit, coords, normal, entity
    repeat
        handle, hit, coords, normal, entity = GetShapeTestResult(shape)
        Wait(0)
    until handle ~= 1
    return hit, coords, normal, entity
end
