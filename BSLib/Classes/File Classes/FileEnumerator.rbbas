#tag Class
Protected Class FileEnumerator
	#tag Method, Flags = &h0
		Sub Constructor(Root As FolderItem, Pattern As String)
		  //Root is the directory in which to search
		  //Pattern is a full or partial filename, with support for wildcards (e.g. "*.exe" to enumerate all files ending in .exe)
		  
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
		Function NextItem() As WIN32_FIND_DATA
		  //This function returns the WIN32_FIND_DATA structure of the next file (starting with the first) in the RootDirectory
		  //If there are no more files, this function sets LastError <> 0
		  
		  Dim data As WIN32_FIND_DATA
		  
		  If FindHandle <= 0 Then
		    FindHandle = FindFirstFile("//?/" + ReplaceAll(RootDirectory.AbsolutePath, "/", "//") + SearchPattern + Chr(0), data)
		    mLastError = GetLastError()
		  ElseIf FindNextFile(FindHandle, data) Then
		    mLastError = 0
		  Else
		    mLastError = GetLastError()
		  End If
		  
		  Return data
		End Function
	#tag EndMethod


	#tag Note, Name = How to use
		Create a new instance of the FileEnumerator class passing the top of the directory tree to be examined and a
		search pattern to match file/folder names against. The search patterns allowed are the same as those accepted
		by the cmd.exe 'dir' command, e.g. "*.*" matches all names; "*.EXE" matches all .exe files; etc.
		
		Call NextItem to receive the next file's or folder's WIN32_FIND_DATA structure.
		
		Example, finding all EXE files in a user selected folder:
		
		  Dim fe As New FileEnumerator(SelectFolder, "*.exe")
		  Dim files() As String
		  Do
		    Dim file As WIN32_FIND_DATA = fe.NextItem()
		    If fe.LastError = 0 Then
		      files.Append(DefineEncoding(file.FileName, Encodings.UTF16))
		    Else
		      Exit Do
		    End If
		  Loop
	#tag EndNote


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

	#tag Property, Flags = &h21
		Private RootDirectory As FolderItem
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
