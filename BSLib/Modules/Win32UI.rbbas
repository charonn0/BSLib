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
		  'Flashes the specified Window once
		  'See: http://msdn.microsoft.com/en-us/library/windows/desktop/ms679346%28v=vs.85%29.aspx
		  
		  #If TargetWin32 Then
		    If System.IsFunctionAvailable("FlashWindow", "User32") Then
		      Soft Declare Function FlashWindow Lib "User32" (HWND As Integer, invert As Boolean) As Boolean
		      Call FlashWindow(win.Handle, True)
		    End If
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetWindowRect(HWND As Integer) As REALbasic.Rect
		  Dim r As Win32Structs.RECT
		  Call GetWindowRect(HWND, r)
		  Return r.ToRBRect
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasTaskbarButton(Extends Win As Window) As Boolean
		  Return TestWindowStyleEx(win.Handle, WS_EX_TOOLWINDOW)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HasTaskbarButton(Extends Win As Window, Assigns HasButton As Boolean)
		  SetWindowStyleEx(Win.Handle, WS_EX_TOOLWINDOW) = Not HasButton
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsPaletteWindow(Extends Win As Window) As Boolean
		  Return TestWindowStyleEx(win.Handle, WS_EX_PALETTEWINDOW)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IsPaletteWindow(Extends Win As Window, Assigns palettized As Boolean)
		  SetWindowStyleEx(Win.Handle, WS_EX_PALETTEWINDOW) = palettized
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetWindowShape(Extends TargetWindow As Window, Shape As Picture, Transparent As Color)
		  Dim x, x2, y As Integer
		  Dim r1, r2 As Integer
		  Dim i As Integer
		  
		  r1 = CreateRectRgn(0, 0, 0, 0)
		  Dim surf As RGBSurface = Shape.RGBSurface
		  For y = 0 To Shape.height - 1
		    x = 0
		    While x < Shape.width
		      If surf.pixel(x, y) <> transparent Then
		        For x2 = x To Shape.width - 1
		          If surf.pixel(x2, y) = transparent Then
		            Exit
		          End If
		          r2 = CreateRectRgn(x, y, x2+1, y+1)
		          i = CombineRgn(r1, r1, r2, 2)
		          i = DeleteObject(r2)
		          x = x2
		        Next
		      End If
		      x = x + 1
		    Wend
		  Next
		  i = SetWindowRgn(TargetWindow.Handle, r1, True)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetWindowStyle(HWND As Integer, flag As Integer, Assigns b As Boolean)
		  Dim oldFlags as Integer
		  Dim newFlags as Integer
		  
		  oldFlags = GetWindowLong(HWND, GWL_STYLE)
		  
		  If Not b Then
		    newFlags = BitAnd(oldFlags, Bitwise.OnesComplement(flag))
		  Else
		    newFlags = BitOr(oldFlags, flag)
		  End
		  
		  Call SetWindowLong(HWND, GWL_STYLE, newFlags)
		  Call SetWindowPos(HWND, 0, 0, 0, 0, 0, SWP_NOMOVE + SWP_NOSIZE + SWP_NOZORDER + SWP_FRAMECHANGED)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetWindowStyleEx(HWND As Integer, flag As Integer, Assigns b As Boolean)
		  Dim oldFlags as Integer
		  Dim newFlags as Integer
		  
		  oldFlags = GetWindowLong(HWND, GWL_EXSTYLE)
		  
		  If Not b Then
		    newFlags = BitAnd(oldFlags, Bitwise.OnesComplement(flag)) 'turn off
		  Else
		    newFlags = BitOr(oldFlags, flag)  'turn on
		  End
		  
		  Call SetWindowLong(HWND, GWL_EXSTYLE, newFlags)
		  Call SetWindowPos(HWND, 0, 0, 0, 0, 0, SWP_NOMOVE + SWP_NOSIZE + SWP_NOZORDER + SWP_FRAMECHANGED)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TestWindowStyle(HWND As Integer, flag As Integer) As Boolean
		  #if TargetWin32
		    Dim oldFlags as Integer
		    oldFlags = GetWindowLong(HWND, GWL_STYLE)
		    
		    Return BitAnd(oldFlags, flag) = flag
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TestWindowStyleEx(HWND As Integer, flag As Integer) As Boolean
		  #if TargetWin32
		    Dim oldFlags as Integer
		    oldFlags = GetWindowLong(HWND, GWL_EXSTYLE)
		    
		    Return BitAnd(oldFlags, flag) = flag
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToRBRECT(Extends Win32Rect As Win32Structs.RECT) As REALbasic.Rect
		  'Returns the passed Win32 RECT Structure as a built-in REALbasic.Rect structure.
		  Dim r As New REALbasic.Rect
		  r.Left = Win32Rect.left
		  r.Bottom = Win32Rect.bottom
		  r.Right = Win32Rect.right
		  r.Top = Win32Rect.top
		  
		  Return r
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToWin32RECT(Extends RBRect As REALbasic.Rect) As Win32Structs.RECT
		  'Returns the passed built-in REALbasic.Rect structure as a Win32 RECT Structure.
		  Dim r As Win32Structs.RECT
		  r.Left = RBRect.left
		  r.Bottom = RBRect.bottom
		  r.Right = RBRect.right
		  r.Top = RBRect.top
		  
		  Return r
		End Function
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
