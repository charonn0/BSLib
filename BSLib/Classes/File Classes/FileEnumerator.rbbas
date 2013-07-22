#tag Class
Protected Class FileEnumerator
	#tag Method, Flags = &h1
		Protected Sub Close()
		  Call FindClose(FindHandle)
		  FindHandle = -1
		  mLastError = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Root As FolderItem = Nil, Pattern As String = "*.*")
		  //Root is the directory in which to search
		  //Pattern is a full or partial filename, with support for wildcards (e.g. "*.exe" to enumerate all files ending in .exe)
		  
		  mRootDirectory = Root
		  mSearchPattern = Pattern
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Destructor()
		  Me.Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NextFolderItem() As FolderItem
		  //This function returns a folderitem representing the next file or directory (starting with the first) in the RootDirectory
		  //If there are no more files, this function sets LastError=18 (ERROR_NO_MORE_FILES). If no more files or an error occurred,
		  //returns Nil.
		  
		  Dim data As WIN32_FIND_DATA = Me.NextItem
		  If data.FileName.Trim = "." Or data.FileName.Trim = ".." Then Return NextFolderItem
		  If Me.LastError = 0 Then
		    Return Me.RootDirectory.Child(data.FileName)
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NextItem() As WIN32_FIND_DATA
		  //This function returns the WIN32_FIND_DATA structure of the next file or directory (starting with the first) in the RootDirectory
		  //If there are no more files, this function sets LastError=18 (ERROR_NO_MORE_FILES).
		  
		  
		  Dim data As WIN32_FIND_DATA
		  
		  If FindHandle <= 0 Then
		    FindHandle = FindFirstFile("//?/" + ReplaceAll(RootDirectory.AbsolutePath_, "/", "//") + SearchPattern + Chr(0), data)
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
		  Dim files() As FolderItem
		  Do
		    Dim file As FolderItem = fe.NextItem()
		    If file <> Nil Then
		      files.Append(file)
		    End If
		  Loop Until fe.LastError <> 0
		
		Using this class to enumerate a folder will be much faster than FolderItem.Item(Index), especially on large
		directories. Execution time of FolderItem.Item rises exponentially relative to the number of items in the directory.
		The execution time of FileEnumerator.NextItem rises only linearly relative to the number of items.
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

	#tag Property, Flags = &h1
		Protected mLastError As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRootDirectory As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSearchPattern As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mRootDirectory
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Me.Close
			  mRootDirectory = value
			End Set
		#tag EndSetter
		RootDirectory As FolderItem
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mSearchPattern
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Me.Close
			  mSearchPattern = value
			End Set
		#tag EndSetter
		SearchPattern As String
	#tag EndComputedProperty


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
			Name="SearchPattern"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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
