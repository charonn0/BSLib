#tag Module
Protected Module Console
	#tag Method, Flags = &h0
		Function ClearScreen() As Boolean
		  //Clears the screen and moves the cursor to the top left corner (0,0)
		  
		  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
		    Declare Function FillConsoleOutputCharacterW Lib "Kernel32" (cHandle As Integer, character As Integer, length As Integer, startCoord As COORD, _
		    ByRef charsWritten As Integer) As Boolean
		    
		    Dim cord As COORD = Buffer.dwSize
		    Dim charCount As Integer = cord.X * cord.Y
		    cord.X = 0
		    cord.Y = 0
		    
		    If FillConsoleOutputCharacterW(StdOutHandle, 0, charCount, cord, charCount) Then
		      Return SetCursorPosition(cord)
		    Else
		      Return False
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Function CTRL_CHandlerRoutine(CTRLType As Integer) As Boolean
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h0
		Function GetChar(x As Integer, y As Integer) As String
		  //Returns the character from the specified character cell in the screen buffer.
		  //On error, raises a Win32Exception with the Last Win32 error code
		  
		  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
		    Declare Function ReadConsoleOutputCharacterW Lib "Kernel32" (cHandle As Integer, chars As Ptr, Length As Integer, buffCords As COORD, charsRead As Ptr) As Boolean
		    
		    Dim mb As New MemoryBlock(4)
		    Dim p As New MemoryBlock(4)
		    Dim cords As COORD
		    cords.X = x
		    cords.Y = y
		    If ReadConsoleOutputCharacterW(StdOutHandle, mb, mb.Size, cords, p) Then
		      Return mb.CString(0)
		    Else
		      Raise New Win32Exception(Platform.LastErrorCode)
		    End If
		    
		  #Else
		    #pragma Unused x
		    #pragma Unused y
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetOriginalTitle() As String
		  //Returns the console window's original title. Only Windows Vista and later support this,
		  //so for earlier versions we work around it.
		  
		  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
		    If System.IsFunctionAvailable("GetConsoleOriginalTitleW", "Kernel32") Then
		      Soft Declare Function GetConsoleOriginalTitleW Lib "Kernel32" (Contitle As Ptr, mbsize As Integer) As Integer
		      
		      Dim mb As New MemoryBlock(0)
		      mb = New MemoryBlock(GetConsoleOriginalTitleW(mb, 0))
		      Call GetConsoleOriginalTitleW(mb, mb.Size)
		      Return mb.Wstring(0)
		    Else  //WinXP and earlier
		      If OriginalTitle = "" Then  //The title was NOT previously changed using Console.ConsoleTitle
		        Return ConsoleTitle  //Just return the current title.
		      Else
		        Return OriginalTitle //Return the saved title
		      End If
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OverrideCTRL_C(NewFunction As CTRL_CHandlerRoutine) As Boolean
		  //ACHTUNG!! This is buggy somehow, and sometimes crashes!!
		  //Call this function with a CTRL_CHandlerRoutine Delegate.
		  //On success, this function returns True and the specified function is invoked any time the user
		  //presses Control+c. Ordinarily Control+C immediately terminates a console application. This function overrides that behavior.
		  //To reverse this, call ResetCTRL_C. Subsequent calls to this function will override the previous HandlerRoutine.
		  
		  //Your custom HandlerRoutine must return TRUE to prevent the application from exiting, or FALSE to allow termination.
		  
		  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
		    Declare Function SetConsoleCtrlHandler Lib "Kernel32" (handlerRoutine As Ptr, add As Boolean) As Boolean
		    Return SetConsoleCtrlHandler(NewFunction, True)
		  #Else
		    #pragma Unused NewFunction
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PrintSeparator(Character As String = "=")
		  //Prints a line of characters (default is "=") accross the console screen. Essentially, a horizontal rule.
		  
		  #If TargetWin32 And Not TargetHasGUI Then
		    Dim bufferwidth As Integer = Console.Buffer.dwSize.X
		    For i As Integer = 1 To bufferwidth
		      stdout.Write(Character)
		    Next
		    stdout.Write(EndOfLine)
		  #Else
		    #pragma Unused Character
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PutChar(x As Integer, y As Integer, char As String) As String
		  //Writes the character specified to the character cell specified in the screen buffer
		  //Returns the character previously occupying the cell, if any.
		  //On error, raises a Win32Exception with the Last Win32 error code
		  
		  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
		    Declare Function WriteConsoleOutputCharacterW Lib "Kernel32" (cHandle As Integer, chars As Ptr, Length As Integer, buffCoords As COORD, charWritten As Ptr) As Boolean
		    
		    Dim ret As String = GetChar(x, y)
		    Dim mb As New MemoryBlock(4)
		    Dim p As New MemoryBlock(4)
		    Dim cords As COORD
		    cords.X = x
		    cords.Y = y
		    mb.CString(0) = char
		    
		    If WriteConsoleOutputCharacterW(StdOutHandle, mb, mb.Size, cords, p) Then
		      Return ret
		    Else
		      Raise New Win32Exception(Platform.LastErrorCode)
		    End If
		  #Else
		    #pragma Unused x
		    #pragma Unused y
		    #pragma Unused char
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ResetCTRL_C() As Boolean
		  //Resets the Control+C behavior to default. See: OverrideCTRL_C.
		  
		  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
		    Declare Function SetConsoleCtrlHandler Lib "Kernel32" (handlerRoutine As Ptr, add As Boolean) As Boolean
		    Return SetConsoleCtrlHandler(Nil, False)
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Resize(x As Integer, y As Integer) As Boolean
		  //Attempts to resize the Console buffer and window to the specified dimensions.
		  //x = the number of columns wide the buffer should be; y is the number of
		  //rows in the buffer.
		  
		  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
		    Declare Function SetConsoleScreenBufferSize Lib "Kernel32" (cHandle As Integer, coords As COORD) As Boolean
		    Declare Function SetConsoleWindowInfo Lib "Kernel32" (cHandle As Integer, Absolute As Boolean, ByRef coords As SMALL_RECT) As Boolean
		    Declare Function GetLargestConsoleWindowSize Lib "Kernel32" (cHandle As Integer) As COORD
		    
		    Dim cord As COORD
		    Dim winSize As SMALL_RECT = Buffer.sdWindow
		    
		    cord.X = winSize.Right
		    cord.Y = winSize.Bottom
		    
		    If x < cord.X Or y < cord.Y Then
		      If x > cord.X Then
		        cord.X = x
		        Call SetConsoleScreenBufferSize(StdOutHandle, cord)
		      End If
		      If y > cord.Y Then
		        cord.Y = y
		        Call SetConsoleScreenBufferSize(StdOutHandle, cord)
		      End If
		      
		      
		      winSize.Right = x - 1
		      winSize.Bottom = y - 1
		      If SetConsoleWindowInfo(StdOutHandle, True, winSize) Then
		        cord.X = x
		        cord.Y = y
		        Return SetConsoleScreenBufferSize(StdOutHandle, cord)
		      End If
		    Else
		      cord.X = x
		      cord.Y = y
		      If SetConsoleScreenBufferSize(StdOutHandle, cord) Then
		        winSize.Right = x - 1
		        winSize.Bottom = y - 1
		        Return SetConsoleWindowInfo(StdOutHandle, True, winSize)
		      End If
		    End If
		  #Else
		    #pragma Unused x
		    #pragma Unused y
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SendCTRL_C()
		  //Sends a Control+C signal. By default this will immediately interrupt and terminate the application. You can override this
		  //behavior using the OverrideCTRL_C function.
		  
		  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
		    Declare Function GenerateConsoleCtrlEvent Lib "Kernel32" (ctrlEvent As Integer, processGroup As Integer) As Boolean
		    Const CTRL_C_EVENT = 0
		    Call GenerateConsoleCtrlEvent(CTRL_C_EVENT, 0)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetBackgroundColor(NewColors As UInt16) As Boolean
		  //Sets the entire console background color. You may also specify text color properties, but they won't apply to
		  //text already printed to the buffer.
		  
		  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
		    Declare Function FillConsoleOutputAttribute Lib "Kernel32" (cHandle As Integer, attrib As UInt16, len As Integer, startCoord As COORD, _
		    ByRef charsWritten As Integer) As Boolean
		    
		    Dim cord As COORD = Buffer.dwSize
		    Dim charCount As Integer = cord.X * cord.Y
		    cord.X = 0
		    cord.Y = 0
		    Return FillConsoleOutputAttribute(StdOutHandle, NewColors, charCount, cord, charCount)
		  #Else
		    #pragma Unused NewColors
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetConsoleTextColor(NewColor As UInt16) As UInt16
		  //Sets the current console text colors to the passed color constant. Multiple (non-conflicting) values can be 
		  //set by Or'ing the constants (see this Module's constants.)
		  //Returns the previous color info on success, or zero on error. Note that 0 is also the default color value.
		  //You should call this function again with the returned old color value to reset the
		  //text formatting for new text.
		  
		  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
		    Declare Function SetConsoleTextAttribute Lib "Kernel32" (hConsole As Integer, attribs As UInt16) As Boolean
		    
		    Dim stdOutHandle As Integer = StdOutHandle()
		    If stdOutHandle <= 0 Then Return 0
		    Dim buffInfo As CONSOLE_SCREEN_BUFFER_INFO = Buffer
		    If SetConsoleTextAttribute(stdOutHandle, NewColor) Then
		      Return buffInfo.Attribute
		    Else
		      Return 0
		    End If
		  #Else
		    #pragma Unused NewColor
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function SetCursorPosition(coords As COORD) As Boolean
		  //Sets the cursor position to the specified coordinates. See ConsoleX and ConsoleY
		  
		  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
		    Declare Function SetConsoleCursorPosition Lib "Kernel32" (cHandle As Integer, cord As COORD) As Boolean
		    Return SetConsoleCursorPosition(StdOutHandle, coords)
		  #Else
		    #pragma Unused coords
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SetRGBColors(NewColors() As UInt32) As Boolean
		  //TODO: Finish this
		  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
		    Soft Declare Function SetConsoleScreenBufferInfoEx Lib "Kernel32" (cHandle As Integer, info As CONSOLE_SCREEN_BUFFER_INFOEX) As Boolean
		    
		    Dim info As CONSOLE_SCREEN_BUFFER_INFOEX
		    info.dwSize = Buffer.dwSize
		    info.CursorPosition = Buffer.CursorPosition
		    info.Attribute = Buffer.Attribute
		    info.sdWindow = Buffer.sdWindow
		    info.MaxWindowSize = Buffer.MaxWindowSize
		    //info.PopupAttributes = Buffer.
		    info.FullscreenSupported = True
		    For i As Integer = 0 To UBound(NewColors)
		      info.ColorTable(i) = NewColors(i)
		    Next
		    Return SetConsoleScreenBufferInfoEx(StdOutHandle,info)
		  #Else
		    #pragma Unused NewColors
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ShowMessageBox(msg As String, title As String, options As Integer = 0) As Integer
		  //Shows a messagebox even if the application has no GUI (a console application)
		  //Buttons, icons, and other options are documented at http://msdn.microsoft.com/en-us/library/ms645505%28v=vs.85%29.aspx
		  //Some options have been defined as Win32Constants.MB_*
		  //Returns an Integer corresponding to the button pressed by the user (just like REALbasic's MsgBox.)
		  //Return values from 1 to 7 are identical to REALbasic's MsgBox return values.
		  
		  #If TargetWin32 Then  //Windows Console Applications only
		    Declare Function MessageBoxW Lib "User32" (HWND As Integer, text As WString, caption As WString, type As Integer) As Integer
		    Return MessageBoxW(0, msg, title, options)
		  #Else
		    #pragma Unused msg
		    #pragma Unused title
		    #pragma Unused options
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WrappingPrint(Msg As String, LinePrefix As String = "")
		  //Prints the Msg to the console, wrapping around where neccessary but without splitting up words between lines.
		  //You may optionally pass a LinePrefix, which is a string that will be prepended to each line
		  
		  #If TargetWin32 And Not TargetHasGUI Then
		    Dim bufferwidth As Integer = Console.Buffer.dwSize.X
		    Dim txt() As String = Split(Msg, " ")
		    Dim currentPosition As Integer
		    Dim lineCount As Integer
		    
		    For i As Integer = 0 To UBound(txt)
		      If currentPosition + Len(txt(i) + " ") > bufferwidth - 1 Then
		        stdout.Write(EndOfLine + LinePrefix + txt(i) + " ")
		        currentPosition = Len(txt(i) + " ")
		        lineCount = lineCount + 1
		      Else
		        stdout.Write(txt(i) + " ")
		        currentPosition = currentPosition + Len(txt(i) + " ")
		        lineCount = lineCount + 1
		      End If
		    Next
		    stdout.Write(EndOfLine)
		    Return lineCount
		  #Else
		    #pragma Unused msg
		    #pragma Unused LinePrefix
		  #endif
		End Sub
	#tag EndMethod


	#tag Note, Name = About This Module
		This module adds some handy functions to Windows Console Applications.
		
	#tag EndNote


	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //Returns a CONSOLE_SCREEN_BUFFER_INFO structure for the current process's screen buffer
			  
			  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
			    Declare Function GetConsoleScreenBufferInfo Lib "Kernel32" (hConsole As Integer, ByRef buffinfo As CONSOLE_SCREEN_BUFFER_INFO) As Boolean
			    Dim buffInfo As CONSOLE_SCREEN_BUFFER_INFO
			    Dim stdOutHandle As Integer = StdOutHandle()
			    If GetConsoleScreenBufferInfo(stdOutHandle, buffInfo) Then
			      Return buffInfo
			    End If
			  #endif
			End Get
		#tag EndGetter
		Protected Buffer As CONSOLE_SCREEN_BUFFER_INFO
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  //Returns the console window title.
			  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
			    Declare Function GetConsoleTitleW Lib "Kernel32" (Contitle As Ptr, mbsize As Integer) As Integer
			    Dim mb As New MemoryBlock(256)
			    Call GetConsoleTitleW(mb, mb.Size)
			    Return mb.Wstring(0)
			  #endif
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  //Sets the console window title.
			  
			  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
			    Declare Function SetConsoleTitleW Lib "Kernel32" (cTitle As WString) As Boolean
			    
			    If OriginalTitle = "" Then OriginalTitle = ConsoleTitle
			    If Not SetConsoleTitleW(value) Then
			      Raise New Win32Exception(Platform.LastErrorCode)
			    End If
			  #Else
			    #pragma Unused value
			  #endif
			End Set
		#tag EndSetter
		ConsoleTitle As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  //Returns the height, in pixels, of the console cursor.
			  
			  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
			    Declare Function GetConsoleCursorInfo Lib "Kernel32" (cHandle As Integer, ByRef CurseInfo As CONSOLE_CURSOR_INFO) As Boolean
			    Dim conInfo As CONSOLE_CURSOR_INFO
			    Call GetConsoleCursorInfo(StdOutHandle, conInfo)
			    
			    Return conInfo.Height
			  #endif
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  //Sets the height, in pixels, of the console cursor.
			  
			  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
			    Declare Function GetConsoleCursorInfo Lib "Kernel32" (cHandle As Integer, ByRef CurseInfo As CONSOLE_CURSOR_INFO) As Boolean
			    Declare Function SetConsoleCursorInfo Lib "Kernel32" (cHandle As Integer, ByRef CurseInfo As CONSOLE_CURSOR_INFO) As Boolean
			    Dim conInfo As CONSOLE_CURSOR_INFO
			    Call GetConsoleCursorInfo(StdOutHandle, conInfo)
			    conInfo.Height = value
			    Call SetConsoleCursorInfo(StdOutHandle, conInfo)
			  #Else
			    #pragma Unused value
			  #endif
			End Set
		#tag EndSetter
		CursorHeight As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  //Returns True if the console cursor is visible.
			  
			  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
			    Declare Function GetConsoleCursorInfo Lib "Kernel32" (cHandle As Integer, ByRef CurseInfo As CONSOLE_CURSOR_INFO) As Boolean
			    Dim conInfo As CONSOLE_CURSOR_INFO
			    Call GetConsoleCursorInfo(StdOutHandle, conInfo)
			    
			    Return conInfo.Visible
			  #endif
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  //Hides or shows the console's cursor.
			  
			  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
			    Declare Function GetConsoleCursorInfo Lib "Kernel32" (cHandle As Integer, ByRef CurseInfo As CONSOLE_CURSOR_INFO) As Boolean
			    Declare Function SetConsoleCursorInfo Lib "Kernel32" (cHandle As Integer, ByRef CurseInfo As CONSOLE_CURSOR_INFO) As Boolean
			    Dim conInfo As CONSOLE_CURSOR_INFO
			    Call GetConsoleCursorInfo(StdOutHandle, conInfo)
			    conInfo.Visible = value
			    Call SetConsoleCursorInfo(StdOutHandle, conInfo)
			  #Else
			    #pragma Unused value
			  #endif
			End Set
		#tag EndSetter
		CursorVisible As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  //Gets the X (horizontal) position of the cursor
			  Return Buffer.CursorPosition.X
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  //Sets the X (horizontal) position of the cursor
			  Dim cord As COORD = Buffer.CursorPosition
			  cord.X = value
			  Call SetCursorPosition(cord)
			End Set
		#tag EndSetter
		CursorX As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  //Gets the Y (vertical) position of the cursor
			  Return Buffer.CursorPosition.Y
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  //Sets the Y (vertical) position of the cursor
			  Dim cord As COORD = Buffer.CursorPosition
			  cord.Y = value
			  Call SetCursorPosition(cord)
			End Set
		#tag EndSetter
		CursorY As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  //Returns True if the current console app is in fullscreen mode, false if not.
			  
			  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
			    If System.IsFunctionAvailable("GetConsoleDisplayMode", "Kernel32") Then
			      Soft Declare Function GetConsoleDisplayMode Lib "Kernel32" (ByRef flags As Integer) As Boolean
			      Dim flags As Integer
			      Call GetConsoleDisplayMode(flags)
			      If flags = 1 or flags = 2 Then
			        Return True
			      Else
			        Return False
			      End If
			    Else
			      Return False
			    End If
			  #endif
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  //Toggles the current console app between windowed and fullscreen mode.
			  
			  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
			    If System.IsFunctionAvailable("SetConsoleDisplayMode", "Kernel32") Then
			      Soft Declare Function SetConsoleDisplayMode Lib "Kernel32" (conHandle As Integer, flags As Integer, rect As Ptr) As Boolean
			      Declare Function GetStdHandle Lib "Kernel32" (hIOStreamType As Integer) As Integer
			      
			      Const STD_OUTPUT_HANDLE = -12
			      Dim stdOutHandle As Integer = StdOutHandle()
			      If stdOutHandle <= 0 Then Return
			      
			      If value Then
			        Call SetConsoleDisplayMode(stdOutHandle, 1, Nil)
			      Else
			        Call SetConsoleDisplayMode(stdOutHandle, 2, Nil)
			      End If
			      
			    End If
			  #Else
			    #pragma Unused value
			  #endif
			End Set
		#tag EndSetter
		Fullscreen As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Setter
			Set
			  //Assigning TRUE to this value causes the application to ignore CTRL+C
			  //Assigning FALSE to this value causes the application to honor CTRL+C after previously being ignored.
			  
			  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
			    Declare Function SetConsoleCtrlHandler Lib "Kernel32" (handlerRoutine As Ptr, add As Boolean) As Boolean
			    Call SetConsoleCtrlHandler(Nil, value)
			  #Else
			    #pragma Unused value
			  #endif
			End Set
		#tag EndSetter
		IgnoreCTRL_C As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  //Returns the maximum height (in characters) of the console buffer
			  return Buffer.dwSize.Y
			End Get
		#tag EndGetter
		MaxBufferHeight As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  //Returns the maximum width (in characters) of the console buffer
			  Return Buffer.dwSize.X
			End Get
		#tag EndGetter
		MaxBufferWidth As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private OriginalTitle As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //Gets the console buffer stdin handle.
			  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
			    Static stdHandle As Integer
			    If stdHandle <= 0 Then
			      Declare Function GetStdHandle Lib "Kernel32" (hIOStreamType As Integer) As Integer
			      Const STD_ERROR_HANDLE = -12
			      stdHandle = GetStdHandle(STD_ERROR_HANDLE)
			    End If
			    Return stdHandle
			  #endif
			End Get
		#tag EndGetter
		Protected StdErrHandle As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //Gets the console buffer stdin handle.
			  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
			    Static stdHandle As Integer
			    If stdHandle <= 0 Then
			      Declare Function GetStdHandle Lib "Kernel32" (hIOStreamType As Integer) As Integer
			      Const STD_INPUT_HANDLE = -10
			      stdHandle = GetStdHandle(STD_INPUT_HANDLE)
			    End If
			    Return stdHandle
			  #endif
			End Get
		#tag EndGetter
		Protected StdInHandle As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //Gets the console buffer stdout handle.
			  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
			    Static stdOutHandle As Integer
			    If stdOutHandle <= 0 Then
			      Declare Function GetStdHandle Lib "Kernel32" (hIOStreamType As Integer) As Integer
			      Const STD_OUTPUT_HANDLE = -11
			      stdOutHandle = GetStdHandle(STD_OUTPUT_HANDLE)
			    End If
			    Return stdOutHandle
			  #endif
			End Get
		#tag EndGetter
		Protected StdOutHandle As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Setter
			Set
			  //Sets whether the console window is visible or not
			  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
			    Declare Function GetConsoleWindow Lib "Kernel32" () As Integer
			    Declare Function ShowWindow Lib "User32" (HWND As Integer, cmd As Integer) As Boolean
			    
			    Const SW_RESTORE = 9
			    Const SW_HIDE = 0
			    
			    Dim conHWND As Integer = GetConsoleWindow()
			    
			    If value Then
			      Call ShowWindow(conHWND, SW_RESTORE)
			    Else
			      Call ShowWindow(conHWND, SW_HIDE)
			    End If
			  #Else
			    #pragma Unused value
			  #endif
			End Set
		#tag EndSetter
		Visible As Boolean
	#tag EndComputedProperty


	#tag Constant, Name = BACKGROUND_BLUE, Type = Double, Dynamic = False, Default = \"&h0010", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BACKGROUND_BOLD, Type = Double, Dynamic = False, Default = \"&h0080", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BACKGROUND_GREEN, Type = Double, Dynamic = False, Default = \"&h0020", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BACKGROUND_RED, Type = Double, Dynamic = False, Default = \"&h0040", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TEXT_BLUE, Type = Double, Dynamic = False, Default = \"&h0001", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TEXT_BOLD, Type = Double, Dynamic = False, Default = \"&h0008", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TEXT_GREEN, Type = Double, Dynamic = False, Default = \"&h0002", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TEXT_RED, Type = Double, Dynamic = False, Default = \"&h0004", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="ConsoleTitle"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CursorHeight"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CursorVisible"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CursorX"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CursorY"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Fullscreen"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IgnoreCTRL_C"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MaxBufferHeight"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MaxBufferWidth"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
