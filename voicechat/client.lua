AddEventHandlerNew = function(name, func)
    RegisterNetEvent(name)
    AddEventHandler(name, func)
end

local useLocalData = { }
useLocalData.player = { }
useLocalData.player.status = false
useLocalData.list = { }
useLocalData.keyDown = false
useLocalData.BanMicrophone = false
useLocalData.PlayerTalking = false
useLocalData.channel = 0
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
            pId = rStatus,
            settings = getSettings
    
        })
    end)
    
end)



function SetPlayerChannel(pChannel) 
    if pChannel >= 0 and pChannel < getSettings.limitRadioVoiceChat then
        useLocalData.channel = pChannel
        return true
    else
        return false
    end
end

function SetPlayerVolume(pId, pVolume) 
    if pVolume >= 0.0 and pVolume <= 1.0 then
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
local IsPlayerConnectedResult = nil
RegisterNUICallback('IsPlayerConnected', function(data, cb)
    cb('ok')
    IsPlayerConnectedResult = data.result
end)

function IsPlayerConnected(pId)
    local tResult = false
    if pId > 0 and pId < 32 then
        IsPlayerConnectedResult = nil
        SendNUIMessage({
            pack = "START_FUNCTION",
            func = "IsPlayerConnected",
            args = { 
                [1] = pId
            }
        })
        while true do
            Citizen.Wait(0)
            if IsPlayerConnectedResult ~= nil then
                break
            end
        end
        tResult = IsPlayerConnectedResult
    end
    return tResult
end

function BanMicrophone(pStatus)
    local convertParam = false
    if pStatus == true or pStatus == 1 then
        convertParam = true
    end
    SendNUIMessage({
        pack = "START_FUNCTION",
        func = "BanMicrophone",
        args = { 
            [1] = convertParam
        }
    })
    useLocalData.BanMicrophone = convertParam
    return convertParam
end

function PlayerHasBanMicrophone()
    return useLocalData.BanMicrophone
end

function ChangeSettingsKeys(tLocalKey, tRadioKey)
    local tResult = false
    if (tLocalKey > 0 and tLocalKey < 212) and (tRadioKey > 0 and tRadioKey < 212) then
        tResult = true
        getSettings.keyVoiceChat = tLocalKey
        getSettings.keyRadioVoiceChat = tRadioKey
    else
        tResult = false
    end
    return tResult
end

local GetPlayerChannelResult = nil
RegisterNUICallback('GetPlayerChannel', function(data, cb)
    cb('ok')
    GetPlayerChannelResult = data.result
end)

function GetPlayerChannel()
    return useLocalData.channel
end

local PlayerIsTalkingResult = nil
RegisterNUICallback('PlayerIsTalking', function(data, cb)
    cb('ok')
    PlayerIsTalkingResult = data.result
end)

function PlayerIsTalking()
    return useLocalData.PlayerTalking
end


local GetPlayerVolumeResult = nil
RegisterNUICallback('GetPlayerVolume', function(data, cb)
    cb('ok')
    GetPlayerVolumeResult = data.result
end)

function GetPlayerVolume(pId)
    local tResult = 0.0

    if pId >= 0 and pId < 32 then
        GetPlayerVolumeResult = nil
        SendNUIMessage({
            pack = "START_FUNCTION",
            func = "GetPlayerVolume",
            args = { 
                [1] = pId
            }
        })
        while true do
            Citizen.Wait(0)
            if GetPlayerVolumeResult ~= nil then
                break
            end
        end
        tResult = GetPlayerVolumeResult
    end 

    return tResult
end
RegisterNUICallback('StartSearchPlayers', function(data, cb)
    cb('!')
    Citizen.Trace("\n[Main Voice] StartSearchPlayers")
    useLocalData.player = data
    useLocalData.player.status = true
    TriggerServerEvent('ConnectToMeAccept', data)
end)

AddEventHandlerNew('ResultConnectToMeAccept', function(data) end)

