#tag Module
Protected Module User32
	#tag ExternalMethod, Flags = &h0
		Declare Function AdjustWindowRect Lib "User32" (ByRef WindowRect As RECT, Style As Integer, bMenu As Boolean) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function AdjustWindowRectEx Lib "User32" (ByRef WindowRect As RECT, Style As Integer, bMenu As Boolean, ExStyle As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function AllowSetForegroundWindow Lib "User32" (ProcessID As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function AnimateWindow Lib "User32" (HWND As Integer, duration As Integer, animation As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function BringWindowToTop Lib "User32" (HWND As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function CallWindowProc Lib "User32" Alias "CallWindowProcW" (WindowProc As Integer, HWND As Integer, msg As Integer, wParam As Ptr, lParam As Ptr) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function ChangeClipboardChain Lib "User32" (Removed As Integer, NextWindow As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function ChildWindowFromPoint Lib "User32" (HWND As Integer, Coordinates As POINT) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function CloseDesktop Lib "User32" (hDesktop As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function CreateDesktop Lib "User32" Alias "CreateDesktopW" (Name As WString, Device As Integer, DevMode As Integer, Flags As Integer, Access As Integer, Security As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function DestroyIcon Lib "User32" (hIcon As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function DrawIcon Lib "User32" (hDC As Integer, xLeft As Integer, yTop As Integer, hIcon As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function DrawIconEx Lib "User32" (hDC As Integer, xLeft As Integer, yTop As Integer, hIcon As Integer, cxWidth As Integer, cyWidth As Integer, istepIfAniCur As Integer, hbrFlickerFreeDraw As Integer, diFlags As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function ExitWindowsEx Lib "User32" (flags As Integer, reason As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function FindWindow Lib "User32" Alias "FindWindowW" (ClassName As Ptr, WindowName As Ptr) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function FindWindowEx Lib "User32" Alias "FindWindowExW" (ParentHWND As Integer, ChildHWND As Integer, ClassName As WString, WindowName As WString) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function FlashWindow Lib "User32" (HWND As Integer, invert As Boolean) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function FlashWindowEx Lib "User32" (Flashinfo As FLASHWINFO) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetAncestor Lib "User32" (HWND As Integer, Flags As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetClientRect Lib "User32" (HWND As Integer, ByRef Dimensions As RECT) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetCursorInfo Lib "User32" (ByRef Info As CURSORINFO) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetDC Lib "User32" (HWND As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetDesktopWindow Lib "User32" () As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetKeyNameText Lib "User32" Alias "GetKeyNameTextW" (LParam As Integer, Buffer As Ptr, BufferSize As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetLayeredWindowAttributes Lib "User32" (hwnd As Integer, thecolor As Integer, ByRef bAlpha As Integer, flags As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetParent Lib "User32" (HWND As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetSystemMetrics Lib "User32" (nIndex As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetThreadDesktop Lib "User32" (ThreadID As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetUserObjectInformation Lib "User32" (Handle As Integer, Index As Integer, Info As Ptr, InfoLen As Integer, ByRef LenNeeded As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetWindow Lib "User32" (HWND As Integer, CMD As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetWindowInfo Lib "User32" (HWND As Integer, ByRef Info As WINDOWINFO) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetWindowLong Lib "User32" Alias "GetWindowLongW" (HWND As Integer, Index As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetWindowPlacement Lib "User32" (HWND As Integer, ByRef WinPlacement As WINDOWPLACEMENT) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetWindowRect Lib "User32" (HWND As Integer, ByRef sm As RECT) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetWindowText Lib "User32" Alias "GetWindowTextW" (HWND As integer, lpString As Ptr, cch As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GlobalDeleteAtom Lib "Kernel32" (Atom As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function IsIconic Lib "User32" (HWND As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function IsWindowVisible Lib "User32" (HWND As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function LoadImage Lib "User32" Alias "LoadImageW" (Instance As Integer, FileName As WString, ImageType As Integer, DesiredWidth As UInt32, DesiredHeight As UInt32, Flags As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function MapVirtualKey Lib "User32" Alias "MapVirtualKeyW" (key As Integer, type As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function MessageBeep Lib "User32" (Type As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function MessageBox Lib "User32" Alias "MessageBox" (HWND As Integer, text As WString, caption As WString, type As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function OpenInputDesktop Lib "User32" (flags As Integer, inherit As Boolean, access As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function PostMessage Lib "User32" Alias "PostMessageW" (HWND As Integer, Message As Integer, WParam As Ptr, LParam As Ptr) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function RegisterHotKey Lib "User32" (HWND As Integer, ID As Integer, Modifiers As Integer, VirtualKey As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function RegisterWindowMessage Lib "User32" Alias "RegisterWindowMessageW" (MessageName As WString) As UInt16
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function ReleaseDC Lib "User32" (HWND As Integer, DC As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function SendMessage Lib "User32" Alias "SendMessageW" (HWND As Integer, Message As UInt32, WParam As Ptr, LParam As Ptr) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function SetClipboardViewer Lib "User32" (NewViewerWindow As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function SetForegroundWindow Lib "User32" (HWND As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function SetLayeredWindowAttributes Lib "User32" (hwnd As Integer, thecolor As Integer, bAlpha As integer, alpha As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function SetThreadDesktop Lib "User32" (hDesktop As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function SetWindowLong Lib "User32" Alias "SetWindowLongW" (HWND As Integer, Index As Integer, NewLong As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function SetWindowLong Lib "User32" Alias "SetWindowLongW" (HWND As Integer, Index As Integer, NewLong As Ptr) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function SetWindowPos Lib "User32" (HWND As Integer, hWndInstertAfter As Integer, x As Integer, y As Integer, cx As Integer, cy As Integer, flags As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function SetWindowRgn Lib "User32" (hWnd As Integer, hRgn As Integer, bRedraw As Boolean) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function SetWindowText Lib "User32" Alias "SetWindowTextW" (WND As Integer, Buffer As WString) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function ShowWindow Lib "User32" (HWND As Integer, Command As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function SwitchDesktop Lib "User32" (hDesktop As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function SystemParametersInfo Lib "User32" Alias "SystemParametersInfoW" (action as UInt32, param1 as UInt32, param2 as Ptr, change as UInt32) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function UnregisterHotKey Lib "User32" (HWND As Integer, ID As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function VkKeyScan Lib "User32" Alias "VkKeyScanW" (Key As Integer) As Short
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function WindowFromPoint Lib "User32" (Coordinates As POINT) As Integer
	#tag EndExternalMethod


	#tag ViewBehavior
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
	#tag EndViewBehavior
End Module
#tag EndModule
