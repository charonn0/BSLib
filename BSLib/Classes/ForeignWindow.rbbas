#tag Class
Protected Class ForeignWindow
	#tag Method, Flags = &h0
		Sub BringToFront()
		  Call ShowWindow(Me.Handle, SW_SHOWNORMAL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Capture(IncludeBorder As Boolean = True) As Picture
		  'Calls CaptureRect on the specified Window.
		  'If the optional IncludeBorder parameter is False, then only the client area of the window
		  'is captured; if True then the client area, borders, and titlebar are included in the capture.
		  'If the window is a ContainerControl or similar construct (AKA child windows), only the contents of the container
		  'are captured. To always capture the topmost containing window, use ForeignWindow.TrueParent.Capture
		  'If all or part of the Window is overlapped by other windows, then the capture will include the overlapping
		  'parts of the other windows.
		  
		  Dim l, t, w, h As Integer
		  If Not IncludeBorder Then
		    l = Me.Left
		    t = Me.Top
		    w = Me.Width
		    h = Me.Height
		    
		  Else
		    l = Me.TrueLeft
		    t = Me.TrueTop
		    w = Me.TrueWidth
		    h = Me.TrueHeight
		  End If
		  
		  Return CaptureRect(l, t, w, h)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(HWND As Integer)
		  Me.mHandle = HWND
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function FromXY(X As Integer, Y As Integer) As ForeignWindow
		  Dim p As POINT
		  p.X = X
		  p.Y = Y
		  Dim hwnd As Integer = WindowFromPoint(p)
		  Return New ForeignWindow(hwnd)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetWindowInfo() As WINDOWINFO
		  Dim info As WINDOWINFO
		  If GetWindowInfo(Me.Handle, info) Then
		    Return info
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Identify(FlashCount As Integer = 1, FlashWindow As Boolean = True, FlashTaskbar As Boolean = True)
		  Dim info As FLASHWINFO
		  info.cbSize = info.Size
		  info.Count = FlashCount
		  info.HWND = Me.Handle
		  Dim flag As Integer
		  If FlashWindow Then
		    flag = flag Or FLASHW_CAPTION
		  ElseIf FlashTaskbar Then
		    flag = flag Or FLASHW_TRAY
		  End If
		  info.Flags = flag
		  Call User32.FlashWindowEx(info)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ListWindows(PartialTitle As String = "") As ForeignWindow()
		  Dim wins() As ForeignWindow
		  Dim ret as integer
		  ret = FindWindow(Nil, Nil)
		  Dim hidden() As String = Split("MSCTFIME UI,Default IME,Jump List,Start Menu,Start,Program Manager", ",")
		  while ret > 0
		    Dim pw As New ForeignWindow(ret)
		    If pw.Caption.Trim <> "" And hidden.IndexOf(pw.Caption.Trim) <= -1 And pw.Visible Then
		      If PartialTitle.Trim = "" Or InStr(pw.Caption, PartialTitle) > 0 Then
		        wins.Append(pw)
		      End If
		    End If
		    ret = GetWindow(ret, GW_HWNDNEXT)
		  wend
		  Return wins
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Maximized()
		  Call ShowWindow(Me.Handle, SW_MAXIMIZE)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Minimized()
		  Call ShowWindow(Me.Handle, SW_MAXIMIZE)
		End Sub
	#tag EndMethod


	#tag Note, Name = About this class
		This class allows you to control and interrogate (to an extent) windows belonging to other applications which
		are running on the same machine as your app. The Class Constructor expects a valid Win32 window handle (HWND),
		any valid window handle (including for windows belonging to your app) will suffice.
		 
		Use the shared method FromXY to get a reference to the topmost window over a specific screen coordinate.
		
		Use the shared methof ListWindows to get an array of ForeignWindow objects corresponding to all the top-level
		windows on the current desktop matching the optional partial title string. Note that the ListWindows method
		searches all top-level windows which is a computationally expensive and occasionally buggy thing to do.
		
		
		Examples:
		
		  'Minimize all Firefox windows
		  Dim wins() As ForeignWindow = ForeignWindow.ListWindows("Firefox")
		  For Each win As ForeignWindow In wins
		    win.Minimize()
		  Next
		
		
		  'Captures a picture of the topmost window under the mouse cursor
		  Dim cap As Picture
		  Dim win As ForeignWindow = ForeignWindow.FromXY(System.MouseX, System.MouseY)
		  cap = win.Capture
	#tag EndNote


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim a As Integer
			  If GetLayeredWindowAttributes(Me.Handle, 0 , a, LWA_ALPHA) Then
			    Return a / 255.0
			  Else
			    Return 255.0
			  End If
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Not TestWindowStyleEx(Me.Handle, WS_EX_LAYERED) Then
			    SetWindowStyleEx(Me.Handle, WS_EX_LAYERED, True)
			  End If
			  Call SetLayeredWindowAttributes(Handle, 0 , value * 255, LWA_ALPHA)
			  
			End Set
		#tag EndSetter
		Alpha As Single
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return GetWindowInfo.cxWindowBorders
			  
			End Get
		#tag EndGetter
		BorderSizeX As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return GetWindowInfo.cyWindowBorders
			End Get
		#tag EndGetter
		BorderSizeY As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim buffer As New MemoryBlock(2048)
			  Dim sz As New MemoryBlock(4)
			  sz.Int32Value(0) = buffer.Size
			  If SendMessage(Me.Handle, WM_GETTEXT, sz, buffer) <= 0 Then 'We ask nicely
			    Call GetWindowText(Me.Handle, buffer, buffer.Size)  'otherwise we try to peek (sometimes crashy!)
			  End If
			  
			  Return buffer.WString(0).Trim
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Dim mb As MemoryBlock = value
			  Call SetWindowText(Me.Handle, mb)
			End Set
		#tag EndSetter
		Caption As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mHandle
			End Get
		#tag EndGetter
		Handle As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim info As WINDOWINFO = GetWindowInfo
			  Dim size As RECT = info.ClientArea
			  Return size.bottom - size.top
			End Get
		#tag EndGetter
		Height As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim info As WINDOWINFO = GetWindowInfo
			  Dim size As RECT = info.ClientArea
			  Return size.left
			End Get
		#tag EndGetter
		Left As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mHandle As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return GetWindow(Me.Handle, GW_OWNER)
			End Get
		#tag EndGetter
		Owner As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim h As Integer = GetAncestor(Me.Handle, GA_PARENT)
			  Return New ForeignWindow(h)
			End Get
		#tag EndGetter
		Parent As ForeignWindow
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim info As WINDOWINFO = GetWindowInfo
			  Dim size As RECT = info.ClientArea
			  Return size.top
			End Get
		#tag EndGetter
		Top As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim info As WINDOWINFO = GetWindowInfo
			  Dim size As RECT = info.WindowArea
			  Return size.bottom - size.top
			End Get
		#tag EndGetter
		TrueHeight As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim info As WINDOWINFO = GetWindowInfo
			  Dim size As RECT = info.WindowArea
			  Return size.Left
			End Get
		#tag EndGetter
		TrueLeft As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim h As Integer = GetAncestor(Me.Handle, GA_ROOTOWNER)
			  Return New ForeignWindow(h)
			End Get
		#tag EndGetter
		TrueOwner As ForeignWindow
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim h As Integer = GetAncestor(Me.Handle, GA_ROOT)
			  Return New ForeignWindow(h)
			End Get
		#tag EndGetter
		TrueParent As ForeignWindow
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim info As WINDOWINFO = GetWindowInfo
			  Dim size As RECT = info.WindowArea
			  Return size.right
			End Get
		#tag EndGetter
		TrueRight As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim info As WINDOWINFO = GetWindowInfo
			  Dim size As RECT = info.WindowArea
			  Return size.top
			End Get
		#tag EndGetter
		TrueTop As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim info As WINDOWINFO = GetWindowInfo
			  Dim size As RECT = info.WindowArea
			  Return size.Right - size.Left
			End Get
		#tag EndGetter
		TrueWidth As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return IsWindowVisible(Me.Handle)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value Then
			    Call ShowWindow(Me.Handle, SW_SHOW)
			  Else
			    Call ShowWindow(Me.Handle, SW_FORCEMINIMIZE)
			  End If
			  
			End Set
		#tag EndSetter
		Visible As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim info As WINDOWINFO = GetWindowInfo
			  Dim size As RECT = info.ClientArea
			  Return size.right - size.left
			End Get
		#tag EndGetter
		Width As Integer
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Alpha"
			Group="Behavior"
			Type="Single"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BackColor"
			Visible=true
			Group="Appearance"
			InitialValue="&hFFFFFF"
			Type="Color"
			InheritedFrom="Window"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backdrop"
			Visible=true
			Group="Appearance"
			Type="Picture"
			EditorType="Picture"
			InheritedFrom="Window"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderSizeX"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BorderSizeY"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Caption"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ClientHeight"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ClientLeft"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ClientRight"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ClientTop"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ClientWidth"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CloseButton"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Window"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Composite"
			Visible=true
			Group="Appearance"
			InitialValue="False"
			Type="Boolean"
			InheritedFrom="Window"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Frame"
			Visible=true
			Group="Appearance"
			InitialValue="0"
			Type="Integer"
			EditorType="Enum"
			InheritedFrom="Window"
			#tag EnumValues
				"0 - Document"
				"1 - Movable Modal"
				"2 - Modal Dialog"
				"3 - Floating Window"
				"4 - Plain Box"
				"5 - Shadowed Box"
				"6 - Rounded Window"
				"7 - Global Floating Window"
				"8 - Sheet Window"
				"9 - Metal Window"
				"10 - Drawer Window"
				"11 - Modeless Dialog"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="FullScreen"
			Visible=true
			Group="Appearance"
			InitialValue="False"
			Type="Boolean"
			InheritedFrom="Window"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Handle"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasBackColor"
			Visible=true
			Group="Appearance"
			InitialValue="False"
			Type="Boolean"
			InheritedFrom="Window"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ImplicitInstance"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			EditorType="Boolean"
			InheritedFrom="Window"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Interfaces"
			Visible=true
			Group="ID"
			InheritedFrom="Window"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LiveResize"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Window"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MacProcID"
			Visible=true
			Group="Appearance"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Window"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MaxHeight"
			Visible=true
			Group="Position"
			InitialValue="32000"
			Type="Integer"
			InheritedFrom="Window"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MaximizeButton"
			Visible=true
			Group="Appearance"
			InitialValue="False"
			Type="Boolean"
			InheritedFrom="Window"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MaxWidth"
			Visible=true
			Group="Position"
			InitialValue="32000"
			Type="Integer"
			InheritedFrom="Window"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MenuBar"
			Visible=true
			Group="Appearance"
			Type="MenuBar"
			EditorType="MenuBar"
			InheritedFrom="Window"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MenuBarVisible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Window"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MinHeight"
			Visible=true
			Group="Position"
			InitialValue="64"
			Type="Integer"
			InheritedFrom="Window"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MinimizeButton"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Window"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MinWidth"
			Visible=true
			Group="Position"
			InitialValue="64"
			Type="Integer"
			InheritedFrom="Window"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Owner"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Parent"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Placement"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType="Enum"
			InheritedFrom="Window"
			#tag EnumValues
				"0 - Default"
				"1 - Parent Window"
				"2 - Main Screen"
				"3 - Parent Window Screen"
				"4 - Stagger"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Resizeable"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Window"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Title"
			Visible=true
			Group="Appearance"
			InitialValue="Untitled"
			Type="String"
			InheritedFrom="Window"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TrueOwner"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TrueParent"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
