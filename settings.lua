getSettings = {
    enabledVoiceChat        =   true                ,-- Enable voice chat.                                       
    useLocalVoiceChat       =   true                ,-- Use local voice chat.
    radiusVoiceChat         =   10.0                ,-- Voice chat range in local mode.
    keyVoiceChat            =   50                  ,-- Enabling voice chat on a key. Default - M.
    useRadioVoiceChat       =   true                ,-- Use communication channel.
    limitRadioVoiceChat     =   10000               ,-- Limit of parallel communication channels.
    keyRadioVoiceChat       =   49                  ,-- Using the walkie-talkie mode on the key. Default - N.
    restartOnError          =   false               ,-- Reload the entire voice chat if an error occurs for any player. (Warning! May cause endless looping and crash of all players)
    securyKeyVoiceChat      =   10                  ,-- The number of characters in the voice chat key.
    
    useCss = { -- Using css style for voice chat
        VoiceIcon = [[
            position: absolute;
            right: 10px;
            bottom: 10px;
        ]],
        VoicePlayers = [[
            font-family: 'Gill Sans', 'Gill Sans MT', Calibri, 'Trebuchet MS', sans-serif;
            font-size: 1.5vh;
            text-align: center;
            color: #78d85d;
            background-color: rgba(0, 0, 0, 0.418);
            padding: 5px;
        ]]
    },

    useIcons = { -- Voice chat icons
        onVoiceChat         =   "icons/on.png"      ,-- Voice chat key pressed.
        offVoiceChat        =   "icons/off.png"     ,-- Voice chat in standby mode.
        onRadioVoiceChat    =   "icons/onr.png"     ,-- The voice chat key in the walkie-talkie mode is pressed.    
        errorVoiceChat      =   "icons/error.png"    -- If an error occurs.
    }
}

--[[Client functions
    Use:
        exports.alv-voicechat:FuncName(args)
    OR
        TriggerEvent('FuncName', args)


    Functions:
    
        SetPlayerVolume(Int ID, float VOLUME) - Set the player's voice chat volume.
            ID          - Player ID. 1 to 31. Use -1 to change the volume of the all players.
            VOLUME      - Player volume from 0.0 to 1.0.


        SetPlayerChannel(float ChannelID)
            ChannelID   - Channel id, from 0 to the set limit in the limitRadioVoiceChat parameter.

        
]]