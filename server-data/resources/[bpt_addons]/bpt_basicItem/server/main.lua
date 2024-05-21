ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterUsableItem("idcard", function(source)
    local _source = source
    TriggerClientEvent("IDCARD:USE", _source)
end)

ESX.RegisterUsableItem("dmvcard", function(source)
    local _source = source
    TriggerClientEvent("DMVCARD:USE", _source)
end)

ESX.RegisterUsableItem("licensecard", function(source)
    local _source = source
    TriggerClientEvent("WCARD:USE", _source)
end)
