---@diagnostic disable: undefined-global

local ESX = exports["es_extended"]:getSharedObject()

-- =========================
-- VARIABILI
-- =========================
local jobBlips = {}
local shopBlips = {}
local textUIVisible = false

-- =========================
-- MARKER CONFIG
-- =========================
local MARKER_TYPE = 1
local MARKER_DRAW_DIST = 10.0
local MARKER_SIZE = vec3(0.45, 0.45, 0.45)

local MARKER_COLOR_SHOP = { r = 0, g = 180, b = 255, a = 150 }
local MARKER_COLOR_STASH = { r = 255, g = 50, b = 50, a = 150 }

-- =========================
-- ESX EVENTS
-- =========================
RegisterNetEvent("esx:playerLoaded", function(xPlayer)
    ESX.PlayerData = xPlayer
    ESX.PlayerLoaded = true
    refreshJobBlips()
end)

RegisterNetEvent("esx:onPlayerLogout", function()
    ESX.PlayerLoaded = false
    ESX.PlayerData = {}
end)

RegisterNetEvent("esx:setJob", function(job)
    ESX.PlayerData.job = job
    refreshJobBlips()
end)

-- =========================
-- BLIP FUNCTIONS
-- =========================
local function createBlip(data)
    local blip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
    SetBlipSprite(blip, data.sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, data.scale)
    SetBlipColour(blip, data.color)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.label)
    EndTextCommandSetBlipName(blip)

    return blip
end

function refreshJobBlips()
    for _, blip in pairs(jobBlips) do
        RemoveBlip(blip)
    end
    jobBlips = {}

    if not ESX.PlayerLoaded or not ESX.PlayerData.job then
        return
    end

    for shopName, shop in pairs(Config.Shops) do
        if shop.blip.stash.enabled and ESX.PlayerData.job.name == shopName then
            jobBlips[#jobBlips + 1] = createBlip(shop.blip.stash)
        end
    end
end

-- =========================
-- CREATE SHOP BLIPS (PUBLIC)
-- =========================
CreateThread(function()
    for _, shop in pairs(Config.Shops) do
        if shop.blip.shop.enabled then
            shopBlips[#shopBlips + 1] = createBlip(shop.blip.shop)
        end
    end
end)

-- =========================
-- SET PRODUCT PRICE (SECURE)
-- =========================
RegisterNetEvent("bpt_oxshops:setProductPrice", function(shop, slot)
    if not ESX.PlayerLoaded or not ESX.PlayerData.job or ESX.PlayerData.job.name ~= shop then
        print("[ANTICHEAT] Tentativo setProductPrice non autorizzato")
        return
    end

    local input = lib.inputDialog(Strings.sell_price, { Strings.amount_input })
    local price = tonumber(input and input[1])

    if not price or price < 0 then
        return
    end

    TriggerEvent("ox_inventory:closeInventory")
    TriggerServerEvent("bpt_oxshops:setData", shop, slot, math.floor(price))

    lib.notify({
        title = Strings.success,
        description = (Strings.item_stocked_desc):format(price),
        type = "success",
    })
end)

-- =========================
-- MAIN LOOP (MARKER + UI)
-- =========================
CreateThread(function()
    while true do
        local sleep = 1500
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for shopName, shopData in pairs(Config.Shops) do
            local stash = shopData.locations.stash
            local shop = shopData.locations.shop

            local distStash = #(coords - stash.coords)
            local distShop = #(coords - shop.coords)

            -- =====================
            -- STASH (JOB LOCKED)
            -- =====================
            if ESX.PlayerData.job and ESX.PlayerData.job.name == shopName then
                if distStash <= MARKER_DRAW_DIST then
                    sleep = 0
                    DrawMarker(
                        MARKER_TYPE,
                        stash.coords.x,
                        stash.coords.y,
                        stash.coords.z - 0.95,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        MARKER_SIZE.x,
                        MARKER_SIZE.y,
                        MARKER_SIZE.z,
                        MARKER_COLOR_STASH.r,
                        MARKER_COLOR_STASH.g,
                        MARKER_COLOR_STASH.b,
                        MARKER_COLOR_STASH.a,
                        false,
                        true,
                        2,
                        false,
                        nil,
                        nil,
                        false
                    )
                end

                if distStash <= stash.range then
                    if not textUIVisible then
                        lib.showTextUI(stash.string)
                        textUIVisible = true
                    end

                    if IsControlJustReleased(0, 38) then
                        exports.ox_inventory:openInventory("stash", shopName)
                    end
                end
            end

            -- =====================
            -- SHOP (PUBLIC)
            -- =====================
            if distShop <= MARKER_DRAW_DIST then
                sleep = 0
                DrawMarker(MARKER_TYPE, shop.coords.x, shop.coords.y, shop.coords.z - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, MARKER_SIZE.x, MARKER_SIZE.y, MARKER_SIZE.z, MARKER_COLOR_SHOP.r, MARKER_COLOR_SHOP.g, MARKER_COLOR_SHOP.b, MARKER_COLOR_SHOP.a, false, true, 2, false, nil, nil, false)
            end

            if distShop <= shop.range then
                if not textUIVisible then
                    lib.showTextUI(shop.string)
                    textUIVisible = true
                end

                if IsControlJustReleased(0, 38) then
                    exports.ox_inventory:openInventory("shop", {
                        type = shopName,
                        id = 1,
                    })
                end
            end

            -- =====================
            -- HIDE UI
            -- =====================
            if distStash > stash.range and distShop > shop.range and textUIVisible then
                lib.hideTextUI()
                textUIVisible = false
            end
        end

        Wait(sleep)
    end
end)
