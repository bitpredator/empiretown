local ALARM_NAME = "PRISON_ALARMS"
local PRISON_COORDS = vector3(1787.004, 2593.1984, 45.7978)
local INTERIOR_TYPE = "int_prison_main"
local INTERIOR_PROP = "prison_alarm"

-- Funzione per ottenere l'interno
local function getPrisonInterior()
    local interior = GetInteriorAtCoordsWithType(PRISON_COORDS.x, PRISON_COORDS.y, PRISON_COORDS.z, INTERIOR_TYPE)
    RefreshInterior(interior)
    return interior
end

-- Funzione per preparare e avviare l'allarme
local function startPrisonAlarm()
    CreateThread(function()
        while not PrepareAlarm(ALARM_NAME) do
            Wait(100)
        end
        StartAlarm(ALARM_NAME, true)
    end)
end

-- Funzione per fermare l'allarme
local function stopPrisonAlarm()
    CreateThread(function()
        while not PrepareAlarm(ALARM_NAME) do
            Wait(100)
        end
        StopAllAlarms(true)
    end)
end

-- Comando per accendere l'allarme
RegisterCommand("alarm_on", function()
    local interior = getPrisonInterior()
    EnableInteriorProp(interior, INTERIOR_PROP)
    startPrisonAlarm()
end, false)

-- Comando per spegnere l'allarme
RegisterCommand("alarm_off", function()
    local interior = getPrisonInterior()
    DisableInteriorProp(interior, INTERIOR_PROP)
    stopPrisonAlarm()
end, false)
