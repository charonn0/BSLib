#tag Module
Protected Module File_Ops
	#tag Method, Flags = &h0
		Function AbsolutePath_(Extends f As FolderItem) As String
		  'This method fixes the deprecation warning for Xojo 2013 R1 and newer
		  'FolderItem.AbsolutePath is deprecated in favor of FolderItem.NativePath
		  'However older versions of REALstudio will not recognize the property name.
		  'This method works just like FolderItem.AbsolutePath or FolderItem.NativePath
		  'depending on the IDE Version.
		  
		  #If RBVersion >= 2013 Then
		    Return f.NativePath
		  #Else
		    Return f.AbsolutePath
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AllNamedStreams(Extends target As FolderItem) As String()
		  //Returns a String array containing the names of all named streams. If the target does not contain any named streams,
		  //then this function returns a string array with Ubound -1
		  //If the target is not on an NTFS volume, an OutOfBoundsException is raised. If the file is not readable, an IOException is Raised
		  //Raises a PlatformNotSupportedException on versions of Windows prior to Windows 2000.
		  
		  #If TargetWin32 Then
		    Dim ret() As String
		    
		    If Platform.KernelVersion < 6.0 And Platform.KernelVersion >= 5.0 Then
		      Dim fHandle As Integer = CreateFile(target.AbsolutePath_, 0,  FILE_SHARE_READ Or FILE_SHARE_WRITE, 0, OPEN_EXISTING, 0, 0)
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
		    ElseIf Platform.KernelVersion >= 6.0 Then
		      Dim buffer As WIN32_FIND_STREAM_DATA
		      Dim sHandle As Integer = FindFirstStream(target.AbsolutePath_, 0, buffer, 0)
		      
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
		Attributes( deprecated = "FileAttributes.Archive" )  Function Archive(Extends target As FolderItem) As Boolean
		  //Returns true if the file has the archive attribute
		  //This method has been deprecated in favor of the FileAttributes class
		  Dim attribs As New FileAttributes(target)
		  Return attribs.Archive
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( deprecated = "FileAttributes.Archive" )  Sub Archive(Extends target As FolderItem, Assigns b As Boolean)
		  //Sets or clears the archive attibute of the file
		  //This method has been deprecated in favor of the FileAttributes class
		  Dim attribs As New FileAttributes(Target)
		  attribs.Archive = b
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( deprecated = "FileAttributes.Compressed" )  Function Compressed(Extends target As FolderItem) As Boolean
		  //Returns true if the file has the compressed attribute
		  //This method has been deprecated in favor of the FileAttributes class
		  Dim attribs As New FileAttributes(target)
		  Return attribs.Compressed
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( deprecated = "FileAttributes.Compressed" )  Sub Compressed(Extends target As FolderItem, Assigns b As Boolean)
		  //Sets or clears the Compressed attribute. Generally, this will cause Windows to compress the file but there's no guarentee
		  //This method has been deprecated in favor of the FileAttributes class
		  Dim attribs As New FileAttributes(Target)
		  attribs.Compressed = b
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CountHardLinks(target As FolderItem) As Integer
		  //Returns the number of NTFS hard links which point to the same file as the specified folderitem
		  //Windows Vista and newer only.
		  //Returns 0 on error.
		  
		  #If TargetWin32 Then
		    Dim findHandle, buffSize, linkCount As Integer
		    Dim linkname As New MemoryBlock(4096)
		    buffSize = linkname.Size
		    linkname = New MemoryBlock(buffSize)
		    findHandle = FindFirstFileNameW(target.AbsolutePath_, 0, buffSize, linkname)
		    If findHandle <> INVALID_HANDLE_VALUE Then
		      Do
		        linkCount = linkCount + 1
		        buffSize = linkname.Size
		      Loop Until Not FindNextFileNameW(findHandle, buffSize, linkname)
		    End If
		    Call FindClose(findHandle)
		    Return linkCount
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CreateHardLink(source As FolderItem, destination As FolderItem) As Boolean
		  //Creates an NTFS Hard Link. Source is the existing file, destination is the new Hard Link
		  //This function will fail if the source and destination are not on the same volume or if the source or destination are directories.
		  //Use CreateSymLink (or CreateShortcut) for files on different volumes.
		  //Raises a PlatformNotSupportedException on versions of Windows not supporting hard links.
		  
		  #If TargetWin32 Then
		    If System.IsFunctionAvailable("CreateHardLinkW", "Kernel32") Then
		      Return CreateHardLink(destination.AbsolutePath_, source.AbsolutePath_, Nil)
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
		      lnkObj = scriptShell.CreateShortcut(SpecialFolder.Temporary.AbsolutePath_ + scName + ".lnk")
		      If lnkObj <> Nil then
		        lnkObj.Description = scName
		        lnkObj.TargetPath = scTarget.AbsolutePath_
		        lnkObj.WorkingDirectory = scTarget.AbsolutePath_
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
		    Dim fHandle As Integer = CreateFile(target.AbsolutePath_ + ":" + StreamName + ":$DATA", 0, _
		    FILE_SHARE_READ Or FILE_SHARE_WRITE, 0, CREATE_NEW, 0, 0)
		    If fHandle > 0 Then
		      target = GetFolderItem(target.AbsolutePath_ + ":" + StreamName + ":$DATA")
		      Call CloseHandle(fHandle)
		      Return target
		    Else
		      If GetLastError = 80 Then  //ERROR_FILE_EXISTS
		        target = GetFolderItem(target.AbsolutePath_ + ":" + StreamName + ":$DATA")
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
		      Dim flags As Integer
		      If source.Directory Then
		        flags = &h1
		      End If
		      
		      Return CreateSymbolicLink(destination.AbsolutePath_, source.AbsolutePath_, flags)
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
		    Return MoveFileEx(source.AbsolutePath_, Nil, MOVEFILE_DELAY_UNTIL_REBOOT)
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DeleteStream(Extends f As FolderItem, StreamName As String) As Boolean
		  //Deletes the named stream of the file or directory specified in target. If deletion was successful, returns True. Otherwise, returns False.
		  //Failure reasons may be: access to the file or directory was denied or the target or named stream does not exist. Passing "" as the
		  //StreamName will delete the file altogether (same as FolderItem.Delete)
		  
		  #If TargetWin32 Then
		    If f <> Nil Then
		      Return DeleteFile(f.AbsolutePath_ + ":" + StreamName + ":$DATA")
		    Else
		      Return False
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteTree(Extends folder as FolderItem)
		  Dim count As Integer
		  count = folder.Count
		  For i As Integer = count DownTo 1
		    If folder.TrueItem(i) <> Nil Then
		      If folder.TrueItem(i).Directory Then
		        folder.TrueItem(i).DeleteTree
		      End If
		      folder.TrueItem(i).Delete
		    End If
		  Next i
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( deprecated = "FileAttributes.Encrypted" )  Function Encrypted(Extends target As FolderItem) As Boolean
		  //Returns True if the file has the Encrypted attribute
		  //This method has been deprecated in favor of the FileAttributes class
		  Dim attribs As New FileAttributes(target)
		  Return attribs.Encrypted
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( deprecated = "FileAttributes.Encrypted" )  Sub Encrypted(Extends target As FolderItem, Assigns b As Boolean)
		  //Clears or sets the encrypted attribute
		  //This method has been deprecated in favor of the FileAttributes class
		  Dim attribs As New FileAttributes(Target)
		  attribs.Encrypted = b
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
		    Dim type As Integer
		    If GetBinaryType(f.AbsolutePath_, type) Then
		      Return type
		    Else
		      Return -1
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Extension(Extends f As FolderItem) As String
		  //Returns the file Extension, if any, without the leading full stop "."
		  If InStr(f.Name, ".") <= 0 Then Return ""
		  Return NthField(f.Name, ".", CountFields(f.Name, "."))
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
		    Dim mb As New MemoryBlock(260)
		    If FindExecutable(documentFile.AbsolutePath_, Nil, mb) > 32 Then
		      Return GetFolderItem(mb.WString(0))
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindFile(Root As FolderItem, Filename As String) As FolderItem
		  'performs a depth-first search on the passed directory for the named file. Returns the first matching file.
		  Dim file As FolderItem
		  If Root = Nil Or Not Root.Directory Then Return Nil
		  Dim count As Integer = Root.Count
		  For i As Integer = 1 To count
		    Dim item As FolderItem = Root.Item(i)
		    If item.Directory Then
		      file = FindFile(item, Filename)
		    ElseIf item.Name = Filename Then
		      file = item
		    End If
		    If file <> Nil Then Exit For
		  Next
		  
		  Return file
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getChildren(dir As FolderItem) As FolderItem()
		  //This function recursively builds a FolderItem array consisting of all files beneath a given Directory.
		  //It does not return subfolders, only their contents
		  
		  Dim files() As FolderItem
		  Dim dirCount As Integer = dir.Count
		  For i As Integer = 1 To dirCount
		    Dim thisItem As FolderItem = dir.Item(i)
		    If thisItem.Directory Then
		      For each item As FolderItem In getChildren(thisItem)
		        files.Append(item)
		      Next
		    Else
		      files.Append(thisItem)
		    End If
		  Next
		  
		  
		  Return files()
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetDriveFreeSize(Drive As FolderItem) As UInt64
		  //Returns the amount of free space, in bytes, on the volume containing the passed FolderItem. The passed FolderItem need
		  //not refer directly to the volume root.
		  
		  #If TargetWin32 Then
		    Dim drvRoot As String = Left(Drive.AbsolutePath_, 1) + ":\"
		    Dim total, free, x As UInt64
		    Call GetDiskFreeSpaceEx(drvRoot, x, total, free)
		    
		    Return free
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetDriveSize(Drive As FolderItem) As UInt64
		  //Returns the total capacity, in bytes, of the volume containing the passed FolderItem. The passed FolderItem need
		  //not refer directly to the volume root.
		  
		  #If TargetWin32 Then
		    Dim drvRoot As String = Left(Drive.AbsolutePath_, 1) + ":\"
		    Dim total, free, x As UInt64
		    Call GetDiskFreeSpaceEx(drvRoot, x, total, free)
		    
		    Return total
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
		          Dim err As New Win32Exception(GetLastError)
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
		    #pragma Error "The GZip Plugin Does Not Support Console Applications"
		    
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
		            Dim err As New Win32Exception(GetLastError)
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
		    #pragma Error "The GZip Plugin Does Not Support Console Applications"
		    
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
		Function HardLinks(Extends target As FolderItem) As FolderItem()
		  //Returns an array of folderitems which are actually NTFS hard links which point to the same file as the specified folderitem
		  //Windows Vista and newer only.
		  //Returns an empty array on error.
		  
		  #If TargetWin32 Then
		    Dim findHandle, buffSize As Integer
		    Dim linkname As New MemoryBlock(4096)
		    Dim ret() As FolderItem
		    buffSize = linkname.Size
		    linkname = New MemoryBlock(buffSize)
		    findHandle = FindFirstFileNameW(target.AbsolutePath_, 0, buffSize, linkname)
		    If findHandle <> INVALID_HANDLE_VALUE Then
		      Do
		        Dim f As FolderItem = GetFolderItem(Left(target.AbsolutePath_, 2) + linkname.WString(0))
		        If f <> Nil Then ret.Append(f)
		        buffSize = linkname.Size
		      Loop Until Not FindNextFileNameW(findHandle, buffSize, linkname)
		    End If
		    Call FindClose(findHandle)
		    Return ret
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( deprecated = "FileAttributes.Hidden" )  Function Hidden(Extends target As FolderItem) As Boolean
		  //Returns true if the file has the hidden attribute
		  //This method has been deprecated in favor of the FileAttributes class
		  Dim attribs As New FileAttributes(target)
		  Return attribs.Hidden
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( deprecated = "FileAttributes.Hidden" )  Sub Hidden(Extends target As FolderItem, Assigns b As Boolean)
		  //Sets or clears the hidden attibute of the file
		  //This method has been deprecated in favor of the FileAttributes class
		  Dim attribs As New FileAttributes(Target)
		  attribs.Hidden = b
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsChildOf(Extends ByVal Child As FolderItem, Parent As FolderItem) As Boolean
		  //A method to determine whether the Child FolderItem is contained within the Parent
		  //FolderItem or one of its sub-directories.
		  
		  If Not Parent.Directory Then Return False
		  While Child.Parent <> Nil
		    If Child.Parent.AbsolutePath_ = Parent.AbsolutePath_ Then
		      Return True
		    End If
		    Child = Child.Parent
		  Wend
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsDangerous(Extends target As FolderItem) As Boolean
		  //Returns True if the target FolderItem has an extension (e.g. ".exe") which Windows deems dangerous.
		  //See the remarks here: http://msdn.microsoft.com/en-us/library/windows/desktop/bb773465%28v=vs.85%29.aspx
		  //XP with SP1 or newer only.
		  
		  #If TargetWin32 Then
		    If Platform.KernelVersion >= 6.0 Or (Platform.KernelVersion = 5.1 And Platform.ServicePack >= 1) Then
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
		Function IsExecutable(Extends target As FolderItem) As Boolean
		  //Returns True if the file is executable or contains executable code (e.g. EXE, VBS, BAT)
		  //See: http://msdn.microsoft.com/en-us/library/windows/desktop/ms722429%28v=vs.85%29.aspx
		  
		  #If TargetWin32 Then
		    Return SaferiIsExecutableFileType(target.AbsolutePath_, False)
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
		Attributes( deprecated = "FileAttributes.Normal" )  Function IsNormal(Extends target As FolderItem) As Boolean
		  //Returns True if the target has no file attributes set
		  //This method has been deprecated in favor of the FileAttributes class
		  Dim attribs As New FileAttributes(target)
		  Return attribs.Normal
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( deprecated = "FileAttributes.Normal" )  Sub IsNormal(Extends target As FolderItem, Assigns b As Boolean)
		  //Clears all file attributes
		  //This method has been deprecated in favor of the FileAttributes class
		  Dim attribs As New FileAttributes(Target)
		  attribs.Normal = b
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsParentOf(Extends Parent As FolderItem, Child As FolderItem) As Boolean
		  Return Child.IsChildOf(Parent)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LaunchAndWait(Extends EXE As FolderItem, Arguments As String = "", deskName as String = "") As Boolean
		  #If TargetWin32
		    Dim StartInfo As New MemoryBlock(STARTUPINFO.Size)
		    Dim procInfo As New MemoryBlock(PROCESS_INFORMATION.Size)
		    StartInfo.Long(0) = StartInfo.Size
		    StartInfo.Ptr(8) = deskName
		    Dim path, args As MemoryBlock
		    path = EXE.AbsolutePath_
		    args = Arguments
		    If CreateProcess(EXE.AbsolutePath_, args, 0, 0, False, 0, Nil, Nil, StartInfo, procInfo) Then
		      Const INFINITE = -1
		      Const WAIT_TIMEOUT = &h00000102
		      Const WAIT_OBJECT_0 = &h0
		      While WaitForSingleObject(procInfo.Long(0), 1) = WAIT_TIMEOUT
		        #If TargetHasGUI Then
		          App.SleepCurrentThread(10)
		        #Else
		          App.DoEvents(10)
		        #endif
		      Wend
		      Call CloseHandle(procInfo.Long(0))
		      Call CloseHandle(procInfo.Long(4))
		      Return true
		      
		    Else
		      Return False
		      
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LaunchAsAdministrator(extends f as FolderItem, ParamArray args as String)
		  #If TargetWin32
		    Dim params as String
		    params = Join(args, " ")
		    Call ShellExecute(0, "runas", f.AbsolutePath_, params, App.ExecutableFile.Parent.AbsolutePath_, 1)
		  #Endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ListDirectory(Root As FolderItem, SearchPattern As String = "*", PrependPath As Boolean = True) As String()
		  'See also the FileEnumerator class.
		  Dim list(), rootdir As String
		  If PrependPath Then rootdir = Root.AbsolutePath_
		  Dim Result As WIN32_FIND_DATA
		  Dim lister As New FileEnumerator(Root, SearchPattern)
		  While lister.LastError = 0
		    If Result.FileName <> "." And Result.FileName <> ".." Then
		      If PrependPath Then
		        list.Append(rootdir + Result.FileName)
		      Else
		        list.Append(Result.FileName)
		      End If
		    End If
		    Result = lister.NextItem
		  Wend
		  Return list
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LockFile(Extends lockedFile As FolderItem) As Integer
		  //Locks the file for exclusive use. You must call UnlockFile with the integer returned from this function to unlock the file.
		  //A positive return value is returned on success, 0 if lockedFile is Nil, and a negative number on error (a negative return value
		  //is actually the last Win32 error multiplied by -1. So, for example, -5 is ERROR_ACCESS_DENIED.)
		  //
		  //Once the file is locked you can pass the integer from this function to the constructor methods of the TextInputStream, TextOutputStream,
		  //and BinaryStream classes:
		  '
		  '    Dim file As FolderItem = GetFolderItem("C:\boot.ini")
		  '    Dim fhandle As Integer = f.LockFile
		  '    Dim tis As TextInputStream = New TextInputStream(fhandle, TextInputStream.HandleTypeWin32Handle
		  '
		  //Just as handy, the Close methods of each Stream class will also release the lock.
		  
		  #If TargetWin32 Then
		    If lockedFile = Nil Then Return 0
		    
		    Dim fHandle As Integer = CreateFile(lockedFile.AbsolutePath_, GENERIC_READ Or GENERIC_WRITE, FILE_SHARE_READ, 0, OPEN_EXISTING, 0, 0)
		    If fHandle > 0 Then
		      If LockFile(fHandle, 0, 0, 1, 0) Then
		        Return fHandle   //You MUST keep this return value if you want to unlock the file later!!!
		      Else
		        Return GetLastError * -1
		      End If
		    Else
		      Return GetLastError * -1
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MD5Hash(target As FolderItem, sizeCutoff As UInt64 = 52428800, ProgressFunction As ProgressCallback = Nil) As String
		  'If the target file is less than sizeCutoff in bytes (default is 50MB) this function uses the MD5() function to hash the file.
		  'If greater than sizeCutoff this function processes the file through the MD5Digest function. MD5Digest is preferable when
		  'hashing large files since the entire file will not be loaded into memory at once.
		  '
		  'If using MD5Digest, the sizeCutoff parameter also dictates how much of the file to read at a time. Default is 50MB.
		  'Returns the Hex representation of the hash
		  '
		  'If a ProgressCallback delegate is passed, the delegate will be invoked for each iteration of the MD5Digest loop (or once only
		  'if MD5Digest is not used.)
		  
		  
		  Dim s As String
		  If target.Length < sizeCutoff Then
		    Dim tis As TextInputStream
		    tis = tis.Open(target)
		    s = tis.ReadAll
		    tis.Close
		    s = EncodeHex(MD5(s))
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
		    s = EncodeHex(m5.Value)
		  End If
		  
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NormalizePath(Path As String) As String
		  //Under construction. Takes a string and normalizes it as a Windows path
		  
		  #If TargetWin32 Then
		    Dim mb As New MemoryBlock(1024)
		    mb.WString(0) = path
		    Dim i As Integer= PathAddBackslash(mb)
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
		Attributes( deprecated = "FileAttributes.ReadOnly" )  Function ReadOnly(Extends target As FolderItem) As Boolean
		  //Returns true if the file has the ReadOnly attribute
		  //This method has been deprecated in favor of the FileAttributes class
		  Dim attribs As New FileAttributes(target)
		  Return attribs.ReadOnly
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( deprecated = "FileAttributes.ReadOnly" )  Sub ReadOnly(Extends target As FolderItem, Assigns b As Boolean)
		  //Sets or clears the Read Only attibute of the file
		  //This method has been deprecated in favor of the FileAttributes class
		  Dim attribs As New FileAttributes(Target)
		  attribs.ReadOnly = b
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
		    If CurrentDir = Nil Then CurrentDir = App.ExecutableFile.Parent
		    
		    Dim outBuff As New MemoryBlock(1024)
		    outBuff.WString(0) = CurrentDir.AbsolutePath_
		    Dim inBuff As New MemoryBlock(1024)
		    inBuff.WString(0) = RelativePath
		    If PathAppend(outBuff, inBuff) Then
		      inBuff.WString(0) = outBuff.WString(0)
		      If PathCanonicalize(outBuff, inBuff) Then
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
		    Return MoveFileEx(source.AbsolutePath_, destination.AbsolutePath_, MOVEFILE_DELAY_UNTIL_REBOOT Or MOVEFILE_REPLACE_EXISTING)
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReplaceWith(Extends source As FolderItem, destination As FolderItem, forceSync As Boolean = False, backupFile As FolderItem = Nil) As Boolean
		  //Replaces the source file with the destination file.
		  //If forceSync is true then the disk buffers are forced to flush all changes to the disk
		  //Specify the backupFile parameter to create a backup copy of the source file
		  //If this function fails, look at GetLastError for the error reason.
		  
		  #If TargetWin32
		    If source.Directory Or destination.Directory Then Return False
		    Dim rpFlags As Integer
		    If forceSync Then rpFlags = REPLACEFILE_WRITE_THROUGH
		    
		    If backupFile = Nil Then
		      Return ReplaceFile(source.AbsolutePath_, destination.AbsolutePath_, Nil, rpFlags, 0, 0)
		    Else
		      Dim backupPath As New MemoryBlock(LenB(backupFile.AbsolutePath_) * 2 + 2)
		      backupPath.WString(0) = backupFile.AbsolutePath_
		      Return ReplaceFile(source.AbsolutePath_, destination.AbsolutePath_, backupPath, rpFlags, 0, 0)
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShowInExplorer(extends f As FolderItem)
		  //Shows the file in Windows Explorer
		  
		  #If TargetWin32 Then
		    Dim param As String = "/select, """ + f.AbsolutePath_ + """"
		    Call ShellExecute(0, "open", "explorer", param, "", SW_SHOW)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SlowAccess(Extends f As FolderItem) As Boolean
		  //Returns True if the specified FolderItem is located on a high-latentcy (<40000 baud) network location.
		  
		  #If TargetWin32 Then
		    Return PathIsSlow(f.AbsolutePath_, -1)
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StopWatchingDirectory(WatchHandle As Integer)
		  //Housekeeping. Call this function with the value returned from WatchDirectoryForChanges to clean up when you're done watching.
		  //FIXME: messy
		  #If TargetWin32 Then
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
		    
		    If Platform.KernelVersion < 6.0 And Platform.KernelVersion >= 5.0 Then
		      Dim fHandle As Integer = CreateFile(target.AbsolutePath_, 0,  FILE_SHARE_READ Or FILE_SHARE_WRITE, 0, OPEN_EXISTING, 0, 0)
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
		      Dim sHandle As Integer = FindFirstStream(target.AbsolutePath_, 0, buffer, 0)
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
		        Dim fHandle As Integer = CreateFile(target.AbsolutePath_ + ":" + StreamName + ":$DATA", 0, FILE_SHARE_READ Or FILE_SHARE_WRITE, 0, OPEN_EXISTING, 0, 0)
		        If fHandle > 0 Then
		          target = GetFolderItem(target.AbsolutePath_ + ":" + StreamName + ":$DATA")
		          Call CloseHandle(fHandle)
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
		    If Platform.KernelVersion >= 5.0 And Platform.KernelVersion < 6.0 Then
		      
		      Dim fHandle As Integer = CreateFile(f.AbsolutePath_, 0,  FILE_SHARE_READ Or FILE_SHARE_WRITE, 0, OPEN_EXISTING, 0, 0)
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
		      Dim sHandle As Integer = FindFirstStream(f.AbsolutePath_, 0, buffer, 0)
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
		Attributes( deprecated = "FileAttributes.SystemFile" )  Function SystemFile(Extends target As FolderItem) As Boolean
		  //Returns True if the target has the System File attribute set
		  //This method has been deprecated in favor of the FileAttributes class
		  Dim attribs As New FileAttributes(target)
		  Return attribs.SystemFile
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( deprecated = "FileAttributes.SystemFile" )  Sub SystemFile(Extends target As FolderItem, Assigns b As Boolean)
		  //Sets or clears the System File attribute of the file
		  //This method has been deprecated in favor of the FileAttributes class
		  //This method has been deprecated in favor of the FileAttributes class
		  Dim attribs As New FileAttributes(Target)
		  attribs.SystemFile = b
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Truncate(Extends Stream As BinaryStream, NewLength As Integer = 0) As Boolean
		  //Truncates the stream to the specified length in bytes. Returns False on error (e.g. the file was in use, not found, etc.)
		  
		  #If TargetWin32 Then
		    Dim i As Integer = SetFilePointer(Stream.Handle(Stream.HandleTypeWin32Handle), NewLength, Nil, FILE_BEGIN)
		    If i <> INVALID_SET_FILE_POINTER Then
		      Return SetEndOfFile(stream.Handle(BinaryStream.HandleTypeWin32Handle))
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Truncate(Extends File As FolderItem, NewLength As Integer = 0) As Boolean
		  //Truncates the file to the specified length in bytes. Returns False on error (e.g. the file was in use, not found, etc.)
		  
		  Dim success As Boolean
		  If NewLength = 0 Then
		    Dim handle As Integer = CreateFile(File.Name, GENERIC_WRITE, 0, 0, TRUNCATE_EXISTING, FILE_ATTRIBUTE_NORMAL, 0)
		    If handle > 0 Then
		      Call CloseHandle(handle)
		      success = True
		    End If
		  Else
		    Dim stream As BinaryStream = BinaryStream.Open(File, True)
		    If stream.Truncate(NewLength) Then
		      stream.Close
		      Return True
		    End If
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TruncateAndOpen(Extends File As FolderItem) As TextOutputStream
		  //Truncates the file to zero bytes. Returns a TextOutputStream to the file.
		  //On error, Returns Nil
		  
		  #If TargetWin32 Then
		    Dim handle As Integer = CreateFile(File.Name, GENERIC_WRITE, 0, 0, TRUNCATE_EXISTING, FILE_ATTRIBUTE_NORMAL, 0)
		    If handle > 0 Then
		      Call CloseHandle(handle)
		      Return TextOutputStream.Create(File)
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function UnlockFile(fHandle As Integer) As Boolean
		  //See the LockFile function
		  #If TargetWin32 Then
		    If Kernel32.UnlockFile(fHandle, 0, 0, 1, 0) Then
		      Call CloseHandle(fHandle)
		      Return True
		    End If
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
		    
		    Dim infoSize As Integer = GetFileVersionInfoSize(f.AbsolutePath_, 0)
		    If infoSize <= 0 Then Return Nil
		    
		    Dim buff As New MemoryBlock(infoSize)
		    If GetFileVersionInfo(f.AbsolutePath_, 0, buff.Size, buff) Then
		      Dim mb As New MemoryBlock(4)
		      Dim retBuffLen As Integer
		      If VerQueryValue(buff, "\VarFileInfo\Translation", mb, retBuffLen) Then
		        Dim fields() As String = Split("Comments InternalName ProductName CompanyName LegalCopyright ProductVersion FileDescription LegalTrademarks PrivateBuild FileVersion OriginalFilename SpecialBuild", " ")
		        Dim j, k As String
		        j = Hex(mb.Ptr(0).Int16Value(0))
		        k = Hex(mb.Ptr(0).Int16Value(2))
		        Dim langCode As String = Left("0000", 4 - Len(j)) + j + Left("0000", 4 - Len(k)) + k
		        Dim ret As New Dictionary
		        For Each datum As String In fields
		          mb = New MemoryBlock(4)
		          If VerQueryValue(buff, "\StringFileInfo\" + langCode + "\" + datum, mb, retBuffLen) Then
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
		    If dir = Nil Then Return 0
		    If Not dir.Exists Or Not dir.Directory Then Return 0
		    
		    Dim customData As MemoryBlock = dir.AbsolutePath_  //Supposedly this gets passed to the callback function, but it doesn't for some reason.
		    Dim allFilters As Integer = FILE_NOTIFY_CHANGE_ATTRIBUTES Or FILE_NOTIFY_CHANGE_DIR_NAME Or FILE_NOTIFY_CHANGE_FILE_NAME Or _
		    FILE_NOTIFY_CHANGE_LAST_WRITE Or FILE_NOTIFY_CHANGE_SECURITY Or FILE_NOTIFY_CHANGE_SIZE
		    
		    Dim monHandle As Integer = FindFirstChangeNotification(dir.AbsolutePath_, True, allFilters)
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
End Module
#tag EndModule
