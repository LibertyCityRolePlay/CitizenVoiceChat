let useLocalDate = { };
let allPlayersList = { };
let IvContPeer = { };
let useDebugMode = false;
let debugIds = 0;
let localMuted = false;
useLocalDate.pChannel = 0;
useLocalDate.pVolume = 1.0;
IvContPeer.READY = 1;
IvContPeer.WAIT = 2;
IvContPeer.NOSET = 3;
IvContPeer.WAITSTART = 4;
IvContPeer.ERROR = 5;
IvContPeer.BTNCLICK = 6;
IvContPeer.RADIOBTNCLICK = 7;
IvContPeer.LuaConverted = [ ];
IvContPeer.LuaConverted.START = 'START';
IvContPeer.LuaConverted.CONNECT = 'CONNECT';
IvContPeer.LuaConverted.DISCONNECT = 'DISCONNECT';
IvContPeer.LuaConverted.VOICE = 'VOICE_L';
IvContPeer.LuaConverted.VOICER = "VOICE_R";
IvContPeer.LuaConverted.LUAFUNCTION = "START_FUNCTION";
IvContPeer.LuaConverted.CHANGEVOICE = "CHANGE_PLAYER_VOICE";
IvContPeer.LuaConverted.CHANGEVOICER = "CHANGE_PLAYER_VOICE_R";
IvContPeer.LuaConverted.SET_PLAYER_CHANNEL = "SetPlayerChannel";
IvContPeer.LuaConverted.SET_PLAYER_VOLUME = "SetPlayerVolume";
IvContPeer.LuaConverted.IS_PLAYER_CONNECTED = "IsPlayerConnected";
IvContPeer.LuaConverted.BAN_MICROPHONE = "BanMicrophone";
IvContPeer.LuaConverted.PLAYER_HAS_BAN = "PlayerHasBan";
IvContPeer.LuaConverted.GET_PLAYER_CHANNEL = "GetPlayerChannel";
IvContPeer.LuaConverted.PLAYER_IS_TALKING = "PlayerIsTalking";
IvContPeer.LuaConverted.GET_PLAYER_VOLUME = "GetPlayerVolume";
if(!useDebugMode) { $("#debugContainer").hide(); }
$('#micro').hide();
IvContPeer.SetClientStatus = function(status) {
    IvContPeer.DebugLog("SET STATUS " + status);
    if(status != -1) {
        useLocalDate.pStatus = status;
    }
    if (localMuted) {
        $('#micro').attr('src', useLocalDate["settings"]["useIcons"].muteVoiceChat);
        $('#micro').show();
    }
    else if(status == -1) {
        $('#micro').hide();
    }
    else {
        switch(status)
        {
            case IvContPeer.READY: { $('#micro').hide(); break; }
            case IvContPeer.BTNCLICK: { $('#micro').attr('src', useLocalDate["settings"]["useIcons"].onVoiceChat); $('#micro').show(); break; }
            case IvContPeer.RADIOBTNCLICK: { $('#micro').attr('src', useLocalDate["settings"]["useIcons"].onRadioVoiceChat); $('#micro').show(); break; }
            case IvContPeer.ERROR: { $('#micro').attr('src', useLocalDate["settings"]["useIcons"].errorVoiceChat); $('#micro').show(); break; }
        }
    }
}

IvContPeer.DebugLog = function(text) {
    if(useDebugMode) {
        console.log(`[ALV-VoiceChat] ${text}`);
        $("#debugContainer").html(`${$("#debugContainer").html()} 
        <div id="sl-${debugIds}">
            <h6>${text}</h6>
            <script type="text/javascript">
                setTimeout(function() {
                    $("#thisid-`+debugIds+`").fadeOut(400, function()
                    {
                        $("#thisid-`+debugIds+`").remove();
                    });
                }, 7500);
            </script>
        </div>  
        `);
        debugIds += 1;
        $("#debugContainer").scrollTop(1000);
    }
    return useDebugMode;
}

IvContPeer.LuaConverted.SendLuaData = function(nameHandler, dataObj) {
    $.post(`http://voicechat/${nameHandler}`, JSON.stringify(dataObj), function(data) { IvContPeer.DebugLog(` ${data}`); });
}

