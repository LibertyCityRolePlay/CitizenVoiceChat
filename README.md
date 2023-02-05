# CitizenIV-VoiceChat

# Functions
SetPlayerVolume (playerID, Volume)
 
  *Arguments:*
  > playerID (-1 - 31) - The identifier of the player whose volume level should be changed. Use -1 to change the volume for all players.

  > Volume (0.0 - 1.0) - Volume level.
  
  *Return:*
  > nil
 
Example:
```lua
  export.voicechat:SetPlayerVolume(-1, 0.5)
 ```
---
 IsPlayerConnected (playerID)
 
  *Arguments:*
  > playerID (0 - 31) - The identifier of the player.
  
  *Return:*
  > status - true or false

Example:
```lua
  local playerConnect = export.voicechat:IsPlayerConnected(21)
 ```
 
 ---
 BanMicrophone (status)
 
  *Arguments:*
  > status (true or false) - TRUE - ban, FALSE - unban
  
  *Return:*
  > nil

Example:
```lua
  export.voicechat:BanMicrophone(true)
 ```
 
 ---
 PlayerHasBanMicrophone ()
 
  *Arguments:*
  > nil
  
  *Return:*
  > status (true or false) - TRUE - ban, FALSE - unban

Example:
```lua
  local playerBan = export.voicechat:PlayerHasBanMicrophone()
 ```
 
 ---
 ChangeSettingsKeys (keyLocal, keyRadio)
 
  *Arguments:*
  > keyLocal (1 - 211) - Local microphone activation key code

  > keyRadio (1 - 211) - Radio microphone activation key code
  
  *Return:*
  > nil

Example:
```lua
  export.voicechat:ChangeSettingsKeys(18, 34)
 ```
 
 ---
 SetPlayerChannel (channelID)
 
  *Arguments:*
  > channelID (-1 - maxChannel) - Radio channel code. Use -1 to switch global radio voice chat.
  
  *Return:*
  > nil

Example:
```lua
  export.voicechat:SetPlayerChannel(12)
 ```
 
  ---
 GetPlayerChannel ()
 
  *Arguments:*
  > nil
  
  *Return:*
  > channelID (0, maxChannel) - Radio channel code.

Example:
```lua
  local playerChannel = export.voicechat:GetPlayerChannel()
 ```
 
---
 PlayerIsTalking ()
 
  *Arguments:*
  > nil
  
  *Return:*
  > status - true or false

Example:
```lua
  local playerTalking = export.voicechat:PlayerIsTalking()
```

---
GetPlayerVolume (playerID)
 
  *Arguments:*
  > playerID (0 - 31) - The identifier of the player.

  *Return:*
  > Volume (0.0 - 1.0) - Volume level.
 
Example:
```lua
  local volume = export.voicechat:GetPlayerVolume(13)
```
---
SetPlayerLocalVoiceChatRadius (radius)
 
  *Arguments:*
  > radius (> 0.0) - The radius in which the player will hear other players in the local voice chat

  *Return:*
  > nil
 
Example:
```lua
  local volume = export.voicechat:SetPlayerLocalVoiceChatRadius(7.9)
```
 
