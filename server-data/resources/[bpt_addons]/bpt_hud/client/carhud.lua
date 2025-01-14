-- SCREEN POSITION PARAMETERS
local screenPosX = 0.165 -- X coordinate (top left corner of HUD)
local screenPosY = 0.882 -- Y coordinate (top left corner of HUD)

-- GENERAL PARAMETERS
local enableController = true -- Enable controller inputs

-- SPEEDOMETER PARAMETERS
local speedLimit = 100.0 -- Speed limit for changing speed color
local speedColorText = { 255, 255, 255 } -- Color used to display speed label text
local speedColorUnder = { 255, 255, 255 } -- Color used to display speed when under speedLimit
local speedColorOver = { 255, 96, 96 } -- Color used to display speed when over speedLimit

-- FUEL PARAMETERS
local fuelShowPercentage = true -- Show fuel as a percentage (disabled shows fuel in liters)
local fuelWarnLimit = 25.0 -- Fuel limit for triggering warning color
local fuelColorText = { 255, 255, 255 } -- Color used to display fuel text
local fuelColorOver = { 255, 255, 255 } -- Color used to display fuel when good
local fuelColorUnder = { 255, 96, 96 } -- Color used to display fuel warning

-- LOCATION AND TIME PARAMETERS
local locationAlwaysOn = false -- Always display location and time
local locationColorText = { 255, 255, 255 } -- Color used to display location and time

-- Globals
local pedInVeh = false
local timeText = ""
local currentFuel = 0.0

-- Main thread
CreateThread(function()
    -- Initialize local variable
    local currSpeed = 0.0
    local cruiseSpeed = 999.0
    local prevVelocity = { x = 0.0, y = 0.0, z = 0.0 }
    local cruiseIsOn = false

    while true do
        -- Loop forever and update HUD every frame
        Wait(0)

        -- Get player PED, position and vehicle and save to locals
        local player = PlayerPedId()
        local position = GetEntityCoords(player)
        local vehicle = GetVehiclePedIsIn(player, false)

        -- Set vehicle states
        if IsPedInAnyVehicle(player, false) then
            pedInVeh = true
        else
            -- Reset states when not in car
            pedInVeh = false
            cruiseIsOn = false
        end

        -- Display Location and time when in any vehicle or on foot (if enabled)
        if pedInVeh or locationAlwaysOn then
            -- Display remainder of HUD when engine is on and vehicle is not a bicycle
            local vehicleClass = GetVehicleClass(vehicle)
            if pedInVeh and GetIsVehicleEngineRunning(vehicle) and vehicleClass ~= 13 then
                -- Save previous speed and get current speed
                local prevSpeed = currSpeed
                currSpeed = GetEntitySpeed(vehicle)

                -- Set PED flags
                SetPedConfigFlag(PlayerPedId(), 32, true)

                -- When player in driver seat, handle cruise control
                if GetPedInVehicleSeat(vehicle, -1) == player then
                    -- Check if cruise control button pressed, toggle state and set maximum speed appropriately
                    if IsControlJustReleased(0, 19) and (enableController or GetLastInputMethod(0) == 0) then
                        cruiseIsOn = not cruiseIsOn
                        cruiseSpeed = currSpeed
                    end
                    local maxSpeed = cruiseIsOn and cruiseSpeed or GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel")
                    SetEntityMaxSpeed(vehicle, maxSpeed)
                else
                    -- Reset cruise control
                    cruiseIsOn = false
                end

                -- Check what units should be used for speed
                if ShouldUseMetricMeasurements() then
                    -- Get vehicle speed in KPH and draw speedometer
                    local speed = currSpeed * 3.6
                    local speedColor = (speed >= speedLimit) and speedColorOver or speedColorUnder
                    DrawTxt(("%.3d"):format(math.ceil(speed)), 2, speedColor, 0.8, screenPosX + 0.000, screenPosY + 0.000)
                    DrawTxt("KPH", 2, speedColorText, 0.4, screenPosX + 0.030, screenPosY + 0.018)
                else
                    -- Get vehicle speed in MPH and draw speedometer
                    local speed = currSpeed * 2.23694
                    local speedColor = (speed >= speedLimit) and speedColorOver or speedColorUnder
                    DrawTxt(("%.3d"):format(math.ceil(speed)), 2, speedColor, 0.8, screenPosX + 0.000, screenPosY + 0.000)
                    DrawTxt("MPH", 2, speedColorText, 0.4, screenPosX + 0.030, screenPosY + 0.018)
                end

                -- Draw fuel gauge
                local fuelColor = (currentFuel >= fuelWarnLimit) and fuelColorOver or fuelColorUnder
                DrawTxt(("%.3d"):format(math.ceil(currentFuel)), 2, fuelColor, 0.8, screenPosX + 0.055, screenPosY + 0.000)
                DrawTxt("FUEL", 2, fuelColorText, 0.4, screenPosX + 0.085, screenPosY + 0.018)

                -- Draw cruise control status
                local cruiseColor = cruiseIsOn and speedColorOver or speedColorUnder
                DrawTxt("CRUISE", 2, cruiseColor, 0.4, screenPosX + 0.020, screenPosY + 0.048)
            end
        end
    end
end)

-- Secondary thread to update strings
CreateThread(function()
    while true do
        -- Update when player is in a vehicle or on foot (if enabled)
        if pedInVeh or locationAlwaysOn then
            -- Get player, position and vehicle
            local player = PlayerPedId()
            local _ = GetEntityCoords(player)

            -- Update fuel when in a vehicle
            if pedInVeh then
                local vehicle = GetVehiclePedIsIn(player, false)
                if fuelShowPercentage then
                    -- Display remaining fuel as a percentage
                    currentFuel = 100 * GetVehicleFuelLevel(vehicle) / GetVehicleHandlingFloat(vehicle, "CHandlingData", "fPetrolTankVolume")
                else
                    -- Display remainign fuel in liters
                    currentFuel = GetVehicleFuelLevel(vehicle)
                end
            end

            -- Update every second
            Wait(1000)
        else
            -- Wait until next frame
            Wait(0)
        end
    end
end)

-- Helper function to draw text to screen
function DrawTxt(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(colour[1], colour[2], colour[3], 255)
    SetTextEntry("STRING")
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end
