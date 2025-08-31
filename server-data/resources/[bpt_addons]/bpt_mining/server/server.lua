local ox_inventory = exports.ox_inventory

RegisterServerEvent("empire_miner:giveItems", function()
    local src = source

    for _, reward in pairs(Config.RewardItems) do
        if math.random(1, 100) <= reward.chance then
            ox_inventory:AddItem(src, reward.item, reward.count)
        end
    end
end)
