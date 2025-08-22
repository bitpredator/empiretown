lib.callback.register("z-phone:server:LoopsLogin", function(source, body)
    local Player = xCore.GetPlayerBySource(source)

    if Player ~= nil then
        local citizenid = Player.citizenid
        local checkUserQuery = "select id from zp_loops_users where username = ? and password = ?"
        local id = MySQL.scalar.await(checkUserQuery, {
            body.username,
            body.password,
        })

        if not id then
            return {
                is_valid = false,
                message = "Nome utente o password non corretti",
            }
        end

        MySQL.update.await("UPDATE zp_users SET active_loops_userid = ? WHERE citizenid = ?", {
            id,
            citizenid,
        })

        local profileQuery = [[
            SELECT 
                zplu.id,
                zplu.fullname,
                zplu.username,
                zplu.avatar,
                zplu.cover,
                zplu.bio,
                DATE_FORMAT(zplu.join_at, '%d %b %Y') as join_at,
                zplu.is_verified,
                zplu.is_allow_message,
                zplu.phone_number
            FROM zp_loops_users zplu
            WHERE zplu.id = ?
        ]]

        local profile = MySQL.single.await(profileQuery, {
            id,
        })

        return {
            is_valid = true,
            message = "Bentornato @" .. body.username,
            profile = profile,
        }
    end

    return {
        is_valid = false,
        message = "Riprova più tardi!",
    }
end)

lib.callback.register("z-phone:server:LoopsSignup", function(source, body)
    local Player = xCore.GetPlayerBySource(source)

    if Player ~= nil then
        local citizenid = Player.citizenid
        local checkUsernameQuery = "select id from zp_loops_users where username = ?"
        local duplicateUsername = MySQL.scalar.await(checkUsernameQuery, {
            body.username,
        })

        if duplicateUsername then
            return {
                is_valid = false,
                message = "@" .. body.username .. " non disponibile",
            }
        end

        local query = "INSERT INTO zp_loops_users (citizenid, username, password, fullname, phone_number) VALUES (?, ?, ?, ?, ?)"
        local id = MySQL.insert.await(query, {
            citizenid,
            body.username,
            body.password,
            body.fullname,
            body.phone_number,
        })

        if id then
            TriggerClientEvent("z-phone:client:sendNotifInternal", Player.source, {
                type = "Notification",
                from = "Loops",
                message = "Perfetto, effettua il login!",
            })
            local content = [[
Benvenuto a bordo! \
\
Nome utente: @%s \
Nome completo : %s \
Password : %s \
Numero di telefono : %s \
\
Siamo felici di averti con noi. Il tuo account Loops è stato creato con successo e sei pronto per esplorare tutte le funzionalità. \
Per iniziare, accedi al tuo account e scopri tutti i post. \
\
Non vediamo l’ora di vederti entrare nel Loopsverse!
    ]]
            MySQL.single.await("INSERT INTO zp_emails (institution, citizenid, subject, content) VALUES (?, ?, ?, ?)", {
                "loops",
                Player.citizenid,
                "Il tuo account " .. body.username .. " è stato creato",
                string.format(content, body.username, body.fullname, body.password, body.phone_number),
            })
            return {
                is_valid = true,
                message = "Loops @" .. body.username .. " è stato creato",
            }
        else
            return {
                is_valid = false,
                message = "Scegli un altro nome utente!",
            }
        end
    end

    return {
        is_valid = false,
        message = "Riprova più tardi!",
    }
end)
