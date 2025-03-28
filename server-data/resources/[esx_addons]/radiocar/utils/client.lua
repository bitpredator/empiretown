ESX = exports["es_extended"]:getSharedObject()

-- Funzione per controllare se il veicolo appartiene al giocatore e aprire la UI
function CheckPlayerCar(vehicle)
    if ESX and ESX.Game and ESX.Game.GetVehicleProperties then
        local veh = ESX.Game.GetVehicleProperties(vehicle)
        TriggerServerEvent("radiocar:openUI", veh.plate)
    else
        TriggerServerEvent("radiocar:openUI", GetVehicleNumberPlateText(vehicle))
    end
end

-- Funzione di permessi speciali (modificabile per VIP, amministratori, ecc.)
function YourSpecialPermission()
    -- Modifica questa funzione per aggiungere restrizioni personalizzate
    return true
end
