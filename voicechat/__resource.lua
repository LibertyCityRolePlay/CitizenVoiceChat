--0.1 Beta

ui_page 'html/index.html'

files {
    'html/sound.png',
    'html/soundr.png',
    'html/err.png',
    'html/on.png',
    'html/mute.png',
    'html/onr.png',
    'html/jq.js',
    'html/material.woff2',
    'html/st.css',
    'html/vc.js',
    'html/voice.js',
    'html/index.html'
}

client_script 'client.lua'
client_script 'settings.lua'
server_script 'settings.lua'
server_script 'server.lua' 


export 'SetPlayerChannel'
export 'SetPlayerVolume'
export 'GetPlayerVolume'
export 'PlayerIsTalking'
export 'GetPlayerChannel'
export 'ChangeSettingsKeys'
export 'PlayerHasBanMicrophone'
export 'BanMicrophone'
export 'IsPlayerConnected'