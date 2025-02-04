---@diagnostic disable: undefined-global

local isDead = false

RegisterCommand("showbills", function()
    if not isDead then
        showBillsMenu()
    end
end, false)

AddEventHandler("esx:onPlayerDeath", function()
    isDead = true
end)
AddEventHandler("esx:onPlayerSpawn", function()
    isDead = false
end)
