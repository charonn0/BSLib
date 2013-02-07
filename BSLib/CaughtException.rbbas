#tag Class
Protected Class CaughtException
Inherits RuntimeException
	#tag Method, Flags = &h0
		Sub Constructor(exc as RuntimeException)
		  If exc IsA CaughtException Then
		    exc = CaughtException(exc).OrigExc
		  End
		  Self.OrigExc = exc
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Stack() As String()
		  Return Self.OrigExc.Stack
		End Function
	#tag EndMethod


	#tag Note, Name = About 
		Code for this class was originally posted by Thomas Tempelmann on the RealSoftware blog
		at http://www.realsoftwareblog.com/2012/07/preserving-stack-trace-when-catching.html
		
	#tag EndNote


	#tag Property, Flags = &h21
		Private OrigExc As RuntimeException
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="ErrorNumber"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="RuntimeException"
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
			Name="Message"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="RuntimeException"
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
