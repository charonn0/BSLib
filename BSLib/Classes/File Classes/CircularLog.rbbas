#tag Class
Protected Class CircularLog
Implements Readable,Writeable
	#tag Method, Flags = &h0
		Sub Close()
		  If IOStream <> Nil Then
		    IOStream.Flush
		    IOStream.Close
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(file As FolderItem, readwrite As Boolean = True)
		  If file.Exists Then
		    IOStream = BinaryStream.Open(file, readwrite)
		    IOStream.Position = IOStream.Length
		  Else
		    IOStream = BinaryStream.Create(file, False)
		    If MaxLength = 0 Then MaxLength = 4096
		  End If
		  
		  Call IOStream.Truncate(MaxLength)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(file As FolderItem, InitialSize As UInt64 = - 1, MaxSize As UInt64 = - 1)
		  If file.Exists Then
		    IOStream = BinaryStream.Open(file, True)
		  Else
		    IOStream = BinaryStream.Create(file, True)
		  End If
		  
		  If IOStream.Length < InitialSize And Not (InitialSize < 0) Then
		    Call IOStream.Truncate(InitialSize)
		  End If
		  
		  If IOStream.Length > MaxSize And Not (MaxSize < 0) Then
		    Call IOStream.Truncate(MaxSize)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(FileHandle As Integer, HandleType As Integer = BinaryStream.HandleTypeWin32Handle)
		  IOStream = New BinaryStream(FileHandle, HandleType)
		  IOStream.Position = IOStream.Length
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Destructor()
		  Me.Close()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EOF() As Boolean Implements Readable.EOF
		  Return False
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Flush() Implements Writeable.Flush
		  IOStream.Flush()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Handle(HandleType As Integer = BinaryStream.HandleTypeWin32Handle) As Integer
		  Return IOStream.Handle(HandleType)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LogFile() As FolderItem
		  'If Platform.KernelVersion >= 6.0 Then
		  'Dim path As New MemoryBlock(2048)
		  'Dim size As Integer = GetFinalPathNameByHandle(Me.Handle, path, path.Size, 0)
		  'If size > path.Size Then
		  'path = New MemoryBlock(size)
		  'Call GetFinalPathNameByHandle(Me.Handle, path, path.Size, 0)
		  '
		  'ElseIf size = 0 Then
		  'Return Nil
		  '
		  'End If
		  '
		  'Return GetFolderItem(path.WString(0), FolderItem.PathTypeAbsolute)
		  '
		  'ElseIf Platform.KernelVersion > 5.0 Then
		  'Under construction
		  Dim path As New MemoryBlock(MAX_PATH + 1)
		  Dim hFilemap, hMap As Integer
		  
		  hFilemap = CreateFileMapping(Me.Handle, Nil, PAGE_READONLY, 0, 1, path)
		  If hFilemap <> INVALID_HANDLE_VALUE Then
		    hMap = MapViewOfFile(hFilemap, FILE_MAP_READ, 0, 0, 1)
		    
		    If hMap <> INVALID_HANDLE_VALUE Then
		      
		      path = New MemoryBlock(MAX_PATH + 1)
		      
		      If PSAPI.GetMappedFileName(GetCurrentProcess(), hMap, path, MAX_PATH) > 0 Then
		        
		        For v As Integer = 0 To VolumeCount - 1
		          Dim outpath As New MemoryBlock(2048)
		          Dim Size As Integer = QueryDosDevice(Volume(v).AbsolutePath_, outpath, outpath.Size)
		          If Size > outpath.Size Then
		            outpath = New MemoryBlock(Size)
		            Call QueryDosDevice(Volume(v).AbsolutePath_, outpath, outpath.Size)
		          End If
		          If Left(path.WString(0), outpath.WString(0).Len) = outpath.WString(0) Then
		            Return GetFolderItem(Replace(outpath.WString(0), path.WString(0), Volume(v).AbsolutePath_))
		          End If
		        Next
		        
		      End If
		      
		    End If
		    
		  End If
		  
		  'End If
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Read(Count As Integer, encoding As TextEncoding = Nil) As String Implements Readable.Read
		  Dim tmp As String
		  If IOStream.Position + Count <= IOStream.Length Then
		    tmp = IOStream.Read(Count, encoding)
		  Else
		    //Recycle
		    Dim c As Integer = (IOStream.Position + Count) - IOStream.Length
		    tmp = IOStream.Read(Count - c)
		    IOStream.Position = 0
		    tmp = tmp + IOStream.Read(c)
		  End If
		  
		  Return tmp
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadError() As Boolean Implements Readable.ReadError
		  Return IOStream.ReadError()
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadLine(Encoding As TextEncoding = Nil) As String
		  Dim line As String
		  If IOStream.EOF Then IOStream.Position = 0
		  
		  While Not IOStream.EOF
		    Dim char, EOL As String
		    #If TargetWin32 Then
		      char = IOStream.Read(2, Encoding)
		      EOL = EndOfLine.Windows
		      
		    #ElseIf TargetLinux
		      char = IOStream.Read(1, Encoding)
		      EOL = EndOfLine.UNIX
		      
		    #ElseIf TargetMacOS
		      char = IOStream.Read(1, Encoding)
		      EOL = EndOfLine.Macintosh
		      
		    #endif
		    
		    If char <> EOL Then
		      line = line + char
		    Else
		      Exit While
		    End If
		  Wend
		  
		  Return line
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Write(text As String) Implements Writeable.Write
		  If IOStream.Position + text.LenB <= MaxLength Then
		    IOStream.Write(text)
		  Else
		    //Recycle
		    Dim c As Integer = (IOStream.Position + text.LenB) - IOStream.Length
		    IOStream.Write(Left(text, text.LenB - c))
		    IOStream.Position = 0
		    IOStream.Write(Mid(text, text.LenB - c))
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function WriteError() As Boolean Implements Writeable.WriteError
		  Return IOStream.WriteError()
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteLine(Text As String)
		  Dim EoL As String
		  #If TargetWin32 Then
		    EoL = EndOfLine.Windows
		  #ElseIf TargetLinux
		    EoL = EndOfLine.UNIX
		  #ElseIf TargetMacOS
		    EoL = EndOfLine.Macintosh
		  #endif
		  
		  If IOStream.Position + text.LenB + EoL.LenB <= MaxLength Then
		    IOStream.Write(text + EoL)
		  Else
		    //Recycle
		    IOStream.Position = 0
		    IOStream.Write(Text + EoL)
		  End If
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private IOStream As BinaryStream
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return IOStream.Length
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  //Redirect the value to MaxLength
			  MaxLength = value
			End Set
		#tag EndSetter
		Length As UInt64
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mMaxLength = 0 Then mMaxLength = Me.Length
			  return mMaxLength
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mMaxLength = value
			  
			  If mMaxLength < Me.Length Then
			    Call IOStream.Truncate(mMaxLength)
			  End If
			End Set
		#tag EndSetter
		MaxLength As UInt64
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mMaxLength As UInt64 = 0
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return IOStream.Position
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  IOStream.Position = value
			End Set
		#tag EndSetter
		Position As Integer
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
			Name="Position"
			Group="Behavior"
			Type="Integer"
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
