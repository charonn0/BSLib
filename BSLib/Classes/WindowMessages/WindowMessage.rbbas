#tag Class
Protected Class WindowMessage
	#tag Method, Flags = &h0
		Sub Constructor(MsgName As String)
		  mMessageName = MsgName
		  mMessageID = RegisterWindowMessage(MessageName)
		  If MessageID = 0 Then
		    mMessageID = GetLastError
		    Dim err As New Win32Exception(mMessageID)
		    Raise err
		  End If
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mMessageID
			End Get
		#tag EndGetter
		MessageID As UInt16
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mMessageName
			End Get
		#tag EndGetter
		MessageName As String
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mMessageID As UInt16
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMessageName As String
	#tag EndProperty


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
			Name="MessageName"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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
