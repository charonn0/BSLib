#tag Class
Protected Class AlternateDataStream
	#tag Method, Flags = &h0
		Sub Constructor(BaseItem As FolderItem)
		  Me.MainStream = BaseItem
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Count() As Integer
		  //Counts the number of data streams attached to a file or directory on an NTFS volume. This count includes the default main stream.
		  //Windows Vista and newer have much better APIs for handling streams than previous versions, so we use those when possible.
		  //On error, returns -1
		  
		  #If TargetWin32 Then
		    If Platform.KernelVersion >= 5.0 And Platform.KernelVersion < 6.0 Then
		      
		      Dim fHandle As Integer = CreateFile(MainStream.AbsolutePath_, 0,  FILE_SHARE_READ Or FILE_SHARE_WRITE, 0, OPEN_EXISTING, 0, 0)
		      If fHandle > 0 Then
		        Dim mb As New MemoryBlock(64 * 1024)
		        Dim status As IO_STATUS_BLOCK
		        NtQueryInformationFile(fHandle, status, mb, mb.Size, 22)
		        Dim ret, currentOffset As Integer
		        While True
		          If mb.UInt32Value(currentOffset) > 0 Then
		            currentOffset = currentOffset + mb.UInt32Value(currentOffset)
		            ret = ret + 1
		          Else
		            Exit While
		          End If
		        Wend
		        Return ret
		        
		      Else
		        Return -1
		      End If
		    ElseIf Platform.KernelVersion >= 6.0 Then
		      Dim buffer As WIN32_FIND_STREAM_DATA
		      Dim sHandle As Integer = FindFirstStream(MainStream.AbsolutePath_, 0, buffer, 0)
		      Dim ret As Integer
		      
		      If sHandle > 0 Then
		        Do
		          ret = ret + 1
		        Loop Until Not FindNextStream(sHandle, buffer)
		      Else
		        Return -1
		      End If
		      Call FindClose(sHandle)
		      Return ret
		    Else
		      Return -1
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Delete(StreamName As String) As Boolean
		  //Deletes the named stream of the file or directory specified in target. If deletion was successful, returns True. Otherwise, returns False.
		  //Failure reasons may be: access to the file or directory was denied or the target or named stream does not exist. Passing "" as the
		  //StreamName will delete the file altogether (same as FolderItem.Delete)
		  
		  #If TargetWin32 Then
		    If MainStream <> Nil Then
		      Return DeleteFile(MainStream.AbsolutePath_ + ":" + StreamName + ":$DATA")
		    Else
		      Return False
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Stream(StreamIndex As Integer) As String
		  //Accesses the data stream of the target FolderItem at StreamIndex. If target has fewer than StreamIndex data streams, or if the target
		  //is not on an NTFS volume, an OutOfBoundsException is raised. If the file is not readable, an IOException is raised.
		  //Otherwise, a String corresponding to the name of the requested data stream is Returned.
		  //Raises a PlatformNotSupportedException on versions of Windows prior to Windows 2000.
		  //Call FolderItem.StreamCount to get the number of streams. The main data stream is always at StreamIndex zero and does
		  //not have a name.
		  
		  
		  #If TargetWin32 Then
		    If StreamIndex = 0 Then Return ""  //Stream zero is the unnamed main stream
		    
		    If Platform.KernelVersion < 6.0 And Platform.KernelVersion >= 5.0 Then
		      Dim fHandle As Integer = CreateFile(MainStream.AbsolutePath_, 0,  FILE_SHARE_READ Or FILE_SHARE_WRITE, 0, OPEN_EXISTING, 0, 0)
		      If fHandle > 0 Then
		        Dim mb As New MemoryBlock(64 * 1024)
		        Dim status As IO_STATUS_BLOCK
		        NtQueryInformationFile(fHandle, status, mb, mb.Size, 22)
		        Dim currentOffset As Integer
		        For i As Integer = 0 To StreamIndex
		          If mb.UInt32Value(currentOffset) > 0 Then
		            currentOffset = mb.UInt32Value(currentOffset)
		            If i = StreamIndex Then
		              Call CloseHandle(fHandle)
		              Return mb.WString(24)
		            End If
		          Else
		            Call CloseHandle(fHandle)
		            Raise New OutOfBoundsException
		          End If
		        Next
		        Call CloseHandle(fHandle)
		      Else
		        Raise New IOException
		      End If
		    ElseIf Platform.KernelVersion >= 6.0 Then
		      Dim buffer As WIN32_FIND_STREAM_DATA
		      Dim sHandle As Integer = FindFirstStream(MainStream.AbsolutePath_, 0, buffer, 0)
		      Dim ret As String
		      
		      If sHandle > 0 Then
		        Dim i As Integer = 1
		        If FindNextStream(sHandle, buffer) Then
		          Do
		            If i = StreamIndex Then
		              ret = DefineEncoding(buffer.StreamName, Encodings.UTF16)
		              ret = NthField(ret, ":", 2)
		              Exit
		            ElseIf i >= StreamIndex Then
		              Raise New OutOfBoundsException
		            Else
		              i = i + 1
		            End If
		          Loop Until Not FindNextStream(sHandle, buffer)
		        Else
		          Raise New OutOfBoundsException
		        End If
		        
		        Call FindClose(sHandle)
		        Return ret
		      Else
		        Raise New IOException
		      End If
		    Else
		      Raise New PlatformNotSupportedException
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Stream(StreamName As String, CreateNew As Boolean = False) As FolderItem
		  //Opens the named stream for the file or directory specified in target. If CreateNew=True then the stream
		  //is created if it doesn't exist. Returns a FolderItem corresponding to the stream. On error returns Nil.
		  //Failure reasons may be: the volume is not NTFS, access to the file or directory was denied, or the target does not exist.
		  
		  #If TargetWin32 Then
		    If MainStream = Nil Then Return Nil
		    If Not MainStream.Exists Then Return Nil
		    Dim target As FolderItem
		    Dim fHandle As Integer = CreateFile(MainStream.AbsolutePath_ + ":" + StreamName + ":$DATA", 0, _
		    FILE_SHARE_READ Or FILE_SHARE_WRITE, 0, CREATE_NEW, 0, 0)
		    If fHandle > 0 Then
		      target = GetFolderItem(MainStream.AbsolutePath_ + ":" + StreamName + ":$DATA")
		      Call CloseHandle(fHandle)
		      Return target
		    Else
		      If GetLastError = 80 And CreateNew Then  //ERROR_FILE_EXISTS
		        target = GetFolderItem(MainStream.AbsolutePath_ + ":" + StreamName + ":$DATA")
		        Return target
		      End If
		    End If
		  #endif
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		MainStream As FolderItem
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
