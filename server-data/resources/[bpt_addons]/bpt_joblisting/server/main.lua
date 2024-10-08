function GetJobs()
    local jobs = ESX.GetJobs()
    local availableJobs = {}
    for k, v in pairs(jobs) do
        if v.whitelisted == false then
            availableJobs[#availableJobs + 1] = { label = v.label, name = k }
        end
    end
    return availableJobs
end

ESX.RegisterServerCallback("bpt_joblisting:getJobsList", function(source, cb)
    local jobs = GetJobs()
    cb(jobs)
end)

function IsJobAvailable(job)
    local jobs = ESX.GetJobs()
    local JobToCheck = jobs[job]
    return not JobToCheck.whitelisted
end

function IsNearCentre(player)
    local Ped = GetPlayerPed(player)
    local PedCoords = GetEntityCoords(Ped)
    local _ = Config.Zones
    local Close = false

    for i = 1, #Config.Zones, 1 do
        local distance = #(PedCoords - Config.Zones[i])

        if distance < Config.DrawDistance then
            Close = true
        end
    end

    return Close
end

RegisterServerEvent("bpt_joblisting:setJob")
AddEventHandler("bpt_joblisting:setJob", function(job)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local _ = GetJobs()

    if xPlayer and IsNearCentre(source) and IsJobAvailable(job) then
        if ESX.DoesJobExist(job, 0) then
            xPlayer.setJob(job, 0)
        else
            print("[^1ERROR^7] Tried Setting User ^5" .. source .. "^7 To Invalid Job - ^5" .. job .. "^7!")
        end
    else
        print("[^3WARNING^7] User ^5" .. source .. "^7 Attempted to Exploit ^5`bpt_joblisting:setJob`^7!")
    end
end)
