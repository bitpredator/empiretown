local ESX = exports["es_extended"]:getSharedObject()

-- Evento per aprire la ID Card (personale o di un altro player)
RegisterNetEvent("bpt_idcard:open", function(ID, targetID, docType)
    local src = source
    local player = ESX.GetPlayerFromId(ID)
    local target = ESX.GetPlayerFromId(targetID)

    if not player then
        print(("[bpt_idcard] ⚠️ Errore: player ID %s non trovato."):format(ID))
        return
    end

    if not target then
        print(("[bpt_idcard] ⚠️ Errore: target ID %s non trovato."):format(targetID))
        return
    end

    local identifier = player.getIdentifier()

    -- Query combinata: utente + licenze
    MySQL.query("SELECT firstname, lastname, dateofbirth, sex, height FROM users WHERE identifier = ?", { identifier }, function(userResult)
        if not userResult[1] then
            print(("[bpt_idcard] ⚠️ Nessun utente trovato per identifier %s"):format(identifier))
            return
        end

        MySQL.query("SELECT type FROM user_licenses WHERE owner = ?", { identifier }, function(licensesResult)
            local show = false
            local user = userResult[1]
            local licenses = licensesResult or {}

            if docType == "driver" then
                for _, license in ipairs(licenses) do
                    if license.type == "drive" or license.type == "drive_bike" or license.type == "drive_truck" then
                        show = true
                        break
                    end
                end
            elseif docType == "weapon" then
                for _, license in ipairs(licenses) do
                    if license.type == "weapon" then
                        show = true
                        break
                    end
                end
            else
                show = true
            end

            if show then
                local data = {
                    firstname = user.firstname or "N/D",
                    lastname = user.lastname or "N/D",
                    dateofbirth = user.dateofbirth or "N/D",
                    sex = user.sex or "N/D",
                    height = user.height or "N/D",
                    licenses = licenses,
                }

                TriggerClientEvent("bpt_idcard:open", target.source, data, docType)
                print(("[bpt_idcard] ✅ Documento '%s' inviato da %s → %s"):format(docType or "idcard", ID, targetID))
            else
                TriggerClientEvent("esx:showNotification", target.source, "❌ Nessuna licenza valida per questo documento.")
            end
        end)
    end)
end)
