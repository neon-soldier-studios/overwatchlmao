#include <Constants.au3>
#include <MsgBoxConstants.au3>
#include <Misc.au3>
#include <WinAPI.au3>
#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <GDIPlus.au3>
#include <ScreenCapture.au3>
#include <File.au3>
HotKeySet("^!q", "Quit")
HotKeySet("^z", "standby")
HotKeySet("^1", "menu")
global $already = 0
Global $winX
Global $winY
Global $winW
Global $winH
global $myguyx = 0
global $myguy = 0
global $myguyy = 900
global $heroes=0
global $mode=False
global $picsize=56/2
global $mousedown=False
global $lastmousedown=False
global $pics=0
global $choices[100][3]
global $waiting=false
global $interupt=false
global $mainmenu=false
global $gui=0

$guu = GUICreate("ready", 200, $picsize*2+10,1,1)
$madamada = GUICtrlCreateLabel( "select a character?", $picsize*2+10, 2)
$cancel = GUICtrlCreateLabel("ctrl-z again to cancel", $picsize*2+10,40)
$selectedimg=GUICtrlCreatePic( "", 2, 2,$picsize*2+5,$picsize*2+5, $BS_BITMAP)
WinSetOnTop($guu,"",$WINDOWS_ONTOP)
GUISetState(@sw_show, $guu)
WinSetState($guu, "", @SW_hide)

Do
menu()
sleep(10000000)
Until (0)
Exit

Func snap($x,$y,$fname)
   $boi=_ScreenCapture_Capture("", $x-$picsize, $y-$picsize, $x+$picsize, $y+$picsize)
   _ScreenCapture_SaveImage ( $fname, $boi)
EndFunc

Func snapnomouse($x,$y,$fname)
   MouseMove(0,0,0)
   Sleep(10)
   snap($x,$y,$fname)
   MouseMove($x,$y,0)
EndFunc

Func menu()
   if(not $mainmenu) Then
	  $mainmenu=true
	  optionmenu()
   Else
	  GUIDelete($gui)
	  $mainmenu=false
   EndIf
EndFunc

Func optionmenu()
   $fil=FileOpen("imagez/opts.txt",0)
   $gui = GUICreate("Choose yo hero", 1920, 1080)
   $x= FileReadLine($fil)
   $pics=0
   while(@error <> -1)
	  $nw=StringSplit($x,",",2)
	  $choices[$pics][1]=$nw[0]
	  $choices[$pics][2]=$nw[1]
	  $choices[$pics][0] = GUICtrlCreateButton("ree", $nw[0],$nw[1],$picsize*2+5,$picsize*2+5, $BS_BITMAP)
	  _GUICtrlButton_SetImage($choices[$pics][0],"imagez/icon"&String($pics)&".bmp")
	  $x=FileReadLine($fil)
	  $pics+=1
   Wend
   FileClose($fil)
   $Setup = GUICtrlCreateButton("Setup", 1200, 200)
   $tip1 = GUICtrlCreateLabel("after clicking Setup, right click all desired options, then return and left click the Setup button again", 1200, 240)
   $tip8 = GUICtrlCreateLabel("|", 1320, 260)
   $tip9 = GUICtrlCreateLabel("|", 1600, 260)
   $tip6 = GUICtrlCreateLabel("(centered)", 1300, 280)
   $tip7 = GUICtrlCreateLabel("(it will read Finish after being clicked the first time)", 1410, 280)
   $tip2 = GUICtrlCreateLabel("hotkeys:", 2, 10)
   $tip3 = GUICtrlCreateLabel("QUIT - ctrl alt q", 2, 30)
   $tip4 = GUICtrlCreateLabel("bring up this menu - ctrl 1", 2, 50)
   $tip5 = GUICtrlCreateLabel("standby to pick - ctrl z", 2, 70)


   ;$Crazybutton = GUICtrlCreateButton("Hanzo", 50*9, 200, 200, 200, $BS_BITMAP)
   ;_GUICtrlButton_SetImage($Crazybutton,"c:\hanzo.bmp")
   ;;;;;;;;;;;;;;;;;;;;;;;;;;

   GUISetState(@sw_show, $gui)
   While 1
	  $mousedown=MouseDown
	  $idMsg = GUIGetMsg()
	  if $idMsg <> 0 Then
		 Switch $idMsg
			case $Setup
			   $mode = not $mode
			   if($mode) Then
				  _FileCreate("imagez/opts.txt")
				  $fil=FileOpen("imagez/opts.txt",2)
				  GUICtrlSetData($Setup,"Finish")
				  $pics=0
			   Else
				  GUICtrlSetData($Setup,"Setup")
			   EndIf
		 EndSwitch
		 For $cont = 0 to $pics
			if $idMsg == $choices[$cont][0] Then
			   $myguyx = $choices[$cont][1]
			   $myguyy = $choices[$cont][2]
			   GUICtrlSetData($madamada, "is with you")
			   GUICtrlSetImage($selectedimg,"imagez/icon"&String($cont)&".bmp")
			   GUIDelete($gui)
			   $mainmenu=false
			   ExitLoop
			EndIf
		Next
	  EndIf
	  if $mode Then
		 if _IsPressed("02") Then
			$mousedown=True
		 Else
			$mousedown=False
		 EndIf
		 If $mousedown and not $lastmousedown Then
			$mpos=MouseGetPos()
			$fname="imagez/icon"&String($pics)&".bmp"
			snapnomouse($mpos[0],$mpos[1],$fname)
			FileWriteLine($fil,String($mpos[0])&","&String($mpos[1]))
			$pics+=1
		 EndIf
	  EndIf
	  $lastmousedown=$mousedown
   WEnd



EndFunc
;;;;;;;;;;;;;;;;;;;;;;;;;;


Func standby()
;;;;;;;;;;;;;;;;;;;;;;;;;;
if(not $waiting) then ; wait to get activated
   $waiting=true
   WinSetOnTop($guu,"",$WINDOWS_ONTOP)
   WinSetState($guu, "", @SW_SHOW)
   WinActivate("Overwatch")

   Local $Wold = 1
	 ;sleep(10)
   while(1)
		 if($interupt) Then ;recieve interupt
			WinSetOnTop($guu,"",$WINDOWS_NOONTOP)
			WinSetState($guu, "", @SW_hide)
			$waiting=false
			$interupt=False
			Return(-1)
		 EndIf
		 $thing =  _WinAPI_GetCursorInfo()

		 if($thing[1] == True And $Wold == False) Then
			WinSetOnTop($guu,"",$WINDOWS_NOONTOP)
			WinSetState($guu, "", @SW_hide)
			  ExitLoop
		 EndIf
		 $Wold = $thing[1]

   Wend
   MouseMove($myguyx+Random(-2,2), $myguyy+Random(-2,2), 0)
   $i=100
   While($i>0)
	  MouseMove($myguyx+Random(-2,2), $myguyy+Random(-2,2), 1)
	  sleep(10)
	  MouseClick("primary")
	  $thing =  _WinAPI_GetCursorInfo()
	  if($thing[1] == False And $Wold == True) Then
		   ExitLoop
		EndIf
	  $i-=1
	  $Wold = $thing[1]
   WEnd
   $waiting=false
else; send interupt
   $interupt=true
EndIf
EndFunc ;==>MyStart
;;;;;;;;;;;;;;;;;;;;;;;;;;


Func Quit()
;;;;;;;;;;;;;;;;;;;;;;;;;;
MsgBox($MB_SYSTEMMODAL, "Sayonara", "")
Exit
EndFunc ;==>MyQuit
;;;;;;;;;;;;;;;;;;;;;;;;;;

