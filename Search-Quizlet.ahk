#Requires AutoHotkey v2.0
#SingleInstance Force

;right click on the tray icon to set a hotkey
A_TrayMenu.Add("Set Hotkeys", SetHotkeys) ; Add a tray menu item to change hotkeys
A_IconTip := "Right click me to set the hotkey`nfor searching quizlet"


; sets the tray icon
onlinequizleticon := "https://raw.githubusercontent.com/Today20092/Autohotkey-script/main/Quizlet.ico"

if !FileExist("Quizlet.ico"){
    try{
        Download(onlinequizleticon, "Quizlet.ico")
    }
    catch{
    }
}

if FileExist("Quizlet.ico") {
    TraySetIcon("Quizlet.ico",,)
}



; Create GUI
MyGui := Gui("AlwaysOnTop -SysMenu", "Press the keys you want to search quizlet")
MyGui.Add("Text", , "It can always be changed later by `nright clicking the icon on the bottom right of the windows tray.")
MyGui.SetFont("s10 q5",)
MyGui.Add("Hotkey", "vChosenHotkey limit1", "^+q")
MyGui.Add("Button", "R2 Section", "OK").OnEvent("Click", OK_Click)
MyGui.Add("Button", "R2 ys", "Cancel").OnEvent("Click", Cancel_Click)


; Saves the hotkey 
XXHK := IniRead(A_ScriptDir "\Hotkeys.ini", "Hotkeys", "SavedHotkey", "NotFound")
if XXHK="NotFound"
	SetHotkeys()
else
	Hotkey XXHK, SearchFunction
return


; Opens GUI
SetHotkeys(*){
	MyGui.Show("Autosize Center")
}

;submit click
OK_Click(*){
    Saved := MyGui.Submit()
    Hotkey Saved.ChosenHotkey, SearchFunction
    IniWrite Saved.ChosenHotkey, A_ScriptDir "\Hotkeys.ini", "Hotkeys", "SavedHotkey"
}

; Submit cancel
Cancel_Click(*){
    MyGui.Destroy()
}

; Search google for quizlets
SearchFunction(*){

    ;sets the clipboard to empty
    A_Clipboard := "" 

    ; sends copy
    Send "^c" 

    ; waits 1 second something to be in the clipboard
    if !ClipWait(1) 
    {
        ToolTip "The attempt to copy text onto the clipboard failed."
        SetTimer () => ToolTip(), -1000
        return
    }    


    ; define the search terms you want here:
    operators := " site:quizlet.com"
    
    
    ; searches with default browser
    Run "https://www.google.com/search?q=" . A_Clipboard . operators
}


