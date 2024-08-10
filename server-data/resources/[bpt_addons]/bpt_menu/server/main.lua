ESX = exports["es_extended"]:getSharedObject()

do
    local origRegisterServerEvent = RegisterServerEvent
    local origEsxRegisterServerCallback = ESX.RegisterServerCallback

    RegisterServerEvent = function(eventName, ...)
        local endIdx = ("bpt_personalmenu:"):len()

        if eventName:sub(1, endIdx) == "bpt_personalmenu" then
            local oldEventName = ("bpt-PersonalMenu:%s"):format(eventName:sub(endIdx + 1))

            origRegisterServerEvent(oldEventName)
            AddEventHandler(oldEventName, function()
                DropPlayer(
                    source,
                    ("Server detected a potentially abusive behaviour.\n" .. "If you're not an abuser please contact the server owner so he can fix the underlying issue.\n\n" .. "- DEBUG INFO -\n" .. "Resource Name : %s\n" .. "Event Name : %s"):format(GetCurrentResourceName(), oldEventName)
                )
            end)
        end

        return origRegisterServerEvent(eventName, ...)
    end

    ESX.RegisterServerCallback = function(eventName, ...)
        local endIdx = ("bpt_personalmenu:"):len()

        if eventName:sub(1, endIdx) == "bpt_personalmenu" then
            local oldEventName = ("bpt-PersonalMenu:%s"):format(eventName:sub(endIdx + 1))

            origEsxRegisterServerCallback(oldEventName, function(source)
                DropPlayer(
                    source,
                    ("Server detected a potentially abusive behaviour.\n" .. "If you're not an abuser please contact the server owner so he can fix the underlying issue.\n\n" .. "- DEBUG INFO -\n" .. "Resource Name : %s\n" .. "Event Name : %s"):format(GetCurrentResourceName(), oldEventName)
                )
            end)
        end

        return origEsxRegisterServerCallback(eventName, ...)
    end
end

function getMaximumGrade(jobName)
    local p = promise.new()

    MySQL.Async.fetchScalar("SELECT grade FROM job_grades WHERE job_name = @job_name ORDER BY `grade` DESC", { ["@job_name"] = jobName }, function(result)
        p:resolve(result)
    end)

    local queryResult = Citizen.Await(p)

    return tonumber(queryResult)
end

function getAdminCommand(name)
    for i = 1, #Config.Admin do
        if Config.Admin[i].name == name then
            return i
        end
    end

    return false
end

function isAuthorized(index, group)
    for i = 1, #Config.Admin[index].groups do
        if Config.Admin[index].groups[i] == group then
            return true
        end
    end

    return false
end

ESX.RegisterServerCallback("bpt_personalmenu:Admin_getUsergroup", function(source, cb)
    cb(ESX.GetPlayerFromId(source).getGroup() or "user")
end)

local function makeTargetedEventFunction(fn)
    return function(target, ...)
        if tonumber(target) == -1 then
            return
        end
        fn(target, ...)
    end
end

-- Grade Menu --
RegisterServerEvent("bpt_personalmenu:Boss_promoteplayer")
AddEventHandler(
    "bpt_personalmenu:Boss_promoteplayer",
    makeTargetedEventFunction(function(target)
        local sourceXPlayer = ESX.GetPlayerFromId(source)
        local sourceJob = sourceXPlayer.getJob()

        if sourceJob.grade_name == "boss" then
            local targetXPlayer = ESX.GetPlayerFromId(target)
            local targetJob = targetXPlayer.getJob()

            if sourceJob.name == targetJob.name then
                local newGrade = tonumber(targetJob.grade) + 1

                if newGrade ~= getMaximumGrade(targetJob.name) then
                    targetXPlayer.setJob(targetJob.name, newGrade)
                    TriggerClientEvent("esx:showNotification", sourceXPlayer.source, TranslateCap("promoted"):format(targetXPlayer.name))
                    TriggerClientEvent("esx:showNotification", target, TranslateCap("you_promoted"):format(sourceXPlayer.name))
                else
                    TriggerClientEvent("esx:showNotification", sourceXPlayer.source, TranslateCap("not_permission"))
                end
            else
                TriggerClientEvent("esx:showNotification", sourceXPlayer.source, TranslateCap("player_not_your_company"))
            end
        else
            TriggerClientEvent("esx:showNotification", sourceXPlayer.source, TranslateCap("not_permission"))
        end
    end)
)

