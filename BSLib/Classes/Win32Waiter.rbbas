#tag Class
Protected Class Win32Waiter
	#tag Method, Flags = &h21
		Private Sub CallBackHandler(parameter As Ptr, timedOut As Boolean)
		  #pragma Unused parameter
		  #pragma Unused timedOut
		  #pragma X86CallingConvention StdCall
		  System.DebugLog(CurrentMethodName)
		  Dim msg As New WindowMessage("BS_Win32Waiter")
		  Call User32.PostMessage(HWND_BROADCAST, msg.MessageID, Nil, Nil)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Constructor()
		  MessageWindow = New Window
		  MessageWindow.Show
		  MessageWindow.Visible = False
		  Dim msg As New WindowMessage("BS_Win32Waiter")
		  MessageReceiver = New WindowMessenger(MessageWindow.Handle, msg.MessageID)
		  AddHandler MessageReceiver.WindowMessage, AddressOf Me.MessageHandler
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Destructor()
		  Call UnregisterWait(WaitHandle)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MessageHandler(Sender As WindowMessenger, Message As Integer, WParam As Ptr, LParam As Ptr) As Boolean
		  #pragma Unused Sender
		  #pragma Unused Message
		  #pragma Unused WParam
		  #pragma Unused LParam
		  Me.StopWaiting()
		  RaiseEvent Signalled()
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StopWaiting()
		  #If TargetWin32 Then
		    'Call UnregisterWait(WaitHandle)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Wait(WaitObject As Integer)
		  Dim callback As Ptr = AddressOf Me.CallBackHandler
		  If Not RegisterWaitForSingleObject(WaitHandle, WaitObject, callback, Nil, &hFFFFFFFF, WT_EXECUTEONLYONCE) Then
		    Me.LastError = GetLastError()
		    Break
		  End If
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Signalled()
	#tag EndHook


	#tag Note, Name = EXPERIMENTAL
		And crashy
		
	#tag EndNote


	#tag Property, Flags = &h0
		LastError As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected MessageReceiver As WindowMessenger
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected MessageWindow As Window
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected WaitHandle As Integer
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
			Name="LastError"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
