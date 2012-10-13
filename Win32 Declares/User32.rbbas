#tag Module
Protected Module User32
	#tag ExternalMethod, Flags = &h0
		Declare Function AnimateWindow Lib "User32" (HWND As Integer, duration As Integer, animation As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function DestroyIcon Lib "User32" (hIcon As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function DrawIconEx Lib "User32" (hDC As Integer, xLeft As Integer, yTop As Integer, hIcon As Integer, cxWidth As Integer, cyWidth As Integer, istepIfAniCur As Integer, hbrFlickerFreeDraw As Integer, diFlags As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function ExitWindowsEx Lib "User32" (flags As Integer, reason As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function FlashWindow Lib "User32" (HWND As Integer, invert As Boolean) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetDC Lib "User32" (HWND As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetDesktopWindow Lib "User32" () As Integer
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
		Declare Sub GetWindowRect Lib "User32" (HWND As Integer, ByRef sm As RECT)
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetWindowText Lib "User32" Alias "GetWindowTextW" (HWND As integer, lpString As Ptr, cch As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function MessageBeep Lib "User32" (Type As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function MessageBox Lib "User32" Alias "MessageBox" (HWND As Integer, text As WString, caption As WString, type As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function ReleaseDC Lib "User32" (HWND As Integer, DC As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function ShowWindow Lib "User32" (HWND As Integer, Command As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function SystemParametersInfo Lib "User32" Alias "SystemParametersInfoW" (action as UInt32, param1 as UInt32, param2 as Ptr, change as UInt32) As Boolean
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
