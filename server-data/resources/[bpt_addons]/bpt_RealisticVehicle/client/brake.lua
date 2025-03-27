local brakeTemp = 0.0 -- Initial brake temperature
local maxBrakeTemp = 100.0 -- Maximum temperature before overheating
local overheating = false
local particleDict = "core"
local smokeParticle = "ent_sht_steam" -- Smoke
local sparkParticle = "ent_dst_elec_fire_sp" -- Sparks

-- Load particle effects
Citizen.CreateThread(function()
    RequestNamedPtfxAsset(particleDict)
    while not HasNamedPtfxAssetLoaded(particleDict) do
        Citizen.Wait(10)
    end
end)

-- Main loop to monitor braking
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100) -- Check every 100ms
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            local speed = GetEntitySpeed(vehicle) * 3.6 -- Convert to KM/H
            local isBraking = IsControlPressed(0, 72) -- 'S' button or brake

            -- Temperature increases if we brake at high speeds
            if isBraking and speed > 30 then
                brakeTemp = brakeTemp + 0.8
            else
                brakeTemp = math.max(brakeTemp - 0.5, 0) -- Cooling
            end

            -- If maximum temperature exceeded, activate effects
            if brakeTemp >= maxBrakeTemp and not overheating then
                overheating = true
                TriggerBrakeEffects(vehicle) -- Visual effects
            elseif brakeTemp < (maxBrakeTemp - 20) then
                overheating = false
            end
        else
            brakeTemp = 0 -- Reset if player exits vehicle
        end
    end
end)

-- Overheating effect function
function TriggerBrakeEffects(vehicle)
    for i = 0, 3 do -- Apply to all wheels
        local boneIndex = GetEntityBoneIndexByName(vehicle, i % 2 == 0 and "wheel_lf" or "wheel_rf")

        -- Smoke effect
        UseParticleFxAssetNextCall(particleDict)
        StartParticleFxLoopedOnEntityBone(smokeParticle, vehicle, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, boneIndex, 1.0, false, false, false)

        -- Sparkles effect
        UseParticleFxAssetNextCall(particleDict)
        StartParticleFxLoopedOnEntityBone(sparkParticle, vehicle, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, boneIndex, 1.0, false, false, false)

        Citizen.Wait(200)
    end

    -- Change neon color to simulate glowing discs
    if IsVehicleNeonLightEnabled(vehicle, 2) then
        SetVehicleNeonLightsColour(vehicle, 255, 50, 0) -- Fiery red
    end

    -- Sound of damaged brakes
    PlaySoundFromEntity(-1, "Scrape", vehicle, "DLC_HEIST_FLEECA_SOUNDSET", false, 0)

    -- Brakes less effective temporarily
    Citizen.CreateThread(function()
        local originalBrakeForce = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fBrakeForce")
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fBrakeForce", originalBrakeForce * 0.6) -- 40% less effective
        Citizen.Wait(5000) -- After 5 seconds, reset the brakes
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fBrakeForce", originalBrakeForce)
    end)
end
