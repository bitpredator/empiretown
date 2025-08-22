lib.callback.register('z-phone:server:GetBank', function(source)
    local Player = xCore.GetPlayerBySource(source)
    if Player ~= nil then
        local citizenid = Player.citizenid

        local histories = xCore.bankHistories(citizenid)
        local bills = xCore.bankInvoices(citizenid)

        return {
            histories = histories,
            bills = bills,
            balance = Player.money.bank
        }
    end
    return {}
end)

lib.callback.register('z-phone:server:PayInvoice', function(source, body)
    local Player = xCore.GetPlayerBySource(source)
    if Player == nil then
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = "Portafoglio",
            message = "Pagamento fattura fallito"
        })
        return false
    end

    if Player.money.bank < body.amount then 
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = "Portafoglio",
            message = "Saldo insufficiente"
        })
        return false
    end

    local citizenid = Player.citizenid
    local invoice = xCore.bankInvoiceByCitizenID(body.id, citizenid)

    if not invoice then
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = "Portafoglio",
            message = "Pagamento fattura fallito"
        })
        return false
    end

    Player.removeAccountMoney('bank', invoice.amount, invoice.reason)

    xCore.AddMoneyBankSociety(invoice.society, invoice.amount, invoice.reason)
    xCore.deleteBankInvoiceByID(invoice.id)

    TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
        type = "Notification",
        from = "Portafoglio",
        message = "Fattura pagata con successo"
    })
    return true
end)

lib.callback.register('z-phone:server:TransferCheck', function(source, body)
    local Player = xCore.GetPlayerBySource(source)
    if Player == nil then 
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = "Portafoglio",
            message = "Errore nel controllare il destinatario!"
        })
        return {
            isValid = false,
            name = ""
        }
    end

    local citizenid = Player.citizenid
    local queryGetCitizenByIban = "select citizenid from zp_users where iban = ?"
    local receiverCitizenid = MySQL.scalar.await(queryGetCitizenByIban, {
        body.iban
    })

    if not receiverCitizenid then
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = "Portafoglio",
            message = "IBAN non registrato!"
        })
        return {
            isValid = false,
            name = ""
        }
    end

    if receiverCitizenid == citizenid then
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = "Portafoglio",
            message = "Non puoi trasferire a te stesso!"
        })
        return {
            isValid = false,
            name = ""
        }
    end

    local ReceiverPlayer = xCore.GetPlayerByIdentifier(receiverCitizenid)
    if ReceiverPlayer == nil then 
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = "Portafoglio",
            message = "Il destinatario è offline!"
        })
        return {
            isValid = false,
            name = ""
        }
    end

    return {
        isValid = true,
        name = ReceiverPlayer.charinfo.firstname .. ' '.. ReceiverPlayer.charinfo.lastname
    }
end)

lib.callback.register('z-phone:server:Transfer', function(source, body)
    local Player = xCore.GetPlayerBySource(source)
    if Player == nil then 
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = "Portafoglio",
            message = "Errore nel controllare il destinatario!"
        })
        return false
    end

    local citizenid = Player.citizenid

    if Player.money.bank < body.total then 
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = "Portafoglio",
            message = "Saldo insufficiente"
        })
        return false
    end

    local queryGetCitizenByIban = "select citizenid from zp_users where iban = ?"
    local receiverCitizenid = MySQL.scalar.await(queryGetCitizenByIban, {
        body.iban
    })

    if not receiverCitizenid then
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = "Portafoglio",
            message = "IBAN non registrato!"
        })
        return false
    end

    if receiverCitizenid == citizenid then
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = "Portafoglio",
            message = "Non puoi trasferire a te stesso!"
        })
        return false
    end

    local ReceiverPlayer = xCore.GetPlayerByIdentifier(receiverCitizenid)
    if ReceiverPlayer == nil then 
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = "Portafoglio",
            message = "Il destinatario è offline!"
        })
        return false
    end

    local senderReason = string.format("Trasferimento inviato: %s - a %s", body.note, body.iban)
    local receiverReason = string.format("%s - da %s", "Trasferimento ricevuto", body.iban)
    Player.removeAccountMoney('bank', body.total, senderReason)
    ReceiverPlayer.addAccountMoney('bank', body.total, receiverReason)

    local content = [[
Siamo lieti di informarti che il tuo recente trasferimento di denaro è stato completato con successo. 
\
Dettagli della transazione:
\
Totale: %s \
IBAN : %s \
Nota : %s \
\
Se hai domande o hai bisogno di ulteriore assistenza, non esitare a contattarci.

Grazie per aver scelto i nostri servizi!
]]
    MySQL.Async.insert('INSERT INTO zp_emails (institution, citizenid, subject, content) VALUES (?, ?, ?, ?)', {
        "wallet",
        Player.citizenid,
        "Conferma trasferimento denaro riuscito",
        string.format(content, body.total, body.iban, body.note),
    })

    TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
        type = "Notification",
        from = "Portafoglio",
        message = "Trasferimento eseguito con successo"
    })

    TriggerClientEvent("z-phone:client:sendNotifInternal", ReceiverPlayer.source, {
        type = "Notification",
        from = "Portafoglio",
        message = "Hai ricevuto un trasferimento"
    })
    return true
end)
