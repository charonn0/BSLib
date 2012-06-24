#tag Module
Protected Module NTDLL
	#tag ExternalMethod, Flags = &h0
		Soft Declare Sub NtQueryInformationFile Lib "NTDLL" (fHandle As Integer, ByRef status As IO_STATUS_BLOCK, FileInformation As Ptr, FILength As UInt32, InfoClass As Int32)
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Soft Declare Function RtlQueryElevationFlags Lib "NTDLL" (ByRef flags As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Soft Declare Function RtlSetProcessIsCritical Lib "NTDLL" (NewStatus As Boolean, ByRef OldStatus As Boolean, needscb As Boolean) As Boolean
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
