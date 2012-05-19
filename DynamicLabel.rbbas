#tag Class
Protected Class DynamicLabel
Inherits Canvas
	#tag Event
		Sub Paint(g As Graphics)
		  Dim p As Picture = TextToPicture(Me.Text, TextFont, TextSize, Bold, Underline, Italic, TextColor, BackColor)
		  Dim tmp As Picture = Buffer
		  tmp.Graphics.DrawPicture(p, 0, 0)
		  g.DrawPicture(tmp, 0, 0)
		  
		  
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h1
		Protected Function GetBackdrop() As Picture
		  '//Returns a Picture of the defined rectangle from current desktop.
		  '//Rectangle coordinates are relative to the upper left corner of the user's leftmost screen, in pixels
		  '
		  '#If TargetWin32 Then
		  'Declare Function GetDesktopWindow Lib "User32" () As Integer
		  'Declare Function GetDC Lib "User32" (HWND As Integer) As Integer
		  'Declare Function BitBlt Lib "GDI32" (DCdest As Integer, xDest As Integer, yDest As Integer, nWidth As Integer, nHeight As Integer, _
		  'DCdource As Integer, xSource As Integer, ySource As Integer, rasterOp As Integer) As Boolean
		  'Declare Function ReleaseDC Lib "User32" (HWND As Integer, DC As Integer) As Integer
		  '
		  'Dim screenWidth, screenHeight As Integer
		  'screenWidth = right - left
		  'screenHeight = bottom - top
		  'Dim screenCap As New Picture(screenWidth, screenHeight, 24)
		  'Dim deskHWND As Integer = GetDesktopWindow()
		  'Dim deskHDC As Integer = GetDC(deskHWND)
		  'Call BitBlt(screenCap.Graphics.Handle(Graphics.HandleTypeHDC), 0, 0, ScreenWidth, ScreenHeight, DeskHDC, left, top, SRCCOPY Or CAPTUREBLT)
		  'Call ReleaseDC(DeskHWND, deskHDC)
		  '
		  'Return screenCap
		  '#endif
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Paint(g As Graphics)
	#tag EndHook


	#tag Property, Flags = &h0
		BackColor As Color = &c000000
	#tag EndProperty

	#tag Property, Flags = &h0
		Bold As Boolean = False
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  #pragma BreakOnExceptions Off
			  Dim p As New Picture(Me.Width, Me.Height, 32)
			  p.Graphics.ForeColor = BackColor
			  p.Graphics.FillRect(0, 0, p.Width, p.Height)
			  Return p
			  
			  Exception OutOfBoundsException
			    Return New Picture(1, 1, 24)
			End Get
		#tag EndGetter
		Private Buffer As Picture
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Italic As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mText As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mText
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mText = value
			End Set
		#tag EndSetter
		Text As String
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		TextColor As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		TextFont As String = "System"
	#tag EndProperty

	#tag Property, Flags = &h0
		TextSize As Integer = 11
	#tag EndProperty

	#tag Property, Flags = &h0
		Transparent As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		Underline As Boolean = False
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="AcceptFocus"
			Visible=true
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AcceptTabs"
			Visible=true
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BackColor"
			Visible=true
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backdrop"
			Visible=true
			Group="Appearance"
			Type="Picture"
			EditorType="Picture"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Bold"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DoubleBuffer"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EraseBackground"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ForeColor"
			Visible=true
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HelpTag"
			Visible=true
			Group="Appearance"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialParent"
			Group="Initial State"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Italic"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Group="Position"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Text"
			Visible=true
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextColor"
			Visible=true
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextFont"
			Visible=true
			Group="Behavior"
			InitialValue="System"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextSize"
			Visible=true
			Group="Behavior"
			InitialValue="11"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Underline"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UseFocusRing"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="Canvas"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			InheritedFrom="Canvas"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
