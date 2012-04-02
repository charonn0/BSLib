#tag Module
Protected Module Uncategorized
	#tag Method, Flags = &h0
		Function ASCIIorUnicode(s As String) As Integer
		  //*Very* naive, detects ASCII or Unicode
		  
		  Const ASCII = 0
		  Const Unicode = 1
		  
		  If MidB(s, 2, 1) = Chr(0) And MidB(s, 4, 1) = Chr(0) Then
		    Return Unicode
		  Else
		    Return ASCII
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Beep(freq As Integer, duration As Integer)
		  //This function differs from the built-in Beep method in that both the frequency and duration of the beep can (must) be specified.
		  //Windows Vista and XP64 omit this function.
		  #If TargetWin32 Then
		    If System.IsFunctionAvailable("Beep", "Kernel32") Then
		      Soft Declare Function WinBeep Lib "Kernel32" Alias "Beep" (freq As Integer, duration As Integer) As Boolean
		      Call WinBeep(freq, duration)
		    Else
		      #If TargetHasGUI Then Realbasic.Beep  //Built-in beep not available in ConsoleApplications? Weird.
		    End If
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ETA(d As Date, d2 As Date = Nil) As String
		  //Given a date object, returns the time difference from now, as a long-form string.
		  //e.g.: "12 minutes from now." or "6 weeks, 4 days, 13 hours, 9 minutes, 12 seconds ago."
		  //
		  //If you pass the optional d2 Date object, then the time difference is calculated as the
		  //difference from d2 (the "present") to d.
		  
		  Dim words As String
		  Dim secsremaining As UInt64
		  If d2 = Nil Then d2 = New Date
		  If d.TotalSeconds < d2.TotalSeconds Then  //In the future
		    secsremaining = d2.TotalSeconds - d.TotalSeconds
		  Else  //In the past (or present)
		    secsremaining = d.TotalSeconds - d2.TotalSeconds
		  End If
		  
		  Const secs_in_min = 60
		  Const secs_in_hour = 3600
		  Const secs_in_day = 86400
		  Const secs_in_week = 604800
		  Const secs_in_year = 31556926
		  
		  Dim tmp As UInt64
		  Dim periodname As String
		  
		  
		  tmp = secsremaining \ secs_in_year
		  If tmp > 0 Then
		    If tmp > 1000 Then Return "Just prior to the heat death of the Universe."  //We've overflowed
		    If tmp = 1 Then
		      periodname = " year, "
		    Else
		      periodname = " years, "
		    End If
		    words = words + Str(tmp) + periodname
		  End If
		  secsremaining = secsremaining - tmp * secs_in_year
		  tmp = 0
		  
		  
		  tmp = secsremaining \ secs_in_week
		  If tmp > 0 Then
		    If tmp = 1 Then
		      periodname = " week, "
		    Else
		      periodname = " weeks, "
		    End If
		    words = words + Str(tmp) + periodname
		  End If
		  secsremaining = secsremaining - tmp * secs_in_week
		  tmp = 0
		  
		  
		  
		  tmp = secsremaining \ secs_in_day
		  If tmp > 0 Then
		    If tmp = 1 Then
		      periodname = " day, "
		    Else
		      periodname = " days, "
		    End If
		    words = words + Str(tmp) + periodname
		  End If
		  secsremaining = secsremaining - tmp * secs_in_day
		  tmp = 0
		  
		  
		  
		  
		  tmp = secsremaining \ secs_in_hour
		  If tmp > 0 Then
		    If tmp = 1 Then
		      periodname = " hour, "
		    Else
		      periodname = " hours, "
		    End If
		    words = words + Str(tmp) + periodname
		  End If
		  secsremaining = secsremaining - tmp * secs_in_hour
		  tmp = 0
		  
		  
		  
		  
		  
		  tmp = secsremaining \ secs_in_min
		  If tmp > 0 Then
		    If tmp > 1 Then
		      periodname = " minutes"
		    Else
		      periodname = " minutes"
		    End If
		    words = words + Str(tmp) + periodname
		  End If
		  secsremaining = secsremaining - tmp * secs_in_min
		  
		  If secsremaining > 0 Then
		    words = words + ", "
		    If tmp > 1 Then
		      periodname = " seconds"
		    Else
		      periodname = " second"
		    End If
		    words = words + Str(secsremaining) + periodname
		  End If
		  words = words + " "
		  
		  
		  
		  If d.TotalSeconds < d2.TotalSeconds Then
		    words = words + " ago."
		  Else
		    words = words + " from now."
		  End If
		  
		  Return words
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FormatBytes(bytes As UInt64) As String
		  //Converts raw byte counts into SI formatted strings. 1KB = 1024 bytes.
		  //Should return properly formatted strings for any positive number of bytes
		  //up to the overflow of a UInt64.
		  
		  Dim suffix As String
		  Dim strBytes As Double
		  
		  If bytes < 1024 Then
		    strBytes = bytes
		    suffix = "bytes"
		  ElseIf bytes <= 512000 And bytes >= 1024 Then
		    strBytes = bytes / 1024
		    suffix = "KB"
		  ElseIf bytes > 512000 And bytes < 786432000 Then  //786432000 bytes = 750 MB
		    strBytes = bytes / 1048576
		    suffix = "MB"
		  ElseIf bytes >= 786432000 And bytes < 824633720832 Then
		    strBytes = bytes / 1073741824
		    suffix = "GB"
		  ElseIf bytes > 824633720832 And bytes < 1125999999999999 Then
		    strBytes = bytes / 1099511627776
		    suffix = "TB"
		  ElseIf bytes >= 1126000000000000 And bytes < 1152921504606846975 Then
		    strBytes = bytes / 1126000000000000
		    suffix = "PB"
		  ElseIf bytes >= 1152921504606846976 Then
		    strBytes = bytes / 1152921504606846976
		    suffix = "EB"
		  End If
		  Return Format(strBytes, "#,###0.00") + " " + suffix
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FormatHertz(hertz As UInt64) As String
		  //Converts raw Hertz into SI formatted strings. 1MHz = 1000 Hertz.
		  Const kilo = 1000
		  Dim mega As UInt64 = 1000 * kilo
		  Dim giga As UInt64 = 1000 * mega
		  Dim tera As UInt64 = 1000 * giga
		  
		  Dim suffix As String
		  Dim strHertz As Double
		  
		  If hertz < kilo Then
		    strHertz = hertz
		    suffix = "Hz"
		  ElseIf hertz >= kilo And hertz < mega Then
		    strHertz = hertz / kilo
		    suffix = "KHz"
		  ElseIf hertz >= mega And hertz < giga Then
		    strHertz = hertz / mega
		    suffix = "MHz"
		  ElseIf hertz >= giga And hertz < tera Then
		    strHertz = hertz / giga
		    suffix = "GHz"
		  ElseIf hertz > tera Then
		    strHertz = hertz / tera
		    suffix = "THz"
		  End If
		  Return Format(strHertz, "#######0.00") + " " + suffix
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IntToHex(src as Byte) As string
		  //Hexify a Byte with padded zeros if needed
		  
		  Return RightB("00" + Hex(src), 2)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RegExFind(Extends source As String, pattern As String) As String()
		  //Returns a string array of all subexpressions
		  
		  Dim rg as New RegEx
		  Dim myMatch as RegExMatch
		  Dim ret() As String
		  rg.SearchPattern = pattern
		  myMatch=rg.search(source)
		  If myMatch <> Nil Then
		    For i As Integer = 0 To myMatch.SubExpressionCount - 1
		      ret.Append(myMatch.SubExpressionString(i))
		    Next
		  End If
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ResolveRelativePath(RelativePath As String, CurrentDir As FolderItem = Nil) As String
		  //Takes a Relative Path and an optional root directory. Returns a string representing the absolute path
		  //represented by the RelativePath relative to the CurrentDir.
		  //If CurrentDir is Nil then the App.ExecutableFile.Parent directory is used.
		  //For Example:
		  
		  'Dim f As FolderItem = GetFolderItem("C:\")
		  'Dim abso As String = ResolveRelativePath("Windows\..\Program Files\MyApp\MyApp Libs\..\MyApp.exe", f)
		  
		  //abso would now be "C:\Program Files\MyApp\MyApp.exe"
		  //Note that this function does not determine whether the resulting absolute path is valid, or whether
		  //the file/directory it refers to exists.
		  
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
		Function Shorten(Extends data As String, maxLength As Integer = 45) As String
		  //Replaces characters from the middle of a string with a single ellipsis ("...") until data.Len is less than the specified length.
		  //Useful for showing long paths by omitting the middle part of the data, though not limited to this use.
		  
		  If data.Len <= maxLength then
		    Return data
		  Else
		    Dim shortdata, snip As String
		    Dim start As Integer
		    shortdata = data
		    
		    While shortdata.len > maxLength
		      start = shortdata.Len / 3
		      snip = mid(shortdata, start, 5)
		      shortdata = Replace(shortdata, snip, "...")
		    Wend
		    Return shortdata
		  End If
		  
		Exception err
		  Return data
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StringToHex(src as string) As string
		  //Hexify a string of binary data, e.g. from RB's built-in MD5 function
		  //Example StringToHex("Hello, world!") = "48656C6C6F2C20776F726C6421"
		  
		  Dim hexvalue As Integer
		  Dim hexedInt As String
		  
		  For i As Integer = 1 To LenB(src)
		    hexvalue = AscB(MidB(src, i, 1))
		    hexedInt = hexedInt + RightB("00" + Hex(hexvalue), 2)
		  next
		  
		  Return LeftB(hexedInt, LenB(hexedInt))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Tokenize(ByVal Input As String) As String()
		  //Returns a String array containing the space-delimited members of the Input string.
		  //Like `String.Split(" ")` but honoring quotes; good for command line arguments and other parsing.
		  //For example, this string:
		  '                     MyApp.exe --foo "C:\My Dir\"
		  //Would become:
		  '                     s(0) = MyApp.exe
		  '                     s(1) = --foo
		  '                     s(2) = "C:\My Dir\"
		  
		  
		  #If TargetWin32 Then
		    Declare Function PathGetArgsW Lib "Shlwapi" (path As WString) As WString
		    Dim ret() As String
		    Dim cmdLine As String = Input
		    While cmdLine.Len > 0
		      Dim tmp As String
		      Dim args As String = PathGetArgsW(cmdLine)
		      If Len(args) = 0 Then
		        tmp = ReplaceAll(cmdLine.Trim, Chr(34), "")
		        ret.Append(tmp)
		        Exit While
		      Else
		        tmp = Left(cmdLine, cmdLine.Len - args.Len).Trim
		        tmp = ReplaceAll(tmp, Chr(34), "")
		        ret.Append(tmp)
		        cmdLine = args
		      End If
		    Wend
		    Return ret
		  #endif
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function UUID() As String
		  //This function ©2004-2011 Adam Shirey
		  //http://www.dingostick.com/node.php?id=11
		  
		  Dim strUUID As String
		  
		  #If TargetMacOS
		    //see http://developer.apple.com/documentation/CoreFOundation/Reference/CFUUIDRef/Reference/reference.html
		    Declare Function CFUUIDCreate Lib "Carbon" (alloc As ptr) As Ptr
		    Declare Function CFUUIDCreateString Lib "Carbon" (alloc As ptr, CFUUIDRef As Ptr) As CFStringRef
		    Declare Sub CFRelease Lib "Carbon" (cf As Ptr)
		    
		    Dim pUUID As ptr = CFUUIDCreate(Nil)
		    StructureInfo = CFUUIDCreateString(Nil, pUUID)
		    CFRelease(pUUID)
		    
		  #ElseIf TargetWin32
		    //see: http://msdn.microsoft.com/en-us/library/aa379205(VS.85).aspx
		    //and: http://msdn.microsoft.com/en-us/library/aa379352(VS.85).aspx
		    
		    Const RPC_S_UUID_LOCAL_ONLY = 1824
		    Const RPC_S_UUID_NO_ADDRESS = 1739
		    
		    Declare Function RpcStringFree Lib "Rpcrt4" Alias "RpcStringFreeA" (Addr As Ptr) As Integer
		    Declare Function UuidCreate Lib "Rpcrt4" (Uuid As Ptr) As Integer
		    Declare Function UuidToString Lib "Rpcrt4" Alias "UuidToStringA" (Uuid As Ptr, ByRef p As ptr) As Integer
		    
		    Static mb As New MemoryBlock(16)
		    Call UuidCreate( mb ) //can compare to RPC_S_UUID_LOCAL_ONLY and RPC_S_UUID_NO_ADDRESS for more info
		    
		    Static ptrUUID As New MemoryBlock(16)
		    
		    Dim ppAddr As ptr
		    Call UuidToString(mb, ppAddr)
		    
		    Dim mb2 As MemoryBlock = ppAddr
		    strUUID = mb2.CString(0)
		    
		    Call RpcStringFree(ptrUUID)
		    
		    
		  #ElseIf TargetLinux
		    // see http://linux.die.net/man/3/uuid_generate
		    
		    // these are soft declared because there's perhaps a smaller chance of libuuid being present on a linux system,
		    // though I have no evidence to support such a claim. it seems pretty standard.
		    
		    Soft Declare Sub uuid_generate Lib "libuuid" (out As ptr)
		    Soft Declare Sub uuid_unparse_upper(mb As Ptr, uu As Ptr)
		    
		    If System.IsFunctionAvailable("uuid_generate", "libuuid") Then
		      Static mb As New MemoryBlock( 16 )
		      Static uu As New MemoryBlock( 36 )
		      
		      uuid_generate(mb) // generate the uuid in binary form
		      uuid_unparse_upper(mb, uu) // convert to a 36-byte string
		      
		      strUUID = uu.StringValue(0, 36)
		    Else
		      System.DebugLog(App.ExecutableFile.Name + ": expected libuuid!")
		    End If
		  #EndIf
		  
		  Return strUUID
		End Function
	#tag EndMethod


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
