; keyboard-shortcuts.ahk
; https://github.com/gucci-on-fleek/scripts/
; SPDX-License-Identifier: MPL-2.0+
; SPDX-FileCopyrightText: 2021 gucci-on-fleek
; Requires: AutoHotKey  

; A script that defines some basic keyboard shortcuts. All of the shortcuts defined here
; should be fairly non-intrusive; I personally use this script in addition to some much 
; more radical remappings.
;  < Win                + Z                         > -- Launch Windows Terminal
;  < Win        + Shift + Z                         > -- Launch Windown Terminal as Admin
;  < Win + Ctrl         + Space                     > -- Make the current window Always-on-top
;  < Win        + Shift + Space                     > -- Insert narrow no-break space
;  < Win                + Numpad Minus              > -- Insert En Dash
;  < Win        + Shift + Numpad Minus              > -- Insert Em Dash
;  < Win                + Numpad Asterisk           > -- Insert Multiplication Sign
;  < Win                + Numpad Slash              > -- Insert Division Sign
;  < Win        + Shift + ^            , Any Digit  > -- Insert Superscript number
;  < Win        + Shift + _            , Any Digit  > -- Insert Subscript number
;  < Win + Ctrl         + G            , Any Letter > -- Insert Greek Letter
;  < Win + Ctrl         + .                         > -- Insert Ellipsis  
;  < Win + Ctrl         + V                         > -- Paste as Plain Text
;  < Win + Ctrl         + C                         > -- Send left-click until keypress
;  <                      Three Finger Touchpad Tap > -- Middle Click

;; Boilerplate
#NoEnv
#InstallKeybdHook
#InstallMouseHook
SendMode Input
SetTitleMatchMode RegEx

#NoTrayIcon
#SingleInstance force

;; Shortcuts
#z:: 
    Run, wt,, max
    Sleep, 100
    WinActivate, ahk_exe WindowsTerminal.exe
return

^#z:: 
    Run, *RunAs wt,, max
    Sleep, 100
    WinActivate, ahk_exe WindowsTerminal.exe
return

^#SPACE::  Winset, Alwaysontop, , A
#^+F22:: Send {MButton} ; The keypress that Windows sends when for a three-finger tap

^#v::                     
  Clip0 = %ClipBoardAll%
  ClipBoard = %ClipBoard% 
  Send ^v                 
  Sleep 50                
  ClipBoard = %Clip0%     
  VarSetCapacity(Clip0, 0)
return

;; Unicode Characters
#+SPACE::Send   ; Narrow no-break space
#+NumpadSub::Send — ; Em dash
#NumpadSub::Send – ; En dash
#NumpadMult::×
#NumpadDiv::÷
#^.::Send …

#+6::
    Input key, L1
    Switch key {
        case "1": Send ¹
        case "2": Send ²
        case "3": Send ³
        case "4": Send ⁴
        case "5": Send ⁵
        case "6": Send ⁶
        case "7": Send ⁷
        case "8": Send ⁸
        case "9": Send ⁹
        case "0": Send ⁰
        case "-": Send ⁻
        case "o": Send °
    }
return
    
#+-::
    Input key, L1
    Switch key {
        case "1": Send ₁
        case "2": Send ₂
        case "3": Send ₃
        case "4": Send ₄
        case "5": Send ₅
        case "6": Send ₆
        case "7": Send ₇
        case "8": Send ₈
        case "9": Send ₉
        case "0": Send ₀
        case "-": Send ₋
    }
return

#^g::
    Input key, L1
    GetKeyState shift, Shift
    if (shift="D") { 
        key .= "x" 
    }
    Switch key {
        case "a": Send α
        case "b": Send β
        case "g": Send γ
        case "d": Send δ
        case "e": Send ε
        case "z": Send ζ
        case "t": Send θ
        case "i": Send ι
        case "k": Send κ
        case "l": Send λ
        case "m": Send μ
        case "n": Send ν
        case "x": Send ξ
        case "p": Send π
        case "r": Send ρ
        case "s": Send σ
        case "t": Send τ
        case "o": Send ω
        case "Gx": Send Γ
        case "Dx": Send Δ
        case "Tx": Send Θ
        case "Lx": Send Λ
        case "Xx": Send Ξ
        case "Px": Send Π
        case "Sx": Send Σ
        case "Ox": Send Ω
    }
return

;; Continuous Clicker
CoordMode client
SetMouseDelay 1
BreakLoop := 0

#^c::
    loop {
        Click
        try {
            Input, OutVar, T0.01
        } 
        if (OutVar) {
            break
        }
    }    
return

return
