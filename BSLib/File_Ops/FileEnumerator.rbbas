#tag Class
Protected Class FileEnumerator
	#tag Method, Flags = &h0
		Sub Constructor(Root As FolderItem, Pattern As String)
		  RootDirectory = Root
		  SearchPattern = Pattern
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Destructor()
		  Call FindClose(FindHandle)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NextItem() As String
		  Dim data As WIN32_FIND_DATA
		  
		  If FindHandle <= 0 Then
		    FindHandle = FindFirstFile(RootDirectory.AbsolutePath + SearchPattern, data)
		    mLastError = GetLastError()
		    Return data.FileName
		  End If
		  
		  If FindNextFile(FindHandle, data) Then
		    mLastError = 0
		    Return DefineEncoding(data.FileName, Encodings.UTF16)
		  Else
		    mLastError = GetLastError()
		    Return ""
		  End If
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private FindHandle As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mLastError
			End Get
		#tag EndGetter
		LastError As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mLastError As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		RootDirectory As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private SearchPattern As String
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
			Name="LastError"
			Group="Behavior"
			Type="Integer"
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
