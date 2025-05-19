RegisterNUICallback("get-houses", function(_, cb)
    lib.callback("b-phone:server:GetHouses", false, function(houses)
        for i, v in pairs(houses) do
            houses[i].image = "https://raw.githubusercontent.com/bitpredator/assets/main/houses/" .. v.id .. ".jpg"
            houses[i].keyholders = json.decode(v.keyholders)
        end

        cb(houses)
    end)
end)

RegisterNUICallback("get-direction", function(body, cb)
    SetNewWaypoint(body.coords.enter.x, body.coords.enter.y)
    xCore.Notify("GPS has been set to " .. body.name .. "!", "success")
    cb("ok")
end)
