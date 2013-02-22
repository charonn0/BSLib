#tag Class
Protected Class ForeignWindow
Inherits Window
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
		  
		  If Not IncludeBorder Then
		    Return CaptureRect(Me.Left, Me.Top, Me.Width, Me.Height)
		    
		  Else
		    Return CaptureRect(Me.ClientLeft, Me.ClientTop, Me.ClientWidth, Me.ClientHeight)
		  End If
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
			  Dim oldFlags As Integer = GetWindowLong(Me.Handle, GWL_EXSTYLE)
			  
			  If BitAnd(oldFlags, WS_EX_LAYERED) <> WS_EX_LAYERED Then
			    // The window isn't layered, so make it so
			    Dim newflags As Integer = oldFlags Or WS_EX_LAYERED
			    Call SetWindowLong(Me.Handle, GWL_EXSTYLE, newFlags)
			    Call SetWindowPos(Me.Handle, 0, 0, 0, 0, 0, SWP_NOMOVE + SWP_NOSIZE + SWP_NOZORDER + SWP_FRAMECHANGED)
			  end
			  
			  // Now we want to set the transparency of the window.  The values range from 0 (totally
			  // transparent) to 255 (totally opaque).
			  Call SetLayeredWindowAttributes(Handle, 0 , value * 255, LWA_ALPHA)
			  
			End Set
		#tag EndSetter
		Alpha As Single
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim info As WINDOWINFO
			  If GetWindowInfo(Me.Handle, info) Then
			    Return info.cxWindowBorders
			  End If
			End Get
		#tag EndGetter
		BorderSizeX As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim info As WINDOWINFO
			  If GetWindowInfo(Me.Handle, info) Then
			    Return info.cyWindowBorders
			  End If
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
			  Dim info As WINDOWINFO
			  info.cbSize = info.Size
			  If GetWindowInfo(Me.Handle, info) Then
			    Dim size As RECT = info.ClientArea
			    Return size.bottom - size.top
			  End If
			End Get
		#tag EndGetter
		ClientHeight As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim info As WINDOWINFO
			  info.cbSize = info.Size
			  If GetWindowInfo(Me.Handle, info) Then
			    Dim size As RECT = info.ClientArea
			    Return size.Left
			  End If
			End Get
		#tag EndGetter
		ClientLeft As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim info As WINDOWINFO
			  info.cbSize = info.Size
			  If GetWindowInfo(Me.Handle, info) Then
			    Dim size As RECT = info.ClientArea
			    Return size.right
			  End If
			End Get
		#tag EndGetter
		ClientRight As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim info As WINDOWINFO
			  info.cbSize = info.Size
			  If GetWindowInfo(Me.Handle, info) Then
			    Dim size As RECT = info.ClientArea
			    Return size.top
			  End If
			End Get
		#tag EndGetter
		ClientTop As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim info As WINDOWINFO
			  info.cbSize = info.Size
			  If GetWindowInfo(Me.Handle, info) Then
			    Dim size As RECT = info.ClientArea
			    Return size.Right - size.Left
			  End If
			End Get
		#tag EndGetter
		ClientWidth As Integer
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
			  Dim info As WINDOWINFO
			  info.cbSize = info.Size
			  If GetWindowInfo(Me.Handle, info) Then
			    Dim size As RECT = info.WindowArea
			    Return size.bottom - size.top
			  End If
			End Get
		#tag EndGetter
		Height As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim info As WINDOWINFO
			  info.cbSize = info.Size
			  If GetWindowInfo(Me.Handle, info) Then
			    Dim size As RECT = info.WindowArea
			    Return size.left
			  End If
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
			  Return GetAncestor(Me.Handle, GA_PARENT)
			End Get
		#tag EndGetter
		Parent As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim info As WINDOWINFO
			  info.cbSize = info.Size
			  If GetWindowInfo(Me.Handle, info) Then
			    Dim size As RECT = info.WindowArea
			    Return size.top
			  End If
			End Get
		#tag EndGetter
		Top As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return GetAncestor(Me.Handle, GA_ROOTOWNER)
			End Get
		#tag EndGetter
		TrueOwner As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return GetAncestor(Me.Handle, GA_ROOT)
			End Get
		#tag EndGetter
		TrueParent As Integer
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
			  Dim info As WINDOWINFO
			  info.cbSize = info.Size
			  If GetWindowInfo(Me.Handle, info) Then
			    Dim size As RECT = info.WindowArea
			    Return size.right - size.left
			  End If
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