local pedInSameVehicleLast = false
local vehicle, lastVehicle, vehicleClass, tireBurstLuckyNumber
local healthEngineLast, healthEngineCurrent, healthEngineNew = 1000.0, 1000.0, 1000.0
local healthBodyLast, healthBodyCurrent, healthBodyNew = 1000.0, 1000.0, 1000.0
local healthPetrolTankLast, healthPetrolTankCurrent, healthPetrolTankNew = 1000.0, 1000.0, 1000.0

local ESX = exports["es_extended"]:getSharedObject()
math.randomseed(GetGameTimer())

local tireBurstMaxNumber = cfg.randomTireBurstInterval * 1200
if cfg.randomTireBurstInterval ~= 0 then
    tireBurstLuckyNumber = math.random(tireBurstMaxNumber)
end

Citizen.CreateThread(function()
    while not ESX.GetPlayerData().job do
        Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    PlayerData.job = job
end)

local function isPedDrivingAVehicle()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    return IsPedInAnyVehicle(ped, false) and GetPedInVehicleSeat(veh, -1) == ped and not ({
        [15] = true, [16] = true, [21] = true, [13] = true
    })[GetVehicleClass(veh)]
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        if isPedDrivingAVehicle() then
            local ped = PlayerPedId()
            vehicle = GetVehiclePedIsIn(ped, false)
            vehicleClass = GetVehicleClass(vehicle)

            healthEngineCurrent = GetVehicleEngineHealth(vehicle)
            healthBodyCurrent = GetVehicleBodyHealth(vehicle)
            healthPetrolTankCurrent = GetVehiclePetrolTankHealth(vehicle)

            if vehicle ~= lastVehicle then
                pedInSameVehicleLast = false
            end

            if pedInSameVehicleLast then
                local damageFactor = cfg.classDamageMultiplier[vehicleClass] or 1.0
                local healthDeltaScaled = math.max(
                    (healthEngineLast - healthEngineCurrent) * cfg.damageFactorEngine * damageFactor,
                    (healthBodyLast - healthBodyCurrent) * cfg.damageFactorBody * damageFactor,
                    (healthPetrolTankLast - healthPetrolTankCurrent) * cfg.damageFactorPetrolTank * damageFactor
                )

                healthEngineNew = math.max(cfg.engineSafeGuard, healthEngineLast - healthDeltaScaled)
                if healthEngineNew < cfg.cascadingFailureThreshold then
                    healthEngineNew = healthEngineNew - (0.1 * cfg.cascadingFailureSpeedFactor)
                end
                healthPetrolTankNew = math.max(cfg.compatibilityMode and 1 or 750, healthPetrolTankNew)
                healthBodyNew = math.max(0, healthBodyNew)
            end

            lastVehicle = vehicle
            pedInSameVehicleLast = true
        end
    end
end)
