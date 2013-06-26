#tag Class
Class FileAttributes
	#tag Method, Flags = &h0
		Sub Constructor(Target As FolderItem)
		  Me.TargetItem = Target
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function HasFlag(MatchFlag As Integer) As Boolean
		  Return BitwiseAnd(attribs, MatchFlag) = MatchFlag
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  //Returns true if the file has the archive attribute
			  Return HasFlag(FILE_ATTRIBUTE_ARCHIVE)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  //Sets or clears the archive attibute of the file
			  If Me.Archive = value Then Return
			  If value Then
			    Me.Attribs = Me.Attribs Or FILE_ATTRIBUTE_ARCHIVE
			  Else
			    Me.Attribs = Me.Attribs Or FILE_ATTRIBUTE_ARCHIVE
			    Me.Attribs = Me.Attribs Xor FILE_ATTRIBUTE_ARCHIVE
			  End If
			End Set
		#tag EndSetter
		Archive As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #If TargetWin32 Then
			    Return GetFileAttributes(Me.TargetItem.AbsolutePath_)
			  #endif
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #If TargetWin32 Then
			    Call SetFileAttributes(Me.TargetItem.AbsolutePath_, value)
			  #endif
			End Set
		#tag EndSetter
		Attribs As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  //Returns true if the file has the compressed attribute
			  Return HasFlag(FILE_ATTRIBUTE_COMPRESSED)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  //Sets or clears the compressed attribute of the file
			  If Me.Compressed = value Then Return
			  If value Then
			    Me.Attribs = Me.Attribs Or FILE_ATTRIBUTE_COMPRESSED
			  Else
			    Me.Attribs = Me.Attribs Or FILE_ATTRIBUTE_COMPRESSED
			    Me.Attribs = Me.Attribs Xor FILE_ATTRIBUTE_COMPRESSED
			  End If
			End Set
		#tag EndSetter
		Compressed As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  //Returns true if the file has the encrypted attribute
			  Return HasFlag(FILE_ATTRIBUTE_ENCRYPTED)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  //Sets or clears the encrypted attibute of the file
			  If Me.Encrypted = value Then Return
			  If value Then
			    Me.Attribs = Me.Attribs Or FILE_ATTRIBUTE_ENCRYPTED
			  Else
			    Me.Attribs = Me.Attribs Or FILE_ATTRIBUTE_ENCRYPTED
			    Me.Attribs = Me.Attribs Xor FILE_ATTRIBUTE_ENCRYPTED
			  End If
			End Set
		#tag EndSetter
		Encrypted As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  //Returns true if the file has the hidden attribute
			  Return HasFlag(FILE_ATTRIBUTE_HIDDEN)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  //Sets or clears the hidden attribute of the file
			  If Me.Hidden = value Then Return
			  If value Then
			    Me.Attribs = Me.Attribs Or FILE_ATTRIBUTE_HIDDEN
			  Else
			    Me.Attribs = Me.Attribs Or FILE_ATTRIBUTE_HIDDEN
			    Me.Attribs = Me.Attribs Xor FILE_ATTRIBUTE_HIDDEN
			  End If
			End Set
		#tag EndSetter
		Hidden As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  //Returns true if the file has the normal attribute
			  Return HasFlag(FILE_ATTRIBUTE_NORMAL)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  //Sets or clears the normal attibute of the file
			  If Me.Hidden = value Then Return
			  If value Then
			    Me.Attribs = Me.Attribs Or FILE_ATTRIBUTE_NORMAL
			  Else
			    Me.Attribs = Me.Attribs Or FILE_ATTRIBUTE_NORMAL
			    Me.Attribs = Me.Attribs Xor FILE_ATTRIBUTE_NORMAL
			  End If
			End Set
		#tag EndSetter
		Normal As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  //Returns true if the file has the read only attribute
			  Return HasFlag(FILE_ATTRIBUTE_READONLY)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  //Sets or clears the read only attibute of the file
			  If Me.Hidden = value Then Return
			  If value Then
			    Me.Attribs = Me.Attribs Or FILE_ATTRIBUTE_READONLY
			  Else
			    Me.Attribs = Me.Attribs Or FILE_ATTRIBUTE_READONLY
			    Me.Attribs = Me.Attribs Xor FILE_ATTRIBUTE_READONLY
			  End If
			End Set
		#tag EndSetter
		ReadOnly As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  //Returns true if the file has the sytem file attribute
			  Return HasFlag(FILE_ATTRIBUTE_SYSTEM)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  //Sets or clears the system file attibute of the file
			  If Me.Hidden = value Then Return
			  If value Then
			    Me.Attribs = Me.Attribs Or FILE_ATTRIBUTE_SYSTEM
			  Else
			    Me.Attribs = Me.Attribs Or FILE_ATTRIBUTE_SYSTEM
			    Me.Attribs = Me.Attribs Xor FILE_ATTRIBUTE_SYSTEM
			  End If
			End Set
		#tag EndSetter
		SystemFile As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		TargetItem As FolderItem
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Archive"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Attribs"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Compressed"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Encrypted"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Hidden"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
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
			Name="Normal"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ReadOnly"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SystemFile"
			Group="Behavior"
			Type="Boolean"
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
