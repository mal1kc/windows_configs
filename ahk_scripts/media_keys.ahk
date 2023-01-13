; #SingleInstance, Force
; SendMode Input
; SetWorkingDir, %A_ScriptDir%

; Lwin & Volume_Up::
; ;MsgBox, me_next, uwu
; OutputDebug, "Lwin+Volume_Up buttons pressed"
; send ,{Media_Next down}{Media_Next up}
; Return

; Lwin & Volume_Down::
; ;MsgBox, me_next, uwu
; OutputDebug, "Lwin+Volume_Down buttons pressed"
; send ,{Media_Play_Pause down}{Media_Play_Pause up}
; Return


; Lwin & Volume_Mute::
; ;MsgBox, me_next, uwu
; OutputDebug, "Lwin+Volume_Mute buttons pressed"
; send ,{Media_Prev down}{Media_Prev up}
; Return

#SingleInstance Force
#Warn ; Enable warnings to assist with detecting common errors.
SendMode "Input" ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir ; Ensures a consistent starting directory.

; Media keys using Windows key
#Volume_Up::
    {
        Send "{Media_Next}"
        OutputDebug "Lwin+Volume_Up buttons pressed"
        Return
    }

#Volume_Down::
    {
        Send "{Media_Play_Pause}"
        OutputDebug "Lwin+Volume_Down buttons pressed"
        Return
    }

#Volume_Mute::
    {
        Send "{Media_Prev}"
        OutputDebug "Lwin+Volume_Mute buttons pressed"
        Return
    }

#^M::
    {
        Run('"C:\ProgramData\scoop\apps\python\current\python.exe" "C:\Users\malikc\.config\win_audio_mixer_mute.py"')
    }