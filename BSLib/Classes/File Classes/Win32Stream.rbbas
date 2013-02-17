#tag Class
Protected Class Win32Stream
Implements Readable,Writeable
	#tag Method, Flags = &h0
		Sub Close()
		  Call CloseHandle(Me.Handle)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(FileHandle As Integer)
		  #If Not TargetWin32 Then #pragma Error "This class is for Windows only."
		  Me.mHandle = FileHandle
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Constructor(FileHandle As Integer, Error As Integer)
		  #If Not TargetWin32 Then #pragma Error "This class is for Windows only."
		  Me.mHandle = FileHandle
		  mLastError = Error
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Create(File As FolderItem, Overwrite As Boolean = False) As Win32Stream
		  Dim CreateDisposition As Integer
		  If Overwrite Then
		    CreateDisposition = CREATE_ALWAYS
		  Else
		    CreateDisposition = CREATE_NEW
		  End If
		  
		  Return Win32Stream.Open(File, 0, 0, CreateDisposition)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Create(File As FolderItem, Access As Integer = 0, Sharemode As Integer = 0, CreateDisposition As Integer = 0, Flags As Integer = 0) As Win32Stream
		  If CreateDisposition = 0 Then CreateDisposition = CREATE_NEW
		  Return Win32Stream.Open(File, Access, Sharemode, CreateDisposition, Flags)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  Me.Close()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EOF() As Boolean Implements Readable.EOF
		  Return LastError = ERROR_HANDLE_EOF
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Flush() Implements Writeable.Flush
		  If FlushFileBuffers(Me.Handle) Then
		    mLastError = 0
		  Else
		    mLastError = GetLastError()
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Open(File As FolderItem, ReadWrite As Boolean = True) As Win32Stream
		  Dim desiredaccess As Integer
		  If ReadWrite Then
		    desiredaccess = GENERIC_READ Or GENERIC_WRITE
		  Else
		    desiredaccess = GENERIC_READ
		  End If
		  
		  Return Win32Stream.Open(File, desiredaccess)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Open(File As FolderItem, Access As Integer = 0, Sharemode As Integer = 0, CreateDisposition As Integer = 0, Flags As Integer = 0) As Win32Stream
		  Dim tmp As Win32Stream = New Win32Stream(INVALID_HANDLE_VALUE)
		  Dim hFile As Integer
		  
		  If Access = 0 Then Access = GENERIC_ALL
		  If CreateDisposition = 0 Then CreateDisposition = OPEN_EXISTING
		  If sharemode = 0 Then sharemode = FILE_SHARE_READ 'exclusive write access
		  
		  hFile = CreateFile("//?/" + ReplaceAll(File.AbsolutePath, "/", "//"), Access, sharemode, 0, CreateDisposition, Flags, 0)
		  
		  If hFile <> INVALID_HANDLE_VALUE Then
		    tmp = New Win32Stream(hFile, GetLastError)
		  End If
		  
		  Return tmp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Read(Count As Integer, encoding As TextEncoding = Nil) As String Implements Readable.Read
		  #pragma BoundsChecking Off
		  
		  Dim mb As New MemoryBlock(Count)
		  Dim read As Integer
		  If ReadFile(Me.Handle, mb, mb.Size, read, Nil) Then
		    If read = mb.Size Then
		      mLastError = 0
		    Else
		      mLastError = ERROR_HANDLE_EOF
		    End If
		  Else
		    mLastError = GetLastError()
		  End If
		  
		  If encoding = Nil Then encoding = Encodings.UTF8
		  Dim data As String = DefineEncoding(mb.StringValue(0, mb.Size), encoding)
		  Return data
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadError() As Boolean Implements Readable.ReadError
		  Return LastError <> 0
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Write(text As String) Implements Writeable.Write
		  Dim mb As MemoryBlock = text
		  Dim written As Integer
		  If WriteFile(Me.Handle, mb, mb.Size, written, Nil) Then
		    mLastError = 0
		  Else
		    mLastError = GetLastError()
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function WriteError() As Boolean Implements Writeable.WriteError
		  Return LastError <> 0
		End Function
	#tag EndMethod


	#tag Note, Name = About this class
		This class emulates RB's built-in BinaryStream class using Winapi calls like CreateFile, WriteFile, etc. and implements the Writeable and Readable interfaces.
		Use the shared methods to create or open folderitems, and the Write, Read, EOF, etc. methods just like the BinaryStream class. e.g.:
		
		  Dim f As FolderItem = GetSaveFolderItem("", "test.txt")
		  If f <> Nil Then
		    Dim stream As Win32Stream = Win32Stream.Create(f)
		    For i As Integer = 0 To 99
		      stream.Write("Hello, world!")
		    Next
		    stream.Close
		  End If
		
		Or,
		
		  Dim f As FolderItem = GetOpenFolderItem("")
		  If f <> Nil Then
		    Dim stream As Win32Stream = Win32Stream.Open(f)
		    stream.Position = stream.Length \ 2
		    While Not stream.EOF
		      Print(stream.Read(1024))
		    Wend
		  End If
		
		
		
		The Shared methods' optional parameters (FolderItem, Integer, Integer, Integer, Integer) correspond to those used by the CreateFile Win32 function.
		
		Win32Template files are not supported by the shared methods, however the class itself doesn't need to know from where the Win32 handle it's operating 
		on comes. This class doesn't even need to know that the handle refers to a file, only that the handle is valid for file-stream functions like ReadFile
		and SetFilePointer.
	#tag EndNote


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mHandle
			End Get
		#tag EndGetter
		Handle As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mLastError
			End Get
		#tag EndGetter
		LastError As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim value, oldvalue As Integer
			  oldvalue = Me.Position
			  value = SetFilePointer(Me.Handle, 0, Nil, FILE_END)
			  Me.Position = oldvalue
			  mLastError = GetLastError()
			  Return value
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  'Sets the position of the EOF. The file is truncated or expanded on-disk as needed to meet the new EOF.
			  'If the current Position of the file pointer is outside the new length, then then Position is moved to
			  'the new EOF. Otherwise thefile pointer position relative to the beginning of the file remains the same.
			  
			  Dim oldvalue As Integer = Me.Position
			  Me.Position = value
			  If Not SetEndOfFile(Me.Handle) Then
			    mLastError = GetLastError()
			  Else
			    mLastError = 0
			  End If
			  If oldvalue <= Me.Position Then Me.Position = oldvalue
			End Set
		#tag EndSetter
		Length As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected mHandle As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mLastError As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim value As Integer = SetFilePointer(Me.Handle, 0, Nil, FILE_CURRENT)
			  mLastError = GetLastError()
			  Return value
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Call SetFilePointer(Me.Handle, value, Nil, FILE_BEGIN)
			  mLastError = GetLastError()
			  
			  
			  
			End Set
		#tag EndSetter
		Position As Integer
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Handle"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
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
			Name="Length"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
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
