if GetResourceState("ox_core") ~= "started" then
    return
end

local file = ("imports/%s.lua"):format(IsDuplicityVersion() and "server" or "client")
local import = LoadResourceFile("ox_core", file)
local chunk = assert(load(import, ("@@ox_core/%s"):format(file)))
local player
chunk()

function IsBlacklistedJob(jobs)
    return player.hasGroup(jobs)
end

AddEventHandler("ox:playerLogout", function()
    TriggerEvent("xt-robnpcs:client:onUnload")
end)
