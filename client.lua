AddEventHandlerNew = function(name, func)
    RegisterNetEvent(name)
    AddEventHandler(name, func)
end

local useLocalData = { }
useLocalData.player = { }
useLocalData.player.status = false
useLocalData.list = { }
useLocalData.keyDown = false

AddEventHandlerNew('CheckPlayer', function(pID, securyKey)
    Citizen.CreateThread(function()
        local rStatus = -1
        while true do
            Citizen.Wait(0)
            for i = 0, 31 do
                if IsNetworkPlayerActive(i) then
                    if(ConvertIntToPlayerindex(i) == ConvertIntToPlayerindex(GetPlayerId())) then
                        rStatus = i
                    end
                end
            end

            if rStatus ~= -1 then
                break
            end
        end
        SendNUIMessage({
            pack = "START",
            sKey = securyKey,
            pName = GetPlayerName(),
            pId = rStatus
    
        })
    end)
    
end)



function SetPlayerChannel(pChannel) 
    if pChannel >= 0 and pChannel < getSettings.limitRadioVoiceChat then
        SendNUIMessage({
            pack = "START_FUNCTION",
            func = "SetPlayerChannel",
            args = { 
                [1] = pChannel 
            }
        })
        return true
    else
        return false
    end
end

function SetPlayerVolume(pId, pVolume) 
    if pVolume >= 0.0 and pVolume < 1.0 then
        SendNUIMessage({
            pack = "START_FUNCTION",
            func = "SetPlayerVolume",
            args = { 
                [1] = pId,
                [2] = pVolume 
            }
        })
        return true
    else
        return false
    end
end


RegisterNUICallback('StartSearchPlayers', function(data, cb)
    cb('!')
    Citizen.Trace("\n[Main Voice] StartSearchPlayers")
    useLocalData.player = data
    useLocalData.player.status = true
    TriggerServerEvent('ConnectToMeAccept', data)
end)

AddEventHandlerNew('ResultConnectToMeAccept', function(data)
    --[[Citizen.Trace("\n[Main Voice]  ` 'ResultConnectToMeAccept'")
    if data.pId ~= useLocalData.player.pId then
        Citizen.Trace("\n[Main Voice] if data.pId ~= useLocalData.player.pId then")
        if useLocalData["list"][data.pId] == nil then
            useLocalData["list"][data.pId] = { }
        end
        useLocalData["list"][data.pId].lastuse = 15
        useLocalData["list"][data.pId].pName = data.pName
        useLocalData["list"][data.pId].pId = data.pId
    end]]
end)

RegisterNUICallback('PlayerConnectedToVoice', function(data, cb)
    cb('a')
    useLocalData["list"][data.pId].lastuse = -1
    --TriggerServerEvent('ConnectToPlayer', useLocalData["list"][data.pId].pId, useLocalData["list"][data.pId].pName)
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if useLocalData.player.status == true then
            for i = 0, 31 do
                if IsNetworkPlayerActive(i) then
                    if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
                        if useLocalData["list"][i] == nil then
                            useLocalData["list"][i] = { }
                            useLocalData["list"][i].lastuse = 15
                            useLocalData["list"][i].pName = GetPlayerName(i)
                            useLocalData["list"][i].pId = i
                        else
                            if useLocalData["list"][i].pName ~= GetPlayerName(i) then
                                useLocalData["list"][i] = { }
                                useLocalData["list"][i].lastuse = 15
                                useLocalData["list"][i].pName = GetPlayerName(i)
                                useLocalData["list"][i].pId = i
                                SendNUIMessage({
                                    pack = "DISCONNECT",
                                    pId = useLocalData["list"][i].pId
                                })
                            else
                                if useLocalData["list"][i].lastuse == 15 then
                                    useLocalData["list"][i].lastuse = 14
                                    SendNUIMessage({
                                        pack = "CONNECT",
                                        pId = useLocalData["list"][i].pId,
                                        pName = GetPlayerName(i)
                                    })
                                elseif useLocalData["list"][i].lastuse > 0 then
                                    useLocalData["list"][i].lastuse = useLocalData["list"][i].lastuse - 1
                                elseif useLocalData["list"][i].lastuse == 0 then
                                    useLocalData["list"][i].lastuse = 15
                                elseif useLocalData["list"][i].lastuse == -1 then
                                    
                                end
                            end
                            
                        end
                    end
                else
                    if useLocalData["list"][i] ~= nil then
                        SendNUIMessage({ pack = "DISCONNECT", pId = useLocalData["list"][i].pId })
                        useLocalData["list"][i] = nil
                    end
                end
            end 
        end
    end
end)

AddEventHandlerNew('ResultVOICE_L', function(pId, keyStatus)
    if useLocalData.player.pId ~= pId then
        SendNUIMessage({ pack = "CHANGE_PLAYER_VOICE", set = keyStatus, pId = pId })
    end
end)

Citizen.CreateThread(function()
    local keyblock = 0 
    local keyradio = 0 
    while true do
        Citizen.Wait(1)
        if IsGameKeyboardKeyPressed(50) then
            if keyblock == 0 then
                if keyradio == 1 then
                    keyradio = 0
                    SendNUIMessage({ pack = "VOICE_R", set = keyradio })
                    TriggerServerEvent('VOICE_R', useLocalData.player.pId, keyradio)
                end

                keyblock = 1
                SendNUIMessage({ pack = "VOICE_L", set = keyblock })
                TriggerServerEvent('VOICE_L', useLocalData.player.pId, keyblock)
            end
        else 
            if keyblock == 1 then
                keyblock = 0
                SendNUIMessage({ pack = "VOICE_L", set = keyblock })
                TriggerServerEvent('VOICE_L', useLocalData.player.pId, keyblock)
            end
        end

        if IsGameKeyboardKeyPressed(49) then
            if keyradio == 0 and keyblock == 0 then
                keyradio = 1
                SendNUIMessage({ pack = "VOICE_R", set = keyradio })
                TriggerServerEvent('VOICE_R', useLocalData.player.pId, keyradio)
            end
        else 
            if keyradio == 1 and keyblock == 0 then
                keyradio = 0
                SendNUIMessage({ pack = "VOICE_R", set = keyradio })
                TriggerServerEvent('VOICE_R', useLocalData.player.pId, keyradio)
            end
        end
    end
end)