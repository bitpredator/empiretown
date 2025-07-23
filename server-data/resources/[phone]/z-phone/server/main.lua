local WebHook = 'https://discord.com/api/webhooks/'

lib.callback.register('z-phone:server:HasPhone', function(source)
    return xCore.HasItemByName(source, 'phone')
end)

lib.callback.register('z-phone:server:GetWebhook', function(_)
    if WebHook ~= '' then
        return WebHook
    else
        print('Set your webhook to ensure that your camera will work!!!!!! Set this on line 10 of the server sided script!!!!!')
        return nil
    end
end)