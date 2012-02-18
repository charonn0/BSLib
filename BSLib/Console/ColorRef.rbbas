#tag Class
Protected Class ColorRef
	#tag Method, Flags = &h0
		Function Operator_Compare(c As Color) As Boolean
		  #pragma Unused c
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Operator_Convert(c As Color)
		  Blue = c.Blue
		  Green = c.Green
		  Red = c.Red
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Lookup(name As String) As Variant
		  #pragma Unused name
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Blue As UInt16
	#tag EndProperty

	#tag Property, Flags = &h0
		Green As UInt16
	#tag EndProperty

	#tag Property, Flags = &h0
		Red As UInt16
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Val("&h00" + IntToHex(Me.Blue) + IntToHex(Me.Green) + IntToHex(Me.Red))
			End Get
		#tag EndGetter
		Value As UInt32
	#tag EndComputedProperty


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
End Class
#tag EndClass
