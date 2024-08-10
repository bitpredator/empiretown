function LoadAnimDict(dict)
    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

function LoadAnimSet(animSet)
    RequestAnimSet(animSet)

    while not HasAnimSetLoaded(animSet) do
        Wait(0)
    end
end

function MathRound(v, numDecimal)
    if math.type(v) ~= "float" then
        v += 0.0
    end

    if numDecimal then
        local power = 10 ^ numDecimal
        return math.floor(v * power + 0.5) / power
    end

    return math.floor(v + 0.5)
end

if Config.Framework == "esx" then
    local playerData = {
        accounts = {},
        job = {},
    }

    local societyMoney = nil

    local function parsePlayerJob(job, xPlayerJob)
        job.id = xPlayerJob.name
        job.name = xPlayerJob.label
        job.gradeName = xPlayerJob.grade_label
        job.isBoss = xPlayerJob.grade_name == "boss"
    end

    function GetPlayerAccounts()
        return playerData.accounts
    end

    function GetPlayerJob()
        return playerData.job
    end

    function GetSocietyMoney()
        return societyMoney
    end

    local function refreshMoney()
        local playerJob = GetPlayerJob()

        if playerJob.isBoss then
            ESX.TriggerServerCallback("esx_society:getSocietyMoney", function(money)
                societyMoney = money
            end, playerJob.id)
        end
    end

    RegisterNetEvent("esx:setJob", function(job)
        parsePlayerJob(playerData.job, job)
        refreshMoney()
    end)

    RegisterNetEvent("bpt_addonaccount:setMoney", function(societyId, money)
        local playerJob = GetPlayerJob()
        if playerJob.isBoss and ("society_%s"):format(playerJob.id) == societyId then
            societyMoney = money
        end
    end)

    function GameNotification(msg)
        ESX.ShowNotification(msg)
    end

    function GetClosestPlayer()
        return ESX.Game.GetClosestPlayer()
    end

    function GroupDigits(number)
        return ESX.Math.GroupDigits(number)
    end

    function TriggerServerCallback(name, cb, ...)
        ESX.TriggerServerCallback(name, cb, ...)
    end

    CreateThread(function()
        ESX = exports["es_extended"]:getSharedObject()

        while not ESX.GetPlayerData().job do
            Wait(100)
        end
    end)
end
