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
		Sub FlashWindow()
		  Call FlashWindow(Me.Handle, True)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function FromXY(X As Integer, Y As Integer) As ForeignWindow
		  Dim p As POINT
		  p.X = X
		  p.Y = Y
		  Dim hwnd As Integer = WindowFromPoint(p)
		  If hwnd > 0 Then
		    If ChildWindowFromPoint(hwnd, p) > 0 Then
		      hwnd = ChildWindowFromPoint(hwnd, p)
		    End If
		  End If
		  Return New ForeignWindow(hwnd)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Attributes( deprecated = "ForeignWindow.WindowInfo" ) Protected Function GetWindowInfo() As WINDOWINFO
		  Dim info As WINDOWINFO
		  If GetWindowInfo(Me.Handle, info) Then
		    Return info
		  End If
		End Function
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
		Function Maximized() As Boolean
		  Dim wp As WINDOWPLACEMENT
		  wp.Length = wp.Size
		  If GetWindowPlacement(Me.Handle, wp) Then
		    Return wp.ShowCmd = SW_SHOWMAXIMIZED
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Maximized(Assigns b As Boolean)
		  If b Then
		    Call ShowWindow(Me.Handle, SW_MAXIMIZE)
		  Else
		    Call ShowWindow(Me.Handle, SW_SHOWDEFAULT)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Minimized() As Boolean
		  Dim wp As WINDOWPLACEMENT
		  wp.Length = wp.Size
		  If GetWindowPlacement(Me.Handle, wp) Then
		    Return wp.ShowCmd = SW_SHOWMINIMIZED
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Minimized(Assigns b As Boolean)
		  If b Then
		    Call ShowWindow(Me.Handle, SW_MINIMIZE)
		  Else
		    Call ShowWindow(Me.Handle, SW_SHOWDEFAULT)
		  End If
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
		    win.Minimized = True
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
			    SetWindowStyleEx(Me.Handle, WS_EX_LAYERED) = True
			  End If
			  Call SetLayeredWindowAttributes(Handle, 0 , value * 255, LWA_ALPHA)
			  
			End Set
		#tag EndSetter
		Alpha As Single
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Me.WindowInfo.cxWindowBorders
			  
			End Get
		#tag EndGetter
		BorderSizeX As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Me.WindowInfo.cyWindowBorders
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
			  Dim size As RECT = Me.WindowInfo.ClientArea
			  Return size.bottom - size.top
			End Get
		#tag EndGetter
		Height As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim size As RECT = Me.WindowInfo.ClientArea
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
			  Dim h As Integer = GetWindow(Me.Handle, GW_OWNER)
			  Return New ForeignWindow(h)
			End Get
		#tag EndGetter
		Owner As ForeignWindow
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim h As Integer = GetParent(Me.Handle)
			  Return New ForeignWindow(h)
			End Get
		#tag EndGetter
		Parent As ForeignWindow
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  
			  Dim size As RECT = Me.WindowInfo.ClientArea
			  Return size.top
			End Get
		#tag EndGetter
		Top As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim size As RECT = Me.WindowInfo.WindowArea
			  Return size.bottom - size.top
			End Get
		#tag EndGetter
		TrueHeight As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  
			  Dim size As RECT = Me.WindowInfo.WindowArea
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
			  
			  Dim size As RECT = Me.WindowInfo.WindowArea
			  Return size.right
			End Get
		#tag EndGetter
		TrueRight As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  
			  Dim size As RECT = Me.WindowInfo.WindowArea
			  Return size.top
			End Get
		#tag EndGetter
		TrueTop As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  
			  Dim size As RECT = Me.WindowInfo.WindowArea
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
			  
			  Dim size As RECT = Me.WindowInfo.ClientArea
			  Return size.right - size.left
			End Get
		#tag EndGetter
		Width As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim info As WINDOWINFO
			  If GetWindowInfo(Me.Handle, info) Then
			    Return info
			  End If
			End Get
		#tag EndGetter
		WindowInfo As WINDOWINFO
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Alpha"
			Group="Behavior"
			Type="Single"
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
			Name="Handle"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
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
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TrueHeight"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TrueLeft"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TrueRight"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TrueTop"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TrueWidth"
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
