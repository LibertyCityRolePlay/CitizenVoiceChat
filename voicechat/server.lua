local securyKey = nil
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

AddEventHandler('playerActivated', function()
	if securyKey == nil then
        securyKey = randomstring(10)
    end
    TriggerClientEvent('CheckPlayer', source, source, securyKey)
	
end)

RegisterServerEvent('ConnectToPlayer')
AddEventHandler('ConnectToPlayer', function(pId, pName)

end)

RegisterServerEvent('ConnectToMeAccept')
AddEventHandler('ConnectToMeAccept', function(data)
    TriggerClientEvent('ResultConnectToMeAccept', -1, data)
end)

RegisterServerEvent('VOICE_L')
AddEventHandler('VOICE_L', function(pId, keyStatus)
    print('VOICE_L '.. pId .. " " .. keyStatus)
    TriggerClientEvent('ResultVOICE_L', -1, pId, keyStatus)
end)

RegisterServerEvent('VOICE_R')
AddEventHandler('VOICE_R', function(pId, keyStatus, channel)
    TriggerClientEvent('ResultVOICE_R', -1, pId, keyStatus, channel)
end)