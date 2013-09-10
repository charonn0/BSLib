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
		Function C2F(C As Double) As Double
		  //Converts degrees Celcius to degrees Fahrenheit
		  Return (9/5) * C + 32
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CRC32(Extends source As MemoryBlock) As Integer
		  Const CRCpolynomial = &hEDB88320
		  Dim crc, t as Integer
		  Dim strCode as String
		  strCode = source.StringValue(0, source.Size)
		  crc = &hffffffff
		  Dim char As String
		  
		  For x As Integer = 1 To LenB(strcode)
		    char = Midb(strcode, x, 1)
		    t = (crc And &hFF) Xor AscB(char)
		    For b As Integer = 0 To 7
		      If((t And &h1) = &h1) Then
		        t = bitwise.ShiftRight(t, 1, 32) Xor CRCpolynomial
		      Else
		        t = bitwise.ShiftRight(t, 1, 32)
		      End If
		    next
		    crc = Bitwise.ShiftRight(crc, 8, 32) Xor t
		  Next
		  Return (crc Xor &hFFFFFFFF)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CreateURLShortcut(URL As String, ShortcutName As String, IconResource As FolderItem = Nil, IconIndex As Integer = - 1) As FolderItem
		  //Creates a shortcut (.url file) in the users %TEMP% directory named ShortcutName and pointing to URL. Returns
		  //a FolderItem corresponding to the shortcut file. You must move the returned Shortcut file to the desired directory.
		  //On error, returns Nil.
		  //You may optionally pass an IconResource and IconIndex. The IconResource is a Windows resource file that has icon resources,
		  //for example EXE, DLL, SYS, ICO, and CUR files. The IconIndex parameter is the index of the icon in the IconResource file.
		  
		  //See also: Images.SelectIcon; File_Ops.CreateShortcut
		  
		  #If TargetWin32 Then
		    Dim lnkObj As OLEObject
		    Dim scriptShell As New OLEObject("Wscript.shell")
		    
		    If scriptShell <> Nil then
		      lnkObj = scriptShell.CreateShortcut(SpecialFolder.Temporary.AbsolutePath_ + ShortcutName + ".url")
		      If lnkObj <> Nil then
		        lnkObj.TargetPath = URL
		        lnkObj.Save
		        
		        Dim optionalparams As String
		        
		        If IconResource <> Nil Then optionalparams = "IconFile=" + IconResource.AbsolutePath_ + EndOfLine.Windows + _
		        "IconIndex=" + Str(IconIndex) + EndOfLine
		        
		        If optionalparams.Trim <> "" Then
		          Dim tos As TextOutputStream
		          tos = tos.Append(SpecialFolder.Temporary.TrueChild(ShortcutName + ".url"))
		          tos.Write(optionalparams)
		          tos.Close
		        End If
		        
		        Return SpecialFolder.Temporary.TrueChild(ShortcutName + ".url")
		      End If
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DataURI(f As FolderItem, MIME As String) As String
		  //encodes a file as an inline data: URI entity
		  Dim s As String = "data:" + MIME +";charset=US-ASCII;base64,"
		  s = ConvertEncoding(s, Encodings.ASCII)
		  Dim tis As TextInputStream
		  Dim tmp As String
		  tis = tis.Open(f)
		  tmp = tis.ReadAll
		  tis.Close
		  tmp = EncodeBase64(tmp)
		  Return s + tmp
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DataURI(pic As Picture) As String
		  //encodes a picture as an inline data: URI entity
		  Dim s As String = "data:image/png;charset=US-ASCII;base64,"
		  s = ConvertEncoding(s, Encodings.ASCII)
		  Dim tmp As String = pic.GetData(Picture.FormatPNG)
		  tmp = EncodeBase64(tmp)
		  Return s + tmp
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DataURI(data As String) As String
		  //Decodes the data part of a data: URI
		  Dim prefix As String = NthField(data, ",", 1)
		  data = Replace(data, prefix + ",", "")
		  prefix = Replace(prefix, "data:", "")
		  data = DecodeBase64(data)
		  Return data
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ETA(d As Date, d2 As Date = Nil) As String
		  //Given a date object, returns the time difference from now, as a long-form string.
		  //e.g.: "12 minutes from now." or "6 weeks, 4 days, 13 hours, 1 minute, 12 seconds"
		  //
		  //If you pass the optional d2 Date object, then the time difference is calculated as the
		  //difference from d2 (the "present") to d.
		  
		  Const secs_in_min = 60
		  Const secs_in_hour = 3600
		  Const secs_in_day = 86400
		  Const secs_in_week = 604800
		  Const secs_in_year = 31556926
		  
		  Dim years, weeks, days, hours, minutes, seconds, diff As UInt64
		  If d2 = Nil Then d2 = New Date
		  
		  If d.TotalSeconds < d2.TotalSeconds Then  //In the future
		    diff = d2.TotalSeconds - d.TotalSeconds
		  ElseIf d.TotalSeconds <> d2.TotalSeconds Then  //In the past (or present)
		    diff = d.TotalSeconds - d2.TotalSeconds
		  Else //dates are identical
		    Return "0 seconds"
		  End If
		  
		  years = diff \ secs_in_year
		  diff = diff Mod secs_in_year
		  weeks = diff \ secs_in_week
		  diff = diff Mod secs_in_week
		  days = diff \ secs_in_day
		  diff = diff Mod secs_in_day
		  hours = diff \ secs_in_hour
		  diff = diff Mod secs_in_hour
		  minutes = diff \ secs_in_min
		  diff = diff Mod secs_in_min
		  seconds = diff
		  
		  Dim data As String
		  
		  If years > 0 Then
		    data = data + Format(years, "###,###,###,###") + " year"
		    If years > 1 Then data = data + "s"
		    data = data + ", "
		  End If
		  
		  If weeks > 0 Then
		    data = data + Format(weeks, "###") + " week"
		    If weeks > 1 Then data = data + "s"
		    data = data + ", "
		  End If
		  
		  If days > 0 Then
		    data = data + Format(days, "#") + " day"
		    If days > 1 Then data = data + "s"
		    data = data + ", "
		  End If
		  
		  If hours > 0 Then
		    data = data + Format(hours, "##") + " hour"
		    If hours > 1 Then data = data + "s"
		    data = data + ", "
		  End If
		  
		  If minutes > 0 Then
		    data = data + Format(minutes, "##") + " minute"
		    If minutes > 1 Then data = data + "s"
		    data = data + ", "
		  End If
		  
		  If seconds > 0 Then
		    data = data + Format(seconds, "##") + " second"
		    If seconds > 1 Then data = data + "s"
		  End If
		  
		  Return data
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ExtractLinks(HTML As String, BaseURL As String) As String()
		  'Given the HTML source code and base URL of a webpage, returns an array of all
		  'hyperlink addresses.
		  Dim proto As String
		  If InStr(BaseURL, "://") > 0 Then
		    proto = NthField(BaseURL, "://", 1)
		  Else
		    proto = "http"
		  End If
		  BaseURL = Replace(BaseURL, proto + "://", "")
		  
		  Dim ret() As String
		  Dim hrefReg As RegEx
		  hrefReg = New RegEx
		  hrefReg.Options.CaseSensitive = False
		  hrefReg.SearchPattern = "<a[^"">]*href=""([^"">]*)""[^>]*>"
		  Dim hrefMatch as RegExMatch
		  
		  // find the match
		  hrefMatch = hrefReg.Search(HTML)
		  while hrefMatch <> Nil
		    Dim s As String = hrefMatch.SubExpressionString(1)
		    If InStr(s, "mailto:") <= 0 Then
		      Dim prto As String
		      If InStr(s, "://") > 0 Then
		        prto = NthField(s, "://", 1)
		        s = NthField(s, "://", 2)
		      Else
		        prto = proto
		      End If
		      
		      If InStr(s, baseURL) > 0 Then
		        s = s
		      ElseIf prto.Trim = proto.Trim Then
		        s = BaseURL + "/" + s
		      End If
		      s = ReplaceAll(s, "//", "/")
		      s = prto + "://" + s
		      'If Left(s, prto.Len) <> prto Then s = prto + s
		      ret.Append(s)
		    Else
		      ret.Append(s)
		    End If
		    hrefMatch = hrefReg.Search()
		  wend
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function F2C(F As Double) As Double
		  //Converts degrees Fahrenheit to degrees Celcius
		  Return (5/9) * (F - 32)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FormatBytes(bytes As UInt64, precision As Integer = 2) As String
		  //Converts raw byte counts into SI formatted strings. 1KB = 1024 bytes.
		  //Optionally pass an integer representing the number of decimal places to return. The default is two decimal places. You may specify
		  //between 0 and 16 decimal places. Specifying more than 16 will append extra zeros to make up the length. Passing 0
		  //shows no decimal places and no decimal point.
		  
		  Const kilo = 1024
		  Static mega As UInt64 = kilo * kilo
		  Static giga As UInt64 = kilo * mega
		  Static tera As UInt64 = kilo * giga
		  Static peta As UInt64 = kilo * tera
		  Static exab As UInt64 = kilo * peta
		  
		  Dim suffix, precisionZeros As String
		  Dim strBytes As Double
		  
		  
		  If bytes < kilo Then
		    strbytes = bytes
		    suffix = "bytes"
		  ElseIf bytes >= kilo And bytes < mega Then
		    strbytes = bytes / kilo
		    suffix = "KB"
		  ElseIf bytes >= mega And bytes < giga Then
		    strbytes = bytes / mega
		    suffix = "MB"
		  ElseIf bytes >= giga And bytes < tera Then
		    strbytes = bytes / giga
		    suffix = "GB"
		  ElseIf bytes >= tera And bytes < peta Then
		    strbytes = bytes / tera
		    suffix = "TB"
		  ElseIf bytes >= tera And bytes < exab Then
		    strbytes = bytes / peta
		    suffix = "PB"
		  ElseIf bytes >= exab Then
		    strbytes = bytes / exab
		    suffix = "EB"
		  End If
		  
		  
		  While precisionZeros.Len < precision
		    precisionZeros = precisionZeros + "0"
		  Wend
		  If precisionZeros.Trim <> "" Then precisionZeros = "." + precisionZeros
		  
		  Return Format(strBytes, "#,###0" + precisionZeros) + " " + suffix
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FormatDegrees(degrees As Double) As String
		  //Assumes Unicode
		  Dim s As String = DefineEncoding(&u00B0, Encodings.UTF8)
		  s = Format(degrees, "-###,##0.0#") + s
		  Return s
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FormatHertz(hertz As UInt64, precision As Integer = 2) As String
		  //Converts raw Hertz into SI formatted strings. 1KHz = 1000 Hertz.
		  //Optionally pass an integer representing the number of decimal places to return. The default is two decimal places. You may specify
		  //between 0 and 16 decimal places. Specifying more than 16 will append extra zeros to make up the length. Passing 0
		  //shows no decimal places and no decimal point.
		  
		  Const kilo = 1000
		  Dim mega As UInt64 = 1000 * kilo
		  Dim giga As UInt64 = 1000 * mega
		  Dim tera As UInt64 = 1000 * giga
		  
		  Dim suffix, precisionZeros As String
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
		  
		  While precisionZeros.Len < precision
		    precisionZeros = precisionZeros + "0"
		  Wend
		  If precisionZeros.Trim <> "" Then precisionZeros = "." + precisionZeros
		  Return Format(strHertz, "###0" + precisionZeros) + " " + suffix
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HighBits(Extends BigInt As UInt64) As Integer
		  'Gets the high-order bits of the passed UInt64
		  Return ShiftRight(BigInt, 32)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HighBits(Extends ByRef BigInt As UInt64, Assigns HighOrder As Integer)
		  'Sets the high-order bits of the passed UInt64
		  BigInt = BitOr(ShiftLeft(HighOrder, 32), BigInt.LowBits)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IntToHex(src as Byte) As string
		  //Hexify a Byte with padded zeros if needed
		  
		  Return RightB("00" + Hex(src), 2)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LowBits(Extends BigInt As UInt64) As Integer
		  'Gets the low-order bits of the passed UInt64
		  Return BitAnd(BigInt, &hFFFFFFFF)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LowBits(Extends ByRef BigInt As UInt64, Assigns LowOrder As Integer)
		  'Sets the low-order bits of the passed UInt64
		  BigInt = BitOr(ShiftLeft(BigInt.HighBits, 32), LowOrder)
		End Sub
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
		Sub ReRaise(Error As RuntimeException)
		  'Used in conjunction with the CaughtException class, this method re-raises the passed RuntimeException
		  'without overwriting the original exception's Stack property. Further discussion and code from:
		  'http://www.realsoftwareblog.com/2012/07/preserving-stack-trace-when-catching.html
		  '
		  'Example usage:
		  'Try
		  ' //Blah blah
		  'Catch Error As SomeException
		  ' //Cleanup the db, maybe logging and user notification, etc.
		  ' //all done, ReRaise it.
		  '  ReRaise Error
		  'End Try
		  
		  Raise New CaughtException(Error)
		  
		End Sub
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
		Function RobotBlocked(robotstxt As String, UserAgent As String, Path As String = "/") As Boolean
		  'Parses a website's robots.txt file and returns True if the passed UserAgent is Disallowed for the specified path
		  'If not disallowed (i.e. allowed) then returns False.
		  
		  Const AllBots = "*"
		  robotstxt = ReplaceLineEndings(robotstxt, EndOfLine.Windows)
		  Dim records() As String = robotstxt.Split(EndOfLine.Windows + EndOfLine.Windows) 'Robots.txt is broken into records by CRLF+CRLF
		  
		  'First parse the raw robots.txt
		  For i As Integer = 0 To UBound(records)
		    Dim UA(), paths(), lines() As String
		    lines = Split(records(i), EndOfLine.Windows) 'Each record is broken into members by CRLF
		    For Each line As String In lines
		      
		      line = Left(line, line.Len - InStr(line, "#"))
		      If line.Trim = "" Then Continue 'comment lines are ignored
		      
		      Dim field, value As String
		      'Each member is broken into halves by a colon (:)
		      field = NthField(line, ":", 1).Trim
		      value = NthField(line, ":", 2).Trim
		      
		      If field.Trim = "User-Agent" Then
		        UA.Append(value)
		        
		      ElseIf field.Trim = "Disallow" Then
		        paths.Append(value)
		        
		      ElseIf field.Trim = "Sitemap"  Then
		        Continue 'Sometimes used (not an error), but not interesting to us
		        
		      Else
		        #If DebugBuild Then
		          Break 'invalid robots.txt data!
		        #endif
		        Return False
		        
		      End If
		    Next
		    
		    'Then check to see if we're blocked
		    For Each Agent As String In UA
		      If Agent = UserAgent Or Agent.Trim = AllBots Then
		        For Each URL As String In paths
		          If InStr(URL, "*") > 1 Then URL = NthField(URL, "*", 1) 'wildcard. we don't support complex patterns, just the *
		          If Left(path, URL.Len) = URL Then
		            Return True 'We're blocked!
		          End If
		        Next
		      End If
		    Next
		  Next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ScreenFromXY(X As Integer, Y As Integer) As Integer
		  'Given X and Y screen coordinates, the following method returns the index of the containing Screen
		  'If the coordinates are not contained in any screen, returns -1
		  
		  Dim rect As New REALbasic.Rect
		  Dim pt As New REALbasic.Point
		  pt.X = X
		  pt.Y = Y
		  For i As Integer = 0 To ScreenCount - 1
		    rect.Top = Screen(i).Top
		    rect.Left = Screen(i).Left
		    rect.Width = Screen(i).Width
		    rect.Height = Screen(i).Height
		    If rect.Contains(pt) Then
		      Return i
		    End If
		  Next
		  
		  Return -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SFSCount(Key As String, Value As String) As Integer
		  //Queries the StopForumSpam API
		  Dim h As New HTTPSocket
		  Dim URL As String = "http://www.stopforumspam.com/api?" + key + "=" + Value
		  Dim result As String = h.Get(URL, 5)
		  result = NthField(result, "<frequency>", 2)
		  result = NthField(result, "</frequency>", 1)
		  Return Val(result.Trim)
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
		Attributes( deprecated = "realbasic.encodehex" )  Function StringToHex(src as string) As string
		  'Deprecated; REALbasic.EncodeHex has been included with RS since 2010r3
		  'Hexify a string of binary data, e.g. from RB's built-in MD5 function
		  
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
		  //Like `String.Split(" ")` but honoring quotes; good for command line arguments and other parsing.
		  //For example, this string:
		  '                     MyApp.exe --foo "C:\My Dir\"
		  //Would become:
		  '                     s(0) = MyApp.exe
		  '                     s(1) = --foo
		  '                     s(2) = "C:\My Dir\"
		  
		  #If TargetWin32 Then
		    Dim ret() As String
		    Dim cmdLine As String = Input
		    While cmdLine.Len > 0
		      Dim tmp As String
		      Dim args As String = PathGetArgs(cmdLine)
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
		    
		    Static mb As New MemoryBlock(16)
		    Call UuidCreate(mb) //can compare to RPC_S_UUID_LOCAL_ONLY and RPC_S_UUID_NO_ADDRESS for more info
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
		    Soft Declare Sub uuid_unparse_upper Lib "libuuid"(mb As Ptr, uu As Ptr)
		    
		    If System.IsFunctionAvailable("uuid_generate", "libuuid") Then
		      Static mb As New MemoryBlock( 16 )
		      Static uu As New MemoryBlock( 36 )
		      
		      uuid_generate(mb) // generate the uuid in binary form
		      uuid_unparse_upper(mb, uu) // convert to a 36-byte string
		      
		      strUUID = uu.StringValue(0, 36)
		    Else
		      Dim error As String = App.ExecutableFile.Name + ": expected libuuid!"
		      #If TargetHasGUI Then
		        System.DebugLog(error)
		      #Else
		        StdErr.Write(error)
		      #endif
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
