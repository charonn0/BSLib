#tag Class
Protected Class ClipboardMonitor
Inherits WindowMessenger
	#tag Event
		Function WindowMessage(Message As Integer, WParam As Ptr, LParam As Ptr) As Boolean
		  Select Case Message
		  Case WM_CHANGECBCHAIN
		    'A window is being removed
		    If Integer(WParam) = NextViewerWindow Then
		      NextViewerWindow = Integer(LParam)
		      Return True
		    Else
		      Call SendMessage(NextViewerWindow, Message, WParam, LParam)
		      Return True
		    End If
		  Case WM_DRAWCLIPBOARD
		    'clipboard changed, pass it on
		    Call SendMessage(NextViewerWindow, Message, WParam, LParam)
		    RaiseEvent ClipboardChanged()
		    Return True
		  Else
		    ' this should never happen since we only get the messages we asked for
		    Return False
		  End Select
		End Function
	#tag EndEvent


	#tag Method, Flags = &h1000
		Sub Constructor(ParentHandle As Integer = 0)
		  // Calling the overridden superclass constructor.
		  Super.Constructor(ParentHandle, WM_CHANGECBCHAIN, WM_DRAWCLIPBOARD)
		  NextViewerWindow = SetClipboardViewer(Me.ParentWindow)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Destructor()
		  Call ChangeClipboardChain(Me.ParentWindow, Me.NextViewerWindow)
		  Super.Destructor()
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event ClipboardChanged()
	#tag EndHook


	#tag Note, Name = About this class
		: http://msdn.microsoft.com/en-us/library/windows/desktop/ms649052%28v=vs.85%29.aspx
		
		Place this class on a window, or call the class constructor with a handle to the desired parent window.
		The ClipboardChanged event will fire every time the contents of the Clipboard are set.
		. SeeLer
	#tag EndNote


	#tag Property, Flags = &h1
		Protected NextViewerWindow As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
