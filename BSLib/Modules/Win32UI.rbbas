#tag Module
Protected Module Win32UI
	#tag Method, Flags = &h0
		Function FadeIn(Extends w As Window) As Boolean
		  Dim ret As Boolean = AnimateWindow(w.Handle, AW_ACTIVATE Or AW_BLEND, 200)
		  w.Show
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FadeOut(Extends w As Window) As Boolean
		  Dim ret As Boolean = AnimateWindow(w.Handle, AW_BLEND Or AW_HIDE, 200)
		  w.Hide
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Flash(Extends win As Window)
		  //Flashes the specified Window once
		  //See: http://msdn.microsoft.com/en-us/library/windows/desktop/ms679346%28v=vs.85%29.aspx
		  
		  #If TargetWin32 Then
		    If System.IsFunctionAvailable("FlashWindow", "User32") Then
		      Soft Declare Function FlashWindow Lib "User32" (HWND As Integer, invert As Boolean) As Boolean
		      Call FlashWindow(win.Handle, True)
		    End If
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ZoomIn(Extends w As Window) As Boolean
		  Dim ret As Boolean = AnimateWindow(w.Handle, AW_ACTIVATE Or AW_CENTER, 200)
		  w.Show
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ZoomOut(Extends w As Window) As Boolean
		  Dim ret As Boolean = AnimateWindow(w.Handle, AW_CENTER Or AW_HIDE, 200)
		  w.Hide
		  Return ret
		End Function
	#tag EndMethod


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