RegisterServerEvent("bpt_personalmenu:Boss_dismissplayer")
AddEventHandler(
    "bpt_personalmenu:Boss_dismissplayer",
    makeTargetedEventFunction(function(target)
        local sourceXPlayer = ESX.GetPlayerFromId(source)
        local sourceJob = sourceXPlayer.getJob()

        if sourceJob.grade_name == "boss" then
            local targetXPlayer = ESX.GetPlayerFromId(target)
            local targetJob = targetXPlayer.getJob()

            if sourceJob.name == targetJob.name then
                local newGrade = tonumber(targetJob.grade) - 1

                if newGrade >= 0 then
                    targetXPlayer.setJob(targetJob.name, newGrade)
                    TriggerClientEvent("esx:showNotification", sourceXPlayer.source, TranslateCap("you_been_relegated"):format(targetXPlayer.name))
                    TriggerClientEvent("esx:showNotification", target, TranslateCap("demoted_from"):format(sourceXPlayer.name))
                else
                    TriggerClientEvent("esx:showNotification", sourceXPlayer.source, TranslateCap("not_downgrade"))
                end
            else
                TriggerClientEvent("esx:showNotification", sourceXPlayer.source, TranslateCap("player_not_your_company"))
            end
        else
            TriggerClientEvent("esx:showNotification", sourceXPlayer.source, TranslateCap("not_permission"))
        end
    end)
)

RegisterServerEvent("bpt_personalmenu:Boss_recruitplayer")
AddEventHandler(
    "bpt_personalmenu:Boss_recruitplayer",
    makeTargetedEventFunction(function(target)
        local sourceXPlayer = ESX.GetPlayerFromId(source)
        local sourceJob = sourceXPlayer.getJob()

        if sourceJob.grade_name == "boss" then
            local targetXPlayer = ESX.GetPlayerFromId(target)

            targetXPlayer.setJob(sourceJob.name, 0)
            TriggerClientEvent("esx:showNotification", sourceXPlayer.source, TranslateCap("you_hired"):format(targetXPlayer.name))
            TriggerClientEvent("esx:showNotification", target, TranslateCap("you_hired_by"):format(sourceXPlayer.name))
        end
    end)
)

RegisterServerEvent("bpt_personalmenu:Boss_fireplayer")
AddEventHandler(
    "bpt_personalmenu:Boss_fireplayer",
    makeTargetedEventFunction(function(target)
        local sourceXPlayer = ESX.GetPlayerFromId(source)
        local sourceJob = sourceXPlayer.getJob()

        if sourceJob.grade_name == "boss" then
            local targetXPlayer = ESX.GetPlayerFromId(target)
            local targetJob = targetXPlayer.getJob()

            if sourceJob.name == targetJob.name then
                targetXPlayer.setJob("unemployed", 0)
                TriggerClientEvent("esx:showNotification", sourceXPlayer.source, TranslateCap("you_fired"):format(targetXPlayer.name))
                TriggerClientEvent("esx:showNotification", target, TranslateCap("you_were_fired"):format(sourceXPlayer.name))
            else
                TriggerClientEvent("esx:showNotification", sourceXPlayer.source, TranslateCap("player_not_your_company"))
            end
        else
            TriggerClientEvent("esx:showNotification", sourceXPlayer.source, TranslateCap("not_permission"))
        end
    end)
)
