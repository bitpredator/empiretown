local function setOutfit(outfit)
    local ped = PlayerPedId()

    RequestModel(outfit.ped)

    while not HasModelLoaded(outfit.ped) do
        Wait(0)
    end

    if GetEntityModel(ped) ~= GetHashKey(outfit.ped) then
        SetPlayerModel(PlayerId(), outfit.ped)
    end

    ped = PlayerPedId()

    for _, comp in ipairs(outfit.components) do
       SetPedComponentVariation(ped, comp[1], comp[2] - 1, comp[3] - 1, 0)
    end

    for _, comp in ipairs(outfit.props) do
        if comp[2] == 0 then
            ClearPedProp(ped, comp[1])
        else
            SetPedPropIndex(ped, comp[1], comp[2] - 1, comp[3] - 1, true)
        end
    end
end

local categoryOutfits = {}

for name, outfit in pairs(outfits) do
    if not categoryOutfits[outfit.category] then
        categoryOutfits[outfit.category] = {}
    end

    categoryOutfits[outfit.category][name] = outfit
end

local menuPool = NativeUI.CreatePool()
local mainMenu = NativeUI.CreateMenu('EUP FiveM', 'Pick your outfit!')

for name, list in pairs(categoryOutfits) do
    local subMenu = menuPool:AddSubMenu(mainMenu, name)

    for id, outfit in pairs(list) do
        outfit.item = NativeUI.CreateItem(id, 'Select this outfit.')
        subMenu:AddItem(outfit.item)
    end

    subMenu.OnItemSelect = function(sender, item, index)
        -- find the outfit
        for _, outfit in pairs(list) do
            if outfit.item == item then
                CreateThread(function()
                    setOutfit(outfit)
                end)
            end
        end
    end
end

menuPool:Add(mainMenu)

menuPool:RefreshIndex()

RegisterCommand('eup', function()
    mainMenu:Visible(not mainMenu:Visible())
end, false)

CreateThread(function()
    while true do
        Wait(0)

        menuPool:ProcessMenus()
    end
end)