IvContPeer.SetConsole = function(text, status) {
    if(status) {
        IvContPeer.DebugLog(useLocalDate);
        IvContPeer.DebugLog(allPlayersList);
        IvContPeer.DebugLog(IvContPeer);
        IvContPeer.DebugLog(`
        useLocalDate: ${useLocalDate}
        allPlayersList: ${allPlayersList}
        IvContPeer: ${IvContPeer}
        ((${text}))
        `);
    }
    else
    {
        IvContPeer.DebugLog(` (((${text})))`);
    }
    
}

IvContPeer.sHandlers = [ ];
IvContPeer.sHandlers.Call = function(call) {
    IvContPeer.SetConsole("The player has connected to us.", true);
    IvContPeer.SetConsole("Microphone search...", false);
    navigator.getUserMedia({video: false, audio: true}, function(stream) {
        IvContPeer.SetConsole(`Microphone found.`, false);
        
        stream.getAudioTracks()[0].enabled = true;
        call.answer(stream); 
        call.on('stream', function(remoteStream) {
            IvContPeer.SetConsole("The player has connected to us. (Successfully)", false);
        });
    });
    
}
IvContPeer.sHandlers.Open = function(id) {
    IvContPeer.SetConsole(`Open Succ (${id})`, false);
    IvContPeer.SetConsole("Waiting for players", false);
    IvContPeer.LuaConverted.SendLuaData('StartSearchPlayers', { pId: useLocalDate.pId, pName: useLocalDate.pName });
    navigator.getUserMedia({video: false, audio: true}, function(stream) {
        IvContPeer.SetClientStatus(IvContPeer.READY); 
    });
    IvContPeer.sPeer.on('call', IvContPeer.sHandlers.Call)
}

function StartLocalClient(SecuryID, pId, pName) {
    useLocalDate.sID = SecuryID;
    useLocalDate.pId = pId;
    useLocalDate.pName = pName;
    useLocalDate.pChannel = useLocalDate["settings"].defaultRadioVoiceChat;
    IvContPeer.SetClientStatus(IvContPeer.WAITSTART);
    IvContPeer.SetConsole(`Starting VoiceChat. (${useLocalDate.pId}${useLocalDate.sID})`, true);
    
    IvContPeer.sPeer = new Peer(`${useLocalDate.pId}${useLocalDate.sID}`);
    IvContPeer.SetConsole("Peer handler succ created!", true);
    IvContPeer.SetConsole("Listening for connections", false);
    IvContPeer.sPeer.on('open', IvContPeer.sHandlers.Open);
}

function ConnectToPlayer(pID, pName) {
    IvContPeer.DebugLog("Search microphone...");
    navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;
    navigator.getUserMedia({video: false, audio: true}, function(stream) {
        IvContPeer.DebugLog(`Microphone found. Attempting to connect to a player ${pID}${useLocalDate.sID}`);
        allPlayersList[pID] = [ ];
        allPlayersList[pID].pName = pName;
        allPlayersList[pID].callHandler = IvContPeer.sPeer.call(`${pID}${useLocalDate.sID}`, stream);
        allPlayersList[pID].callHandler.on('stream', function(remoteStream) {
            IvContPeer.DebugLog(`CONNECTED TO PEER. pName: ${allPlayersList[pID].pName} pID: ${pID}. CREATING AUDIOSTREAM...`);
           
            allPlayersList[pID].audioObj = document.createElement('audio');
            allPlayersList[pID].audioObj.id = "voicer_" + pID;
            allPlayersList[pID].pChannel = 0;
            
            document.getElementById('audblocks').appendChild(allPlayersList[pID].audioObj);
            allPlayersList[pID].audioObj.srcObject = remoteStream;
            allPlayersList[pID].audioObj.controls = 'controls';
            allPlayersList[pID].audioObj.autoplay = '';
            allPlayersList[pID].audioObj.volume = 0.0;
            allPlayersList[pID].audioObj.style.opacity = "0";
            allPlayersList[pID].audioObj.pause();

            let namepla = pName;
            namepla = namepla.toUpperCase();
            namepla = namepla.replace('_', ' ');
            $("#audui").html($("#audui").html() + `
            <div id="voiceui_${pID}" class="item">
                <img id="voiceuiimg_${pID}" src="sound.png" alt="">
                <p>${pName}</p>
            </div>
            `);
            allPlayersList[pID].uiObj = document.getElementById(`voiceui_${pID}`);
            $("#voiceui_"+pID).hide();
            var vid = document.getElementById("voicer_"+pID);
            vid.volume = 0.0;  
            IvContPeer.LuaConverted.SendLuaData('PlayerConnectedToVoice', { pId: pID });
            IvContPeer.DebugLog(`AUDIOSTREAM CREATED! pName: ${allPlayersList[pID].pName} pID: ${pID}`);
        });
    });
}

