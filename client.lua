local uiBuffer = {}
local myid = -1
local sec = ""
local radioChannel = 1

local voiceactive = false
AddEventHandlerNew = function(name, func)
    RegisterNetEvent(name)
    AddEventHandler(name, func)
end
AddEventHandlerNew('ResultYouId', function(ids, secu)
    Citizen.CreateThread(function()
        if ids == -1 then
            Citizen.Wait(2000)
            TriggerServerEvent('GetMeMyIdNow')
        
        end
        sec = secu
        myid = ids
    end)
    
end)
RegisterNUICallback('getstatus', function(data, cb)
    local localBuf = uiBuffer
    uiBuffer = {}

    cb(localBuf)
end)
AddEventHandlerNew('ChangeMyRadioChannel', function(idchannel)
    radioChannel = idchannel
end)
local startvoice = 0
local voiceschatplayers = { }
local mynames = ""
function StartLoadingVoice() 
        local players = GetPlayers()
        for _, player in ipairs(players) do
            if GetPlayerServerId(player) ~= myid then
                if voiceschatplayers[GetPlayerServerId(player)] == nil then
                    Citizen.Wait(1500)
                    SendNUIMessage({
                        meta = 'adduser',
                        db = GetPlayerServerId(player),
                        myid = myid,
                        name = GetPlayerName(player)
                    })
                    
                    TriggerServerEvent('PlsAddMeToVoiceChat', GetPlayerServerId(player), myid, GetPlayerName(GetPlayerId()))
                    voiceschatplayers[GetPlayerServerId(player)] = 1
                end
            
            end
        end
        
end
RegisterNUICallback('goodload', function(data, cb)
    TriggerServerEvent('GetMeMyIdNow')
    Citizen.CreateThread(function()
        while true do
            if myid > 0 and sec ~= "" then
                SendNUIMessage({
                    meta = 'getmyids',
                    smyid = myid, 
                    secure = sec
                })
                
                startvoice = 1
                break
            end
            Citizen.Wait(1000)
        end
    end)
    cb('ok')
end)

RegisterNUICallback('SendMessageCust', function(data, cb)
   
    Citizen.Trace("\nVOICE: ".. data.msgactig.."\n")
    TriggerEvent('AddConsoleCommand', "Voice Chat",data.msgactig)
    --cb('ok')
end)

AddEventHandlerNew('NewPlayerConnectToVoice', function(playerid, name)
    
    Citizen.CreateThread(function()
        while true do
            if myid > 0 then
                if myid ~= playerid then
                    SendNUIMessage({
                        meta = 'adduser',
                        db = playerid,
                        myid = myid,
                        name = name
                    })
                    
                    --PollUI()

                    
                    break
                
                end
                
            end
            Citizen.Wait(100)
        end
        while true do
            Citizen.Wait(100)
            local numwait = tonumber(GetPlayerId())
            if numwait then
                Citizen.Wait(numwait*100)
                TriggerServerEvent('PlsAddMeToVoiceChat', playerid, numwait)
                break
            end
        end
    end)
    
end)

AddEventHandlerNew('ResultPlsAddMeToVoiceChat', function(playerid, name)
    if voiceschatplayers[playerid] == nil then
        SendNUIMessage({
            meta = 'adduser',
            db = playerid,
            myid = myid,
            name = name
        })
        
        voiceschatplayers[playerid] = 1
    end
        
end)

function IsPlayerNearCoords(x, y, z, radius)
    local pos = table.pack(GetCharCoordinates(GetPlayerChar(-1)))
    local dist = GetDistanceBetweenCoords3d(x, y, z, pos[1], pos[2], pos[3]-1.1);
	if dist < radius then 
		return true
	else 
		return false
    end
end

AddEventHandlerNew('DeletePlayerVoiceChat', function(playerid)
    SendNUIMessage({
        meta = 'deletevoiceuser',
        player = playerid
    })
    
end)
local playervoices = { }
local playersonclipsaoduo = {

}
AddEventHandlerNew('SetValueByPlayerVoiceRadio', function(playerid, status, channel)
    if radioChannel == channel then
        SendNUIMessage({
            meta = 'setstatusvoiceradio',
            player = playerid,
            volume = status
        })
        
        if status == 1 then
            playersonclipsaoduo[playerid] = 1
        else
            playersonclipsaoduo[playerid] = nil
        end
    end

end)
AddEventHandlerNew('ActivateIconMicro', function()
    
    SendNUIMessage({
        meta = 'activeloginmicro'
    })
    
end)
local playerspeding = {

}
AddEventHandlerNew('AddNewUserVoiceChat', function(playerid)
    playerspeding[playerid] = 1
end)
AddEventHandlerNew('SetValueByPlayerVoice', function(playerid, status)
    
        SendNUIMessage({
            meta = 'setstatusvoice',
            player = playerid,
            volume = status
        })
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if startvoice == 1 then
            Citizen.Wait(5000)
            StartLoadingVoice()
        end
    end
end)
local volumsplayer = { }
Citizen.CreateThread(function()
    while true do
       Citizen.Wait(1)
       local players = GetPlayers()
        for _, player in ipairs(players) do
            
            if GetPlayerServerId(player) ~= myid then
                if playerspeding[GetPlayerServerId(player)] then
                    if playersonclipsaoduo[GetPlayerServerId(player)] then
                        local pos = table.pack(GetCharCoordinates(GetPlayerChar(player)))
                        local posx = table.pack(GetCharCoordinates(GetPlayerChar(-1)))
                        local ns = GetDistanceBetweenCoords3d(pos[1], pos[2], pos[3]-1.1, posx[1], posx[2], posx[3]-1.1);
      
                        if volumsplayer[GetPlayerServerId(player)] == nil then
                            volumsplayer[GetPlayerServerId(player)] = ns
                        else
                            if ns < 40 then

                                if volumsplayer[GetPlayerServerId(player)] ~= ns then
                                
                                    SendNUIMessage({
                                        meta = 'setvolumeplayer',
                                        player = GetPlayerServerId(player),
                                        volume = ns
                                    })
                                    
                                    Citizen.Wait(5000)
                                end
                            end
                        end
                    end
                
                end
                
                
            end
        end
        
    end

end)
local chatst = 0
local chatstnewl = 0
Citizen.CreateThread(function()
    while true do
       Citizen.Wait(1)
        if IsGameKeyboardKeyPressed(49) then
            if chatstnewl == 0 and chatst == 0 then
                chatstnewl = 1
                TriggerServerEvent('PlsChangeMyVoiceByRadio', 1, radioChannel)
                voiceactive = true
                SendNUIMessage({
                    meta = 'voiceonr'
                })
                
            end
        else
            if chatstnewl == 1 then
                chatstnewl = 0
                TriggerServerEvent('PlsChangeMyVoiceByRadio', 0, radioChannel)
                voiceactive = true
                SendNUIMessage({
                    meta = 'voiceoff'
                })
            end
        end  
        if IsGameKeyboardKeyPressed(50) then
            if chatst == 0 and chatstnewl == 0 then
                chatst = 1
                TriggerServerEvent('PlsChangeMyVoice', 1)
                voiceactive = true
                SendNUIMessage({
                    meta = 'voiceon'
                })
                
                
            end
        else
            
            if chatst == 1 then
                chatst = 0
                TriggerServerEvent('PlsChangeMyVoice', 0)
                voiceactive = false
                SendNUIMessage({
                    meta = 'voiceoff'
                })
            
            end
        end  
    end

end)