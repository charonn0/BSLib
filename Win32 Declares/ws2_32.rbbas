#tag Module
Protected Module ws2_32
	#tag ExternalMethod, Flags = &h0
		Declare Function gethostbyname Lib "ws2_32" (Address As CString) As Ptr
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetHostName Lib "ws2_32" (name As Ptr, size As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function inet_addr Lib "ws2_32" (Address As CString) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Sub WSACleanup Lib "ws2_32" ()
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Sub WSAStartup Lib "ws2_32" (versRequest As Integer, data As Ptr)
	#tag EndExternalMethod


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
