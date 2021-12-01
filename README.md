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
 Ban (playerID, status)
 
  *Arguments:*
  > playerID (-1 - 31) - The identifier of the player. Use -1 to block local player voice chat.
  
  > status (true or false) - TRUE - ban, FALSE - unban
  
  *Return:*
  > nil

Example:
```lua
  export.voicechat:Ban(12, true)
 ```
 
 ---
 PlayerHasBan (playerID)
 
  *Arguments:*
  > playerID (-1 - 31) - The identifier of the player. Use -1 to block local player voice chat.
  
  *Return:*
  > status (true or false) - TRUE - ban, FALSE - unban

Example:
```lua
  local playerBan = export.voicechat:PlayerHasBan(18)
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
 SetPlayerChannel (playerID, channelID)
 
  *Arguments:*
  > playerID (-1 - 31) - The identifier of the player. Use -1 for local player

  > channelID (-1 - maxChannel) - Radio channel code. Use -1 to switch global radio voice chat.
  
  *Return:*
  > nil

Example:
```lua
  export.voicechat:SetPlayerChannel(-1, 12)
 ```
 
  ---
 GetPlayerChannel (playerID)
 
  *Arguments:*
  > playerID (-1 - 31) - The identifier of the player. Use -1 for local player
  
  *Return:*
  > channelID (-1, maxChannel) - Radio channel code.

Example:
```lua
  local playerChannel = export.voicechat:GetPlayerChannel(-1)
 ```
 
---
 PlayerIsTalking (playerID)
 
  *Arguments:*
  > playerID (-1 - 31) - The identifier of the player. Use -1 for local player
  
  *Return:*
  > resultID (0 - 2) - Returns 0 if the player is not talking, 1 if talking through the local chat, 2 - of talking through the walkie-talkie

Example:
```lua
  local playerTalking = export.voicechat:PlayerIsTalking(-1)
```

---
GetPlayerVolume (playerID)
 
  *Arguments:*
  > playerID (-1 - 31) - The identifier of the player. Use -1 for local player

  *Return:*
  > Volume (0.0 - 1.0) - Volume level.
 
Example:
```lua
  local volume = export.voicechat:GetPlayerVolume(-1)
```

---
SetPlayer (playerID)
 
  *Arguments:*
  > playerID (-1 - 31) - The identifier of the player. Use -1 for local player

  *Return:*
  > Volume (0.0 - 1.0) - Volume level.
 
Example:
```lua
  local volume = export.voicechat:GetPlayerVolume(-1)
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
 
