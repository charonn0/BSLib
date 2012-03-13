#tag Module
Protected Module File_Ops
	#tag Method, Flags = &h0
		Function AllNamedStreams(Extends target As FolderItem) As String()
		  //Returns a String array containing the names of all named streams. If the target does not contain any named streams,
		  //then this function returns a string array with Ubound -1
		  //If the target is not on an NTFS volume, an OutOfBoundsException is raised. If the file is not readable, an IOException is Raised
		  //Raises a PlatformNotSupportedException on versions of Windows prior to Windows 2000.
		  
		  #If TargetWin32 Then
		    Dim ret() As String
		    
		    If Platform.IsOlderThan(Platform.WinVista) And Platform.IsAtLeast(Platform.Win2000) Then
		      Soft Declare Sub NtQueryInformationFile Lib "NTDLL" (fHandle As Integer, ByRef status As IO_STATUS_BLOCK, FileInformation As Ptr, FILength As UInt32, InfoClass As Int32)
		      
		      Dim fHandle As Integer = Platform.CreateFile(target.AbsolutePath, 0,  FILE_SHARE_READ Or FILE_SHARE_WRITE, 0, OPEN_EXISTING, 0, 0)
		      If fHandle > 0 Then
		        Dim mb As New MemoryBlock(64 * 1024)
		        Dim status As IO_STATUS_BLOCK
		        NtQueryInformationFile(fHandle, status, mb, mb.Size, 22)
		        Dim currentOffset As Integer
		        While True
		          If mb.UInt32Value(currentOffset) > 0 Then
		            currentOffset = currentOffset + mb.UInt32Value(currentOffset)
		            ret.append(mb.WString(24))
		          Else
		            Exit While
		          End If
		        Wend
		      End If
		    ElseIf Platform.IsAtLeast(Platform.WinVista) Then
		      Dim buffer As WIN32_FIND_STREAM_DATA
		      Dim sHandle As Integer = FindFirstStream(target.AbsolutePath, 0, buffer, 0)
		      
		      If sHandle > 0 Then
		        Do
		          Dim s As String = NthField(DefineEncoding(buffer.StreamName, Encodings.UTF16), ":", 2).Trim
		          If s <> "" Then ret.Append(s)
		        Loop Until Not FindNextStream(sHandle, buffer)
		      End If
		      Call FindClose(sHandle)
		    Else
		      Raise New PlatformNotSupportedException
		    End If
		    Return ret
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Archive(Extends target As FolderItem) As Boolean
		  //Returns true if the file has the archive attribute
		  #If TargetWin32 Then
		    Dim attribs As Integer = GetFileAttributes(target)
		    Return BitwiseAnd(attribs, &h20) = &h20
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Archive(Extends target As FolderItem, Assigns b As Boolean)
		  //Sets or clears the archive attibute of the file
		  #If TargetWin32 Then
		    Dim cfattribs As Integer = GetFileAttributes(target)
		    
		    If target.Archive = b Then Return
		    If b Then
		      cfattribs = cfattribs Or &h20
		    Else
		      cfattribs = cfattribs Or &h20
		      cfattribs = cfattribs Xor &h20
		    End If
		    
		    Call SetFileAttributes(target, cfattribs)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Compressed(Extends target As FolderItem) As Boolean
		  //Returns true if the file has the compressed attribute
		  #If TargetWin32 Then
		    Dim attribs As Integer = GetFileAttributes(target)
		    Return BitwiseAnd(attribs, &h800) = &h800
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Compressed(Extends target As FolderItem, Assigns b As Boolean)
		  //Sets or clears the Compressed attribute. Generally, this will cause Windows to compress the file but there's no guarentee
		  #If TargetWin32 Then
		    Dim cfattribs As Integer = GetFileAttributes(target)
		    
		    If target.Compressed = b Then Return
		    If b Then
		      cfattribs = cfattribs Or &h800
		    Else
		      cfattribs = cfattribs Or &h800
		      cfattribs = cfattribs Xor &h800
		    End If
		    
		    Call SetFileAttributes(target, cfattribs)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CreateHardLink(source As FolderItem, destination As FolderItem) As Boolean
		  //Creates an NTFS Hard Link. Source is the existing file, destination is the new Hard Link
		  //This function will fail if the source and destination are not on the same volume or if the source or destination are directories.
		  //Use CreateSymLink (or CreateShortcut) for files on different volumes.
		  //Raises a PlatformNotSupportedException on versions of Windows not supporting hard links.
		  
		  #If TargetWin32 Then
		    If System.IsFunctionAvailable("CreateHardLinkW", "Kernel32") Then
		      Soft Declare Function CreateHardLinkW Lib "Kernel32" (newFile As WString, existingFile As WString, reserved As Ptr) As Boolean
		      Return CreateHardLinkW(destination.AbsolutePath, source.AbsolutePath, Nil)
		    Else
		      Raise New PlatformNotSupportedException
		    End If
		  #endif
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CreateShortcut(Extends scTarget as FolderItem, scName as String) As FolderItem
		  //Creates a shortcut (.lnk file) in the users %TEMP% directory named scName and pointing to scTarget. Returns
		  //a FolderItem corresponding to the shortcut file. You must move the returned Shortcut file to the desired directory.
		  //On error, returns Nil.
		  
		  #If TargetWin32 Then
		    Dim lnkObj As OLEObject
		    Dim scriptShell As New OLEObject("{F935DC22-1CF0-11D0-ADB9-00C04FD58A0B}")
		    
		    If scriptShell <> Nil then
		      lnkObj = scriptShell.CreateShortcut(SpecialFolder.Temporary.AbsolutePath + scName + ".lnk")
		      If lnkObj <> Nil then
		        lnkObj.Description = scName
		        lnkObj.TargetPath = scTarget.AbsolutePath
		        lnkObj.WorkingDirectory = scTarget.AbsolutePath
		        lnkObj.Save
		        Return SpecialFolder.Temporary.TrueChild(scName + ".lnk")
		      Else
		        Return Nil
		      End If
		    Else
		      Return Nil
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CreateStream(Extends target As FolderItem, StreamName As String) As FolderItem
		  //Creates a new named stream for the file or directory specified in target. If creation was successful or if
		  //the named stream already exists, returns a FolderItem corresponding to the stream. Otherwise, returns Nil.
		  //Failure reasons may be: the volume is not NTFS, access to the file or directory was denied, or the target does not exist.
		  
		  #If TargetWin32 Then
		    If target = Nil Then Return Nil
		    If Not Target.Exists Then Return Nil
		    Dim fHandle As Integer = Platform.CreateFile(target.AbsolutePath + ":" + StreamName + ":$DATA", 0, _
		    FILE_SHARE_READ Or FILE_SHARE_WRITE, 0, CREATE_NEW, 0, 0)
		    If fHandle > 0 Then
		      target = GetFolderItem(target.AbsolutePath + ":" + StreamName + ":$DATA")
		      Call Platform.CloseHandle(fHandle)
		      Return target
		    Else
		      If Platform.LastErrorCode = 80 Then  //ERROR_FILE_EXISTS
		        target = GetFolderItem(target.AbsolutePath + ":" + StreamName + ":$DATA")
		        Return target
		      End If
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CreateSymLink(source As FolderItem, destination As FolderItem) As Boolean
		  //Creates an NTFS Symbolic Link.
		  //Source is the existing file or directory, destination is the new Symbolic Link
		  //Use this function if the source and destination are not on the same volume, otherwise use CreateHardLink
		  //This feature is not available in Windows prior to Windows Vista, and will always fail in older versions.
		  
		  #If TargetWin32 Then
		    If System.IsFunctionAvailable("CreateSymbolicLinkW", "Kernel32") Then
		      Soft Declare Function CreateSymbolicLinkW Lib "Kernel32" (newFile As WString, existingFile As WString, flags As Integer) As Boolean
		      
		      Dim flags As Integer
		      If source.Directory Then
		        flags = &h1
		      End If
		      
		      Return CreateSymbolicLinkW(destination.AbsolutePath, source.AbsolutePath, flags)
		    Else
		      Return False
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DeleteOnReboot(Extends source As FolderItem) As Boolean
		  //Schedules the source file to be deleted on the next system reboot
		  //This function will fail if the user does not have write access to the
		  //HKEY_LOCAL_MACHINE registry hive (HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\PendingFileRenameOperations)
		  //Or if the user does not have write access to the Target file.
		  
		  #If TargetWin32
		    Declare Function MoveFileExW Lib "Kernel32" (sourceFile As WString, destinationFile As WString, flags As Integer) As Boolean
		    
		    Const MOVEFILE_DELAY_UNTIL_REBOOT = 4
		    
		    Return MoveFileExW(source.AbsolutePath, Nil, MOVEFILE_DELAY_UNTIL_REBOOT)
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DeleteStream(Extends f As FolderItem, StreamName As String) As Boolean
		  //Deletes the named stream of the file or directory specified in target. If deletion was successful, returns True. Otherwise, returns False.
		  //Failure reasons may be: access to the file or directory was denied or the target or named stream does not exist. Passing "" as the
		  //StreamName will delete the file altogether (same as FolderItem.Delete)
		  
		  #If TargetWin32 Then
		    Declare Function DeleteFileW Lib "Kernel32" (path As WString) As Boolean
		    
		    If f <> Nil Then
		      Return DeleteFileW(f.AbsolutePath + ":" + StreamName + ":$DATA")
		    Else
		      Return False
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Encrypted(Extends target As FolderItem) As Boolean
		  //Returns True if the file has the Encrypted attribute
		  #If TargetWin32 Then
		    Dim attribs As Integer = GetFileAttributes(target)
		    Return BitwiseAnd(attribs, &h4000) = &h4000
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Encrypted(Extends target As FolderItem, Assigns b As Boolean)
		  //Clears or sets the encrypted attribute
		  
		  #If TargetWin32 Then
		    Dim cfattribs As Integer = GetFileAttributes(target)
		    If target.Encrypted = b Then Return
		    If b Then
		      cfattribs = cfattribs Or &h4000
		    Else
		      cfattribs = cfattribs Or &h4000
		      cfattribs = cfattribs Xor &h4000
		    End If
		    
		    Call SetFileAttributes(target, cfattribs)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function exeType(f As FolderItem) As Integer
		  //Returns an integer based on the type of executable file f is.
		  //-1 = Error or not an executable
		  //0 = A 32-bit Windows-based application
		  //1 = An MS-DOS – based application
		  //2 = A 16-bit Windows-based application
		  //3 = A PIF file that executes an MS-DOS – based application
		  //4 = A POSIX – based application    (e.g. for the pseudo-POSIX Windows subsystem)
		  //5 = A 16-bit OS/2-based application
		  //6 = A 64-bit Windows-based application.
		  
		  #If TargetWin32 Then
		    Declare Function GetBinaryTypeW Lib "Kernel32" (appFile As WString, ByRef binType As Integer) As Boolean
		    
		    Dim type As Integer
		    If GetBinaryTypeW(f.AbsolutePath, type) Then
		      Return type
		    Else
		      Return -1
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Extension(Extends f As FolderItem) As String
		  Dim fn As String = f.Name
		  Dim ext As String = NthField(fn, ".", CountFields(fn, "."))
		  Return ext
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindClose(FindHandle As Integer) As Boolean
		  //Closes the passed FindFirst* handle.
		  Soft Declare Function MyFindClose Lib "Kernel32" Alias "FindClose" (fHandle As Integer) As Boolean
		  Return MyFindClose(FindHandle)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindDefaultApp(Extends documentFile As FolderItem) As FolderItem
		  //Given a documentFile FolderItem, will return a FolderItem corresponding to the application currently
		  //associated with the file (e.g. a .doc file might return C:\Program Files\Microsoft Office\winword.exe)
		  //If no application is associated with the documentFile, the documentFile doesn't exist, or is inaccessble
		  //then this function returns Nil.
		  //If the documentFile is itself an application (.exe, .scr, etc.) then this function returns a FolderItem
		  //corresponding to the documentFile itself (e.g. "C:\foo\bar.exe" is associated with itself.)
		  
		  #If TargetWin32 Then
		    Declare Function FindExecutableW Lib "Shell32" (file As WString, directory As WString, result As Ptr) As Integer
		    
		    Dim mb As New MemoryBlock(260)
		    If FindExecutableW(documentFile.AbsolutePath, Nil, mb) > 32 Then
		      Return GetFolderItem(mb.WString(0))
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindFirstStream(filename As String, InfoLevel As Integer, ByRef buffer As WIN32_FIND_STREAM_DATA, reserved As Integer = 0) As Integer
		  Soft Declare Function FindFirstStreamW Lib "Kernel32" (filename As WString, InfoLevel As Integer, ByRef buffer As WIN32_FIND_STREAM_DATA, reserved As Integer) As Integer
		  Return FindFirstStreamW(filename, InfoLevel, buffer, reserved)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindNextStream(sHandle As Integer, ByRef buffer As WIN32_FIND_STREAM_DATA) As Boolean
		  Soft Declare Function FindNextStreamW Lib "Kernel32" (sHandle As Integer, ByRef buffer As WIN32_FIND_STREAM_DATA) As Boolean
		  Return FindNextStreamW(sHandle, buffer)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getChildren(dir As FolderItem) As FolderItem()
		  //This function recursively builds a FolderItem array consisting of all files beneath a given Directory.
		  //It does not return subfolders, only their contents
		  //Don't use this function for extremely deep folder hierarchies or hierarchies known to have circular link references or you risk a stack overflow.
		  //This function should be cross-platform safe.
		  
		  
		  Dim files(), dirs() As FolderItem
		  dirs.Append(dir)
		  
		  While dirs.Ubound > -1
		    Dim thisDir As FolderItem = dirs.Pop
		    Dim thisDirCount As Integer = thisDir.Count
		    For i As Integer = 1 To thisDirCount
		      If thisDir.Item(i).Directory Then
		        For each item As FolderItem In getChildren(thisDir.Item(i))
		          files.Append(item)
		        Next
		      Else
		        files.Append(thisDir.Item(i))
		      End If
		    Next
		  Wend
		  
		  Return files()
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetDriveFreeSize(Drive As FolderItem) As UInt64
		  //Returns the amount of free space, in bytes, on the volume containing the passed FolderItem. The passed FolderItem need
		  //not refer directly to the volume root.
		  
		  #If TargetWin32 Then
		    Declare Function GetDiskFreeSpaceExW Lib "Kernel32" (dirname As WString, ByRef freeBytesAvailable As UInt64, ByRef totalbytes As UInt64, _
		    ByRef totalFreeBytes As UInt64) As Boolean
		    
		    Dim drvRoot As String = Left(Drive.AbsolutePath, 1) + ":\"
		    Dim total, free, x As UInt64
		    Call GetDiskFreeSpaceExW(drvRoot, x, total, free)
		    
		    Return free
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetDriveSize(Drive As FolderItem) As UInt64
		  //Returns the total capacity, in bytes, of the volume containing the passed FolderItem. The passed FolderItem need
		  //not refer directly to the volume root.
		  
		  #If TargetWin32 Then
		    Declare Function GetDiskFreeSpaceExW Lib "Kernel32" (dirname As WString, ByRef freeBytesAvailable As UInt64, ByRef totalbytes As UInt64, _
		    ByRef totalFreeBytes As UInt64) As Boolean
		    
		    Dim drvRoot As String = Left(Drive.AbsolutePath, 1) + ":\"
		    Dim total, free, x As UInt64
		    Call GetDiskFreeSpaceExW(drvRoot, x, total, free)
		    
		    Return total
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetFileAttributes(f As FolderItem) As Integer
		  //See: Archive, Encrypted, Hidden, IsNormal, ReadOnly, and SystemFile functions in this module.
		  
		  #If TargetWin32 Then
		    Declare Function GetFileAttributesW Lib "Kernel32" (path As WString) As Integer
		    Return GetFileAttributesW(f.AbsolutePath)
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetShortName(Extends target As FolderItem) As String
		  //Same thing as FolderItem.ShellPath
		  
		  #If TargetWin32 Then
		    Declare Function GetShortPathNameW Lib "Kernel32" (longName As WString, shortName As Ptr, buffSize As Integer) As Integer
		    
		    Dim mb As New MemoryBlock(1024)
		    Call GetShortPathNameW(target.AbsolutePath, mb, mb.Size)
		    Return mb.Wstring(0)
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function gzipCompress(Extends source As FolderItem, destination As FolderItem = Nil) As Boolean
		  //This function requires the GZip plugin available at http://sourceforge.net/projects/realbasicgzip/
		  //source is the file to be compressed, destination is where the compressed file will be saved
		  //If destination = Nil then the source file is replaced
		  //This function can be ported to other platforms by modifying the last part (that replaces the original
		  //file with the compressed version.
		  //
		  //The GZip plugin does not support Console Applications
		  
		  #If TargetHasGUI Then
		    If source = Nil Then Return False
		    If Not source.Exists Then Return False
		    
		    
		    Dim inputStream As BinaryStream
		    Dim inputString As String
		    Dim i As Integer
		    Dim gzFile As GZipStream
		    
		    If destination = Nil Then destination = SpecialFolder.Temporary.Child(source.Name + ".tmp")
		    If destination.exists Then destination.delete
		    
		    gzFile = New GZIPStream
		    gzFile.Open(destination, True)
		    inputStream = inputStream.Open(source)
		    
		    If inputStream = Nil Then Return False
		    If  gzFile.Error <> 0 Then
		      Dim err As New RuntimeException
		      err.Message = gzFile.ErrorString
		      Raise err
		    End If
		    
		    
		    While inputStream.EOF <> True
		      inputString = inputStream.Read(4096)
		      
		      i = gzFile.Write(inputString)
		      
		      If i <> LenB(inputString) Then
		        inputStream.Close
		        gzFile.Close
		        Return False
		      End If
		      
		    Wend
		    
		    inputStream.close
		    
		    gzFile.Close
		    
		    If destination.Parent = SpecialFolder.Temporary Then
		      #If TargetWin32 Then
		        If Not source.ReplaceWith(destination, True) Then
		          Dim err As New Win32Exception(Platform.LastErrorCode)
		          Raise err
		        Else
		          Return True
		        End If
		      #Else
		        source.Delete
		        destination.MoveFileTo(source)
		        Return True
		      #EndIf
		    End If
		  #Else
		    #pragma Unused source
		    #pragma Unused destination
		    #pragma Warning "The GZip Plugin Does Not Support ConsoleApplications"
		    #If DebugBuild Then
		      Break //The GZip Plugin Does Not Support ConsoleApplications
		    #EndIf
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function gzipDecompress(Extends Source As FolderItem, destination As FolderItem = Nil) As Boolean
		  //This function requires the GZip plugin available at http://sourceforge.net/projects/realbasicgzip/
		  //source is the file to be decompressed, destination is where the decompressed file will be saved
		  //If destination = Nil then the source file is replaced with the destination upon completion
		  //This function can be ported to other platforms by modifying the last part (that replaces the original
		  //file with the compressed version.
		  //
		  //The GZip plugin does not support Console Applications
		  
		  #If TargetHasGUI Then
		    Dim saveStream As BinaryStream
		    Dim inputString As String
		    Dim gzFile As GZIPStream
		    
		    If source = Nil Then Return False
		    If Not source.Exists Then Return False
		    If destination = Nil Then destination = SpecialFolder.Temporary.Child(source.Name + ".tmp")
		    If destination.exists Then destination.delete
		    
		    saveStream = saveStream.Create(destination, True)
		    
		    gzFile = New GZipStream
		    gzFile.Open(source, False)
		    
		    If gzFile.Error<> GZIP.Z_OK Then
		      saveStream.Close
		      gzFile.Close
		      Return False
		    End If
		    
		    While gzFile.EOF <> True
		      inputString = gzFile.Read(4096)
		      If gzFile.Error <> GZIP.Z_OK Then
		        If gzFile.EOF Then
		        Else
		          saveStream.Close
		          gzFile.Close
		          Return False
		        End If
		      End If
		      saveStream.Write(inputString)
		    Wend
		    saveStream.close
		    gzFile.Close
		    
		    If destination.Parent = SpecialFolder.Temporary Then
		      If destination.Parent = SpecialFolder.Temporary Then
		        #If TargetWin32 Then
		          If Not source.ReplaceWith(destination, True) Then
		            Dim err As New Win32Exception(Platform.LastErrorCode)
		            Raise err
		          Else
		            Return True
		          End If
		        #Else
		          source.Delete
		          destination.MoveFileTo(source)
		          Return True
		        #EndIf
		      End If
		    End If
		  #Else
		    #pragma Unused source
		    #pragma Unused destination
		    #pragma Warning "The GZip Plugin Does Not Support ConsoleApplications"
		    #If DebugBuild Then
		      Break //The GZip Plugin Does Not Support ConsoleApplications
		    #EndIf
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function gzipIsCompressed(Extends source As FolderItem) As Boolean
		  //Checks the GZip magic number. Returns True if the source file is likely a GZip archive
		  Dim bs As BinaryStream
		  bs = bs.Open(source)
		  
		  If bs.ReadByte = &h1F And bs.ReadByte = &h8B Then
		    bs.Close
		    Return True
		  Else
		    bs.Close
		    Return False
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Hidden(Extends target As FolderItem) As Boolean
		  //Returns true if the file has the hidden attribute
		  #If TargetWin32 Then
		    Dim attribs As Integer = GetFileAttributes(target)
		    Return BitwiseAnd(attribs, &h2) = &h2
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Hidden(Extends target As FolderItem, Assigns b As Boolean)
		  //Sets or clears the hidden attibute of the file
		  #If TargetWin32 Then
		    Dim cfattribs As Integer = GetFileAttributes(target)
		    If target.Hidden = b Then Return
		    If b Then
		      cfattribs = cfattribs Or &h2
		    Else
		      cfattribs = cfattribs Or &h2
		      cfattribs = cfattribs Xor &h2
		    End If
		    
		    Call SetFileAttributes(target, cfattribs)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function isAccessible(Extends f As FolderItem) As Integer
		  //Returns 0 if the file exists and is Readable
		  //Returns a Win32 error code on failure. Refer to http://msdn.microsoft.com/en-us/library/ms681381(v=vs.85).aspx
		  //for error code explainations, or use Platform.ErrorMessageFromCode for an error message.
		  
		  #If TargetWin32 Then
		    Dim HWND As Integer = Platform.CreateFile(f.AbsolutePath, GENERIC_READ, FILE_SHARE_READ, 0, OPEN_EXISTING, 0, 0)
		    If HWND = -1 Then
		      Return Platform.LastErrorCode
		    Else
		      Call Platform.CloseHandle(HWND)
		      Return 0
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsDangerous(Extends target As FolderItem) As Boolean
		  //Returns True if the target FolderItem has an extension (e.g. ".exe") which Windows deems dangerous.
		  //See the remarks here: http://msdn.microsoft.com/en-us/library/windows/desktop/bb773465%28v=vs.85%29.aspx
		  //XP with SP1 or newer only.
		  
		  #If TargetWin32 Then
		    If Platform.IsAtLeast(Platform.WinVista) Or (Platform.IsExactly(Platform.WinXP) And Platform.ServicePack >= 1) Then
		      Soft Declare Function AssocIsDangerous Lib "Shlwapi" (ext As WString) As Boolean
		      Return AssocIsDangerous("." + target.Extension)
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsEXE32Bit(Extends target As FolderItem) As Boolean
		  //Returns True if the file is a 32 bit Windows application
		  #If TargetWin32 Then
		    Return exeType(target) = 0
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsEXE64Bit(Extends target As FolderItem) As Boolean
		  //Returns True if the file is a 64 bit Windows application
		  #If TargetWin32 Then
		    Return exeType(target) = 6
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsLocked(Extends f As FolderItem) As Boolean
		  //Attempts to lock the file referenced by f. Returns True if the file is locked or cannot be locked. Returns False if
		  //the file is not locked and can be locked.
		  
		  #If TargetWin32 Then
		    Dim i As Integer = f.LockFile()
		    If i > 0 Then  //Negative values indicate an error. See LockFile
		      Call UnlockFile(i)
		      Return False
		    Else
		      Return True
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsNormal(Extends target As FolderItem) As Boolean
		  //Returns True if the target has no file attributes set
		  #If TargetWin32 Then
		    Dim attribs As Integer = GetFileAttributes(target)
		    Return BitwiseAnd(attribs, &h80) = &h80
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IsNormal(Extends target As FolderItem, Assigns b As Boolean)
		  //Clears all file attributes
		  #If TargetWin32 Then
		    Dim cfattribs As Integer = GetFileAttributes(target)
		    If target.IsNormal = b Then Return
		    If b Then
		      cfattribs = &h80
		    Else
		      cfattribs = cfattribs Or &h80
		      cfattribs = cfattribs Xor &h80
		    End If
		    
		    Call SetFileAttributes(target, cfattribs)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LaunchWithArgs(extends f as FolderItem, ParamArray args as String) As Boolean
		  //Same as FolderItem.Launch, but with arguments. Returns True if the operation succeeded.
		  #If TargetWin32 Then
		    Declare Function ShellExecuteW Lib "Shell32"(hwnd as Integer, operation as WString, file as WString, params as WString, _
		    directory as WString, show as Integer) As Integer
		    
		    Dim params as String
		    params = Join( args, " " )
		    Return ShellExecuteW( 0, "open", f.AbsolutePath, params, "", 1 ) > 32
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LockFile(Extends lockedFile As FolderItem) As Integer
		  //Locks the file for exclusive use. You must call UnlockFile with the integer returned from this function to unlock the file.
		  //A positive return value is returned on success, 0 if lockedFile is Nil, and a negative number on error (a negative return value
		  //is actually the last Win32 error multiplied by -1. So, for example, -5 is ERROR_ACCESS_DENIED.)
		  //
		  //You cannot open a lockedFile with a TextInputStream, TextOutputStream, or BinaryStream. Attempting to do so will
		  //raise an IOException. Likewise, you cannot lock a file currently open in a TextInputStream, TextOutputStream, or BinaryStream.
		  
		  #If TargetWin32 Then
		    Declare Function MyLockFile Lib "kernel32" Alias "LockFile" (hFile As Integer, dwFileOffsetLow As Integer, dwFileOffsetHigh As Integer, _
		    nNumberOfBytesToLockLow As Integer, nNumberOfBytesToLockHigh As Integer) As Boolean
		    
		    If lockedFile = Nil Then Return 0
		    
		    Dim fHandle As Integer = Platform.CreateFile(lockedFile.AbsolutePath, GENERIC_READ, FILE_SHARE_READ, 0, OPEN_EXISTING, 0, 0)
		    If fHandle > 0 Then
		      If myLockFile(fHandle, 0, 0, 1, 0) Then
		        Return fHandle   //You MUST keep this return value if you want to unlock the file later!!!
		      Else
		        Return Platform.LastErrorCode * -1
		      End If
		    Else
		      Return Platform.LastErrorCode * -1
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MD5Hash(target As FolderItem, sizeCutoff As UInt64 = 52428800, ProgressFunction As ProgressCallback = Nil) As String
		  //If the target file is less than sizeCutoff in bytes (default is 50MB) this function uses the MD5() function to hash the file.
		  //If greater than sizeCutoff this function processes the file through the MD5Digest function. MD5Digest is preferable when
		  //hashing large files since the entire file will not be loaded into memory at once.
		  //
		  //If using MD5Digest, the sizeCutoff parameter also dictates how much of the file to read at a time. Default is 50MB.
		  //Returns the Hex representation of the hash
		  //
		  //If a ProgressCallback delegate is passed, the delegate will be invoked for each iteration of the MD5Digest loop (or once only
		  //if MD5Digest is not used.)
		  //
		  //This function should be cross-platform safe.
		  
		  Dim s As String
		  If target.Length < sizeCutoff Then
		    Dim tis As TextInputStream
		    tis = tis.Open(target)
		    s = tis.ReadAll
		    tis.Close
		    s = StringToHex(MD5(s))
		    If ProgressFunction <> Nil Then ProgressFunction.Invoke(100.00)
		  Else
		    Dim bs As BinaryStream
		    bs = bs.Open(target)
		    Dim m5 As New MD5Digest
		    While Not bs.EOF
		      s = bs.Read(sizeCutoff)
		      m5.Process(s)
		      If ProgressFunction <> Nil Then ProgressFunction.Invoke(bs.Position * 100 / bs.Length)
		    Wend
		    bs.Close
		    s = StringToHex(m5.Value)
		  End If
		  
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NormalizePath(Path As String) As String
		  //Under construction. Takes a string and normalizes it as a Windows path
		  
		  #If TargetWin32 Then
		    Declare Function PathAddBackslashW Lib "Shlwapi" (thePath As Ptr) As Integer
		    
		    Dim mb As New MemoryBlock(1024)
		    mb.WString(0) = path
		    Dim i As Integer= PathAddBackslashW(mb)
		    path = mb.WString(0)
		    path = Left(path, i)
		    Return path
		  #endif
		End Function
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub ProgressCallback(PercentDone As Double)
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h0
		Function ReadOnly(Extends target As FolderItem) As Boolean
		  //Returns true if the file has the ReadOnly attribute
		  #If TargetWin32 Then Return BitwiseAnd(GetFileAttributes(target), &h1) = &h1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ReadOnly(Extends target As FolderItem, Assigns b As Boolean)
		  //Sets or clears the Read Only attibute of the file
		  #If TargetWin32
		    Dim cfattribs As Integer = GetFileAttributes(target)
		    
		    If target.ReadOnly = b Then Return
		    If b Then
		      cfattribs = cfattribs Or &h1
		    Else
		      cfattribs = cfattribs Or &h1
		      cfattribs = cfattribs Xor &h1
		    End If
		    
		    Call SetFileAttributes(target, cfattribs)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RelativeToAbsolute(RelativePath As String, CurrentDir As FolderItem = Nil) As String
		  //Takes a Relative Path and an optional root directory. Returns a string representing the absolute path
		  //represented by the RelativePath relative to the CurrentDir.
		  //If CurrentDir is Nil then the App.ExecutableFile.Parent directory is used.
		  //
		  //For Example:
		  //Dim f As FolderItem = GetFolderItem("C:\")
		  //Dim abso As String = RelativeToAbsolute("Windows\..\Program Files\MyApp\MyApp Libs\..\MyApp.exe", f)
		  ////abso = C:\Program Files\MyApp\MyApp.exe
		  #If TargetWin32 Then
		    Declare Function PathCanonicalizeW Lib "Shlwapi" (OutBuffer As Ptr, InBuffer As Ptr) As Boolean
		    Declare Function PathAppendW Lib "Shlwapi" (firstHalf As Ptr, secondHalf As Ptr) As Boolean
		    If CurrentDir = Nil Then CurrentDir = App.ExecutableFile.Parent
		    
		    Dim outBuff As New MemoryBlock(1024)
		    outBuff.WString(0) = CurrentDir.AbsolutePath
		    Dim inBuff As New MemoryBlock(1024)
		    inBuff.WString(0) = RelativePath
		    If PathAppendW(outBuff, inBuff) Then
		      inBuff.WString(0) = outBuff.WString(0)
		      If PathCanonicalizeW(outBuff, inBuff) Then
		        Return outBuff.WString(0)
		      End If
		    End If
		    Return RelativePath
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReplaceFileOnReboot(Extends source As FolderItem, destination As FolderItem) As Boolean
		  //Schedules the source file to be replaced by the destination file on the next system reboot
		  //Cannot be used if the source and destination are on different volumes or if the source or destination
		  //are on a network share. This function will also fail if the user does not have write access to the
		  //HKEY_LOCAL_MACHINE registry hive (HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\PendingFileRenameOperations)
		  
		  #If TargetWin32
		    Declare Function MoveFileExW Lib "Kernel32" (sourceFile As WString, destinationFile As WString, flags As Integer) As Boolean
		    
		    Const MOVEFILE_DELAY_UNTIL_REBOOT = 4
		    Const MOVEFILE_REPLACE_EXISTING = 1
		    
		    Return MoveFileExW(source.AbsolutePath, destination.AbsolutePath, MOVEFILE_DELAY_UNTIL_REBOOT Or MOVEFILE_REPLACE_EXISTING)
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReplaceWith(Extends source As FolderItem, destination As FolderItem, forceSync As Boolean = False, backupFile As FolderItem = Nil) As Boolean
		  //Replaces the source file with the destination file.
		  //If forceSync is true then the disk buffers are forced to flush all changes to the disk
		  //Specify the backupFile parameter to create a backup copy of the source file
		  //If this function fails, look at Platform.LastErrorCode for the error reason.
		  
		  #If TargetWin32
		    If source.Directory Or destination.Directory Then Return False
		    
		    Declare Function ReplaceFileW Lib "Kernel32" (sourceFile As WString, destinationFile As WString, backupFile As Ptr, flags As Integer, _
		    reserved1 As Integer, reserved2 As Integer) As Boolean
		    
		    Dim rpFlags As Integer
		    If forceSync Then rpFlags = 1    //REPLACEFILE_WRITE_THROUGH = 1
		    
		    If backupFile = Nil Then
		      Return ReplaceFileW(source.AbsolutePath, destination.AbsolutePath, Nil, rpFlags, 0, 0)
		    Else
		      Dim backupPath As New MemoryBlock(LenB(backupFile.AbsolutePath) * 2 + 2)
		      backupPath.WString(0) = backupFile.AbsolutePath
		      Return ReplaceFileW(source.AbsolutePath, destination.AbsolutePath, backupPath, rpFlags, 0, 0)
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SetFileAttributes(f As FolderItem, attribs As Integer) As Boolean
		  //See: Archive, Encrypted, Hidden, IsNormal, ReadOnly, and SystemFile functions in this module.
		  
		  #If TargetWin32 Then
		    Declare Function SetFileAttributesW Lib "Kernel32" (path As WString, fattribs As Integer) As Boolean
		    If attribs = 0 Then attribs = &h80
		    Return SetFileAttributesW(f.AbsolutePath, attribs)
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShowInExplorer(extends f As FolderItem)
		  //Shows the file in Windows Explorer
		  
		  #If TargetWin32 Then
		    Dim param As String = "/select, """ + f.AbsolutePath + """"
		    Soft Declare Sub ShellExecuteW Lib "Shell32" (hwnd As Integer, op As WString, file As WString, params As WString, directory As Integer, _
		    cmd As Integer)
		    
		    Const SW_SHOW = 5
		    ShellExecuteW(0, "open", "explorer", param, 0, SW_SHOW)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SlowAccess(Extends f As FolderItem) As Boolean
		  //Returns True if the specified FolderItem is located on a high-latentcy (<40000 baud) network location.
		  
		  #If TargetWin32 Then
		    Declare Function PathIsSlowW Lib "Shell32" (path As WString, attribs As Integer) As Boolean
		    Return PathIsSlowW(f.AbsolutePath, -1)
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StopWatchingDirectory(WatchHandle As Integer)
		  //Housekeeping. Call this function with the value returned from WatchDirectoryForChanges to clean up when you're done watching.
		  //FIXME: messy
		  #If TargetWin32 Then
		    Declare Function UnregisterWait Lib "Kernel32" (wHandle As Integer) As Boolean
		    Call UnregisterWait(WatchHandle)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Stream(Extends target As FolderItem, StreamIndex As Integer) As String
		  //Accesses the data stream of the target FolderItem at StreamIndex. If target has fewer than StreamIndex data streams, or if the target
		  //is not on an NTFS volume, an OutOfBoundsException is raised. If the file is not readable, an IOException is raised.
		  //Otherwise, a String corresponding to the name of the requested data stream is Returned.
		  //Raises a PlatformNotSupportedException on versions of Windows prior to Windows 2000.
		  //Call FolderItem.StreamCount to get the number of streams. The main data stream is always at StreamIndex zero and does
		  //not have a name.
		  
		  
		  #If TargetWin32 Then
		    If StreamIndex = 0 Then Return ""  //Stream zero is the unnamed main stream
		    
		    If Platform.IsOlderThan(Platform.WinVista) And Platform.IsAtLeast(Platform.Win2000) Then
		      Soft Declare Sub NtQueryInformationFile Lib "NTDLL" (fHandle As Integer, ByRef status As IO_STATUS_BLOCK, FileInformation As Ptr, FILength As UInt32, InfoClass As Int32)
		      Dim fHandle As Integer = Platform.CreateFile(target.AbsolutePath, 0,  FILE_SHARE_READ Or FILE_SHARE_WRITE, 0, OPEN_EXISTING, 0, 0)
		      If fHandle > 0 Then
		        Dim mb As New MemoryBlock(64 * 1024)
		        Dim status As IO_STATUS_BLOCK
		        NtQueryInformationFile(fHandle, status, mb, mb.Size, 22)
		        Dim currentOffset As Integer
		        For i As Integer = 0 To StreamIndex
		          If mb.UInt32Value(currentOffset) > 0 Then
		            currentOffset = mb.UInt32Value(currentOffset)
		            If i = StreamIndex Then
		              Return mb.WString(24)
		            End If
		          Else
		            Raise New OutOfBoundsException
		          End If
		        Next
		      Else
		        Raise New IOException
		      End If
		    ElseIf Platform.IsAtLeast(Platform.WinVista) Then
		      Dim buffer As WIN32_FIND_STREAM_DATA
		      Dim sHandle As Integer = FindFirstStream(target.AbsolutePath, 0, buffer, 0)
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
		Function Stream(Extends target As FolderItem, StreamName As String) As FolderItem
		  //Accesses the named data stream of the target specified by StreamName. If there is no such stream, or if the target
		  //is not on an NTFS volume, returns Nil. Otherwise, a FolderItem corresponding to the requested data stream is Returned.
		  //Passing an empty string as the StreamName returns the main stream which is synonymous with the file itself.
		  
		  #If TargetWin32 Then
		    If target <> Nil Then
		      If target.Exists Then
		        Dim fHandle As Integer = Platform.CreateFile(target.AbsolutePath + ":" + StreamName + ":$DATA", 0, FILE_SHARE_READ Or FILE_SHARE_WRITE, 0, OPEN_EXISTING, 0, 0)
		        If fHandle > 0 Then
		          target = GetFolderItem(target.AbsolutePath + ":" + StreamName + ":$DATA")
		          Call Platform.CloseHandle(fHandle)
		          Return target
		        Else
		          Return Nil
		        End If
		      End If
		    Else
		      Return Nil
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StreamCount(Extends f As FolderItem) As Integer
		  //Counts the number of data streams attached to a file or directory on an NTFS volume. This count includes the default main stream.
		  //Windows Vista and newer have much better APIs for handling streams than previous versions, so we use those when possible.
		  //On error, returns -1
		  
		  #If TargetWin32 Then
		    If Platform.IsOlderThan(Platform.WinVista) And Platform.IsAtLeast(Platform.Win2000) Then
		      Soft Declare Sub NtQueryInformationFile Lib "NTDLL" (fHandle As Integer, ByRef status As IO_STATUS_BLOCK, FileInformation As Ptr, FILength As UInt32, InfoClass As Int32)
		      
		      Dim fHandle As Integer = Platform.CreateFile(f.AbsolutePath, 0,  FILE_SHARE_READ Or FILE_SHARE_WRITE, 0, OPEN_EXISTING, 0, 0)
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
		    ElseIf Platform.IsAtLeast(Platform.WinVista) Then
		      Dim buffer As WIN32_FIND_STREAM_DATA
		      Dim sHandle As Integer = FindFirstStream(f.AbsolutePath, 0, buffer, 0)
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
		Function SystemFile(Extends target As FolderItem) As Boolean
		  //Returns True if the target has the System File attribute set
		  #If TargetWin32 Then
		    Dim attribs As Integer = GetFileAttributes(target)
		    Return BitwiseAnd(attribs, &h4) = &h4
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SystemFile(Extends target As FolderItem, Assigns b As Boolean)
		  //Sets or clears the System File attribute of the file
		  #If TargetWin32 Then
		    Dim cfattribs As Integer = GetFileAttributes(target)
		    
		    If target.SystemFile = b Then Return
		    If b Then
		      cfattribs = cfattribs Or &h4
		    Else
		      cfattribs = cfattribs Or &h4
		      cfattribs = cfattribs Xor &h4
		    End If
		    
		    Call SetFileAttributes(target, cfattribs)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function UnlockFile(fHandle As Integer) As Boolean
		  //See the LockFile function
		  #If TargetWin32 Then
		    Declare Function myUnlockFile Lib "kernel32" Alias "UnlockFile" (ByVal hFile As integer, ByVal dwFileOffsetLow As integer, ByVal dwFileOffsetHigh As integer, _
		    ByVal nNumberOfBytesToUnlockLow As integer, ByVal nNumberOfBytesToUnlockHigh As integer) As Boolean
		    
		    Dim ret As Boolean = myUnlockFile(fHandle, 0, 0, 1, 0)
		    Call Platform.CloseHandle(fHandle)
		    
		    Return ret
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VersionInfo(Extends f As FolderItem) As Dictionary
		  //Returns the VersionInfo headers of a Windows executable in a Dictionary object.
		  //On error, or if the file does not have VersionInfo embedded or does not exist, Returns Nil
		  //Some fields may not be present in all executables.
		  //Supported fields are: Comments, InternalName, ProductName, CompanyName, LegalCopyright, ProductVersion, FileDescription,
		  //LegalTrademarks, PrivateBuild, FileVersion, OriginalFilename, and SpecialBuild.
		  
		  #If TargetWin32 Then
		    If f = Nil Then Return Nil
		    If Not f.Exists Then Return Nil
		    
		    Declare Function GetFileVersionInfoSizeW Lib "Version" (fileName As WString, ignored As Integer) As Integer
		    Declare Function GetFileVersionInfoW Lib "Version" (fileName As WString, ignored As Integer, bufferSize As Integer, buffer As Ptr) As Boolean
		    Declare Function VerQueryValueW Lib "Version" (inBuffer As Ptr, subBlock As WString, outBuffer As Ptr, ByRef outBufferLen As Integer) As Boolean
		    
		    Dim infoSize As Integer = GetFileVersionInfoSizeW(f.AbsolutePath, 0)
		    If infoSize <= 0 Then Return Nil
		    
		    Dim buff As New MemoryBlock(infoSize)
		    If GetFileVersionInfoW(f.AbsolutePath, 0, buff.Size, buff) Then
		      Dim mb As New MemoryBlock(4)
		      Dim retBuffLen As Integer
		      If VerQueryValueW(buff, "\VarFileInfo\Translation", mb, retBuffLen) Then
		        Dim fields() As String = Split("Comments InternalName ProductName CompanyName LegalCopyright ProductVersion FileDescription LegalTrademarks PrivateBuild FileVersion OriginalFilename SpecialBuild", " ")
		        Dim j, k As String
		        j = Hex(mb.Ptr(0).Int16Value(0))
		        k = Hex(mb.Ptr(0).Int16Value(2))
		        Dim langCode As String = Left("0000", 4 - Len(j)) + j + Left("0000", 4 - Len(k)) + k
		        Dim ret As New Dictionary
		        For Each datum As String In fields
		          mb = New MemoryBlock(4)
		          If VerQueryValueW(buff, "\StringFileInfo\" + langCode + "\" + datum, mb, retBuffLen) Then
		            ret.Value(datum) = mb.Ptr(0).WString(0)
		          End If
		        Next
		        Return ret
		      Else
		        Return Nil
		      End If
		    Else
		      Return Nil
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub WaitCallback(parameter As Ptr, timedOut As Boolean)
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h0
		Function WatchDirectoryForChanges(dir As FolderItem, callbackFunction As WaitCallback) As Integer
		  //Causes Windows to watch the specified directory for any changes.
		  //If a change occurs, the Subroutine specifed in callbackFunction is invoked.
		  //Your callbackFunction must conform to the WaitCallback Delegate's method signature.
		  //Returns a handle (integer) which you later give to StopWatchingDirectory
		  
		  #If TargetWin32 Then
		    Declare Function RegisterWaitForSingleObject Lib "Kernel32" (ByRef waitHandle As Integer, objectHandle As Integer, callback As Ptr, context As Ptr, _
		    waitMilliseconds As Integer, flags As Integer) As Boolean
		    Declare Function FindFirstChangeNotificationW Lib "Kernel32" (dirPath As WString, watchChildren As Boolean, eventTypeFilter As Integer) As Integer
		    
		    If dir = Nil Then Return 0
		    If Not dir.Exists Or Not dir.Directory Then Return 0
		    
		    Const WT_EXECUTEONLYONCE = &h00000008
		    Const FILE_NOTIFY_CHANGE_FILE_NAME = &h00000001
		    Const FILE_NOTIFY_CHANGE_DIR_NAME = &h00000002
		    Const FILE_NOTIFY_CHANGE_ATTRIBUTES = &h00000004
		    Const FILE_NOTIFY_CHANGE_SIZE = &h00000008
		    Const FILE_NOTIFY_CHANGE_LAST_WRITE = &h00000010
		    Const FILE_NOTIFY_CHANGE_SECURITY = &h00000100
		    
		    Dim customData As MemoryBlock = dir.AbsolutePath  //Supposedly this gets passed to the callback function, but it doesn't for some reason.
		    Dim allFilters As Integer = FILE_NOTIFY_CHANGE_ATTRIBUTES Or FILE_NOTIFY_CHANGE_DIR_NAME Or FILE_NOTIFY_CHANGE_FILE_NAME Or _
		    FILE_NOTIFY_CHANGE_LAST_WRITE Or FILE_NOTIFY_CHANGE_SECURITY Or FILE_NOTIFY_CHANGE_SIZE
		    
		    Dim monHandle As Integer = FindFirstChangeNotificationW(dir.AbsolutePath, True, allFilters)
		    If monHandle > 0 Then
		      Dim waitHandle As Integer
		      If RegisterWaitForSingleObject(waitHandle, monHandle, callbackFunction, customData, &hFFFFFFFF, WT_EXECUTEONLYONCE) Then
		        Return waitHandle
		      Else
		        Return 0
		      End If
		    End If
		  #endif
		End Function
	#tag EndMethod


	#tag Note, Name = Notes on Data Streams
		All files and directorys on an NTFS volume are associated with at least one stream (the main stream) and may also have an arbitrary number 
		of Alternate Data Streams. Most of the Stream-related functions in this module return a FolderItem representing the requested stream. These
		FolderItems can be used in any way a regular FolderItem can. However, FolderItem.Exists will always be False for Streams even if the stream
		exists.
		
		See: http://msdn.microsoft.com/en-us/library/windows/desktop/aa364404%28v=vs.85%29.aspx
		
		
		
		Sample code, counting streams, creating a stream, getting a stream by index, getting a stream by name, reading and writing to a stream
		
		  Dim f As FolderItem = GetOpenFolderItem("")
		  If f <> Nil Then
		    MsgBox(f.AbsolutePath + " has " + Str(f.StreamCount) + " Data Streams")
		    Dim stream1 As FolderItem = f.CreateStream("Test")
		    Dim tos As TextOutputStream
		    tos = tos.Append(stream1)
		    tos.WriteLine("Hello, World!")
		    tos.Close
		    If f.StreamCount > 0 Then
		      MsgBox(f.AbsolutePath + " has " + Str(f.StreamCount) + " Data Streams")
		      MsgBox("Stream: " + f.Stream(1))
		      Dim tis As TextInputStream
		      tis = tis.Open(f.Stream(f.Stream(1)))
		      MsgBox(tis.ReadAll)
		      tis.Close
		    End If
		  End If
	#tag EndNote


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