RegisterNUICallback('PlayerConnectedToVoice', function(data, cb)
    cb('a')
    useLocalData["list"][data.pId].lastuse = -1
end)
Citizen.CreateThread(function()
    while getSettings.enabledVoiceChat do
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
                            useLocalData["list"][i].volumeBlink = false
                            useLocalData["list"][i].channelActive = false
                        else
                            if useLocalData["list"][i].pName ~= GetPlayerName(i) then
                                useLocalData["list"][i] = { }
                                useLocalData["list"][i].lastuse = 15
                                useLocalData["list"][i].pName = GetPlayerName(i)
                                useLocalData["list"][i].pId = i
                                useLocalData["list"][i].volumeBlink = false
                                useLocalData["list"][i].channelActive = false
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
AddEventHandlerNew('ResultVOICE_R', function(pId, keyStatus, pChannel)
    if useLocalData.player.pId ~= pId and pChannel == useLocalData.channel then
        SendNUIMessage({ pack = "CHANGE_PLAYER_VOICE_R", set = keyStatus, pId = pId })
        if keyStatus == 1 then 
            SetPlayerVolume(pId, 1.0)
            useLocalData["list"][i].channelActive = true
        else 
            SetPlayerVolume(pId, 0.0) 
            useLocalData["list"][i].channelActive = false 
        end
    end
end)
AddEventHandlerNew('ResultVOICE_L', function(pId, keyStatus)
    if useLocalData.player.pId ~= pId then
        SendNUIMessage({ pack = "CHANGE_PLAYER_VOICE", set = keyStatus, pId = pId })
    end
end)
Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1)
        for i = 0, 31 do
            if IsNetworkPlayerActive(i) and useLocalData["list"][i] ~= nil and (not useLocalData["list"][i].channelActive) then
                if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
                    local ped = GetPlayerChar(i)
                    local rX, rY, rZ =  GetCharCoordinates(ped)
                    local x, y, z = GetCharCoordinates(GetPlayerChar(-1))
                    local dist = GetDistanceBetweenCoords3d(x, y, z, rX, rY, rZ)
                    if dist < getSettings.localVoiceChatDistance then
                        local newVol = 1 - (dist / getSettings.localVoiceChatDistance)
                        if not useLocalData["list"][i].volumeBlink then
                            if newVol < 0.1 then 
                                newVol = 0.0 
                                useLocalData["list"][i].volumeBlink = true 
                            end
                            if newVol > 1 then newVol = 1.0 end
                            SetPlayerVolume(i, newVol)
                        elseif  newVol > 0.1 then
                            useLocalData["list"][i].volumeBlink = false
                            if newVol > 1 then newVol = 1.0 end
                            SetPlayerVolume(i, newVol)
                        end
                    end
                    
                end
            end
        end 
    end
end)
Citizen.CreateThread(function()
    local keyblock = 0 
    local keyradio = 0 
    while getSettings.enabledVoiceChat do
        Citizen.Wait(1)
        if useLocalData.BanMicrophone == false then
            

            if IsGameKeyboardKeyPressed(getSettings.keyVoiceChat) then
                if keyblock == 0 then
                    useLocalData.PlayerTalking = true
                    keyblock = 1
                    SendNUIMessage({ pack = "VOICE_L", set = keyblock })
                    TriggerServerEvent('VOICE_L', useLocalData.player.pId, keyblock)
                end
            else 
                if keyblock == 1 then
                    keyblock = 0
                    useLocalData.PlayerTalking = false
                    SendNUIMessage({ pack = "VOICE_L", set = keyblock })
                    TriggerServerEvent('VOICE_L', useLocalData.player.pId, keyblock)
                end
            end

            if IsGameKeyboardKeyPressed(getSettings.keyRadioVoiceChat) then
                if keyradio == 0 and keyblock == 0 then
                    if keyblock == 1 then
                        keyblock = 0
                        SendNUIMessage({ pack = "VOICE_L", set = keyblock })
                        TriggerServerEvent('VOICE_L', useLocalData.player.pId, keyblock)
                    end
                    keyradio = 1
                    useLocalData.PlayerTalking = true
                    SendNUIMessage({ pack = "VOICE_R", set = keyradio })
                    TriggerServerEvent('VOICE_R', useLocalData.player.pId, keyradio, useLocalData.channel)
                end
            else 
                if keyradio == 1 and keyblock == 0 then
                    keyradio = 0
                    useLocalData.PlayerTalking = false
                    SendNUIMessage({ pack = "VOICE_R", set = keyradio })
                    TriggerServerEvent('VOICE_R', useLocalData.player.pId, keyradio, useLocalData.channel)
                end
            end
        else
            if keyblock == 1 then
                keyblock = 0
                useLocalData.PlayerTalking = false
                SendNUIMessage({ pack = "VOICE_L", set = keyblock })
                TriggerServerEvent('VOICE_L', useLocalData.player.pId, keyblock)
            end

            if keyradio == 1 then
                keyradio = 0
                useLocalData.PlayerTalking = false
                SendNUIMessage({ pack = "VOICE_R", set = keyradio })
                TriggerServerEvent('VOICE_R', useLocalData.player.pId, keyradio, useLocalData.channel)
            end
        end
    end
end)