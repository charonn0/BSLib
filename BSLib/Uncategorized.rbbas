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
		Function Tokenize(Input As String) As String()
		  //Returns a String array containing the space-delimited members of the Input string.
		  //Like `Split` but honoring quotes; good for command line arguments and other parsing.
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
