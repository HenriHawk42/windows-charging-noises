#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; this stops the program from playing the same sound a billion f**king times
unplugNoisePlayed = 0
inplugNoisePlayed = 0

while (true) {
  ; this gets the power state i think
  VarSetCapacity(powerstatus, 1+1+1+1+4+4)
  success := DllCall("kernel32.dll\GetSystemPowerStatus", "uint", &powerstatus)

  acLineStatus:=ReadInteger(&powerstatus,0,1,false)
  
  ReadInteger( p_address, p_offset, p_size, p_hex=true )
  {
    value = 0
    old_FormatInteger := a_FormatInteger
    if ( p_hex )
      SetFormat, integer, hex
    else
      SetFormat, integer, dec
    loop, %p_size%
      value := value+( *( ( p_address+p_offset )+( a_Index-1 ) ) << ( 8* ( a_Index-1 ) ) )
    SetFormat, integer, %old_FormatInteger%
  return, value
  }
  
  
  ; if ac is not connected
  if (acLineStatus == 0 && unplugNoisePlayed == 0) {
    SoundPlay, %A_WinDir%\Media\Windows Hardware Remove.wav
    unplugNoisePlayed = 1
    inplugNoisePlayed = 0
  }

  ; if ac is connected
  if (acLineStatus = 1 && inplugNoisePlayed == 0) {
    SoundPlay, %A_WinDir%\Media\Windows Hardware Insert.wav
    inplugNoisePlayed = 1
    unplugNoisePlayed = 0
  }
}
