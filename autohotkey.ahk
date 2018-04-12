#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn   ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetCapsLockState, AlwaysOff  ; Disable capslock--we're using it as a modifier key

; vim
Capslock & h::Send {Left}
Capslock & j::Send {Down}
Capslock & k::Send {Up}
Capslock & l::Send {Right}
Capslock & u::Send {PgUp}
Capslock & d::Send {PgDown}
Capslock & y::Send ^c
Capslock & p::Send ^v

; media
Capslock & -::Send {Volume_Down}
Capslock & =::Send {Volume_Up}
Capslock & 0::Send {Volume_Mute}
Capslock & [::Send {Browser_Back}
Capslock & ]::Send {Browser_Forward}

