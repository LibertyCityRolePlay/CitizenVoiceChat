getSettings = {
    enabledVoiceChat        =   true                ,-- Enable voice chat.                                       
    useLocalVoiceChat       =   true                ,-- Use local voice chat.
    localVoiceChatDistance  =   10.0                ,-- Voice chat range in local mode.
    keyVoiceChat            =   50                  ,-- Enabling voice chat on a key. Default - M.
    useRadioVoiceChat       =   true                ,-- Use communication channel.
    limitRadioVoiceChat     =   10000               ,-- Limit of parallel communication channels.
    keyRadioVoiceChat       =   49                  ,-- Using the walkie-talkie mode on the key. Default - N.
    securyKeyVoiceChat      =   10                  ,-- The number of characters in the voice chat key.
    defaultRadioVoiceChat   =   0                   ,-- Set the default communication channel
    panelVoiceVisible       =   true                ,-- Displaying the conversation bar, which is on the right

    useIcons = { -- Voice chat icons
        onVoiceChat         =   "on.png"      ,-- Voice chat key pressed.
        onRadioVoiceChat    =   "onr.png"     ,-- The voice chat key in the walkie-talkie mode is pressed.    
        errorVoiceChat      =   "err.png"     ,-- If an error occurs.
        muteVoiceChat       =   "mute.png"
    }
}