window.addEventListener('message', function(event)
{
    switch(event.data.pack) {
        case IvContPeer.LuaConverted.START: {
            useLocalDate.settings = event.data.settings;
            useLocalDate["settings"].enabledVoiceChat ? StartLocalClient(event.data.sKey, event.data.pId, event.data.pName) : IvContPeer.DebugLog("VoiceChat disabled from settings.lua");
            break;   
        }
        case IvContPeer.LuaConverted.STOP: {
            useLocalDate["settings"].enabledVoiceChat = false;
            break;
        }
        case IvContPeer.LuaConverted.LUAFUNCTION: {
            var args = event.data.args;
            switch(event.data.func) {
                case IvContPeer.LuaConverted.SET_PLAYER_CHANNEL: {
                    IvContPeer.DebugLog(`CHANGE CHANNEL FROM ${useLocalDate.pChannel} TO ${args[0]}`);
                    useLocalDate.pChannel = args[0];
                    break;
                }
                case IvContPeer.LuaConverted.IS_PLAYER_CONNECTED: {
                    if(allPlayersList[args[0]].audioObj) {
                        IvContPeer.LuaConverted.SendLuaData('IsPlayerConnected', { result: true });
                    }
                    else {
                        IvContPeer.LuaConverted.SendLuaData('IsPlayerConnected', { result: false });
                    }
                    break;
                }
                case IvContPeer.LuaConverted.GET_PLAYER_CHANNEL: {
                    IvContPeer.LuaConverted.SendLuaData('GetPlayerChannel', { result: useLocalDate.pChannel });
                    
                    break;
                }
                case IvContPeer.LuaConverted.BAN_MICROPHONE: {
                    localMuted = args[0]
                    IvContPeer.DebugLog(`CHANGE MICROPHONE MUTE STATUS: ${localMuted}`);
                    IvContPeer.SetClientStatus(-1);
                    break;
                }
                case IvContPeer.LuaConverted.PLAYER_IS_TALKING: {
                    if(allPlayersList[args[0]].audioObj) {
                        if(allPlayersList[args[0]].audioObj.paused) {
                            IvContPeer.LuaConverted.SendLuaData('IsPlayerConnected', { result: false });
                        }
                        else {
                            IvContPeer.LuaConverted.SendLuaData('IsPlayerConnected', { result: true });
                        }
                    }
                    else {
                        IvContPeer.LuaConverted.SendLuaData('IsPlayerConnected', { result: false });
                    }
                    break;
                }
                case IvContPeer.LuaConverted.GET_PLAYER_VOLUME: {
                    if(allPlayersList[args[0]].audioObj) {
                        IvContPeer.LuaConverted.SendLuaData('GetPlayerVolume', { result: allPlayersList[args[0]].audioObj.volume });
                    }
                    else {
                        IvContPeer.LuaConverted.SendLuaData('GetPlayerVolume', { result: 0.0 });
                    }
                    break;
                }
                case IvContPeer.LuaConverted.SET_PLAYER_VOLUME: {
                    if(args[0] == -1)
                    {
                        //IvContPeer.DebugLog(`CHANGE VOLUME (ALL PEERS) volume: ${args[1]}`);
                        useLocalDate.pVolume = args[1];
                        for(var i = 0; i < 32; i++)
                        {
                            if(allPlayersList[i].audioObj)
                            {
                                allPlayersList[i].audioObj.volume = args[1];
                            }
                        }
                    }
                    else
                    {
                        //IvContPeer.DebugLog(`CHANGE VOLUME (pId: ${args[0]}) volume: ${args[1]}`);
                        if(allPlayersList[args[0]].audioObj)
                        {
                            allPlayersList[args[0]].audioObj.volume = args[1];
                        }
                    }
                    
                }
            };
            break;
        }
        case IvContPeer.LuaConverted.CHANGEVOICE: {
            if(event.data.set == 1) {
                if(allPlayersList[event.data.pId].audioObj)
                {
					useLocalDate.pVolume = event.data.vol;
                    allPlayersList[event.data.pId].audioObj.play();
                    $("#voiceuiimg_"+event.data.pId).attr("src","sound.png");
                    if(useLocalDate["settings"].panelVoiceVisible) {
                        $("#voiceui_"+event.data.pId).show();
                    }
                }
                

            } else if(event.data.set == 0) { 
                if(allPlayersList[event.data.pId].audioObj)
                {
                    allPlayersList[event.data.pId].audioObj.pause();
                    $("#voiceui_"+event.data.pId).hide();
                }
            }
            break;
        }
        case IvContPeer.LuaConverted.CHANGEVOICER: {

            if(event.data.set == 1) {
                if(allPlayersList[event.data.pId].audioObj)
                {
                    allPlayersList[event.data.pId].audioObj.play();
                    $("#voiceuiimg_"+event.data.pId).attr("src","soundr.png");
                    if(useLocalDate["settings"].panelVoiceVisible) {
                        $("#voiceui_"+event.data.pId).show();
                    }
                }
                

            } else if(event.data.set == 0) { 
                if(allPlayersList[event.data.pId].audioObj)
                {
                    allPlayersList[event.data.pId].audioObj.pause();
                    $("#voiceui_"+event.data.pId).hide();
                }
            }
            break;
        }
        case IvContPeer.LuaConverted.VOICE: {
            IvContPeer.DebugLog("SET VOICECHAT (L) BTN: " + event.data.set + " STATUS: " + useLocalDate.pStatus);
            if(event.data.set == 1 && useLocalDate.pStatus == IvContPeer.READY) {
                IvContPeer.SetClientStatus(IvContPeer.BTNCLICK);
            } else if(event.data.set == 0 && useLocalDate.pStatus == IvContPeer.BTNCLICK) { 
                IvContPeer.SetClientStatus(IvContPeer.READY);
            }
            break;
        }
        case IvContPeer.LuaConverted.VOICER: {
            IvContPeer.DebugLog("SET VOICECHAT (R) BTN: " + event.data.set + " STATUS: " + useLocalDate.pStatus);
            if(event.data.set == 1 && useLocalDate.pStatus == IvContPeer.READY) {
                IvContPeer.SetClientStatus(IvContPeer.RADIOBTNCLICK);
            }
            else if(event.data.set == 0 && useLocalDate.pStatus == IvContPeer.RADIOBTNCLICK) { 
                IvContPeer.SetClientStatus(IvContPeer.READY);
            }
            break;
        }
        case IvContPeer.LuaConverted.CONNECT: {
            IvContPeer.DebugLog(`CONNECTING TO PEER pID: ${event.data.pId} pName: ${event.data.pName}`);
            ConnectToPlayer(event.data.pId, event.data.pName);
            break;
        }
        case IvContPeer.LuaConverted.DISCONNECT: {
            IvContPeer.DebugLog("PEER DISCONNECTED pId: " + event.data.pId);
            if(allPlayersList[event.data.pId].audioObj)
            {
                //$("#voiceui_"+event.data.pId).remove();
                allPlayersList[event.data.pId].audioObj.remove();
                if(allPlayersList[event.data.pId].uiObj)
                {
                    allPlayersList[event.data.pId].uiObj.remove();
                }
            }
            break;
        }
    }
    return;
    
}, false);
