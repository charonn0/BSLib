#tag Class
Protected Class TrayIcon
	#tag Method, Flags = &h0
		Sub Constructor(Ico As Picture, title As String, tip As String, HWND As Window)
		  Declare Function Shell_NotifyIcon Lib "Shell32" (message As Integer, ByRef data As NOTIFYICONDATA) As Boolean
		  
		  Const NIF_MESSAGE = &h00000001
		  Const NIF_ICON = &h00000002
		  Const NIF_TIP = &h00000004
		  Const NIF_STATE = &h00000008
		  Const NIF_REALTIME = &h00000040
		  Const NIF_SHOWTIP = &h00000080
		  Const NIF_INFO = &h00000010
		  Const NIF_GUID = &h00000020
		  Const NIM_ADD = &h00000000
		  Const NIM_MODIFY = &h00000001
		  Const NIM_DELETE = &h00000002
		  Const NIM_SETFOCUS = &h00000003
		  Const NIM_SETVERSION = &h00000004
		  
		  Dim tray As NOTIFYICONDATA
		  tray.sSize = tray.Size
		  tray.WindowHandle = GDIBMPHandle(1, SpecialFolder.Windows.Child("system32").Child("shell32.dll"))
		  tray.uID = IconID
		  tray.Flags = NIF_ICON Or NIF_TIP Or NIF_STATE Or NIF_SHOWTIP
		  tray.IconHandle = Ico.Graphics.Handle(6)
		  tray.ToolTip = tip
		  tray.BalloonTitle = title
		  
		  If Shell_NotifyIcon(NIM_ADD, tray) Then
		    Break
		  Else
		    Break
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GDIBMPHandle(Resource As Integer, File As FolderItem) As Integer
		  #If TargetWin32 Then
		    Declare Function ExtractIconExW Lib "Shell32" ( lpszFile As WString, ByVal nIconIndex As Integer, phiconLarge As ptr, phiconSmall As ptr, ByVal nIcons As Integer ) As Integer
		    
		    Declare Function DestroyIcon Lib "User32" (hIcon As Integer) As Integer
		    Dim small As New MemoryBlock(4)
		    Try
		      Call ExtractIconExW(file.AbsolutePath, Resource, Nil, small, 1)
		    Catch
		      Return -1
		    End Try
		    Return small.Int32Value(0)
		  #endif
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Clicked(ClickType As Integer) As Boolean
	#tag EndHook


	#tag Property, Flags = &h21
		Private IconHandle As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mIconID = 0 Then
			    Dim rand As New Random
			    Dim d As New Date
			    rand.Seed = d.TotalSeconds
			    mIconID = rand.InRange(0, 99)  //A hundred ought to be enough icons for anyone.
			  End If
			  return mIconID
			End Get
		#tag EndGetter
		IconID As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mIconID As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="IconID"
			Group="Behavior"
			Type="Integer"
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
	#tag EndViewBehavior
End Class
#tag EndClass
