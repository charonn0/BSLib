#tag Module
Protected Module Console
	#tag Method, Flags = &h0
		Function ClearScreen() As Boolean
		  //Clears the screen and moves the cursor to the top left corner (0,0)
		  
		  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
		    Dim cord As COORD = Buffer.dwSize
		    Dim charCount As Integer = cord.X * cord.Y
		    cord.X = 0
		    cord.Y = 0
		    
		    If FillConsoleOutputCharacter(StdOutHandle, 0, charCount, cord, charCount) Then
		      Return SetConsoleCursorPosition(StdOutHandle, cord)
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
		    Dim mb As New MemoryBlock(4)
		    Dim p As New MemoryBlock(4)
		    Dim cords As COORD
		    cords.X = x
		    cords.Y = y
		    If ReadConsoleOutputCharacter(StdOutHandle, mb, mb.Size, cords, p) Then
		      Return mb.CString(0)
		    Else
		      Raise New Win32Exception(GetLastError)
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
		      Dim mb As New MemoryBlock(0)
		      mb = New MemoryBlock(GetConsoleOriginalTitle(mb, 0))
		      Call GetConsoleOriginalTitle(mb, mb.Size)
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
		    Dim ret As String = GetChar(x, y)
		    Dim mb As New MemoryBlock(4)
		    Dim p As New MemoryBlock(4)
		    Dim cords As COORD
		    cords.X = x
		    cords.Y = y
		    mb.CString(0) = char
		    
		    If WriteConsoleOutputCharacter(StdOutHandle, mb, mb.Size, cords, p) Then
		      Return ret
		    Else
		      Raise New Win32Exception(GetLastError)
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
		    Return SetConsoleCtrlHandler(Nil, False)
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SendCTRL_C()
		  //Sends a Control+C signal. By default this will immediately interrupt and terminate the application. You can override this
		  //behavior using the OverrideCTRL_C function.
		  
		  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
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

	#tag Method, Flags = &h0
		Function SetRGBColors(NewColors() As UInt32) As Boolean
		  //TODO: Finish this
		  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
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
			    Dim buffInfo As CONSOLE_SCREEN_BUFFER_INFO
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
			  //Returns the maximum height (in characters) of the console buffer
			  return Buffer.dwSize.Y
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  //Attempts to resize the Console buffer and window to the specified dimensions.
			  //value = the number of columns high the buffer should be
			  
			  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
			    Dim cord As COORD
			    Dim winSize As SMALL_RECT = Buffer.sdWindow
			    
			    cord.X = winSize.Right
			    cord.Y = winSize.Bottom
			    
			    If Value > cord.Y Then
			      cord.X = BufferWidth
			      cord.Y = Value
			      If SetConsoleScreenBufferSize(StdOutHandle, cord) Then
			        winSize.Bottom = value - 1
			        Call SetConsoleWindowInfo(StdOutHandle, False, winSize)
			      End If
			    Else
			      winSize.Bottom = value - 1
			      If SetConsoleWindowInfo(StdOutHandle, True, winSize) Then
			        cord.X = BufferWidth
			        cord.Y = value
			        Call SetConsoleScreenBufferSize(StdOutHandle, cord)
			      End If
			    End If
			  #Else
			    #pragma Unused Value
			  #endif
			End Set
		#tag EndSetter
		BufferHeight As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  //Returns the maximum width (in characters) of the console buffer
			  Return Buffer.dwSize.X
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  //Attempts to resize the Console buffer and window to the specified dimensions.
			  //value = the number of columns wide the buffer should be
			  
			  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
			    Dim cord As COORD
			    Dim winSize As SMALL_RECT = Buffer.sdWindow
			    
			    cord.X = winSize.Right
			    cord.Y = winSize.Bottom
			    
			    If Value > cord.X Then
			      cord.X = Value
			      cord.Y = BufferHeight
			      If SetConsoleScreenBufferSize(StdOutHandle, cord) Then
			        winSize.Right = value - 1
			        Call SetConsoleWindowInfo(StdOutHandle, False, winSize)
			      End If
			    Else
			      winSize.Right = BufferWidth - value
			      If SetConsoleWindowInfo(StdOutHandle, True, winSize) Then
			        cord.X = Value - 1
			        cord.Y = BufferHeight
			        Call SetConsoleScreenBufferSize(StdOutHandle, cord)
			      End If
			    End If
			  #Else
			    #pragma Unused Value
			  #endif
			End Set
		#tag EndSetter
		BufferWidth As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  //Returns the console window title.
			  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
			    Dim mb As New MemoryBlock(256)
			    Call GetConsoleTitle(mb, mb.Size)
			    If mb.Size = 0 Then Return ""
			    Return mb.Wstring(0)
			  #endif
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  //Sets the console window title.
			  
			  #If Not TargetHasGUI And TargetWin32 Then  //Windows Console Applications only
			    If OriginalTitle = "" Then OriginalTitle = ConsoleTitle
			    If Not SetConsoleTitle(value) Then
			      Raise New Win32Exception(GetLastError)
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
			  Call SetConsoleCursorPosition(StdOutHandle, cord)
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
			  Call SetConsoleCursorPosition(StdOutHandle, cord)
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
			    Call SetConsoleCtrlHandler(Nil, value)
			  #Else
			    #pragma Unused value
			  #endif
			End Set
		#tag EndSetter
		IgnoreCTRL_C As Boolean
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
			    If stdHandle = INVALID_HANDLE_VALUE Then 
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
			    If stdHandle <= 0 Then stdHandle = GetStdHandle(STD_INPUT_HANDLE)
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
			    If stdOutHandle <= 0 Then stdOutHandle = GetStdHandle(STD_OUTPUT_HANDLE)
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
			Name="BufferHeight"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BufferWidth"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
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
