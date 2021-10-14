local sec = ""
function randomstring(length)
    local chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    local randomString = ''

    math.randomseed(os.time())

    charTable = {}
    for c in chars:gmatch"." do
        table.insert(charTable, c)
    end

    for i = 1, length do
        randomString = randomString .. charTable[math.random(1, #charTable)]
    end
    
    return randomString
end

RegisterServerEvent("GetMeMyIdNow")
AddEventHandler('GetMeMyIdNow', function()
    if sec == "" then
        sec = randomstring(10)
        print("Genereted Voice Secure ID: "..sec)
    end
    local kokos = source
    TriggerClientEvent('ResultYouId', kokos, kokos, sec)
    print('SendIDs = '..kokos)
    
end)


RegisterServerEvent('PlsChangeMyVoice')
AddEventHandler('PlsChangeMyVoice', function(status)

    TriggerClientEvent('SetValueByPlayerVoice', -1, source, status)

end)

AddEventHandler('playerDropped', function(reason)
    TriggerClientEvent('DeletePlayerVoiceChat', -1, source)
end)

RegisterServerEvent('PlsChangeMyVoiceByRadio')
AddEventHandler('PlsChangeMyVoiceByRadio', function(status, channel)

    TriggerClientEvent('SetValueByPlayerVoiceRadio', -1, source, status, channel)

end)

RegisterServerEvent('PlsAddMeToVoiceChat')
AddEventHandler('PlsAddMeToVoiceChat', function(toplayerid, playerid, anem)
    TriggerClientEvent('ResultPlsAddMeToVoiceChat', toplayerid, playerid, anem)
end)