RegisterNUICallback("get-photos", function(_, cb)
    lib.callback("b-phone:server:GetPhotos", false, function(photos)
        cb(photos)
    end)
end)

RegisterNUICallback("save-photos", function(body, cb)
    body.location = GetStreetName()
    lib.callback("b-phone:server:SavePhotos", false, function(isOk)
        if isOk then
            xCore.Notify("Successful save to gallery!", "success")
        end
        cb(isOk)
    end, body)
end)

RegisterNUICallback("delete-photos", function(body, cb)
    lib.callback("b-phone:server:DeletePhotos", false, function(isOk)
        if isOk then
            xCore.Notify("Successful delete from gallery!", "success")
        end

        lib.callback("b-phone:server:GetPhotos", false, function(photos)
            cb(photos)
        end)
    end, body)
end)
