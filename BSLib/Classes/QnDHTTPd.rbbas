#tag Class
Protected Class QnDHTTPd
Inherits TCPSocket
	#tag Event
		Sub DataAvailable()
		  Dim data As MemoryBlock = Me.ReadAll
		  Dim response, line, verb, httppath, postcontent As String
		  Dim httpver As Single
		  line = NthField(data, CRLF, 1)
		  data = Replace(data, line + CRLF, "")
		  postcontent = NthField(data, CRLF + CRLF, 2)
		  data = Replace(data, postcontent, "")
		  QueryHeaders = ParseRawHeaders(data)
		  
		  verb = NthField(line, " ", 1).Trim
		  httppath = NthField(line, " ", 2).Trim
		  httpver = CDbl(Replace(NthField(line, " ", 3).Trim, "HTTP/", ""))
		  response = DefaultRequestHandler(verb, httppath, httpver, postcontent)
		  
		  
		  If response.Trim <> "" Then
		    Me.DoResponse(response)
		    Me.Flush
		  End If
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Error()
		  Me.Log("Socket Error: " + Str(Me.LastErrorCode), Severity_Caution)
		  Me.Close()
		  RaiseEvent Error()
		End Sub
	#tag EndEvent

	#tag Event
		Sub SendComplete(userAborted as Boolean)
		  #pragma Unused userAborted
		  If LastHTTPCode <> 302 Then
		    Me.Close
		    Me.Log("Connection closed.", Severity_Debug)
		  End If
		  Done(Me.LastHTTPCode)
		  If KeepListening Then
		    Me.Listen
		  End If
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h1
		Protected Shared Function Acceptable(MIMEType As String, RequestHeaders As InternetHeaders) As Boolean
		  'Returns true if the passed MIMEType is listed as acceptable in the passed headers.
		  For i As Integer = 0 To RequestHeaders.Count - 1
		    If RequestHeaders.Name(i) = "Accept" Then
		      Dim acceptable() As String = Split(RequestHeaders.Value("Accept"), ",")
		      For Each type As String In acceptable
		        type = type.Trim
		        If Left(type, MIMEType.Len) = MIMEType Or Left(type, Len("*/*")) = "*/*" Then
		          Return True
		        End If
		      Next
		    End If
		  Next
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(File As FolderItem)
		  Super.Constructor
		  Page = file
		  Me.Log("Server Ready.", Severity_Debug)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function CRLF() As String
		  Return EndOfLine.Windows
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DefaultRequestHandler(HTTPVerb As String, HTTPPath As String, HTTPVersion As Single, PostContent As String) As String
		  Dim tamper As InternetHeaders = ParseRawHeaders(QueryHeaders.Source)
		  If TamperRequestHeaders(tamper) Then
		    'first chance tampering by subclasses
		    Log("Tampering with inbound headers", Severity_Debug)
		    QueryHeaders = tamper
		  End If
		  Me.Log(HTTPVerb + " " + HTTPPath + " HTTP/" + Format(HTTPVersion, "0.0") + EndOfLine + QueryHeaders.Source)
		  
		  Dim HTTPreply, pagedata As String
		  If HTTPVersion < 1.0 Or HTTPVersion >= 1.11 Then
		    DoError(505, Format(HTTPVersion, "0.0"))
		    Return ""
		  End If
		  
		  If Me.Authenticate Then
		    'Basic HTTP Authenticatation
		    Me.Log("Checking authorization.", Severity_Debug)
		    Dim pw As String = GetHeader(QueryHeaders, "Authorization")
		    pw = pw.Replace("Basic ", "")
		    Dim realm As String
		    If Not CheckAuthentication(pw, realm) Then
		      'HTTP 401 Unauthorized.
		      Me.Log("Authentication failed.", Severity_Caution)
		      pagedata = ErrorPage(401)
		      HTTPreply = HTTPResponse(401) + CRLF
		      ReplyHeaders = ResponseHeaders(pagedata.LenB, MIMEstring("error.html"))
		      mLastHTTPCode = 401
		      ReplyHeaders.AppendHeader("WWW-Authenticate", "Basic realm=""" + Realm + """")
		      GoTo Reply
		    Else
		      Me.Log("Authentication succeeded.", Severity_Debug)
		    End If
		  End If
		  
		  
		  'Offer to let the HandleRequest event process the request
		  Dim mime As String = MIMEstring("index.html")
		  Dim code As Integer = 200
		  Me.Log("Offering first-chance to subclass.", Severity_Debug)
		  
		  pagedata = HandleRequest(HTTPVerb, PostContent, HTTPPath, QueryHeaders, HTTPVersion, mime, code)
		  If pagedata.Trim <> "" Then
		    Me.Log("Subclass handled request.", Severity_Debug)
		    HTTPreply = HTTPResponse(Code) + CRLF
		    ReplyHeaders = ResponseHeaders(pagedata.LenB, mime)
		    ReplyHeaders.AppendHeader("Last-Modified", HTTPDate(New Date))
		    mLastHTTPCode = code
		    GoTo Reply
		  End If
		  'Carry on
		  
		  Me.Log("Running default handler.", Severity_Debug)
		  Select Case HTTPVerb
		  Case "GET", "HEAD"
		    'They want something, find out what
		    Dim request As String = URLDecode(HTTPPath)
		    Dim f As FolderItem = FindItem(request)
		    
		    'glitchy
		    'If HasHeader(QueryHeaders, "If-Modified-Since") Then
		    'Dim d As Date = HTTPDate(GetHeader(QueryHeaders, "If-Modified-Since"))
		    'If d <> Nil Then
		    'If f.ModificationDate.TotalSeconds < d.TotalSeconds Then
		    ''HTTP 304 Not modified
		    'DoError(304, HTTPPath)
		    'Return ""
		    'End If
		    'End If
		    'End If
		    
		    
		    If f = Nil Or Not f.Exists Then
		      'HTTP 404 Not found
		      DoError(404, HTTPPath)
		      Return ""
		    End If
		    
		    'Do we have what they want?
		    If f.Directory Then
		      If AllowDirectoryIndexPages Then
		        'Send an HTML directory index
		        pagedata = DirectoryIndex(request, f)
		        HTTPreply = HTTPResponse(200) + CRLF
		        ReplyHeaders = ResponseHeaders(pagedata.LenB, MIMEstring("index.html"))
		        ReplyHeaders.AppendHeader("Last-Modified", HTTPDate(f.ModificationDate))
		        mLastHTTPCode = 200
		      Else
		        DoError(403, HTTPPath)
		        Return ""
		      End If
		      
		    ElseIf request = "/" Then
		      'they want the root item but it's not a directory
		      'We'll send a 302 redirect from "/" to "/" + f.name
		      Me.Log("Redirect(302) index to single page.", Severity_Debug)
		      ReplyHeaders = ResponseHeaders()
		      'ReplyHeaders.SetHeader("Connection", "Keep-Alive")
		      Dim location As String = "http://" + Me.LocalAddress + ":" + Format(Me.Port, "######")
		      ReplyHeaders.AppendHeader("Location", location + "/" + f.Name)
		      pagedata = ""
		      HTTPreply = HTTPResponse(302) + CRLF
		      mLastHTTPCode = 302
		      
		    Else
		      'they want a file other than the root item or a directory
		      Dim bs As BinaryStream
		      Dim start, stop As UInt64
		      
		      If HasHeader(QueryHeaders, "Range") Then
		        'They want only a specific byte range
		        Dim range As String = GetHeader(QueryHeaders, "Range")
		        start = Val(NthField(range, "-", 1).Trim)
		        stop = Val(NthField(range, "-", 2).Trim)
		        If start < 0 Or stop > f.Length Then
		          'HTTP 416 Requested Range Not Satisfiable
		          DoError(416, "")
		          Return ""
		        End If
		        'open the stream and set the position
		        bs = BinaryStream.Open(f)
		        bs.Position = start
		      Else
		        stop = f.length
		      End If
		      
		      If HTTPVerb = "GET" Then
		        'They want the file, not just headers
		        If bs = Nil Then bs = BinaryStream.Open(f)
		        bs = BinaryStream.Open(f)
		        pagedata = bs.Read(stop - start)
		        bs.Close
		      End If
		      
		      HTTPreply = HTTPResponse(200) + CRLF 'HTTP 200 OK
		      ReplyHeaders = ResponseHeaders(stop - start, MIMEstring(f.Name))
		      ReplyHeaders.AppendHeader("Last-Modified", HTTPDate(f.ModificationDate))
		      mLastHTTPCode = 200
		      
		    End If
		    
		    
		  Case "POST", "PUT", "DELETE", "TRACE", "OPTIONS", "CONNECT", "PATCH"
		    'HTTP 405 Method Not Allowed
		    ReplyHeaders.AppendHeader("Allow", "GET, HEAD")
		    DoError(405, HTTPVerb)
		    Return ""
		  Else
		    'HTTP 400 Bad request
		    DoError(400, HTTPVerb)
		    Return ""
		  End Select
		  
		  
		  
		  'Send the reply
		  Reply:
		  
		  #If GZIPAvailable Then
		    'If GZIPAvailable and the browser asked for GZip then we use GZip to compress the pagedata
		    'Using GZip will reduce bandwidth, but can impact response times and resource usage.
		    Me.Log("GZip is available.", Severity_Debug)
		    Dim h As String = GetHeader(QueryHeaders, "Accept-Encoding")
		    Dim codings() As String = Split(h, ",")
		    If codings.IndexOf("gzip") >= 0 Then
		      ReplyHeaders.SetHeader("Content-Encoding", "gzip")
		      Me.Log("GZip is Acceptable.", Severity_Debug)
		      ReplyHeaders.AppendHeader("X-Original-Length", Str(pagedata.LenB))
		      Dim gz As String
		      Try
		        gz = GZipPage(Replace(PageData, "%PAGEGZIPSTATUS%", "Compressed with GZip " + GZip.Version))
		        pagedata = gz
		      Catch Error
		        'Just send the uncompressed data
		        ReplyHeaders.SetHeader("Content-Encoding", "Identity")
		      End Try
		      ReplyHeaders.SetHeader("Content-Length", Str(pagedata.LenB))
		    End If
		  #else
		    PageData = Replace(PageData, "%PAGEGZIPSTATUS%", "No compression.")
		  #endif
		  
		  Dim tamperMIME As String = GetHeader(ReplyHeaders,"Content-Type")
		  If Not Acceptable(tamperMIME, QueryHeaders) And HasHeader(QueryHeaders, "Accept") Then
		    Me.Log(HTTPResponse(406), Severity_Caution)
		    HTTPreply = HTTPResponse(406) + CRLF 'HTTP 406 Not acceptable
		    pagedata = ErrorPage(406)
		    ReplyHeaders = ResponseHeaders(pagedata.LenB, MIMEstring("*.html"))
		    mLastHTTPCode = 406
		  End If
		  
		  Dim response As String = HTTPreply + ReplyHeaders.Source + CRLF + CRLF + pagedata
		  If LenB(response) > 2^26 Then
		    'Technically, this is the wrong response. But it's close enough
		    'HTTP 507 Insufficient Storage
		    HTTPreply = HTTPResponse(507) + CRLF
		    ReplyHeaders = ResponseHeaders()
		    pagedata = ErrorPage(507)
		    Me.Log(HTTPResponse(507), Severity_Caution)
		    mLastHTTPCode = 507
		    response = HTTPreply + ReplyHeaders.Source + CRLF + CRLF + pagedata
		  End If
		  
		  tamper = ParseRawHeaders(Me.ReplyHeaders.Source)
		  If TamperResponseHeaders(tamper) Then
		    'last chance tampering by subclasses
		    Log("Tampering with outbound headers", Severity_Debug)
		    Me.ReplyHeaders = tamper
		  End If
		  
		  'Return the raw response
		  Me.Log("Default handler has completed.", Severity_Debug)
		  Return HTTPreply + ReplyHeaders.Source + CRLF + CRLF + pagedata
		  
		  
		Exception Err
		  If Err IsA EndException Or Err IsA ThreadEndException Then Raise Err
		  'Return an HTTP 500 Internal Server Error page.
		  Dim errpage As String
		  Me.Log(HTTPResponse(500), Severity_Caution)
		  #If DebugBuild Or VerboseErrors Then
		    #If VerboseErrors Then
		      #pragma Warning "Verbose errors are on."
		    #endif
		    
		    Dim stack As String
		    If UBound(Err.Stack) <= -1 Then
		      stack = "<br />(empty)<br />"
		    Else
		      stack = Join(Err.Stack, "<br />")
		    End If
		    Dim msg As String = "<img src=""" + SadMan + """ align=""top""/><b>Exception<b>: " + _
		    Introspection.GetType(Err).FullName + "<br />Error Number: " + Str(Err.ErrorNumber) + "<br />Message: " + Err.Message + EndOfLine
		    errpage = ErrorPage(500, msg + "<br />Stack follows:<blockquote>" + stack + "</blockquote>")
		  #else
		    errpage = ErrorPage(500)
		  #endif
		  
		  ReplyHeaders = ResponseHeaders(errpage.LenB, MIMEstring("*.html"))
		  mLastHTTPCode = 500
		  Return HTTPResponse(500) + CRLF + ReplyHeaders.Source + CRLF + CRLF + errpage
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function DirectoryIndex(serverpath As String, f As FolderItem) As String
		  Dim timestart, timestop As UInt64
		  Dim PageData As String
		  Dim i As Integer
		  Const pagetop = "<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Transitional//EN"" ""http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd""><html xmlns=""http://www.w3.org/1999/xhtml""><meta http-equiv=""Content-Type"" content=""text/html; charset=iso-8859-1"" /><head><title>Index of %FILENAME%</title></head><body link=""#0000FF"" vlink=""#004080"" alink=""#FF0000""><h1>Index of %FILENAME%</h1><h2>%INDEXCOUNT% item(s) found. </h2>"
		  Const TableHead = "<Table cellpadding=5 width=""90%""><TR><TD>&nbsp;</TD><TD>Name</TD><TD>Last modified</TD><TD>Size</TD><TD>Description</TD>%UPDIR%"
		  Const TableRow = "<TR bgcolor=%ROWCOLOR%><TD><img src=""%FILEICON%"" width=22 height=22 /></TD><TD><a href=""%FILEPATH%"">%FILENAME%</a></TD><TD>%FILEDATE%</TD><TD>%FILESIZE%</TD><TD>%FILETYPE%</TD></TR>"
		  Const pageend = "</Table><hr><p><small>Powered by: %DAEMON%<br >%TIMESTAMP% %PAGEGZIPSTATUS%</small></p></body></html>"
		  
		  timeStart = Microseconds
		  If f.Directory Then
		    PageData = ReplaceAll(pagetop, "%FILENAME%", serverpath) + ReplaceAll(TableHead , "%UPICON%", MIMEIcon_Back)
		    Dim parentpath As String = serverpath
		    If Right(parentpath, 1) = "/" Then parentpath = Left(parentpath, parentpath.Len - 1)
		    parentpath = NthField(parentpath, "/", CountFields(parentpath, "/"))
		    parentpath = Replace(serverpath, parentpath, "")
		    parentpath = ReplaceAll(parentpath, "//", "/")
		    If serverpath <> "/" Then
		      PageData = ReplaceAll(PageData, "%UPDIR%", "<img src=""" + MIMEIcon_Back + """ width=22 height=22 /><a href=""" + parentpath + """>Parent Directory</a>")
		    Else
		      PageData = ReplaceAll(PageData, "%UPDIR%", "")
		    End If
		    i = 1
		    While i <= f.Count
		      Dim line As String
		      Dim name, href, icon As String
		      name = f.TrueItem(i).Name
		      href = URLEncode(ReplaceAll(ServerPath + "/" + name, "//", "/"))
		      While Name.len > 40
		        Dim start As Integer
		        Dim snip As String
		        start = Name.Len / 3
		        snip = mid(Name, start, 5)
		        Name = Replace(Name, snip, "...")
		      Wend
		      
		      line = TableRow
		      line = ReplaceAll(line, "%FILENAME%", URLDecode(name))
		      line = ReplaceAll(line, "%FILEPATH%", href)
		      line = ReplaceAll(line, "%FILEDATE%", HTTPDate(f.TrueItem(i).ModificationDate))
		      if f.TrueItem(i).Directory Then
		        icon = MIMEIcon("folder")
		        line = ReplaceAll(line, "%FILESIZE%", " - ")
		        line = ReplaceAll(line, "%FILETYPE%", "Directory")
		      Else
		        icon = MIMEIcon(NthField(name, ".", CountFields(name, ".")))
		        line = ReplaceAll(line, "%FILESIZE%", FormatBytes(f.TrueItem(i).Length))
		        line = ReplaceAll(line, "%FILETYPE%", MIMEstring(f.TrueItem(i).Name))
		      End if
		      line = ReplaceAll(line, "%FILEICON%", icon)
		      If i Mod 2 = 0 Then
		        line = ReplaceAll(line, "%ROWCOLOR%", "#C0C0C0")
		      Else
		        line = ReplaceAll(line, "%ROWCOLOR%", "#A7A7A7")
		      End If
		      
		      PageData = PageData + line + EndOfLine
		      i = i + 1
		    Wend
		    
		    PageData = ReplaceAll(PageData, "%INDEXCOUNT%", Format(i - 1, "###,###,##0"))
		    PageData = PageData + ReplaceAll(pageend, "%DAEMON%", DaemonVersion)
		  Else
		    PageData = "Not a Directory"
		    
		  End If
		  timestop = Microseconds
		  timestart = timestop - timestart
		  Dim timestamp As String = "This page was generated in " + Format(timestart / 1000, "###,##0.0#") + "ms. <br />"
		  PageData = Replace(PageData, "%TIMESTAMP%", timestamp)
		  
		  Return PageData
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DoError(Code As Integer, Param As String)
		  Dim pagedata As String = ErrorPage(Code, param)
		  mLastHTTPCode = Code
		  Me.ReplyHeaders = ResponseHeaders(pagedata.LenB, MIMEstring("error.html"))
		  Dim tamper As InternetHeaders = ParseRawHeaders(Me.ReplyHeaders.Source)
		  If TamperResponseHeaders(tamper) Then
		    'last chance tampering by subclasses
		    Log("Tampering with outbound headers", Severity_Debug)
		    Me.ReplyHeaders = tamper
		  End If
		  pagedata = HTTPResponse(404) + CRLF + ReplyHeaders.Source + CRLF + CRLF + pagedata
		  Me.Log(HTTPResponse(Code), Severity_Caution)
		  DoResponse(pagedata)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DoResponse(PageData As String)
		  Me.Log(HTTPResponse(Me.LastHTTPCode) + EndOfLine + ReplyHeaders.Source)
		  Me.Write(PageData)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ErrorPage(ErrorNumber As Integer, Param As String = "") As String
		  Dim page As String = BlankErrorPage
		  page = ReplaceAll(page, "%HTTPERROR%", HTTPResponse(ErrorNumber))
		  
		  Select Case ErrorNumber
		  Case 400
		    page = ReplaceAll(page, "%DOCUMENT%", "The server  did not understand your request.")
		    
		  Case 403, 401
		    page = ReplaceAll(page, "%DOCUMENT%", "Permission to access '" + Param + "' is denied.")
		    
		  Case 404
		    page = ReplaceAll(page, "%DOCUMENT%", "The requested file, '" + Param + "', was not found on this server. ")
		    
		  Case 406
		    page = ReplaceAll(page, "%DOCUMENT%", "Your browser did not specify an acceptable Content-Type that was compatible with the data requested.")
		    
		  Case 410
		    page = ReplaceAll(page, "%DOCUMENT%", "The requested file, '" + Param + "', is no longer available.")
		    
		  Case 418
		    page = ReplaceAll(page, "%DOCUMENT%", "I'm a little teapot, short and stout; here is my handle, here is my spout.")
		    
		  Case 451
		    page = ReplaceAll(page, "%DOCUMENT%", "The requested file, '" + Param + "', is unavailable for legal reasons.")
		    
		  Case 500
		    page = ReplaceAll(page, "%DOCUMENT%", "An error ocurred while processing your request. We apologize for any inconvenience. </p><p>" + Param + "</p>")
		    
		  Case 501
		    page = ReplaceAll(page, "%DOCUMENT%", "Your browser has made a request  (verb: '" + Param + "') of this server which, while valid, is not implemented by this server.")
		    
		  Case 505
		    page = ReplaceAll(page, "%DOCUMENT%", "Your browser is using an HTTP version (" + Param + ") that is not supported by this server. This server supports HTTP 1.0 and HTTP 1.1.")
		    
		  Else
		    page = ReplaceAll(page, "%DOCUMENT%", "An HTTP error of the type specified above has occurred. No further information is available.")
		  End Select
		  
		  page = ReplaceAll(page, "%SIGNATURE%", "<em>Powered By " + DaemonVersion + "</em><br />")
		  
		  page = page + "<!--"
		  Do
		    page = page + " padding to make IE happy. "
		  Loop Until page.LenB >= 512
		  page = page + "-->"
		  
		  
		  Return Page
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FindItem(Path As String) As FolderItem
		  Dim s As String
		  Path = Path.ReplaceAll("/", "\")
		  
		  If Not Page.Directory And "\" + Page.Name = path Then
		    Me.Log("Request found at page/root.", Severity_Debug)
		    Return Page
		  End If
		  
		  s = ReplaceAll(Page.AbsolutePath + Path, "\\", "\")
		  Me.Log("Found: " + s, Severity_Debug)
		  Return GetTrueFolderItem(s, FolderItem.PathTypeAbsolute)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function FormatBytes(bytes As UInt64, precision As Integer = 2) As String
		  'Converts raw byte counts into SI formatted strings. 1KB = 1024 bytes.
		  'Optionally pass an integer representing the number of decimal places to return. The default is two decimal places. You may specify
		  'between 0 and 16 decimal places. Specifying more than 16 will append extra zeros to make up the length. Passing 0
		  'shows no decimal places and no decimal point.
		  
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
		  
		  Return Format(strBytes, "#,###0" + precisionZeros) + suffix
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetCookies(Headers As InternetHeaders) As String()
		  'Returns a string array of all HTTP cookies in the passed headers
		  Dim cookies() As String
		  Dim head As String = GetHeader(Headers, "Cookie")
		  Dim c() As String = Split(head, ";")
		  For Each cook As String In c
		    cookies.Append(cook.Trim)
		  Next
		  
		  Return cookies
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetHeader(Headers As InternetHeaders, Headername As String) As String
		  'Returns a string array of all HTTP cookies in the passed headers
		  For i As Integer = 0 To Headers.Count - 1
		    If Headers.Name(i) = headername Then
		      Return Headers.Value(i)
		    End If
		  Next
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function GZipPage(PageData As String) As String
		  'This function requires the GZip plugin available at http://sourceforge.net/projects/realbasicgzip/
		  'Returns the passed PageData after being compressed. If GZIPAvailable = false, returns the original PageData unchanged.
		  #If GZipAvailable Then'
		    Dim size As Single = PageData.LenB
		    If size > 2^26 Then Return PageData 'if bigger than 64MB, don't try compressing it.
		    System.DebugLog(App.ExecutableFile.Name + ": About to GZip data. Size: " + FormatBytes(size))
		    PageData = GZip.Compress(PageData)
		    size = PageData.LenB * 100 / size
		    System.DebugLog(App.ExecutableFile.Name + ": GZip done. New size: " + FormatBytes(PageData.LenB) + " (" + Format(size, "##0.0##\%") + " of original.)")
		    If GZip.Error <> 0 Then
		      Dim err As New RuntimeException
		      err.Message = "GZip error."
		      err.ErrorNumber = GZip.Error
		      Raise err
		    End If
		    Dim mb As New MemoryBlock(PageData.LenB + 8)
		    'magic
		    mb.Byte(0) = &h1F
		    mb.Byte(1) = &h8B
		    mb.Byte(2) = &h08
		    mb.StringValue(8, PageData.LenB) = PageData
		    Return mb
		  #Else
		    'QnDHTTPd.GZIPAvailable must be set to True and the GZip plugin must be installed.
		    #pragma Warning "The GZip Plugin is not available or has been disabled."
		    Return PageData
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function HasHeader(Headers As InternetHeaders, HeaderName As String) As Boolean
		  For i As Integer = 0 To Headers.Count - 1
		    If Headers.Name(i) = HeaderName Then Return True
		  Next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function HTTPDate(d As Date) As String
		  Dim dt As String
		  d.GMTOffset = 0
		  Select Case d.DayOfWeek
		  Case 1
		    dt = dt + "Sun, "
		  Case 2
		    dt = dt + "Mon, "
		  Case 3
		    dt = dt + "Tue, "
		  Case 4
		    dt = dt + "Wed, "
		  Case 5
		    dt = dt + "Thu, "
		  Case 6
		    dt = dt + "Fri, "
		  Case 7
		    dt = dt + "Sat, "
		  End Select
		  
		  dt = dt  + Format(d.Day, "00") + " "
		  
		  Select Case d.Month
		  Case 1
		    dt = dt + "Jan "
		  Case 2
		    dt = dt + "Feb "
		  Case 3
		    dt = dt + "Mar "
		  Case 4
		    dt = dt + "Apr "
		  Case 5
		    dt = dt + "May "
		  Case 6
		    dt = dt + "Jun "
		  Case 7
		    dt = dt + "Jul "
		  Case 8
		    dt = dt + "Aug "
		  Case 9
		    dt = dt + "Sep "
		  Case 10
		    dt = dt + "Oct "
		  Case 11
		    dt = dt + "Nov "
		  Case 12
		    dt = dt + "Dec "
		  End Select
		  
		  dt = dt  + Format(d.Year, "0000") + " " + Format(d.Hour, "00") + ":" + Format(d.Minute, "00") + ":" + Format(d.Second, "00") + " GMT"
		  Return dt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function HTTPDate(Data As String) As Date
		  
		  'Sat, 29 Oct 1994 19:43:31 GMT
		  
		  Dim d As Date
		  Dim members() As String = Split(Data, " ")
		  If UBound(members) = 5 Then
		    Dim dom, mon, year, h, m, s, tz As Integer
		    
		    dom = Val(members(1))
		    
		    Select Case members(2)
		    Case "Jan"
		      mon = 1
		    Case "Feb"
		      mon = 2
		    Case "Mar"
		      mon = 3
		    Case "Apr"
		      mon = 4
		    Case "May"
		      mon = 5
		    Case "Jun"
		      mon = 6
		    Case "Jul"
		      mon = 7
		    Case "Aug"
		      mon = 8
		    Case "Sep"
		      mon = 9
		    Case "Oct"
		      mon = 10
		    Case "Nov"
		      mon = 11
		    Case "Dec"
		      mon = 12
		    End Select
		    
		    year = Val(members(3))
		    
		    Dim time As String = members(4)
		    h = Val(NthField(time, ":", 1))
		    m = Val(NthField(time, ":", 2))
		    s = Val(NthField(time, ":", 3))
		    tz = Val(members(5))
		    
		    
		    
		    d = New Date(year, mon, dom, h, m, s, tz)
		  End If
		  Return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function HTTPResponse(Code As Integer) As String
		  'Returns the properly formatted HTTP response line for a given HTTP status code.
		  'e.g. HTTPResponse(404) = "HTTP/1.1 404 Not Found"
		  
		  Dim msg As String
		  
		  Select Case Code
		  Case 100
		    msg = "Continue"
		    
		  Case 101
		    msg = "Switching Protocols"
		    
		  Case 102
		    msg = "Processing"
		    
		  Case 200
		    msg = "OK"
		    
		  Case 201
		    msg = "Created"
		    
		  Case 202
		    msg = "Accepted"
		    
		  Case 203
		    msg = "Non-Authoritative Information"
		    
		  Case 204
		    msg = "No Content"
		    
		  Case 205
		    msg = "Reset Content"
		    
		  Case 206
		    msg = "Partial Content"
		    
		  Case 207
		    msg = "Multi-Status"
		    
		  Case 208
		    msg = "Already Reported"
		    
		    
		  Case 226
		    msg = "IM Used"
		    
		  Case 300
		    msg = "Multiple Choices"
		    
		  Case 301
		    msg = "Moved Permanently"
		    
		  Case 302
		    msg = "Found"
		    
		  Case 303
		    msg = "See Other"
		    
		  Case 304
		    msg = "Not Modified"
		    
		  Case 305
		    msg = "Use Proxy"
		    
		  Case 306
		    msg = "Switch Proxy"
		    
		  Case 307
		    msg = "Temporary Redirect"
		    
		  Case 308 ' https://tools.ietf.org/html/draft-reschke-http-status-308-07
		    msg = "Permanent Redirect"
		    
		  Case 400
		    msg = "Bad Request"
		    
		  Case 401
		    msg = "Unauthorized"
		    
		  Case 403
		    msg = "Forbidden"
		    
		  Case 404
		    msg = "Not Found"
		    
		  Case 405
		    msg = "Method Not Allowed"
		    
		  Case 406
		    msg = "Not Acceptable"
		    
		  Case 407
		    msg = "Proxy Authentication Required"
		    
		  Case 408
		    msg = "Request Timeout"
		    
		  Case 409
		    msg = "Conflict"
		    
		  Case 410
		    msg = "Gone"
		    
		  Case 411
		    msg = "Length Required"
		    
		  Case 412
		    msg = "Precondition Failed"
		    
		  Case 413
		    msg = "Request Entity Too Large"
		    
		  Case 414
		    msg = "Request-URI Too Long"
		    
		  Case 415
		    msg = "Unsupported Media Type"
		    
		  Case 416
		    msg = "Requested Range Not Satisfiable"
		    
		  Case 417
		    msg = "Expectation Failed"
		    
		  Case 418
		    msg = "I'm a teapot" ' https://tools.ietf.org/html/rfc2324
		    
		  Case 420
		    msg = "Enhance Your Calm" 'Nonstandard, from Twitter API
		    
		  Case 422
		    msg = "Unprocessable Entity"
		    
		  Case 423
		    msg = "Locked"
		    
		  Case 424
		    msg = "Failed Dependency"
		    
		  Case 425
		    msg = "Unordered Collection" 'Draft, https://tools.ietf.org/html/rfc3648
		    
		  Case 426
		    msg = "Upgrade Required"
		    
		  Case 428
		    msg = "Precondition Required"
		    
		  Case 429
		    msg = "Too Many Requests"
		    
		  Case 431
		    msg = "Request Header Fields Too Large"
		    
		  Case 444
		    msg = "No Response" 'Nginx
		    
		  Case 449
		    msg = "Retry With" 'Nonstandard, from Microsoft http://msdn.microsoft.com/en-us/library/dd891478.aspx
		    
		  Case 450
		    msg = "Blocked By Windows Parental Controls" 'Nonstandard, from Microsoft
		    
		  Case 451
		    msg = "Unavailable For Legal Reasons" 'Draft, https://tools.ietf.org/html/draft-tbray-http-legally-restricted-status-00
		    
		  Case 494
		    msg = "Request Header Too Large" 'nginx
		    
		  Case 495
		    msg = "Cert Error" 'nginx
		    
		  Case 496
		    msg = "No Cert" 'nginx
		    
		  Case 497
		    msg = "HTTP to HTTPS" 'nginx
		    
		  Case 499
		    msg = "Client Closed Request" 'nginx
		    
		  Case 500
		    msg = "Internal Server Error"
		    
		  Case 501
		    msg = "Not Implemented"
		    
		  Case 502
		    msg = "Bad Gateway"
		    
		  Case 503
		    msg = "Service Unavailable"
		    
		  Case 504
		    msg = "Gateway Timeout"
		    
		  Case 505
		    msg = "HTTP Version Not Supported"
		    
		  Case 506
		    msg = "Variant Also Negotiates" 'WEBDAV https://tools.ietf.org/html/rfc2295
		    
		  Case 507
		    msg = "Insufficient Storage" 'WEBDAV https://tools.ietf.org/html/rfc4918
		    
		  Case 508
		    msg = "Loop Detected" 'WEBDAV https://tools.ietf.org/html/rfc5842
		    
		  Case 509
		    msg = "Bandwidth Limit Exceeded" 'Apache, others
		    
		  Case 510
		    msg = "Not Extended"  'https://tools.ietf.org/html/rfc2774
		    
		  Case 511
		    msg = "Network Authentication Required" 'https://tools.ietf.org/html/rfc6585
		    
		  Else
		    msg = "Unknown Status Code"
		  End Select
		  
		  
		  
		  
		  Return "HTTP/1.1 " + Str(Code) + " " + msg
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Listen()
		  Super.Listen()
		  Me.Log("Listening on " + Me.LocalAddress + ":" + Str(Me.Port), Severity_Debug)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Log(Line As String, Severity As Integer = Severity_Normal)
		  If Severity >= LogLevel Then
		    Dim d As New Date
		    Dim timestamp As String = HTTPDate(d)
		    line = "(" + timestamp + ") " + EndOfLine + Line + EndOfLine
		    If Me.Logstream <> Nil Then
		      Me.Logstream.Write(Line)
		    End If
		    #If TargetHasGUI Then
		      System.DebugLog(App.ExecutableFile.Name + ": " + Line)
		    #Else
		      Print(Line)
		    #endif
		    RaiseEvent Log(Line)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function MIMEIcon(ext As String) As String
		  'This method is from here: https://github.com/bskrtich/RBHTTPServer
		  ext = Lowercase(ext)
		  
		  Select Case ext
		  Case "exe", "com", "scr", "pif", "dll", "deb", "rpm"
		    Return MIMEIcon_Binary
		    
		  Case "js", "cs", "c", "h", "vbs", "vbe", "bat", "cmd", "sh", "ini", "reg"
		    Return MIMEIcon_Script
		    
		  Case "rbp", "rbbas", "rbvcp", "rbfrm", "rbres"
		    Return MIMEIcon_RBP
		    
		  Case "back"
		    Return MIMEIcon_Back
		    
		  Case "folder"
		    Return MIMEIcon_Folder
		    
		  Case "txt", "md"
		    Return MIMEIcon_Text
		    
		  Case "htm", "html"
		    Return MIMEIcon_HTML
		    
		  Case "css"
		    Return MIMEIcon_CSS
		    
		  Case "xml", "xsl"
		    Return MIMEIcon_XML
		    
		  Case "jpg", "jpeg", "png", "bmp", "gif", "tif"
		    Return MIMEIcon_Image
		    
		  Case "mov", "mp4", "m4v", "avi", "mpg", "mpeg", "wmv", "mkv"
		    Return MIMEIcon_Movie
		    
		  Case "ttf", "otf", "pfb", "pfm"
		    Return MIMEIcon_Font
		    
		  Case "zip", "tar", "rar", "7zip", "bzip", "gzip", "7z", "tgz", "gz", "z"
		    Return MIMEIcon_Compressed
		    
		  Case "wav"
		    Return MIMEIcon_WAV
		    
		  Case "mp3", "m4a", "m4b", "m4p", "ogg", "flac"
		    Return MIMEIcon_Music
		    
		  Case "pdf", "ps"
		    Return MIMEIcon_PDF
		    
		  Case "xls", "xlsx"
		    Return MIMEIcon_XLS
		    
		  Case "doc", "docx"
		    Return MIMEIcon_DOC
		    
		  Else ' This returns the default icon
		    Return MIMEIcon_Unknown
		    
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function MIMEstring(FileName As String) As String
		  'This method is from here: https://github.com/bskrtich/RBHTTPServer
		  Dim ext As String = NthField(FileName, ".", CountFields(FileName, "."))
		  
		  Select Case ext
		  Case "ez"
		    Return "application/andrew-inset"
		    
		  Case "aw"
		    Return "application/applixware"
		    
		  Case "atom"
		    Return "application/atom+xml"
		    
		  Case "atomcat"
		    Return "application/atomcat+xml"
		    
		  Case "atomsvc"
		    Return "application/atomsvc+xml"
		    
		  Case "ccxml"
		    Return "application/ccxml+xml"
		    
		  Case "cdmia"
		    Return "application/cdmi-capability"
		    
		  Case "cdmic"
		    Return "application/cdmi-container"
		    
		  Case "cdmid"
		    Return "application/cdmi-domain"
		    
		  Case "cdmio"
		    Return "application/cdmi-object"
		    
		  Case "cdmiq"
		    Return "application/cdmi-queue"
		    
		  Case "cu"
		    Return "application/cu-seeme"
		    
		  Case "davmount"
		    Return "application/davmount+xml"
		    
		  Case "dssc"
		    Return "application/dssc+der"
		    
		  Case "xdssc"
		    Return "application/dssc+xml"
		    
		  Case "ecma"
		    Return "application/ecmascript"
		    
		  Case "emma"
		    Return "application/emma+xml"
		    
		  Case "epub"
		    Return "application/epub+zip"
		    
		  Case "exi"
		    Return "application/exi"
		    
		  Case "pfr"
		    Return "application/font-tdpfr"
		    
		  Case "stk"
		    Return "application/hyperstudio"
		    
		  Case "ipfix"
		    Return "application/ipfix"
		    
		  Case "jar"
		    Return "application/java-archive"
		    
		  Case "ser"
		    Return "application/java-serialized-object"
		    
		  Case "class"
		    Return "application/java-vm"
		    
		  Case "js"
		    Return "application/javascript"
		    
		  Case "json"
		    Return "application/json"
		    
		  Case "lostxml"
		    Return "application/lost+xml"
		    
		  Case "hqx"
		    Return "application/mac-binhex40"
		    
		  Case "cpt"
		    Return "application/mac-compactpro"
		    
		  Case "mads"
		    Return "application/mads+xml"
		    
		  Case "mrc"
		    Return "application/marc"
		    
		  Case "mrcx"
		    Return "application/marcxml+xml"
		    
		  Case "ma", "nb", "mb"
		    Return "application/mathematica"
		    
		  Case "mathml"
		    Return "application/mathml+xml"
		    
		  Case "mbox"
		    Return "application/mbox"
		    
		  Case "mscml"
		    Return "application/mediaservercontrol+xml"
		    
		  Case "meta4"
		    Return "application/metalink4+xml"
		    
		  Case "mets"
		    Return "application/mets+xml"
		    
		  Case "mods"
		    Return "application/mods+xml"
		    
		  Case "m21", "mp21"
		    Return "application/mp21"
		    
		  Case "mp4s"
		    Return "application/mp4"
		    
		  Case "doc", "dot"
		    Return "application/msword"
		    
		  Case "mxf"
		    Return "application/mxf"
		    
		  Case "bin", "dms", "lha", "lrf", "lzh", "so", "iso", "dmg", "dist", "distz", "pkg", "bpk", "dump", "elc", "deploy", "mobipocket-ebook"
		    Return "application/octet-stream"
		    
		  Case "oda"
		    Return "application/oda"
		    
		  Case "opf"
		    Return "application/oebps-package+xml"
		    
		  Case "ogx"
		    Return "application/ogg"
		    
		  Case "onetoc", "onetoc2", "onetmp", "onepkg"
		    Return "application/onenote"
		    
		  Case "xer"
		    Return "application/patch-ops-error+xml"
		    
		  Case "pdf"
		    Return "application/pdf"
		    
		  Case "pgp"
		    Return "application/pgp-encrypted"
		    
		  Case "asc", "sig"
		    Return "application/pgp-signature"
		    
		  Case "prf"
		    Return "application/pics-rules"
		    
		  Case "p10"
		    Return "application/pkcs10"
		    
		  Case "p7m", "p7c"
		    Return "application/pkcs7-mime"
		    
		  Case "p7s"
		    Return "application/pkcs7-signature"
		    
		  Case "p8"
		    Return "application/pkcs8"
		    
		  Case "ac"
		    Return "application/pkix-attr-cert"
		    
		  Case "cer"
		    Return "application/pkix-cert"
		    
		  Case "crl"
		    Return "application/pkix-crl"
		    
		  Case "pkipath"
		    Return "application/pkix-pkipath"
		    
		  Case "pki"
		    Return "application/pkixcmp"
		    
		  Case "pls"
		    Return "application/pls+xml"
		    
		  Case "ai", "eps", "ps"
		    Return "application/postscript"
		    
		  Case "cww"
		    Return "application/prs.cww"
		    
		  Case "pskcxml"
		    Return "application/pskc+xml"
		    
		  Case "rdf"
		    Return "application/rdf+xml"
		    
		  Case "rif"
		    Return "application/reginfo+xml"
		    
		  Case "rnc"
		    Return "application/relax-ng-compact-syntax"
		    
		  Case "rl"
		    Return "application/resource-lists+xml"
		    
		  Case "rld"
		    Return "application/resource-lists-diff+xml"
		    
		  Case "rs"
		    Return "application/rls-services+xml"
		    
		  Case "rsd"
		    Return "application/rsd+xml"
		    
		  Case "rss"
		    Return "application/rss+xml"
		    
		  Case "rtf"
		    Return "application/rtf"
		    
		  Case "sbml"
		    Return "application/sbml+xml"
		    
		  Case "scq"
		    Return "application/scvp-cv-request"
		    
		  Case "scs"
		    Return "application/scvp-cv-response"
		    
		  Case "spq"
		    Return "application/scvp-vp-request"
		    
		  Case "spp"
		    Return "application/scvp-vp-response"
		    
		  Case "sdp"
		    Return "application/sdp"
		    
		  Case "setpay"
		    Return "application/set-payment-initiation"
		    
		  Case "setreg"
		    Return "application/set-registration-initiation"
		    
		  Case "shf"
		    Return "application/shf+xml"
		    
		  Case "smi", "smil"
		    Return "application/smil+xml"
		    
		  Case "rq"
		    Return "application/sparql-query"
		    
		  Case "srx"
		    Return "application/sparql-results+xml"
		    
		  Case "gram"
		    Return "application/srgs"
		    
		  Case "grxml"
		    Return "application/srgs+xml"
		    
		  Case "sru"
		    Return "application/sru+xml"
		    
		  Case "ssml"
		    Return "application/ssml+xml"
		    
		  Case "tei", "teicorpus"
		    Return "application/tei+xml"
		    
		  Case "tfi"
		    Return "application/thraud+xml"
		    
		  Case "tsd"
		    Return "application/timestamped-data"
		    
		  Case "plb"
		    Return "application/vnd.3gpp.pic-bw-large"
		    
		  Case "psb"
		    Return "application/vnd.3gpp.pic-bw-small"
		    
		  Case "pvb"
		    Return "application/vnd.3gpp.pic-bw-var"
		    
		  Case "tcap"
		    Return "application/vnd.3gpp2.tcap"
		    
		  Case "pwn"
		    Return "application/vnd.3m.post-it-notes"
		    
		  Case "aso"
		    Return "application/vnd.accpac.simply.aso"
		    
		  Case "imp"
		    Return "application/vnd.accpac.simply.imp"
		    
		  Case "acu"
		    Return "application/vnd.acucobol"
		    
		  Case "atc", "acutc"
		    Return "application/vnd.acucorp"
		    
		  Case "air"
		    Return "application/vnd.adobe.air-application-installer-package+zip"
		    
		  Case "fxp", "fxpl"
		    Return "application/vnd.adobe.fxp"
		    
		  Case "xdp"
		    Return "application/vnd.adobe.xdp+xml"
		    
		  Case "xfdf"
		    Return "application/vnd.adobe.xfdf"
		    
		  Case "ahead"
		    Return "application/vnd.ahead.space"
		    
		  Case "azf"
		    Return "application/vnd.airzip.filesecure.azf"
		    
		  Case "azs"
		    Return "application/vnd.airzip.filesecure.azs"
		    
		  Case "azw"
		    Return "application/vnd.amazon.ebook"
		    
		  Case "acc"
		    Return "application/vnd.americandynamics.acc"
		    
		  Case "ami"
		    Return "application/vnd.amiga.ami"
		    
		  Case "apk"
		    Return "application/vnd.android.package-archive"
		    
		  Case "cii"
		    Return "application/vnd.anser-web-certificate-issue-initiation"
		    
		  Case "fti"
		    Return "application/vnd.anser-web-funds-transfer-initiation"
		    
		  Case "atx"
		    Return "application/vnd.antix.game-component"
		    
		  Case "mpkg"
		    Return "application/vnd.apple.installer+xml"
		    
		  Case "m3u8"
		    Return "application/vnd.apple.mpegurl"
		    
		  Case "swi"
		    Return "application/vnd.aristanetworks.swi"
		    
		  Case "aep"
		    Return "application/vnd.audiograph"
		    
		  Case "mpm"
		    Return "application/vnd.blueice.multipass"
		    
		  Case "bmi"
		    Return "application/vnd.bmi"
		    
		  Case "rep"
		    Return "application/vnd.businessobjects"
		    
		  Case "cdxml"
		    Return "application/vnd.chemdraw+xml"
		    
		  Case "mmd"
		    Return "application/vnd.chipnuts.karaoke-mmd"
		    
		  Case "cdy"
		    Return "application/vnd.cinderella"
		    
		  Case "cla"
		    Return "application/vnd.claymore"
		    
		  Case "rp9"
		    Return "application/vnd.cloanto.rp9"
		    
		  Case "c4g", "c4d", "c4f", "c4p", "c4u"
		    Return "application/vnd.clonk.c4group"
		    
		  Case "c11amc"
		    Return "application/vnd.cluetrust.cartomobile-config"
		    
		  Case "c11amz"
		    Return "application/vnd.cluetrust.cartomobile-config-pkg"
		    
		  Case "csp"
		    Return "application/vnd.commonspace"
		    
		  Case "cdbcmsg"
		    Return "application/vnd.contact.cmsg"
		    
		  Case "cmc"
		    Return "application/vnd.cosmocaller"
		    
		  Case "clkx"
		    Return "application/vnd.crick.clicker"
		    
		  Case "clkk"
		    Return "application/vnd.crick.clicker.keyboard"
		    
		  Case "clkp"
		    Return "application/vnd.crick.clicker.palette"
		    
		  Case "clkt"
		    Return "application/vnd.crick.clicker.template"
		    
		  Case "clkw"
		    Return "application/vnd.crick.clicker.wordbank"
		    
		  Case "wbs"
		    Return "application/vnd.criticaltools.wbs+xml"
		    
		  Case "pml"
		    Return "application/vnd.ctc-posml"
		    
		  Case "ppd"
		    Return "application/vnd.cups-ppd"
		    
		  Case "car"
		    Return "application/vnd.curl.car"
		    
		  Case "pcurl"
		    Return "application/vnd.curl.pcurl"
		    
		  Case "rdz"
		    Return "application/vnd.data-vision.rdz"
		    
		  Case "uvf", "uvvf", "uvd", "uvvd"
		    Return "application/vnd.dece.data"
		    
		  Case "uvt", "uvvt"
		    Return "application/vnd.dece.ttml+xml"
		    
		  Case "uvx", "uvvx"
		    Return "application/vnd.dece.unspecified"
		    
		  Case "fe_launch"
		    Return "application/vnd.denovo.fcselayout-link"
		    
		  Case "dna"
		    Return "application/vnd.dna"
		    
		  Case "mlp"
		    Return "application/vnd.dolby.mlp"
		    
		  Case "dpg"
		    Return "application/vnd.dpgraph"
		    
		  Case "dfac"
		    Return "application/vnd.dreamfactory"
		    
		  Case "ait"
		    Return "application/vnd.dvb.ait"
		    
		  Case "svc"
		    Return "application/vnd.dvb.service"
		    
		  Case "geo"
		    Return "application/vnd.dynageo"
		    
		  Case "mag"
		    Return "application/vnd.ecowin.chart"
		    
		  Case "nml"
		    Return "application/vnd.enliven"
		    
		  Case "esf"
		    Return "application/vnd.epson.esf"
		    
		  Case "msf"
		    Return "application/vnd.epson.msf"
		    
		  Case "qam"
		    Return "application/vnd.epson.quickanime"
		    
		  Case "slt"
		    Return "application/vnd.epson.salt"
		    
		  Case "ssf"
		    Return "application/vnd.epson.ssf"
		    
		  Case "es3", "et3"
		    Return "application/vnd.eszigno3+xml"
		    
		  Case "ez2"
		    Return "application/vnd.ezpix-album"
		    
		  Case "ez3"
		    Return "application/vnd.ezpix-package"
		    
		  Case "fdf"
		    Return "application/vnd.fdf"
		    
		  Case "mseed"
		    Return "application/vnd.fdsn.mseed"
		    
		  Case "seed", "dataless"
		    Return "application/vnd.fdsn.seed"
		    
		  Case "gph"
		    Return "application/vnd.flographit"
		    
		  Case "ftc"
		    Return "application/vnd.fluxtime.clip"
		    
		  Case "fm", "frame", "maker", "book"
		    Return "application/vnd.framemaker"
		    
		  Case "fnc"
		    Return "application/vnd.frogans.fnc"
		    
		  Case "ltf"
		    Return "application/vnd.frogans.ltf"
		    
		  Case "fsc"
		    Return "application/vnd.fsc.weblaunch"
		    
		  Case "oas"
		    Return "application/vnd.fujitsu.oasys"
		    
		  Case "oa2"
		    Return "application/vnd.fujitsu.oasys2"
		    
		  Case "oa3"
		    Return "application/vnd.fujitsu.oasys3"
		    
		  Case "fg5"
		    Return "application/vnd.fujitsu.oasysgp"
		    
		  Case "bh2"
		    Return "application/vnd.fujitsu.oasysprs"
		    
		  Case "ddd"
		    Return "application/vnd.fujixerox.ddd"
		    
		  Case "xdw"
		    Return "application/vnd.fujixerox.docuworks"
		    
		  Case "xbd"
		    Return "application/vnd.fujixerox.docuworks.binder"
		    
		  Case "fzs"
		    Return "application/vnd.fuzzysheet"
		    
		  Case "txd"
		    Return "application/vnd.genomatix.tuxedo"
		    
		  Case "ggb"
		    Return "application/vnd.geogebra.file"
		    
		  Case "ggt"
		    Return "application/vnd.geogebra.tool"
		    
		  Case "gex", "gre"
		    Return "application/vnd.geometry-explorer"
		    
		  Case "gxt"
		    Return "application/vnd.geonext"
		    
		  Case "g2w"
		    Return "application/vnd.geoplan"
		    
		  Case "g3w"
		    Return "application/vnd.geospace"
		    
		  Case "gmx"
		    Return "application/vnd.gmx"
		    
		  Case "kml"
		    Return "application/vnd.google-earth.kml+xml"
		    
		  Case "kmz"
		    Return "application/vnd.google-earth.kmz"
		    
		  Case "gqf", "gqs"
		    Return "application/vnd.grafeq"
		    
		  Case "gac"
		    Return "application/vnd.groove-account"
		    
		  Case "ghf"
		    Return "application/vnd.groove-help"
		    
		  Case "gim"
		    Return "application/vnd.groove-identity-message"
		    
		  Case "grv"
		    Return "application/vnd.groove-injector"
		    
		  Case "gtm"
		    Return "application/vnd.groove-tool-message"
		    
		  Case "tpl"
		    Return "application/vnd.groove-tool-template"
		    
		  Case "vcg"
		    Return "application/vnd.groove-vcard"
		    
		  Case "hal"
		    Return "application/vnd.hal+xml"
		    
		  Case "zmm"
		    Return "application/vnd.handheld-entertainment+xml"
		    
		  Case "hbci"
		    Return "application/vnd.hbci"
		    
		  Case "les"
		    Return "application/vnd.hhe.lesson-player"
		    
		  Case "hpgl"
		    Return "application/vnd.hp-hpgl"
		    
		  Case "hpid"
		    Return "application/vnd.hp-hpid"
		    
		  Case "hps"
		    Return "application/vnd.hp-hps"
		    
		  Case "jlt"
		    Return "application/vnd.hp-jlyt"
		    
		  Case "pcl"
		    Return "application/vnd.hp-pcl"
		    
		  Case "pclxl"
		    Return "application/vnd.hp-pclxl"
		    
		  Case "sfd-hdstx"
		    Return "application/vnd.hydrostatix.sof-data"
		    
		  Case "x3d"
		    Return "application/vnd.hzn-3d-crossword"
		    
		  Case "mpy"
		    Return "application/vnd.ibm.minipay"
		    
		  Case "afp", "listafp", "list3820"
		    Return "application/vnd.ibm.modcap"
		    
		  Case "irm"
		    Return "application/vnd.ibm.rights-management"
		    
		  Case "sc"
		    Return "application/vnd.ibm.secure-container"
		    
		  Case "icc", "icm"
		    Return "application/vnd.iccprofile"
		    
		  Case "igl"
		    Return "application/vnd.igloader"
		    
		  Case "ivp"
		    Return "application/vnd.immervision-ivp"
		    
		  Case "ivu"
		    Return "application/vnd.immervision-ivu"
		    
		  Case "igm"
		    Return "application/vnd.insors.igm"
		    
		  Case "xpw", "xpx"
		    Return "application/vnd.intercon.formnet"
		    
		  Case "i2g"
		    Return "application/vnd.intergeo"
		    
		  Case "qbo"
		    Return "application/vnd.intu.qbo"
		    
		  Case "qfx"
		    Return "application/vnd.intu.qfx"
		    
		  Case "rcprofile"
		    Return "application/vnd.ipunplugged.rcprofile"
		    
		  Case "irp"
		    Return "application/vnd.irepository.package+xml"
		    
		  Case "xpr"
		    Return "application/vnd.is-xpr"
		    
		  Case "fcs"
		    Return "application/vnd.isac.fcs"
		    
		  Case "jam"
		    Return "application/vnd.jam"
		    
		  Case "rms"
		    Return "application/vnd.jcp.javame.midlet-rms"
		    
		  Case "jisp"
		    Return "application/vnd.jisp"
		    
		  Case "joda"
		    Return "application/vnd.joost.joda-archive"
		    
		  Case "ktz", "ktr"
		    Return "application/vnd.kahootz"
		    
		  Case "karbon"
		    Return "application/vnd.kde.karbon"
		    
		  Case "chrt"
		    Return "application/vnd.kde.kchart"
		    
		  Case "kfo"
		    Return "application/vnd.kde.kformula"
		    
		  Case "flw"
		    Return "application/vnd.kde.kivio"
		    
		  Case "kon"
		    Return "application/vnd.kde.kontour"
		    
		  Case "kpr", "kpt"
		    Return "application/vnd.kde.kpresenter"
		    
		  Case "ksp"
		    Return "application/vnd.kde.kspread"
		    
		  Case "kwd", "kwt"
		    Return "application/vnd.kde.kword"
		    
		  Case "htke"
		    Return "application/vnd.kenameaapp"
		    
		  Case "kia"
		    Return "application/vnd.kidspiration"
		    
		  Case "kne", "knp"
		    Return "application/vnd.kinar"
		    
		  Case "skp", "skd", "skt", "skm"
		    Return "application/vnd.koan"
		    
		  Case "sse"
		    Return "application/vnd.kodak-descriptor"
		    
		  Case "lasxml"
		    Return "application/vnd.las.las+xml"
		    
		  Case "lbd"
		    Return "application/vnd.llamagraphics.life-balance.desktop"
		    
		  Case "lbe"
		    Return "application/vnd.llamagraphics.life-balance.exchange+xml"
		    
		  Case "123"
		    Return "application/vnd.lotus-1-2-3"
		    
		  Case "apr"
		    Return "application/vnd.lotus-approach"
		    
		  Case "pre"
		    Return "application/vnd.lotus-freelance"
		    
		  Case "nsf"
		    Return "application/vnd.lotus-notes"
		    
		  Case "org"
		    Return "application/vnd.lotus-organizer"
		    
		  Case "scm"
		    Return "application/vnd.lotus-screencam"
		    
		  Case "lwp"
		    Return "application/vnd.lotus-wordpro"
		    
		  Case "portpkg"
		    Return "application/vnd.macports.portpkg"
		    
		  Case "mcd"
		    Return "application/vnd.mcd"
		    
		  Case "mc1"
		    Return "application/vnd.medcalcdata"
		    
		  Case "cdkey"
		    Return "application/vnd.mediastation.cdkey"
		    
		  Case "mwf"
		    Return "application/vnd.mfer"
		    
		  Case "mfm"
		    Return "application/vnd.mfmp"
		    
		  Case "flo"
		    Return "application/vnd.micrografx.flo"
		    
		  Case "igx"
		    Return "application/vnd.micrografx.igx"
		    
		  Case "mif"
		    Return "application/vnd.mif"
		    
		  Case "daf"
		    Return "application/vnd.mobius.daf"
		    
		  Case "dis"
		    Return "application/vnd.mobius.dis"
		    
		  Case "mbk"
		    Return "application/vnd.mobius.mbk"
		    
		  Case "mqy"
		    Return "application/vnd.mobius.mqy"
		    
		  Case "msl"
		    Return "application/vnd.mobius.msl"
		    
		  Case "plc"
		    Return "application/vnd.mobius.plc"
		    
		  Case "txf"
		    Return "application/vnd.mobius.txf"
		    
		  Case "mpn"
		    Return "application/vnd.mophun.application"
		    
		  Case "mpc"
		    Return "application/vnd.mophun.certificate"
		    
		  Case "xul"
		    Return "application/vnd.mozilla.xul+xml"
		    
		  Case "cil"
		    Return "application/vnd.ms-artgalry"
		    
		  Case "cab"
		    Return "application/vnd.ms-cab-compressed"
		    
		  Case "xls", "xlm", "xla", "xlc", "xlt", "xlw"
		    Return "application/vnd.ms-excel"
		    
		  Case "xlam"
		    Return "application/vnd.ms-excel.addin.macroenabled.12"
		    
		  Case "xlsb"
		    Return "application/vnd.ms-excel.sheet.binary.macroenabled.12"
		    
		  Case "xlsm"
		    Return "application/vnd.ms-excel.sheet.macroenabled.12"
		    
		  Case "xltm"
		    Return "application/vnd.ms-excel.template.macroenabled.12"
		    
		  Case "eot"
		    Return "application/vnd.ms-fontobject"
		    
		  Case "chm"
		    Return "application/vnd.ms-htmlhelp"
		    
		  Case "ims"
		    Return "application/vnd.ms-ims"
		    
		  Case "lrm"
		    Return "application/vnd.ms-lrm"
		    
		  Case "thmx"
		    Return "application/vnd.ms-officetheme"
		    
		  Case "cat"
		    Return "application/vnd.ms-pki.seccat"
		    
		  Case "stl"
		    Return "application/vnd.ms-pki.stl"
		    
		  Case "ppt", "pps", "pot"
		    Return "application/vnd.ms-powerpoint"
		    
		  Case "ppam"
		    Return "application/vnd.ms-powerpoint.addin.macroenabled.12"
		    
		  Case "pptm"
		    Return "application/vnd.ms-powerpoint.presentation.macroenabled.12"
		    
		  Case "sldm"
		    Return "application/vnd.ms-powerpoint.slide.macroenabled.12"
		    
		  Case "ppsm"
		    Return "application/vnd.ms-powerpoint.slideshow.macroenabled.12"
		    
		  Case "potm"
		    Return "application/vnd.ms-powerpoint.template.macroenabled.12"
		    
		  Case "mpp", "mpt"
		    Return "application/vnd.ms-project"
		    
		  Case "docm"
		    Return "application/vnd.ms-word.document.macroenabled.12"
		    
		  Case "dotm"
		    Return "application/vnd.ms-word.template.macroenabled.12"
		    
		  Case "wps", "wks", "wcm", "wdb"
		    Return "application/vnd.ms-works"
		    
		  Case "wpl"
		    Return "application/vnd.ms-wpl"
		    
		  Case "xps"
		    Return "application/vnd.ms-xpsdocument"
		    
		  Case "mseq"
		    Return "application/vnd.mseq"
		    
		  Case "mus"
		    Return "application/vnd.musician"
		    
		  Case "msty"
		    Return "application/vnd.muvee.style"
		    
		  Case "nlu"
		    Return "application/vnd.neurolanguage.nlu"
		    
		  Case "nnd"
		    Return "application/vnd.noblenet-directory"
		    
		  Case "nns"
		    Return "application/vnd.noblenet-sealer"
		    
		  Case "nnw"
		    Return "application/vnd.noblenet-web"
		    
		  Case "ngdat"
		    Return "application/vnd.nokia.n-gage.data"
		    
		  Case "n-gage"
		    Return "application/vnd.nokia.n-gage.symbian.install"
		    
		  Case "rpst"
		    Return "application/vnd.nokia.radio-preset"
		    
		  Case "rpss"
		    Return "application/vnd.nokia.radio-presets"
		    
		  Case "edm"
		    Return "application/vnd.novadigm.edm"
		    
		  Case "edx"
		    Return "application/vnd.novadigm.edx"
		    
		  Case "ext"
		    Return "application/vnd.novadigm.ext"
		    
		  Case "odc"
		    Return "application/vnd.oasis.opendocument.chart"
		    
		  Case "otc"
		    Return "application/vnd.oasis.opendocument.chart-template"
		    
		  Case "odb"
		    Return "application/vnd.oasis.opendocument.database"
		    
		  Case "odf"
		    Return "application/vnd.oasis.opendocument.formula"
		    
		  Case "odft"
		    Return "application/vnd.oasis.opendocument.formula-template"
		    
		  Case "odg"
		    Return "application/vnd.oasis.opendocument.graphics"
		    
		  Case "otg"
		    Return "application/vnd.oasis.opendocument.graphics-template"
		    
		  Case "odi"
		    Return "application/vnd.oasis.opendocument.image"
		    
		  Case "oti"
		    Return "application/vnd.oasis.opendocument.image-template"
		    
		  Case "odp"
		    Return "application/vnd.oasis.opendocument.presentation"
		    
		  Case "otp"
		    Return "application/vnd.oasis.opendocument.presentation-template"
		    
		  Case "ods"
		    Return "application/vnd.oasis.opendocument.spreadsheet"
		    
		  Case "ots"
		    Return "application/vnd.oasis.opendocument.spreadsheet-template"
		    
		  Case "odt"
		    Return "application/vnd.oasis.opendocument.text"
		    
		  Case "odm"
		    Return "application/vnd.oasis.opendocument.text-master"
		    
		  Case "ott"
		    Return "application/vnd.oasis.opendocument.text-template"
		    
		  Case "oth"
		    Return "application/vnd.oasis.opendocument.text-web"
		    
		  Case "xo"
		    Return "application/vnd.olpc-sugar"
		    
		  Case "dd2"
		    Return "application/vnd.oma.dd2+xml"
		    
		  Case "oxt"
		    Return "application/vnd.openofficeorg.extension"
		    
		  Case "pptx"
		    Return "application/vnd.openxmlformats-officedocument.presentationml.presentation"
		    
		  Case "sldx"
		    Return "application/vnd.openxmlformats-officedocument.presentationml.slide"
		    
		  Case "ppsx"
		    Return "application/vnd.openxmlformats-officedocument.presentationml.slideshow"
		    
		  Case "potx"
		    Return "application/vnd.openxmlformats-officedocument.presentationml.template"
		    
		  Case "xlsx"
		    Return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
		    
		  Case "xltx"
		    Return "application/vnd.openxmlformats-officedocument.spreadsheetml.template"
		    
		  Case "docx"
		    Return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
		    
		  Case "dotx"
		    Return "application/vnd.openxmlformats-officedocument.wordprocessingml.template"
		    
		  Case "mgp"
		    Return "application/vnd.osgeo.mapguide.package"
		    
		  Case "dp"
		    Return "application/vnd.osgi.dp"
		    
		  Case "pdb", "pqa", "oprc"
		    Return "application/vnd.palm"
		    
		  Case "paw"
		    Return "application/vnd.pawaafile"
		    
		  Case "str"
		    Return "application/vnd.pg.format"
		    
		  Case "ei6"
		    Return "application/vnd.pg.osasli"
		    
		  Case "efif"
		    Return "application/vnd.picsel"
		    
		  Case "wg"
		    Return "application/vnd.pmi.widget"
		    
		  Case "plf"
		    Return "application/vnd.pocketlearn"
		    
		  Case "pbd"
		    Return "application/vnd.powerbuilder6"
		    
		  Case "box"
		    Return "application/vnd.previewsystems.box"
		    
		  Case "mgz"
		    Return "application/vnd.proteus.magazine"
		    
		  Case "qps"
		    Return "application/vnd.publishare-delta-tree"
		    
		  Case "ptid"
		    Return "application/vnd.pvi.ptid1"
		    
		  Case "qxd", "qxt", "qwd", "qwt", "qxl", "qxb"
		    Return "application/vnd.quark.quarkxpress"
		    
		  Case "bed"
		    Return "application/vnd.realvnc.bed"
		    
		  Case "mxl"
		    Return "application/vnd.recordare.musicxml"
		    
		  Case "musicxml"
		    Return "application/vnd.recordare.musicxml+xml"
		    
		  Case "cryptonote"
		    Return "application/vnd.rig.cryptonote"
		    
		  Case "cod"
		    Return "application/vnd.rim.cod"
		    
		  Case "rm"
		    Return "application/vnd.rn-realmedia"
		    
		  Case "link66"
		    Return "application/vnd.route66.link66+xml"
		    
		  Case "st"
		    Return "application/vnd.sailingtracker.track"
		    
		  Case "see"
		    Return "application/vnd.seemail"
		    
		  Case "sema"
		    Return "application/vnd.sema"
		    
		  Case "semd"
		    Return "application/vnd.semd"
		    
		  Case "semf"
		    Return "application/vnd.semf"
		    
		  Case "ifm"
		    Return "application/vnd.shana.informed.formdata"
		    
		  Case "itp"
		    Return "application/vnd.shana.informed.formtemplate"
		    
		  Case "iif"
		    Return "application/vnd.shana.informed.interchange"
		    
		  Case "ipk"
		    Return "application/vnd.shana.informed.package"
		    
		  Case "twd", "twds"
		    Return "application/vnd.simtech-mindmapper"
		    
		  Case "mmf"
		    Return "application/vnd.smaf"
		    
		  Case "teacher"
		    Return "application/vnd.smart.teacher"
		    
		  Case "sdkm", "sdkd"
		    Return "application/vnd.solent.sdkm+xml"
		    
		  Case "dxp"
		    Return "application/vnd.spotfire.dxp"
		    
		  Case "sfs"
		    Return "application/vnd.spotfire.sfs"
		    
		  Case "sdc"
		    Return "application/vnd.stardivision.calc"
		    
		  Case "sda"
		    Return "application/vnd.stardivision.draw"
		    
		  Case "sdd"
		    Return "application/vnd.stardivision.impress"
		    
		  Case "smf"
		    Return "application/vnd.stardivision.math"
		    
		  Case "sdw", "vor"
		    Return "application/vnd.stardivision.writer"
		    
		  Case "sgl"
		    Return "application/vnd.stardivision.writer-global"
		    
		  Case "sm"
		    Return "application/vnd.stepmania.stepchart"
		    
		  Case "sxc"
		    Return "application/vnd.sun.xml.calc"
		    
		  Case "stc"
		    Return "application/vnd.sun.xml.calc.template"
		    
		  Case "sxd"
		    Return "application/vnd.sun.xml.draw"
		    
		  Case "std"
		    Return "application/vnd.sun.xml.draw.template"
		    
		  Case "sxi"
		    Return "application/vnd.sun.xml.impress"
		    
		  Case "sti"
		    Return "application/vnd.sun.xml.impress.template"
		    
		  Case "sxm"
		    Return "application/vnd.sun.xml.math"
		    
		  Case "sxw"
		    Return "application/vnd.sun.xml.writer"
		    
		  Case "sxg"
		    Return "application/vnd.sun.xml.writer.global"
		    
		  Case "stw"
		    Return "application/vnd.sun.xml.writer.template"
		    
		  Case "sus", "susp"
		    Return "application/vnd.sus-calendar"
		    
		  Case "svd"
		    Return "application/vnd.svd"
		    
		  Case "sis", "sisx"
		    Return "application/vnd.symbian.install"
		    
		  Case "xsm"
		    Return "application/vnd.syncml+xml"
		    
		  Case "bdm"
		    Return "application/vnd.syncml.dm+wbxml"
		    
		  Case "xdm"
		    Return "application/vnd.syncml.dm+xml"
		    
		  Case "tao"
		    Return "application/vnd.tao.intent-module-archive"
		    
		  Case "tmo"
		    Return "application/vnd.tmobile-livetv"
		    
		  Case "tpt"
		    Return "application/vnd.trid.tpt"
		    
		  Case "mxs"
		    Return "application/vnd.triscape.mxs"
		    
		  Case "tra"
		    Return "application/vnd.trueapp"
		    
		  Case "ufd", "ufdl"
		    Return "application/vnd.ufdl"
		    
		  Case "utz"
		    Return "application/vnd.uiq.theme"
		    
		  Case "umj"
		    Return "application/vnd.umajin"
		    
		  Case "unityweb"
		    Return "application/vnd.unity"
		    
		  Case "uoml"
		    Return "application/vnd.uoml+xml"
		    
		  Case "vcx"
		    Return "application/vnd.vcx"
		    
		  Case "vsd", "vst", "vss", "vsw"
		    Return "application/vnd.visio"
		    
		  Case "vis"
		    Return "application/vnd.visionary"
		    
		  Case "vsf"
		    Return "application/vnd.vsf"
		    
		  Case "wbxml"
		    Return "application/vnd.wap.wbxml"
		    
		  Case "wmlc"
		    Return "application/vnd.wap.wmlc"
		    
		  Case "wmlsc"
		    Return "application/vnd.wap.wmlscriptc"
		    
		  Case "wtb"
		    Return "application/vnd.webturbo"
		    
		  Case "nbp"
		    Return "application/vnd.wolfram.player"
		    
		  Case "wpd"
		    Return "application/vnd.wordperfect"
		    
		  Case "wqd"
		    Return "application/vnd.wqd"
		    
		  Case "stf"
		    Return "application/vnd.wt.stf"
		    
		  Case "xar"
		    Return "application/vnd.xara"
		    
		  Case "xfdl"
		    Return "application/vnd.xfdl"
		    
		  Case "hvd"
		    Return "application/vnd.yamaha.hv-dic"
		    
		  Case "hvs"
		    Return "application/vnd.yamaha.hv-script"
		    
		  Case "hvp"
		    Return "application/vnd.yamaha.hv-voice"
		    
		  Case "osf"
		    Return "application/vnd.yamaha.openscoreformat"
		    
		  Case "osfpvg"
		    Return "application/vnd.yamaha.openscoreformat.osfpvg+xml"
		    
		  Case "saf"
		    Return "application/vnd.yamaha.smaf-audio"
		    
		  Case "spf"
		    Return "application/vnd.yamaha.smaf-phrase"
		    
		  Case "cmp"
		    Return "application/vnd.yellowriver-custom-menu"
		    
		  Case "zir", "zirz"
		    Return "application/vnd.zul"
		    
		  Case "zaz"
		    Return "application/vnd.zzazz.deck+xml"
		    
		  Case "vxml"
		    Return "application/voicexml+xml"
		    
		  Case "wgt"
		    Return "application/widget"
		    
		  Case "hlp"
		    Return "application/winhlp"
		    
		  Case "wsdl"
		    Return "application/wsdl+xml"
		    
		  Case "wspolicy"
		    Return "application/wspolicy+xml"
		    
		  Case "7z"
		    Return "application/x-7z-compressed"
		    
		  Case "abw"
		    Return "application/x-abiword"
		    
		  Case "ace"
		    Return "application/x-ace-compressed"
		    
		  Case "aab", "x32", "u32", "vox"
		    Return "application/x-authorware-bin"
		    
		  Case "aam"
		    Return "application/x-authorware-map"
		    
		  Case "aas"
		    Return "application/x-authorware-seg"
		    
		  Case "bcpio"
		    Return "application/x-bcpio"
		    
		  Case "torrent"
		    Return "application/x-bittorrent"
		    
		  Case "bz"
		    Return "application/x-bzip"
		    
		  Case "bz2", "boz"
		    Return "application/x-bzip2"
		    
		  Case "vcd"
		    Return "application/x-cdlink"
		    
		  Case "chat"
		    Return "application/x-chat"
		    
		  Case "pgn"
		    Return "application/x-chess-pgn"
		    
		  Case "cpio"
		    Return "application/x-cpio"
		    
		  Case "csh"
		    Return "application/x-csh"
		    
		  Case "deb", "udeb"
		    Return "application/x-debian-package"
		    
		  Case "dir", "dcr", "dxr", "cst", "cct", "cxt", "w3d", "fgd", "swa"
		    Return "application/x-director"
		    
		  Case "wad"
		    Return "application/x-doom"
		    
		  Case "ncx"
		    Return "application/x-dtbncx+xml"
		    
		  Case "dtb"
		    Return "application/x-dtbook+xml"
		    
		  Case "res"
		    Return "application/x-dtbresource+xml"
		    
		  Case "dvi"
		    Return "application/x-dvi"
		    
		  Case "bdf"
		    Return "application/x-font-bdf"
		    
		  Case "gsf"
		    Return "application/x-font-ghostscript"
		    
		  Case "psf"
		    Return "application/x-font-linux-psf"
		    
		  Case "otf"
		    Return "application/x-font-otf"
		    
		  Case "pcf"
		    Return "application/x-font-pcf"
		    
		  Case "snf"
		    Return "application/x-font-snf"
		    
		  Case "ttf", "ttc"
		    Return "application/x-font-ttf"
		    
		  Case "pfa", "pfb", "pfm", "afm"
		    Return "application/x-font-type1"
		    
		  Case "woff"
		    Return "application/x-font-woff"
		    
		  Case "spl"
		    Return "application/x-futuresplash"
		    
		  Case "gnumeric"
		    Return "application/x-gnumeric"
		    
		  Case "gtar"
		    Return "application/x-gtar"
		    
		  Case "hdf"
		    Return "application/x-hdf"
		    
		  Case "jnlp"
		    Return "application/x-java-jnlp-file"
		    
		  Case "latex"
		    Return "application/x-latex"
		    
		  Case "prc", "mobi"
		    Return "application/x-mobipocket-ebook"
		    
		  Case "m3u8"
		    Return "application/x-mpegurl"
		    
		  Case "application"
		    Return "application/x-ms-application"
		    
		  Case "wmd"
		    Return "application/x-ms-wmd"
		    
		  Case "wmz"
		    Return "application/x-ms-wmz"
		    
		  Case "xbap"
		    Return "application/x-ms-xbap"
		    
		  Case "mdb"
		    Return "application/x-msaccess"
		    
		  Case "obd"
		    Return "application/x-msbinder"
		    
		  Case "crd"
		    Return "application/x-mscardfile"
		    
		  Case "clp"
		    Return "application/x-msclip"
		    
		  Case "exe", "dll", "com", "bat", "msi"
		    Return "application/x-msdownload"
		    
		  Case "mvb", "m13", "m14"
		    Return "application/x-msmediaview"
		    
		  Case "wmf"
		    Return "application/x-msmetafile"
		    
		  Case "mny"
		    Return "application/x-msmoney"
		    
		  Case "pub"
		    Return "application/x-mspublisher"
		    
		  Case "scd"
		    Return "application/x-msschedule"
		    
		  Case "trm"
		    Return "application/x-msterminal"
		    
		  Case "wri"
		    Return "application/x-mswrite"
		    
		  Case "nc", "cdf"
		    Return "application/x-netcdf"
		    
		  Case "p12", "pfx"
		    Return "application/x-pkcs12"
		    
		  Case "p7b", "spc"
		    Return "application/x-pkcs7-certificates"
		    
		  Case "p7r"
		    Return "application/x-pkcs7-certreqresp"
		    
		  Case "rar"
		    Return "application/x-rar-compressed"
		    
		  Case "sh"
		    Return "application/x-sh"
		    
		  Case "shar"
		    Return "application/x-shar"
		    
		  Case "swf"
		    Return "application/x-shockwave-flash"
		    
		  Case "xap"
		    Return "application/x-silverlight-app"
		    
		  Case "sit"
		    Return "application/x-stuffit"
		    
		  Case "sitx"
		    Return "application/x-stuffitx"
		    
		  Case "sv4cpio"
		    Return "application/x-sv4cpio"
		    
		  Case "sv4crc"
		    Return "application/x-sv4crc"
		    
		  Case "tar"
		    Return "application/x-tar"
		    
		  Case "tcl"
		    Return "application/x-tcl"
		    
		  Case "tex"
		    Return "application/x-tex"
		    
		  Case "tfm"
		    Return "application/x-tex-tfm"
		    
		  Case "texinfo", "texi"
		    Return "application/x-texinfo"
		    
		  Case "ustar"
		    Return "application/x-ustar"
		    
		  Case "src"
		    Return "application/x-wais-source"
		    
		  Case "der", "crt"
		    Return "application/x-x509-ca-cert"
		    
		  Case "fig"
		    Return "application/x-xfig"
		    
		  Case "xpi"
		    Return "application/x-xpinstall"
		    
		  Case "xdf"
		    Return "application/xcap-diff+xml"
		    
		  Case "xenc"
		    Return "application/xenc+xml"
		    
		  Case "xhtml", "xht"
		    Return "application/xhtml+xml; charset=utf-8"
		    
		  Case "xml", "xsl"
		    Return "application/xml"
		    
		  Case "dtd"
		    Return "application/xml-dtd"
		    
		  Case "xop"
		    Return "application/xop+xml"
		    
		  Case "xslt"
		    Return "application/xslt+xml"
		    
		  Case "xspf"
		    Return "application/xspf+xml"
		    
		  Case "mxml", "xhvml", "xvml", "xvm"
		    Return "application/xv+xml"
		    
		  Case "yang"
		    Return "application/yang"
		    
		  Case "yin"
		    Return "application/yin+xml"
		    
		  Case "zip"
		    Return "application/zip"
		    
		  Case "adp"
		    Return "audio/adpcm"
		    
		  Case "au", "snd"
		    Return "audio/basic"
		    
		  Case "mid", "midi", "kar", "rmi"
		    Return "audio/midi"
		    
		  Case "mp4a"
		    Return "audio/mp4"
		    
		  Case "m4a", "m4p"
		    Return "audio/mp4a-latm"
		    
		  Case "mpga", "mp2", "mp2a", "mp3", "m2a", "m3a"
		    Return "audio/mpeg"
		    
		  Case "oga", "ogg", "spx"
		    Return "audio/ogg"
		    
		  Case "uva", "uvva"
		    Return "audio/vnd.dece.audio"
		    
		  Case "eol"
		    Return "audio/vnd.digital-winds"
		    
		  Case "dra"
		    Return "audio/vnd.dra"
		    
		  Case "dts"
		    Return "audio/vnd.dts"
		    
		  Case "dtshd"
		    Return "audio/vnd.dts.hd"
		    
		  Case "lvp"
		    Return "audio/vnd.lucent.voice"
		    
		  Case "pya"
		    Return "audio/vnd.ms-playready.media.pya"
		    
		  Case "ecelp4800"
		    Return "audio/vnd.nuera.ecelp4800"
		    
		  Case "ecelp7470"
		    Return "audio/vnd.nuera.ecelp7470"
		    
		  Case "ecelp9600"
		    Return "audio/vnd.nuera.ecelp9600"
		    
		  Case "rip"
		    Return "audio/vnd.rip"
		    
		  Case "weba"
		    Return "audio/webm"
		    
		  Case "aac"
		    Return "audio/x-aac"
		    
		  Case "aif", "aiff", "aifc"
		    Return "audio/x-aiff"
		    
		  Case "m3u"
		    Return "audio/x-mpegurl"
		    
		  Case "wax"
		    Return "audio/x-ms-wax"
		    
		  Case "wma"
		    Return "audio/x-ms-wma"
		    
		  Case "ram", "ra"
		    Return "audio/x-pn-realaudio"
		    
		  Case "rmp"
		    Return "audio/x-pn-realaudio-plugin"
		    
		  Case "wav"
		    Return "audio/x-wav"
		    
		  Case "cdx"
		    Return "chemical/x-cdx"
		    
		  Case "cif"
		    Return "chemical/x-cif"
		    
		  Case "cmdf"
		    Return "chemical/x-cmdf"
		    
		  Case "cml"
		    Return "chemical/x-cml"
		    
		  Case "csml"
		    Return "chemical/x-csml"
		    
		  Case "xyz"
		    Return "chemical/x-xyz"
		    
		  Case "bmp"
		    Return "image/bmp"
		    
		  Case "cgm"
		    Return "image/cgm"
		    
		  Case "g3"
		    Return "image/g3fax"
		    
		  Case "gif"
		    Return "image/gif"
		    
		  Case "ief"
		    Return "image/ief"
		    
		  Case "jp2"
		    Return "image/jp2"
		    
		  Case "jpeg", "jpg", "jpe"
		    Return "image/jpeg"
		    
		  Case "ktx"
		    Return "image/ktx"
		    
		  Case "pict", "pic", "pct"
		    Return "image/pict"
		    
		  Case "png"
		    Return "image/png"
		    
		  Case "btif"
		    Return "image/prs.btif"
		    
		  Case "svg", "svgz"
		    Return "image/svg+xml"
		    
		  Case "tiff", "tif"
		    Return "image/tiff"
		    
		  Case "psd"
		    Return "image/vnd.adobe.photoshop"
		    
		  Case "uvi", "uvvi", "uvg", "uvvg"
		    Return "image/vnd.dece.graphic"
		    
		  Case "sub"
		    Return "image/vnd.dvb.subtitle"
		    
		  Case "djvu", "djv"
		    Return "image/vnd.djvu"
		    
		  Case "dwg"
		    Return "image/vnd.dwg"
		    
		  Case "dxf"
		    Return "image/vnd.dxf"
		    
		  Case "fbs"
		    Return "image/vnd.fastbidsheet"
		    
		  Case "fpx"
		    Return "image/vnd.fpx"
		    
		  Case "fst"
		    Return "image/vnd.fst"
		    
		  Case "mmr"
		    Return "image/vnd.fujixerox.edmics-mmr"
		    
		  Case "rlc"
		    Return "image/vnd.fujixerox.edmics-rlc"
		    
		  Case "mdi"
		    Return "image/vnd.ms-modi"
		    
		  Case "npx"
		    Return "image/vnd.net-fpx"
		    
		  Case "wbmp"
		    Return "image/vnd.wap.wbmp"
		    
		  Case "xif"
		    Return "image/vnd.xiff"
		    
		  Case "webp"
		    Return "image/webp"
		    
		  Case "ras"
		    Return "image/x-cmu-raster"
		    
		  Case "cmx"
		    Return "image/x-cmx"
		    
		  Case "fh", "fhc", "fh4", "fh5", "fh7"
		    Return "image/x-freehand"
		    
		  Case "ico"
		    Return "image/x-icon"
		    
		  Case "pntg", "pnt", "mac"
		    Return "image/x-macpaint"
		    
		  Case "pcx"
		    Return "image/x-pcx"
		    
		  Case "pic", "pct"
		    Return "image/x-pict"
		    
		  Case "pnm"
		    Return "image/x-portable-anymap"
		    
		  Case "pbm"
		    Return "image/x-portable-bitmap"
		    
		  Case "pgm"
		    Return "image/x-portable-graymap"
		    
		  Case "ppm"
		    Return "image/x-portable-pixmap"
		    
		  Case "qtif", "qti"
		    Return "image/x-quicktime"
		    
		  Case "rgb"
		    Return "image/x-rgb"
		    
		  Case "xbm"
		    Return "image/x-xbitmap"
		    
		  Case "xpm"
		    Return "image/x-xpixmap"
		    
		  Case "xwd"
		    Return "image/x-xwindowdump"
		    
		  Case "eml", "mime"
		    Return "message/rfc822"
		    
		  Case "igs", "iges"
		    Return "model/iges"
		    
		  Case "msh", "mesh", "silo"
		    Return "model/mesh"
		    
		  Case "dae"
		    Return "model/vnd.collada+xml"
		    
		  Case "dwf"
		    Return "model/vnd.dwf"
		    
		  Case "gdl"
		    Return "model/vnd.gdl"
		    
		  Case "gtw"
		    Return "model/vnd.gtw"
		    
		  Case "mts"
		    Return "model/vnd.mts"
		    
		  Case "vtu"
		    Return "model/vnd.vtu"
		    
		  Case "wrl", "vrml"
		    Return "model/vrml"
		    
		  Case "manifest"
		    Return "text/cache-manifest"
		    
		  Case "ics", "ifb"
		    Return "text/calendar"
		    
		  Case "css"
		    Return "text/css"
		    
		  Case "csv"
		    Return "text/csv"
		    
		  Case "html", "htm"
		    Return "text/html; charset=utf-8"
		    
		  Case "n3"
		    Return "text/n3"
		    
		  Case "txt", "text", "conf", "def", "list", "log", "in"
		    Return "text/plain"
		    
		  Case "dsc"
		    Return "text/prs.lines.tag"
		    
		  Case "rtx"
		    Return "text/richtext"
		    
		  Case "sgml", "sgm"
		    Return "text/sgml"
		    
		  Case "tsv"
		    Return "text/tab-separated-values"
		    
		  Case "t", "tr", "roff", "man", "me", "ms"
		    Return "text/troff"
		    
		  Case "ttl"
		    Return "text/turtle"
		    
		  Case "uri", "uris", "urls"
		    Return "text/uri-list"
		    
		  Case "curl"
		    Return "text/vnd.curl"
		    
		  Case "dcurl"
		    Return "text/vnd.curl.dcurl"
		    
		  Case "scurl"
		    Return "text/vnd.curl.scurl"
		    
		  Case "mcurl"
		    Return "text/vnd.curl.mcurl"
		    
		  Case "fly"
		    Return "text/vnd.fly"
		    
		  Case "flx"
		    Return "text/vnd.fmi.flexstor"
		    
		  Case "gv"
		    Return "text/vnd.graphviz"
		    
		  Case "3dml"
		    Return "text/vnd.in3d.3dml"
		    
		  Case "spot"
		    Return "text/vnd.in3d.spot"
		    
		  Case "jad"
		    Return "text/vnd.sun.j2me.app-descriptor"
		    
		  Case "wml"
		    Return "text/vnd.wap.wml"
		    
		  Case "wmls"
		    Return "text/vnd.wap.wmlscript"
		    
		  Case "s", "asm"
		    Return "text/x-asm"
		    
		  Case "c", "cc", "cxx", "cpp", "h", "hh", "dic"
		    Return "text/x-c"
		    
		  Case "f", "for", "f77", "f90"
		    Return "text/x-fortran"
		    
		  Case "p", "pas"
		    Return "text/x-pascal"
		    
		  Case "java"
		    Return "text/x-java-source"
		    
		  Case "etx"
		    Return "text/x-setext"
		    
		  Case "uu"
		    Return "text/x-uuencode"
		    
		  Case "vcs"
		    Return "text/x-vcalendar"
		    
		  Case "vcf"
		    Return "text/x-vcard"
		    
		  Case "3gp"
		    Return "video/3gpp"
		    
		  Case "3g2"
		    Return "video/3gpp2"
		    
		  Case "h261"
		    Return "video/h261"
		    
		  Case "h263"
		    Return "video/h263"
		    
		  Case "h264"
		    Return "video/h264"
		    
		  Case "jpgv"
		    Return "video/jpeg"
		    
		  Case "jpm", "jpgm"
		    Return "video/jpm"
		    
		  Case "mj2", "mjp2"
		    Return "video/mj2"
		    
		  Case "ts"
		    Return "video/mp2t"
		    
		  Case "mp4", "mp4v", "mpg4", "m4v"
		    Return "video/mp4"
		    
		  Case "mpeg", "mpg", "mpe", "m1v", "m2v"
		    Return "video/mpeg"
		    
		  Case "ogv"
		    Return "video/ogg"
		    
		  Case "qt", "mov"
		    Return "video/quicktime"
		    
		  Case "uvh", "uvvh"
		    Return "video/vnd.dece.hd"
		    
		  Case "uvm", "uvvm"
		    Return "video/vnd.dece.mobile"
		    
		  Case "uvp", "uvvp"
		    Return "video/vnd.dece.pd"
		    
		  Case "uvs", "uvvs"
		    Return "video/vnd.dece.sd"
		    
		  Case "uvv", "uvvv"
		    Return "video/vnd.dece.video"
		    
		  Case "fvt"
		    Return "video/vnd.fvt"
		    
		  Case "mxu", "m4u"
		    Return "video/vnd.mpegurl"
		    
		  Case "pyv"
		    Return "video/vnd.ms-playready.media.pyv"
		    
		  Case "uvu", "uvvu"
		    Return "video/vnd.uvvu.mp4"
		    
		  Case "viv"
		    Return "video/vnd.vivo"
		    
		  Case "dv", "dif"
		    Return "video/x-dv"
		    
		  Case "webm"
		    Return "video/webm"
		    
		  Case "f4v"
		    Return "video/x-f4v"
		    
		  Case "fli"
		    Return "video/x-fli"
		    
		  Case "flv"
		    Return "video/x-flv"
		    
		  Case "m4v"
		    Return "video/x-m4v"
		    
		  Case "rbp", "rbbas", "rbvcp"
		    Return "application/x-REALbasic-Project"
		    
		  Case "asf", "asx"
		    Return "video/x-ms-asf"
		    
		  Case "wm"
		    Return "video/x-ms-wm"
		    
		  Case "wmv"
		    Return "video/x-ms-wmv"
		    
		  Case "wmx"
		    Return "video/x-ms-wmx"
		    
		  Case "wvx"
		    Return "video/x-ms-wvx"
		    
		  Case "avi"
		    Return "video/x-msvideo"
		    
		  Case "movie"
		    Return "video/x-sgi-movie"
		    
		  Case "ice"
		    Return "x-conference/x-cooltalk"
		    
		  Else
		    ' This returns the default mime type
		    Return "application/octet-stream"
		    'Return "text/plain"
		    
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function ParseRawHeaders(Data As String) As InternetHeaders
		  Dim headers As New InternetHeaders
		  Dim lines() As String = data.Split(CRLF)
		  
		  For i As Integer = 0 To UBound(lines)
		    Dim line As String = lines(i)
		    If Instr(line, ": ") <= 1  Or line.Trim = "" Then Continue
		    headers.AppendHeader(NthField(line, ": ", 1), NthField(line, ": ", 2))
		  Next
		  Return headers
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function ResponseHeaders(ContentLength As UInt64 = 0, ContentType As String = "") As InternetHeaders
		  Dim headers As New InternetHeaders
		  Dim now As New Date
		  headers.AppendHeader("Date", HTTPDate(now))
		  If ContentLength > 0 Then
		    headers.AppendHeader("Content-Length", Str(ContentLength))
		    headers.AppendHeader("Content-Encoding", "Identity")
		  End If
		  If ContentType.Trim <> "" Then
		    headers.AppendHeader("Content-Type", ContentType)
		  End If
		  headers.AppendHeader("Accept-Ranges", "bytes")
		  headers.AppendHeader("Server", DaemonVersion)
		  headers.AppendHeader("Connection", "Close")
		  Return headers
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function URLDecode(s as String) As String
		  'This method is from here: https://github.com/bskrtich/RBHTTPServer
		  // takes a Unix-encoded string and decodes it to the standard text encoding.
		  
		  // By Sascha RenÃ© Leib, published 11/08/2003 on the Athenaeum
		  
		  Dim r As String
		  Dim c As Integer ' current char
		  Dim i As Integer ' loop var
		  
		  // first, remove the unix-path-encoding:
		  
		  For i= 1 To LenB(s)
		    c = AscB(MidB(s, i, 1))
		    
		    If c = 37 Then ' %
		      r = r + ChrB(Val("&h" + MidB(s, i+1, 2)))
		      i = i + 2
		    Else
		      r = r + ChrB(c)
		    End If
		    
		  Next
		  
		  r = ReplaceAll(r,"+"," ")
		  
		  Return r
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function URLEncode(s as String) As String
		  'This method is from here: https://github.com/bskrtich/RBHTTPServer
		  // takes a locally encoded text string and converts it to a Unix-encoded string
		  
		  // By Sascha RenÃ© Leib, published 11/08/2003 on the Athenaeum
		  
		  Dim t As String ' encoded string
		  Dim r As String
		  Dim c As Integer ' current char
		  Dim i As Integer ' loop var
		  
		  Dim srcEnc, trgEnc As TextEncoding
		  Dim conv As TextConverter
		  
		  // in case the text converter is not available,
		  // use at least the standard encoding:
		  t = s
		  
		  // first, encode the string to UTF-8
		  srcEnc = GetTextEncoding(0, 0, 0) ' default encoding
		  trgEnc = GetTextEncoding(&h0100, 0, 2) ' Unicode 2.1: UTF-8
		  If srcEnc<>Nil And trgEnc<>Nil Then
		    conv = GetTextConverter(srcEnc, trgEnc)
		    If conv<>Nil Then
		      conv.clear
		      t = conv.convert(s)
		    End If
		  End If
		  
		  For i=1 To LenB(t)
		    c = AscB(MidB(t, i, 1))
		    
		    If c<=34 Or c=37 Or c=38 Then
		      r = r + "%" + RightB("0" + Hex(c), 2)
		    Elseif (c>=43 And c<=63) Or (c>=65 And c<=90) Or (c>=97 And c<=122) Then
		      r = r + Chr(c)
		    Else
		      r = r + "%" + RightB("0" + Hex(c), 2)
		    End If
		    
		  Next ' i
		  
		  Return r
		  
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event CheckAuthentication(AuthString As String, ByRef Realm As String) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Done(ResponseCode As Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Error()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event HandleRequest(HTTPVerb As String, PostContent As String, HTTPPath As String, Headers As InternetHeaders, HTTPVersion As Single, ByRef MIMEType As String, ByRef HTTPCode As Integer) As String
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Log(LogLine As String)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event TamperRequestHeaders(ByRef Headers As InternetHeaders) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event TamperResponseHeaders(ByRef Headers As InternetHeaders) As Boolean
	#tag EndHook


	#tag Note, Name = About this class
		This class implements a very basic single-connection, single-request HTTP server. If you set the Page Property of the socket to a directory, 
		then any file or subdirectory will be requestable by a path relative to the socket's page. Requests against directories will return a directory
		index if AllowDirectoryIndexPages is True. If KeepListening is True, this class can pass as a single-user file server by re-Listening at the end 
		of each transaction. This class ought to work with the ServerSocket without modification.
		
		Usage:
		
		  Dim SomeFile As FolderItem = GetOpenFolderItem("")
		  Dim QnD As New QnDHTTPd(SomeFile)
		  QnD.Port = 80
		  QnD.Listen()
		
		or
		
		  Dim SomeFolder As FolderItem = SelectFolder()
		  Dim QnD As New QnDHTTPd(SomeFolder)
		  QnD.Page = SomeFolder
		  QnD.Port = 80
		  QnD.Listen()
		
		
		This class supports GZip compression, basic HTTP Authentication, the HTTP Range, Accept, and Content-Encoding headers, getting and
		setting HTTP cookies, and directory browsing with HTML-formatted index pages.
		
		When subclassing this class, you can override the DefaultRequestHandler by Returning a non-empty string from the HandleRequest event.
		The returned string is used verbatim as the page or file source to the socket, and is sent to the client after compression (if used) and after
		the TamperResponseHeaders event is raised and headers are prepended. You may also set the HTTP response code and the MIME-type of the returned data
		in the HandleRequest event.
		
		You can peek at and modify both inbound request headers and outbound response headers using the TamperRequestHeaders and TamperResponseHeaders
		events. TamperRequestHeaders receives inbound headers before any processing is done locally and TamperResponseHeaders receives outbound headers
		just before they are written to the socket. Headers are passed ByRef, if you alter them you must return true from the tamper event or your changes
		will be discarded.
		
		If the GZip plugin is installed and QnDHTTPd.GZIPAvailable is True, then this class will use gzip compression whenever a client requests it. Otherwise,
		the default handler will use Identity encoding (i.e. no encoding.)
		
		The GZip plugin is available from here: http://sourceforge.net/projects/realbasicgzip/
		
		Logging to System.DebugLog(GUI), Console.Print(CLI), and to a log file is supported. To log to a file, assign an implementor of the
		Writeable interface (e.g. a BinaryStream or TextOutputStream) to the Logstream property. The LogLevel property controls what sort of 
		messages will be logged. Severity_Normal is 0 and the default. Severity_Debug is -1 and includes runtime debug messages. Severity_Caution
		is +1 and includes only serious errors. Severity_Normal includes everything in Severity_Caution and nothing in Severity_Debug. This class emits
		log messages of Severity_Normal only upon receipt of a request and upon sending of its response. To turn logging off, set LogLevel>Severity_Caution.
	#tag EndNote

	#tag Note, Name = Licensing
		Copyright (c) 2013 Andrew Lambert
		
		Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
		to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
		and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
		
		The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
		
		    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
		    WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
		    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
		    ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
		
		
		--
		The MIMEtype and other Icons provided in this class were obtained from the Open Icon Library at http://openiconlibrary.sourceforge.net/
		The MIMEstring and MIMEIcon shared methods were adapted from https://github.com/bskrtich/RBHTTPServer
	#tag EndNote


	#tag Property, Flags = &h0
		AllowDirectoryIndexPages As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		Authenticate As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		KeepListening As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mLastHTTPCode
			End Get
		#tag EndGetter
		LastHTTPCode As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		LogLevel As Integer = Severity_Debug
	#tag EndProperty

	#tag Property, Flags = &h0
		Logstream As Writeable
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mLastHTTPCode As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Page As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private QueryHeaders As InternetHeaders
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ReplyHeaders As InternetHeaders
	#tag EndProperty

	#tag Property, Flags = &h21
		Private TimeOut As Integer = 10000
	#tag EndProperty

	#tag Property, Flags = &h21
		Private TimeoutTimer As Timer
	#tag EndProperty


	#tag Constant, Name = BlankErrorPage, Type = String, Dynamic = False, Default = \"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r<html xmlns\x3D\"http://www.w3.org/1999/xhtml\">\r<head>\r<meta http-equiv\x3D\"Content-Type\" content\x3D\"text/html; charset\x3Diso-8859-1\" />\r<title>%HTTPERROR%</title>\r<style type\x3D\"text/css\">\r<!--\rbody\x2Ctd\x2Cth {\r\tfont-family: Arial\x2C Helvetica\x2C sans-serif;\r\tfont-size: medium;\r}\ra:link {\r\tcolor: #0000FF;\r\ttext-decoration: none;\r}\ra:visited {\r\ttext-decoration: none;\r\tcolor: #990000;\r}\ra:hover {\r\ttext-decoration: underline;\r\tcolor: #009966;\r}\ra:active {\r\ttext-decoration: none;\r\tcolor: #FF0000;\r}\r-->\r</style></head>\r\r<body>\r<h1>%HTTPERROR%</h1>\r<p>%DOCUMENT%</p>\r<hr />\r<p>%SIGNATURE%</p>\r</body>\r</html>", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = DaemonVersion, Type = String, Dynamic = False, Default = \"QnDHTTPd/1.0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = GZIPAvailable, Type = Boolean, Dynamic = False, Default = \"False", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_Back, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAABIAAAASABGyWs+AAAACXZwQWcAAAAWAAAAFgDcxelYAAADRUlEQVQ4y53TTWhcVRTA8f+5\r9703mUym+bQxiW1DNAakWK0xQRFRUFvpWsSNKC504c6dQkAraBeCtjUqlULblRtBwaXZiBY/6kLU\rtilppzO1mmBqM87Xm/fuPS4marTNR3O2597fPZxzD6wVXdMw+XFw24HZif6pn0ZUleE3zrKRkNVT\rO3hXC3z4funhbHfuSOHMfKcR9uW7u75JkybnXhpeEzarJV7VAp9/urSr846Bty80w1uT2PWFkf0k\racb3Y/y6FV8XfuGXhPMny7urQ/mjcw29s7ZYplxpEqvcHATykao+OHqoeGPwM6erRI57Fgfy07OO\r3dWFKkGSEAmU646GcksYBsdU9ZHhw8WNwc+dbRCkOlHaYg/NpkyWL8VEDY8VsFYIDSzWPTU1w2Fo\rp1Hds+NgcW34ya8WCVK9a2Gw7fDPidz3R8ERVRKM/DtiKxAKLMWeCmbUBME7qO4ZPLZwPfhNdr72\rNaR69/xQ5shZ7L1XL0BYu/bPOEAMiBEqKTSDaEw6swe96qOPH7/6X9hayQg8EU90nzjTLuPNELK9\rUOu21KMALwIKzkPdQy3y2E5LJp/BdWbxW3O3b89n31PlofEVePDiKw/0LQV2/7dHSyPnF5qNjHM0\rm56nx/Ph6fxN9oeGJRKIU2Wox7Ct2MHJP8vO1OcSk23DZxxXCgPb+sd6Puje5Z8CvgcI2nPhfOzk\rscq5KsnlGHUpiXNs6S1PVbfnntWozXhAU89AV8TOQRpfHI9OaH3pdZuNcWFCPNdD74gY4Ld/KvZO\rUwfFIGcx+QDjgFT4cnZpZnHE7s0IQ7rc4LgOHaOmGIy4/W4uLJlMgGbA5wzyv3kEB16evGZAALXn\rZ/qM+I5Wi1u3nIO4rhnf5Yb8Z3tLK/ev8B0U1ts8AFWTwasFbR2TFq9OjabazjqxKoxHN3r0xuC/\rF2O5YMQAfkViszBYwKDLjgXUsVF59R63alURwAsYQR1oq9XBpmGf6kU0uIIIWItaQ5IoRmgY4dJ6\r8Kovu0bzR6LwsjiJNJBfsZYEtoqRWlubuVjZLKxJMotjSsQEEpoFNYBqb2TIj/WH1VObhTEmodKc\rsfl2zECXc3O/Y5w3WRF76q2SruPyF/GBZ+iTkw4aAAAAJXRFWHRjcmVhdGUtZGF0ZQAyMDA5LTEx\rLTI4VDE3OjE4OjI4LTA3OjAwMZGyLAAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxMC0wMi0yMFQyMzoy\rNjoxNy0wNzowMJGkTagAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTAtMDEtMTFUMDg6NDQ6MDYtMDc6\rMDA+Z9PyAAAANXRFWHRMaWNlbnNlAGh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL2xpY2Vuc2Vz\rL0xHUEwvMi4xLzvBtBgAAAAldEVYdG1vZGlmeS1kYXRlADIwMDktMTEtMjhUMTQ6MzI6MTUtMDc6\rMDBz/Of9AAAAFnRFWHRTb3VyY2UAQ3J5c3RhbCBQcm9qZWN06+PkiwAAACd0RVh0U291cmNlX1VS\rTABodHRwOi8vZXZlcmFsZG8uY29tL2NyeXN0YWwvpZGTWwAAAABJRU5ErkJggg\x3D\x3D", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_Binary, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAQAAABuvaSwAAAAAmJLR0QAAKqNIzIAAAAJcEhZcwAA\rDdYAAA3WAZBveZwAAAAJdnBBZwAAABYAAAAWANzF6VgAAAI+SURBVCjP1dNPSJNhHAfw7/Nse/fu\rnc7NNraMmc4KhoiHAhvhxRLxOKpDsy7SJbpE0CE8BR0KDLoVVHaotLCDIARdLPIQWVrUCkq3TLep\r2965P++7d++2d0+H9odCCLr1XH7w8OHhC7/vA/x/h/x5EajOyb/hu1g1Xi3O99lOsVJ2+spbn8Gl\rntsJH8Q7TBzouVycFYy7H4KKo/kCBj9dH/3ah4Wq0dXwGF56fVPuYaO3kG45TEg21nraPtQyMPPR\rv6YhCACgvyjDKpUTLEpg7uEvrhsihD8rdFPoyiw1p5/CUQCAHgBOgtAnl/qbQnPpgaig8BZUsMFZ\r4Na2Z/zHF6zPxxyFOrYh4HSc0Xd75G+8CV5UQACsIEo9F3RNLnHoEbdUj9GOLq/VTZA3E9qOBFuP\rR8QcOqES2SIRHW/v9SFQwzzY+3ggNJOGCSmIkWa/eURMSuARRfDB8qDy1NTIXAKhhoqU5UCRhcw9\rc9tYJyg0KCh0qf3S5qvcZA3HUdqbmnC5ytBQhuZ039dBNTEAOZSP5HrlRfVH/eUYPgfd8xgubu3y\rEFICNTEoMCCjbcSYPbWSDHKNGCJGipvj5nuJNsftDs4KFQCPNEJa5ib3JSOExX2/r/s8tA7ntPEQ\r1ayypZmRdCojML4cSp7gPtyoGlrDKgpiblZNa68j18Ll79i6VXmsqdILJZGvF0nfaBwk5/ixZSbZ\rPK0aIVl9+I7tzeJ0cHvninIwQ4Cwv22PkzMkk0trkKFAhgL2Dz/lJyyu5Cr8XCplAAAAJXRFWHRk\rYXRlOmNyZWF0ZQAyMDEwLTA1LTI0VDA3OjQyOjIwLTA2OjAwPLYQbgAAACV0RVh0ZGF0ZTptb2Rp\rZnkAMjAxMC0wNS0yNFQwNzo0MjoyMC0wNjowME3rqNIAAAA1dEVYdExpY2Vuc2UAaHR0cDovL2Ny\rZWF0aXZlY29tbW9ucy5vcmcvbGljZW5zZXMvTEdQTC8yLjEvO8G0GAAAABl0RVh0U29mdHdhcmUA\rd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAAPdEVYdFNvdXJjZQBudW92ZVhUMuogNtwAAAAidEVYdFNv\rdXJjZV9VUkwAaHR0cDovL251b3ZleHQucHdzcC5uZXSRicctAAAAAElFTkSuQmCC", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_Compressed, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAAN2AAADdgF91YLMAAAACXZwQWcAAAAWAAAAFgDcxelYAAADuklEQVQ4y7WV22tcRRzHPzN7\r9uzJbm6b3bS2SRNJNLEtghhqjYIQUi1Kn+uTDxJQyENQCOKLL6IoPvik+KL/gg/SCIWCIJgUkeiS\rNObSpOZSkibZzWV3z+6cOeeMD7knm4qIPxhmBobPfObLDCOMMfwfZe0NhBDNwIX/yFs0xiwdAQPN\rrlsa1lojBCAEQggEu+PD/YHNgWEkgm3b3cAJsCgrRalUQkqBlHIHfLwd22i/bBs42PcwGCl2gJXA\rSikcx0EKUREsxJGzHAULKYhEdoBSCG798D3ba3/hSMXZdA0/3Z2iqbmZ2uQZ0mcv8NrrN9jTfDx4\r105KyZ3bQ7zQFiFobcUtlXGLLqVCjpZ0Kx1tCaxonju3f+T6Llz+E1hKST6fR62NU25oYWJqlnt/\rzjExM0+sKsHC4iOazzVSF43irWUolXpJJBInjMXePRZCdBeKxWHP8/j2q89IWVlKZYUODGXlU1Y+\rruuCCVFaY8kI9bUJnPTTvPfhp0gpsSzrJWPMyEnj3SM5ToxXrl45YqA8jVIapTx8rfC9MoHvMbES\r3Y/w1CjeevsDEok4wni4RUP3symeSMXQfoDWPtoPCEMfrQMeLJeZWtIsb/q82/8RfhCeHsXk5Nyw\rWy4xMzVJfiPL/NI6jiO48pSktkoS+Jrf5wK0lWQzu0F76xkam9tpaX0SKQUXn2mvHEVuc5utrU02\rNrI0JaNc7niO8el57k6v83BxFuWFnD9/jo62RjovtKDcbdxiAeUFeJ53ehQxx6GWemw7zurKPI9W\rlkgm04yvLvP5F18yc3+a7775mmK9YHY1ACNp67qMEALHcY6A5eFJREqqYg71yRQmDCE0ZFeX2dxY\rxfd9AArbOSIIpBQEGFzXJQj8vUdoKhpjDDIiuTcxQTwsUyqVMSZkfS3H4sICvqcJkeTyioKrsJ04\r+sEsdbUJpCALrFYE5wsFampq6O3tJZPJENUat1gEew7P99CBhxVvhHgTn3z8/q6LYXR0VPf19b1h\rjJmrbIyhWCxQV1dPT08PQgg8TzE/f5+hoVu4rktHZyfPd3XtQ8fGxvyBgYFrmUzm11MzllJijKFQ\ryIMxO5k7VVx79Tq53BZ2NM6LV1/G9xXGGMbHx/Tg4OCN4eHhnzlWR4wdx0EphTEh2/ktkskGIjJC\rsr6BSxcvEbVjOFUxfO2Syfyh+vvf6R0Z+e0XKtRhY5NOpUjE41iWhRCCQj6PEALLkti2TXV1NbFY\rjCAMszdvvtl9GvT4y/s3f95DY8zC4xb8DYvotg/VHc9GAAAAJXRFWHRjcmVhdGUtZGF0ZQAyMDA5\rLTExLTE1VDE3OjAzOjA0LTA3OjAw16rizwAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxMC0wMS0xMVQw\rOToyNToxNC0wNzowMM7uAgEAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTAtMDEtMTFUMDk6MjU6MTQt\rMDc6MDC/s7q9AAAAZ3RFWHRMaWNlbnNlAGh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL2xpY2Vu\rc2VzL2J5LXNhLzMuMC8gb3IgaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbGljZW5zZXMvTEdQ\rTC8yLjEvW488YwAAACV0RVh0bW9kaWZ5LWRhdGUAMjAwOS0wMy0xOVQxMDo1Mjo0Ni0wNjowMHZl\rwxYAAAAZdEVYdFNvZnR3YXJlAHd3dy5pbmtzY2FwZS5vcmeb7jwaAAAAE3RFWHRTb3VyY2UAT3h5\rZ2VuIEljb25z7Biu6AAAACd0RVh0U291cmNlX1VSTABodHRwOi8vd3d3Lm94eWdlbi1pY29ucy5v\rcmcv7zeqywAAAABJRU5ErkJggg\x3D\x3D", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_CSS, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAABYlAAAWJQFJUiTwAAAACXZwQWcAAAAWAAAAFgDcxelYAAAEgUlEQVQ4y5WV224bVRSGvz0n\rj2PHSYknTpxAW0QPBGgjQFBUSou44wkqJMSjIXHPK3CJKkEPtCWEJmnrOLYTx05aH+awD7O5cBrS\rQoX4pa3Z2jPzzT9rLa0leFkC8ICC77uuEI6YHFsEAgsgBMJOrlhrMyk1kAH6VdDxfrpcnl9eXvow\riqKVQiEoW6wgt1hrsVisBYtl8gWLza2Nk+T5/n7vwe5e926apocc3fVeUGdnZ6PV1cvffP751W/f\rvXjxbBiGfm40xpijpcnzyV5JSZqmmNyQxHH2aGPzzzt373+/9fjpj0mSHJwE+8vLSx9/ce3adzdv\r3ry8vLyEMRolJVoplFZoLZGZZDgc0N/v87zXIxmPmK4vlOqLtU+VUvlgMFjfbrZ+BoxzBC5E1erK\rhQvnzy7V6+RHrpSSSCXRKiNLU7r7XVqNHWS3z1Rrj4Nf79HaekIUzTln3nrz3KnZ2fOAD/AC7AWB\rXykUgkAbRZalSJkhpUTJjDiOabfa9JptyuOEWq9P/vAho04b4bp4nk8YhgXf96cB96UYW2uFMRop\rs8nvK4nWiiRJ6Oy0GO7tU00lwXaT7Tt3WOv38K98zFvn36FYDPE8D+E4x8XwNxiL0fo4BFpNnO9s\rNxk0dqgORuSbm6w/eMATa6hcv8rK9WtEtXnA4gcBJ7gnwPkLcIaSknE8ptF4yt7aIxb7z4i3tth6\r8oR+NEf9qxtcvPIJs7MzCCHI8xzhOJzUMRhr0UajlGQ4GtBpbtBvrXHY2CRe6zAcJ4hLK6x8eYPT\rF89RLBY5+e6rOgbn1qL1JMbPD3vo8VPerh6g5wf80Q05feM6K599ytx8hOs6/JdOJg9jDEmSsN9t\rE/caOEEPt1Ri9eurnHvvI6ZOuvw/4Nxo4vGIbneX4b5ER2eYrp+hfnqF0tTUvwKEEJO+8XpwjlYK\rYzQzpxYIS6eI5heZm5sjN4Zer48QgjAM8TyXOEkw2uC6LmEYvh6MtWit2N3tsvm4iTGG0Viys9Om\r1WrjeR7FYshifZHRcESzuUOxWKRSmebChXPHne+FjrPgCEGWSR7+vk6jsU2tFlGbj9jY3OL23XsM\rh8NJDuKE27fvsvbHOmmaYq3FcZzXOxaOY3MLw/GIN944xUcfrlIqlRjHCXluCAoBO602SZJx9uwZ\ryuUySmk2tx4zM1shNwZHCPuqY620HgkhVFStcvjsGbdu/cLva+uUyyWWlpYQwqHd7tDpdFhYqFFb\rqJFmGU8b27Tbu8TjWGqlx4A56TjrHxysd3b3mpc+eH8lCAIGwyG+71OZqeC6LuVSidXLl1herlMo\rBHiuw3xUpVaLmJmp2Pv3Hz7uHxxuAAqOOhFgpVQDrbXrOGJxZqZSLIZhjkArKTU2157n6nJpSruu\ro9M00dZaHfi+xubJo43NtXu/Pfihsd38SSk1hpdHkzM9XV6sLy5ciaLqe2GhMG2xAmsRwpk8aSdl\riRBHM9DmaZI+3+vu/9Zu7/4SJ0mXo9H0amULIPB9LwyCwP9n2b8sayHLMqmNSY9CcJy8vwDwmov/\rGurQOQAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxMC0wNS0yMFQxOTo1OTozNi0wNjowMBl6oLwAAAAl\rdEVYdGRhdGU6bW9kaWZ5ADIwMTAtMDUtMjBUMTk6NTk6MzYtMDY6MDBoJxgAAAAANHRFWHRMaWNl\rbnNlAGh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL2xpY2Vuc2VzL0dQTC8yLjAvbGoGqAAAABl0\rRVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAAXdEVYdFNvdXJjZQB4ZmNlNC1pY29u\rLXRoZW1lsdI4UgAAAB90RVh0U291cmNlX1VSTABodHRwOi8vd3d3LnhmY2Uub3JnL/qctaoAAAAA\rSUVORK5CYII\x3D", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_DOC, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAAN2AAADdgF91YLMAAAACXZwQWcAAAAWAAAAFgDcxelYAAADg0lEQVQ4y7XVz4scRRTA8e97\rVd07Mzu/ssFMdiO6JBhBRCKKeMjBP8CLrCcRL94kahQFycVT/gAFQw6eBSEIEi/JJUZMSA5KQm7B\rZKOEZHdnd5jNOJPu6a56HjbZbDZjQCQNRfNe05+qfq+aEjPjSVx+ayAi+4AD/9O8Alz125IHDr7/\r1QlTh3MeVY+oR51H1CGbOYc6j27P+YRbJ784fOHcmT+2w/hKEwOOffYm12/32Tu3g8PHfsU5h6qH\re3dV/wD1HlUlcYrTCaUA2DfXYByUG8tDvvnpKh++9RJTteYWyCE+wYmiTvACqoITwXuZXGOApbwF\rKJf/HHJ44RXmO9Ok1SaqDucEr4KqoCJ4BVVwKjgVvOq/w3t3VSii47e/xly6eRsnQq2abqzoPiTy\r0CQbMagA6ibDC2/sJxQFiOJk40VRwYki9yCBjVhABBAQwDvl7LE8ToT3zwRihNXVFarVGnvm5uiv\rr4MZSZJQFAXNZpPBYEC73SbLMvI8p1ar0WjUMSttIlyv18nHY0QE7xyiymg4xDlHnud471ldXSXG\ruAmWZcloNKLRaGw6uh3O85wYAuocWZbRXVkhSVNijCRJws6dO6nX67TbbWKMlGVJq9VCRBB5zK6I\rMWJmPL1nDwYk3tPr9UjTFFXF3ZswSRJ2795NlmUMh0PSNH34f9gOT09PE0Kg3+/TX19nulZDRKhW\rq4xGI9bW1ijLkhACZVliZpvjsXC/3wcgSVOajQazs7PEGOn1eszPz2NmqCqqSgiBEMLmV5Zl+e/w\rU7t2URYFg8GAVqvFnTt3CCFQqVQQET64oNwcAhhmgpkDHK/PjPnoub/zpaWlPmCPwN2VFUSENE3J\rsoypqSmAzcZUrEuz2iaKJ5YFM8ObvNyO7PcFx4//+MPi4uIpM3sU7nQ6FEXB8vIyd+/epdPpEGNk\rNBrRbrfxl79lVgtmnj1IsbbEl+++w/Vr1zh56pfTR44c+cTMuhNL0e12UVXSNMV7z2g0IssyKpUK\rALfOfM+LLzR5JvzOa6++zY3F65w7e+r8p4cOvWdmy/cd2dpNEVkoiuJEWZb0er0HjfCeNE1ptVpc\r+flr4nhArbaDYfo85y9eOn3o488fQgG2b5eFEIIVRWFlWVoIwUIIFmO0GKOZmcUYbTweW7/fz48e\rPfod0Nlq3B/bV/xfjqYxcNHMViY9lCd1mP4DFKCqtdQRKFcAAAAldEVYdGNyZWF0ZS1kYXRlADIw\rMDktMTEtMTVUMTc6MDM6MDQtMDc6MDDXquLPAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDEwLTAxLTEx\rVDA5OjI1OjEyLTA3OjAwrT43OwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAxMC0wMS0xMVQwOToyNTox\rMi0wNzowMNxjj4cAAABndEVYdExpY2Vuc2UAaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbGlj\rZW5zZXMvYnktc2EvMy4wLyBvciBodHRwOi8vY3JlYXRpdmVjb21tb25zLm9yZy9saWNlbnNlcy9M\rR1BMLzIuMS9bjzxjAAAAJXRFWHRtb2RpZnktZGF0ZQAyMDA5LTAzLTE5VDEwOjUyOjQ2LTA2OjAw\rdmXDFgAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAATdEVYdFNvdXJjZQBP\reHlnZW4gSWNvbnPsGK7oAAAAJ3RFWHRTb3VyY2VfVVJMAGh0dHA6Ly93d3cub3h5Z2VuLWljb25z\rLm9yZy/vN6rLAAAAAElFTkSuQmCC", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_Folder, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAA3XAAAN1wFCKJt4AAAACXZwQWcAAAAWAAAAFgDcxelYAAABp0lEQVQ4y7WVQWqUQRCF36uu\rqu4OkUCiGwWRbOMBsswR3LsVvIGbLAx6APEE5g7i2gMEFBduRBBXgy4ik5lM5p/55y8XmoW4UXqm\rVg0FH69e9etmRGATJRuhbhKs14fHp+d/eUIgssXTlw/3nv8vmBGBE0BGp+erw/3VH82uJz59E1x2\r/w5c3Nutr44w59HJWz3AQe7vpun928um8T+ODFVmd95/+fydh8fvxot+tR0Ra/Gb5OCapqqa8pMH\r+/PtoltkGzQCmFz1ixdvvmat7svXH7p5tmGLaLvTAaJbLufVXTVnX2Yz1uxAIxggQEjOvtTq2rnR\ri3Mt4NWAVF1nWrPO3VhqFrSmmyAWvUjNOtdiemUie8WIYWjbHoWwjiymV1pLmrmCxYFhaFQshCul\rljTTku3SjFJdsGoEixBmZMl2qdXT1BIlO5vBSQhLwuqcarE0SYl0I1ZDW/hEiJQSi8VELetFRMho\rCvR9qxUASbGcLvTmjpzteDz6lbrGTAMICMcLOSOAW75141jEd5upAILDuJv8eMbrP4+krkFyREQP\r/H7oN1E/AeRPjq94b8L1AAAAJXRFWHRjcmVhdGUtZGF0ZQAyMDA5LTExLTE1VDE3OjAzOjA0LTA3\rOjAw16rizwAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxMC0wMS0xMVQwOToyNTowMy0wNzowMMfjPBEA\rAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTAtMDEtMTFUMDk6MjU6MDMtMDc6MDC2voStAAAAZ3RFWHRM\raWNlbnNlAGh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL2xpY2Vuc2VzL2J5LXNhLzMuMC8gb3Ig\raHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbGljZW5zZXMvTEdQTC8yLjEvW488YwAAACV0RVh0\rbW9kaWZ5LWRhdGUAMjAwOS0wMy0xOVQxMDo1Mjo0Ni0wNjowMHZlwxYAAAAZdEVYdFNvZnR3YXJl\rAHd3dy5pbmtzY2FwZS5vcmeb7jwaAAAAE3RFWHRTb3VyY2UAT3h5Z2VuIEljb25z7Biu6AAAACd0\rRVh0U291cmNlX1VSTABodHRwOi8vd3d3Lm94eWdlbi1pY29ucy5vcmcv7zeqywAAAABJRU5ErkJg\rgg\x3D\x3D", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_Font, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAA3WAAAN1gGQb3mcAAAACXZwQWcAAAAWAAAAFgDcxelYAAAD6klEQVQ4y52VP2wTVxzHP+/e\rXXyOSeJACMIUCH/UP2qnSpUKVZHKSJEQC11RFYmFAXWJBANjJbqxsTJ36BCpLB06QFkqJEhDqsql\rSXBiB5s4trF9d+/9XoezHUySDj3pp5Pu3n3f9/f9fb/vFMCtW7ewVsJz5778IpfL5QHHHlcURd7y\r8vJGsVh8PDk5Gc/Nze26TgHcv3+fKIo+uXjx4nw+nz/knNsTWERUrVZrVSqVez8/eHDnSKHQmJ2d\r3bHOAwgCH611qD1v3BoTaq2zxpgskHUiWWttVimVNcZktdZhJpOZOnb8+NzXFy7cWVpamrx79+7u\rwCIO5xxWBGvtf5ZYi4gA+CdOnpy9fPny90+fPh27ffv2TmBcCizWkhiDAsIwxPd9gpERMpkMWmvC\rMEzvmQxJHBP4vj59+vS3V65cmZufnx+5du3aANhPcR3OCSiF7/t9RrsPRSlQimazSbVaI0niYHx8\r4sb169dXr169eu/ZswUePXqYMnbOgQNjDN1OBxHZs+LEEvg+B6em8DyP9fUy5XI5Nz09/d3NmzdP\rnD//1TZjcQ4RQcGejD2lWCy1eFysc+nTafbnRigUDjM2NoaIxVp7cHn5nwNhGL4YlgKHMYYojvE8\r7532oZM4flmo8LzU5POTY+RHNdrzyE+Mp9I0Gijl4Xl6e3jOCU5S1m4XZ4gIS6UtGu0IaxI26m1k\rF6c4l9ZbwG4gRy8EQ9XuJjx58ZozpybQzrBWaw027Je1tmcCN+wKnMNaSxRFQ1J4SrG4WsdD+PDw\rKIEnlKpNYmPT2PackjJ+B1jEIS59obXGWjsA7lrh92KVM+9PkQ089o0o1mpNOt2YMNC4HrC1tien\re0djlw6v2+0OtHNOeL5aRzlhZiqLQtif01Ret2i2o6GkigjSz8OQKyTVub+7UhAnjoeLZU4c2kep\r1kzbdsJWq8PrZod8LkBk+5udGst2pI0xKKXQnmLpZZ2/y3U2W22eFDdQwOabmMhYXtU7zBzMYXvA\rA1fI2xq7tI1+W1pr4kR4/OcGlz57j4+P5REBz4MXlRY//LRAud5OJegdsH3GskMKJ4OHzln+Wmtg\rjOWjI+NoBVqnQTmwL2A041Pe7AM7QGHFDjof8nF/eHEc8aRY48fflqk2u1TqbcQarDVsvYn49Y8y\rsbEsrGzyaGkDY94KyU6NZeisCAPF2Q8OoJViRIPtnx1OmJ7I8M3ZozgHE6N+z1HsrnG5UiFJks21\r9fXF0Wy2kFW4UxOp/TuNKu3G9n/saK4fC3AuprTWQIFqdzrlV6+qWyNBMFhLoVAA8GZmZo75vp/j\rf1zGJO2VldUVcPblyxL/AsFr/L+k3iqiAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDEwLTA1LTI0VDA3\rOjQyOjIwLTA2OjAwPLYQbgAAACV0RVh0ZGF0ZTptb2RpZnkAMjAxMC0wNS0yNFQwNzo0MjoyMC0w\rNjowME3rqNIAAAA1dEVYdExpY2Vuc2UAaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbGljZW5z\rZXMvTEdQTC8yLjEvO8G0GAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAAP\rdEVYdFNvdXJjZQBudW92ZVhUMuogNtwAAAAidEVYdFNvdXJjZV9VUkwAaHR0cDovL251b3ZleHQu\rcHdzcC5uZXSRicctAAAAAElFTkSuQmCC", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_HTML, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAAN2AAADdgF91YLMAAAACXZwQWcAAAAWAAAAFgDcxelYAAADUUlEQVQ4y7WVT2gcVRzHP+9l\rZnd2k91t/mzS/GnSkjYKKbRYBYNUEPHiRWyvtd48SW4RvIiXnMRLDnrzqAiiocRDS4sieKjtIWVF\r2sAmGNpms93YbffvvJl5Pw/mzya7rRbpgy8zD2Y+85kf7/2eEhGex3BaJ0qpSeD0/2TmgBVEZDfA\r+TAMpdFsSrPpi+9vxxgxBxMEYoJAgpZEUSQzMzMfAto5+Lmm71OpVNBao5Tave7mn1/bu9+eA8Ri\rsc6l2C4HWut9QN0KVuqJYKXUU8Cwz1ZQfHvLkrtX5dc//iSTHmSwJ+LNF3u4ONP/DOAdS63Zqmk+\ruuqwtrrCw9ImU6P9vDQ1TE88ye/rd5nbLPPp22nSCRcA3QLWtJPRWmNF8ckvSd44msSGDaZHMhzr\r83htMs4LQzA6PEbj4Raf/2T2StQy2sBq2/qbnMeRVBdfXbuBZwOyqThj2RQT/ZBNWQ4lDL0DE2w8\ririS22qDtxtvg29vxVi7v8Hyyl2SsS6SnstAOsGJrMPRPoczEx7HD6dwrc+Py8U24441thbSTkB6\r5BADqQQmtPhBRNKDhKsII7hfhscNyHia63cqbcbOk4wlNMRch3NnT3DtRp6hdJybd0pkEg5dWqO0\rR/GvGqqrm/GRwf9m7DoaFdXRbpbTE5O8+8o4xWKR1UKFmytF8oUa3ckESgSvb5JTYz1Ya9Fa/7vx\rcLLGuh+HSppq0yWmEnxx9RbphIuIUK4bLrx1luX1IhfP9WOMwXH2cB2XG8D7rw9SKhTZrG9SDyN+\rW31MtrcfIzFC5TGaHeL2epELL2c43meo1+tUq1W/UCiUAem485RSxF3Nx+8M8tnlB6yHDV6dGufM\rsSyVpkEEaoHDqVGXKW+FQsElDENZWlr6fm1t7bKIiGrtx0qp80EQfBcEwW6/iCx8+XOBew8iKsYj\r0x3nSK9i+nBEVm1w8uQ0+XyexcXFS3Nzcx+IyCZAW9sMgkAajYb4vi/GGAmCQMIwlCiKxForYRhK\rrVaTUqkkuVxO8vm8LCwsXAGGWlkdN8jTxs6L1lpERH5YXLw0Ozv73q7pwQd3jKMo2me5Y2qtFRER\ra60YY6RcLvvz8/NfHzTdycEaP8vRZIDrIlLsuGSf12H6N1rr65d342PiAAAAJXRFWHRjcmVhdGUt\rZGF0ZQAyMDA5LTExLTE1VDE3OjAzOjA0LTA3OjAw16rizwAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAx\rMC0wMS0yNVQwODozMDo0MS0wNzowMKms+cAAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTAtMDEtMTFU\rMDk6MjU6MTMtMDc6MDB6FIQzAAAAZ3RFWHRMaWNlbnNlAGh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMu\rb3JnL2xpY2Vuc2VzL2J5LXNhLzMuMC8gb3IgaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbGlj\rZW5zZXMvTEdQTC8yLjEvW488YwAAACV0RVh0bW9kaWZ5LWRhdGUAMjAwOS0wMy0xOVQxMDo1Mjo0\rNi0wNjowMHZlwxYAAAAZdEVYdFNvZnR3YXJlAHd3dy5pbmtzY2FwZS5vcmeb7jwaAAAAE3RFWHRT\rb3VyY2UAT3h5Z2VuIEljb25z7Biu6AAAACd0RVh0U291cmNlX1VSTABodHRwOi8vd3d3Lm94eWdl\rbi1pY29ucy5vcmcv7zeqywAAAABJRU5ErkJggg\x3D\x3D", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_Image, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAA3WAAAN1gGQb3mcAAAACXZwQWcAAAAWAAAAFgDcxelYAAADUklEQVQ4y7WVy24cRRSGv3NO\rVc+1Pe74EltZgCwvkIhQJNhAEiFeBl4hWbNllTcIEnkKdrBmwRKRRBBIHBtPhMcz7emZrsOiezyO\rkqxQSir9pVNVp/4+l7/hPQ25f/8+Ry+P7ODgoJvFTBxvdi7BX1+/Yw+c5M7J8Un14MGDSh5+/3Dz\rzp079/JhfhtBAdyb029Fb92/A6uq+vvp06ffhcPDw1s7OztfdzqdQrhyyFtOV7Bh+La9hnnCSXWi\rLMvnIcbYV5E4nS84nS5fY3iVzVV7alHaUHj7SC/AqBcw1Y0AYAo/Pyn59pcAZiigAgKoOCI0MQIy\rg+v9Zv3qAuoEIs2jd4sJ39xqToYVoSoJ59pHNKDSOLYWFQgK13pwYygcbDaOj6ZwdA5V7SwSLOUC\rb0MVVhmNCttdJwTYGzTJPps3jFScPBP2htA1ZzxrvnIY4MONxsO0cnJfhcsJbT7IFD7IhY0ebHQa\rtvMaJhXgAsBsDh4hz2Cn39z56wyqJYhDZr6KPMHbrGayZDPMiRapllyGY3/g5BHqNp/DTOhFx9oc\rHBawTDCthHy+LsmGMYJfnFI++YlUHEBa4NZjxjVcewhCNKUYRub9QL9j9KLi7igQTdiI0K9py7Jl\rDLCYT3jx24+E2CEf7WGxx4IuM7aoGDKfl1jMGYz2yPt9doucciFUNRT9yO4oo8jWZRpWDTmfTTh+\r9hjRxNnoBd3+JlV5TnVxTl3X1GmBWsYi32Y52qccXse622i2xTTb4vlxQW9f4cagKbdV0U/P50xP\ra0QT5b/HeHqJp8veQFRQWzAdT3kVnhE6GVm3T9YdEjo5KRT8MfuEdPMuvmbsTCvjpNxCpC14FEdB\rjISxJKMmkoi4BhDDLYIGXI1lMjZXQV4xdncqGfFP9hloBDXQsJ7WoFhA1DALqAXUDAsBa+2D7S6r\rKms6LyX2d7f48vaniFpzQRVVxazB0NrM1jOoYmYEU0SVj7fTpR4Hd2eZnK9u7vLFR1utvr6pYPha\rf9+FTe0L7u5hPB4fl2V5NhwMhr1or2nvWmdbB2/VacddLm2LxaKeTCZ/hkc/PPp1PB7fK4ricxEx\r3C9JwptivoY3bALObFY+e/z494dy5TelNF36f0da0Xov4z9IwtlM74rHQAAAACV0RVh0ZGF0ZTpj\rcmVhdGUAMjAxMC0wNS0yNFQwNzo0MjoyMC0wNjowMDy2EG4AAAAldEVYdGRhdGU6bW9kaWZ5ADIw\rMTAtMDUtMjRUMDc6NDI6MjAtMDY6MDBN66jSAAAANXRFWHRMaWNlbnNlAGh0dHA6Ly9jcmVhdGl2\rZWNvbW1vbnMub3JnL2xpY2Vuc2VzL0xHUEwvMi4xLzvBtBgAAAAZdEVYdFNvZnR3YXJlAHd3dy5p\rbmtzY2FwZS5vcmeb7jwaAAAAD3RFWHRTb3VyY2UAbnVvdmVYVDLqIDbcAAAAInRFWHRTb3VyY2Vf\rVVJMAGh0dHA6Ly9udW92ZXh0LnB3c3AubmV0kYnHLQAAAABJRU5ErkJggg\x3D\x3D", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_Movie, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAAN2AAADdgF91YLMAAAACXZwQWcAAAAWAAAAFgDcxelYAAADLUlEQVQ4y7WV3WtcRRjGfzM5\ru0nWlA3eaK9sbRsjqRitH8mVUShBeiVNUWjFf0AC3uaqGnJTsJbcJiJpXUMQa40JWC+E0qDkwo8S\rIqRlEzEtZpMF0242Z8/MnHm9MGfdJNvQIh14OGcO5/zmeZ95OaNEhEcxgtqJUuoQ0Pk/mXPATUSk\rKuCkc07CSkUqlUiiaEvGiNkpa8VYK7ZGcRxLd3f3+4AOdi5XiSJKpRJaa5RS1WtV/5b23/3WHCCd\rTlc5eic4gSVSSqFrtfVsdnaWz3M5oija9u79wbDNrdYapTXWWkZHR/now0GMsdxe/osbv91kZuan\ruuCgnuNExbUiExMTXL/+IxcufMxzR5+nuFZicnKKZ9oOceJEL9lstgrUe4GpKffSxS95tuMI6XSG\r+fnfeeHFTl5+9SUU0NjYiHMOYwxNTU27MHWjSHK9MT/Hd1d/IJcbp1BYRSvN6z29jI3lWF1do6en\rl5GRz7ZVeX/HSRxa83jrPoIgoKvrFW7dynP+k2G6urtYXPyDc+fOc+xYJ8vLf24D7pmx3lq97+Rb\rtGSzIBpB4QViD97H2Fjwcczde6Uq+IEca6UYu3iJ1mwrT+7fT3HtbwqFVQ4eeIr2jnbGc+O0HTnM\rwsICZ069+QAZ1+TlXcy+lhaChgBrLcePv0Fb22EqFUumOcPBpw+gFIgI3vu9wdWStrojSKVZv1si\r3Kxw+atvuHZtBu9jUqkUv/z8K94LxhiMMTjn9m63pDv63j5FpvkxRDcgohAB5wXvhb4z72FdTLhZ\rJgxDvPdoraOVlZV1QHZvXk0cn46Mks8vkU6lCVIpGnQDoPDe42KLMREdHe281nUU55xMTU1dXlpa\ruioiUnfzknH69DvcXr5DWAkplzfZ2NgAINOcobGpkSAIGBw8y+LiItPT098ODAx8ICJrALt+m9Za\rCcNQoigSY4xYa8U5J3Eci/denHNSLpelWCzK3Nyc5PN5GR4e/h54opaleciRfOi9R0Tk6ytXJvv7\r+98VkULdFxPHcRxvc5k49d6LiIj3Xowxsr6+Hg0NDX2x02kiVXvmPeTRZIBZEVmt27KP6jD9B+To\r976kkXBsAAAAJXRFWHRjcmVhdGUtZGF0ZQAyMDA5LTExLTE1VDE3OjAzOjA0LTA3OjAw16rizwAA\rACV0RVh0ZGF0ZTpjcmVhdGUAMjAxMC0wMS0yNVQwODozMDo0MS0wNzowMKms+cAAAAAldEVYdGRh\rdGU6bW9kaWZ5ADIwMTAtMDEtMTFUMDk6MjU6MTMtMDc6MDB6FIQzAAAAZ3RFWHRMaWNlbnNlAGh0\rdHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL2xpY2Vuc2VzL2J5LXNhLzMuMC8gb3IgaHR0cDovL2Ny\rZWF0aXZlY29tbW9ucy5vcmcvbGljZW5zZXMvTEdQTC8yLjEvW488YwAAACV0RVh0bW9kaWZ5LWRh\rdGUAMjAwOS0wMy0xOVQxMDo1Mjo0Ni0wNjowMHZlwxYAAAAZdEVYdFNvZnR3YXJlAHd3dy5pbmtz\rY2FwZS5vcmeb7jwaAAAAE3RFWHRTb3VyY2UAT3h5Z2VuIEljb25z7Biu6AAAACd0RVh0U291cmNl\rX1VSTABodHRwOi8vd3d3Lm94eWdlbi1pY29ucy5vcmcv7zeqywAAAABJRU5ErkJggg\x3D\x3D", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_Music, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAA3WAAAN1gGQb3mcAAAACXZwQWcAAAAWAAAAFgDcxelYAAADqklEQVQ4y4WVS0wbRxzGfzPe\r8SMGGwOBYN6IBqVtemiObSMVpYemXDg016IIiR44VLlQwYFjpRy55VSJ9JJzSZtjU6m0atRUIjS1\rWqHGvIx5hIcdg707Mz2sa6DYYaS/dqWd+fab3377HwEwNTWF1iZ8/foH70Wj0QbAUmMUi0WZTqc3\rl5aWfkkkEqWJiYmq8wTA7OwsxWLx7aGhobl4PN76OmFjjNjZ2clns9l73z96dLc9mTwYHR09M08C\rKOUgpQwrpWJBpcJKqUitCodC4Xg83tzV3T3xyc2bd1OpVGJmZqa6sDEWay3GGLQxGK1rljYGawxY\r6/T29Y0ODw9/tbCwUD89PX1WGOsL2/Iic15Zi+u6KMcJ9Pf3375169bE3NxccGxsrCLs+Lplx9Zf\raG1NxCAEQghyuRzb2zu4bknFYvEvxsfHV0ZGRu49e7bI/PxPvmNbcWzPd6s1ynG42NyMlJJMZoON\rjY1oS0vLncnJyd7BwQ+PHRt7zPhcx+WhgkGSyTbq6+sxRqO1vphOv2gKh8P/nEGhtUZrfa6wEAKB\rIOgomhIJDJaD/X2EkEgZOMnYYMt8awlLIRFC4GmPQ7fA3tEu2XyG9MsXvNn0Du2xjopOVcfVUAgE\ri9lFnqzOs5JLs55fZvNVlt1Xe+TzBb58f5r2uo6KztlU1HAsheS7P77lwcI3tMZaaKtr42r8Gj1d\rfaQ2//RNGX1W2Bg/EbUYW2EJKsXYu+MMXr5BPNJAJBQh5IS4/9vXfky1KafqlGM/9LUcW2EJBxVv\rNPTT0diJZzystbjaxdMeBoM2upyuGoxrCTtBicXiei7aaIQQSCRaGzyr0dpUYWxszVQIIQAIBCRg\r0Z7GYDjyjsjmMyxvrzDQWIcx2k/FSRTGmlOO/9uFEAJXuxyU9sgdHWCU//Kdo21+yD4kVXjKfOYp\rl+MDPuNyWziNwvhf1he2gOCguM+vuz+S1s/5e/cvBsJXscbye+YJD7fuoy4VUCFJWyyJp73yzv8X\rN2Ot3xbLKAIiwM9rj3lsHxC55FFcl4RFFNdz6bzQQzL/FoVUjs96P+ZK2xVKpVKlNZxgfPzn+awA\rAc3BVliL4u5LbkQ/orOhG1eX6Ih1cefaNMYYIqEICKoz3shmcV13dz2TeX4hEkna8tHUZFv4tO5z\rrLUkIo1sbW5WzixRvr7070Xh8HBja2t7P6jU8fNkMgkge3p6uhzHiXJisXKCCKCk3dc2J89zC8vL\rK8tg9erqGv8CLa3m9JMTKpMAAAAldEVYdGRhdGU6Y3JlYXRlADIwMTAtMDUtMjRUMDc6NDI6MjAt\rMDY6MDA8thBuAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDEwLTA1LTI0VDA3OjQyOjIwLTA2OjAwTeuo\r0gAAADV0RVh0TGljZW5zZQBodHRwOi8vY3JlYXRpdmVjb21tb25zLm9yZy9saWNlbnNlcy9MR1BM\rLzIuMS87wbQYAAAAGXRFWHRTb2Z0d2FyZQB3d3cuaW5rc2NhcGUub3Jnm+48GgAAAA90RVh0U291\rcmNlAG51b3ZlWFQy6iA23AAAACJ0RVh0U291cmNlX1VSTABodHRwOi8vbnVvdmV4dC5wd3NwLm5l\rdJGJxy0AAAAASUVORK5CYII\x3D", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_PDF, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\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\r5XEfxWXGZf5kiPg+oiDinEjMOJiRk3FYVbgFbz8WraKKKhQhhDz+R/gvNfAhtB8fUrqPjHSPFxnv\rZs8nZDwLWMACmehef9OjjVZsWbFlxRbWuS87t0q0G93oRqv6P6QktMGDfWblAAAAJXRFWHRjcmVh\rdGUtZGF0ZQAyMDA5LTExLTE1VDE3OjAzOjA0LTA3OjAw16rizwAAACV0RVh0ZGF0ZTpjcmVhdGUA\rMjAxMC0wMS0xMVQwOToyNTowOS0wNzowMGOTY18AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTAtMDEt\rMTFUMDk6MjU6MDktMDc6MDASztvjAAAAZ3RFWHRMaWNlbnNlAGh0dHA6Ly9jcmVhdGl2ZWNvbW1v\rbnMub3JnL2xpY2Vuc2VzL2J5LXNhLzMuMC8gb3IgaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcv\rbGljZW5zZXMvTEdQTC8yLjEvW488YwAAACV0RVh0bW9kaWZ5LWRhdGUAMjAwOS0wMy0xOVQxMDo1\rMjo0Ni0wNjowMHZlwxYAAAAZdEVYdFNvZnR3YXJlAHd3dy5pbmtzY2FwZS5vcmeb7jwaAAAAE3RF\rWHRTb3VyY2UAT3h5Z2VuIEljb25z7Biu6AAAACd0RVh0U291cmNlX1VSTABodHRwOi8vd3d3Lm94\reWdlbi1pY29ucy5vcmcv7zeqywAAAABJRU5ErkJggg\x3D\x3D", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_PPT, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAAN2AAADdgF91YLMAAAACXZwQWcAAAAWAAAAFgDcxelYAAADQ0lEQVQ4y7WVMWybVRCAv3vv\rz+/ETrBjxTFEwghTRR0jdaIsbIgBFsSGVFWwtF3ohiLGiKUbKyMSUhCCOZAtCRIMXSIk1CR12pTU\rjh3ixo6T37/fOwbHTho7RQj1SSfdu6f33b27ezpRVV7GCs5vROQtYO5/MteBB8EF49yzL9/9AVGM\rUUQUjCKGM1169q5NzKmIIlZ4b1E+X175ffMiGDMS49Ux9uk3+L0NbP4KJ99+NgBCug4RBQuIIOYM\rZy6CDyYLNDOvobUHdJa/Qvc3sAmHDTvYhMOEDhN6ggTY0GATIWZkDBlJQZjsIwcino43URwmf4XE\r+1+gO2vYEYcYQYwFY0EsiBnUTQCcDAcfpItY3yL7043TSxZJjCGnehfWBYkJhjioDwdn3rlBJ25z\rLEKr1Ua77QIIGIOIxRghOTZKGIZnZwjGWKKv7/pLIp7De0+tViM9nSYIAlQV7z2qinMOYwx/PH7M\r9etvIyLnKm/oqOhQ8Pj4OFG7jfOedDqNcw7vPc65PlRVmZqa6vX+v38QgCiK8N4DsLG0hGm1aNfr\rHJTL7DYaBIkEHnjzgw9xzvXB2WyWmZmZy8G9JwuQa7WYePoUH0X8qcrHCwt4kYFXeO+pVCovBqdS\rKZxz3UJms2SSSQhDyuvrVLe2aOzudqETE/1oBUgXCi9ORb1eP6vFxCtwfAzeQz6P39yiMJ0j3t/n\r7/v3ae3sYIOAyqNHZO7do9PpXA7OTU/TiWMqlQrP3ihw8GoegP0nTyiur5NYWyUxOkoqihi7dg0t\rlXjdWg6NodlsRuVyuQ7oALi6t4eIoKoQhpgw7OvJXI7wtK1OtrdxqRR/FYvI1as0Gw2+X1z8sVQq\rLanqIDifzxPHMZlMhlKp1M9ju90mLhRonPa15HKUGw1mb95k6+FD1n7+ZXl+fv6uqlaHpqJarWKM\rYXJyktnZWUQEESGKIuJslrhYBEBViZtNStvbrKys/Hrnzu1PVLVyeY5zueeK0FvJZJLDw0Ostf2W\rjOOYldXV5du3bj0H7XvuCfCRc07jONZOp6POOXXOqfdevfcax7FGUaRHR0daq9WihYWF74D8eUZP\r5PzM+4+jqQ38pqp7ww7lZQ3TfwCaHr3lMhqzqAAAACV0RVh0Y3JlYXRlLWRhdGUAMjAwOS0xMS0x\rNVQxNzowMzowNC0wNzowMNeq4s8AAAAldEVYdGRhdGU6Y3JlYXRlADIwMTAtMDEtMTFUMDk6MjU6\rMTEtMDc6MDCc1i2mAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDEwLTAxLTExVDA5OjI1OjExLTA3OjAw\r7YuVGgAAAGd0RVh0TGljZW5zZQBodHRwOi8vY3JlYXRpdmVjb21tb25zLm9yZy9saWNlbnNlcy9i\reS1zYS8zLjAvIG9yIGh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL2xpY2Vuc2VzL0xHUEwvMi4x\rL1uPPGMAAAAldEVYdG1vZGlmeS1kYXRlADIwMDktMDMtMTlUMTA6NTI6NDYtMDY6MDB2ZcMWAAAA\rGXRFWHRTb2Z0d2FyZQB3d3cuaW5rc2NhcGUub3Jnm+48GgAAABN0RVh0U291cmNlAE94eWdlbiBJ\rY29uc+wYrugAAAAndEVYdFNvdXJjZV9VUkwAaHR0cDovL3d3dy5veHlnZW4taWNvbnMub3JnL+83\rqssAAAAASUVORK5CYII\x3D", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_RBP, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAMAAADzapwJAAAAB3RJTUUH3QIKFygfvjUA/wAAAAlw\rSFlzAAAOxAAADsQBlSsOGwAAAARnQU1BAACxjwv8YQUAAAKIUExURf////j4+Orr6+Xl5fPz8/7+\r/vf39+Tk5MPDw56dnZWVlbSzs9na2v39/fb29uLj48PDwpqamYOBgpaSlZGPkXt6epCPjrm5ud3d\r3fT09OPk5JqampCNkMvJy8nIyY6Ljn18fJWUlMDAwObm5vv7++vr6769vZGRkZCOkMrIyfr6+9XT\r1bKvsrKustjV2Pr5+sfFx5+entTV1PHy8bm3uPj5+N3b3YN8gg4FDGNuZU1hUxYKFIqCiN/e3/j3\r+MbExsXExdXU1MC+wPHx8d7c3oiChxoPFwYdDEOgWqLptGPMfgN+JAAVACMWII+Hju/v7768vtfW\r17KvsZmWmBsSGQQZCUidXGPUf1bDcaDbrl+/eA2gNRewQAuBKwAQACQYIba0trWztEI4PjaDSWTW\rgF3Hd1vBdFS+bl2+dw2cMxagOxalPBexQQBmGV1QWLm3uUg8RUyuZFzEdhajPAiMK2JTXEqpYgeJ\rKlO+bZ7arFi8cwycMweHKlrAc0W4YbPkv4rSnQCUIAybMhWfOgeIKkqpYVXBcEq7ZojSmun47Nbt\r3eT36Vi+cwCWJgyeNAeIKT80PD6lV43ZoOn47tvv4qbYtaHWsd/x5eL251bAcgCCGlpLVIuHicvX\rzuX+7azhvaLXsqfZtq7ivun/8b/SxZqVl//9/bKwsf79/VhTVQUOCHKZfrTrxa3hvK3hvbTrxG+U\regMLBltVWLy6vMG/wNfS00tERwsSDXifhbbtxrXsxnWbgAsRDUpCRtbR0fv7+sC+v+3s7bSytMTC\rw9POz0E5PRMfFxEbFUM8QNbQ0sXDxbe1t7KwssXDxMG8vcbAwsrIyu3t7urq6q6srrGusezs7bWz\rte3t7RsbwKwAAAABdFJOUwBA5thmAAABV0lEQVR42mNggIGr10yuM6CDS5fPMjAYXFFFEVQ9AxQ8\rd56B4cKhi3DBg4cOMzAcOXrs+ImTDAynTvtDRDdv0WfYum37jp27du/Zu49h/wElsPByhhUrV61e\rs3bhwnXrN2zctIwhASycyDBn7rz5C6YuXDh1waLFS5Yuy4cKT5g4afKUqdOmTZ0+Y+as2Qww4YLW\rtvaOzq6u7p7evv5ShHBZUW16XX1DY1NzcQuKcFpaRWVVdVZWcQ2acHpkRiZQuBxJuBAhXIIQTkpO\rSYUIZ+fk5kGFgxiCQ0LDwiMio6JjYuPihaHecXRydnF1c/fw9PL28fWz9Q8IhASKsYmBqZm5haWV\rtY2tnb2DCkSUVVVNXUNTS1tHV0/fQMPQiBEasIxSHNJCMrIMrHLyCopKyiqwAGfl4xcQFBIWERUT\rl5DkRYoeVjZ2Dk4ubh4WZEGIUUzMLKwwDgDX0HqoxaoxqAAAAABJRU5ErkJggg\x3D\x3D", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_Script, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAA3WAAAN1gGQb3mcAAAACXZwQWcAAAAWAAAAFgDcxelYAAAEEklEQVQ4y32VwW8TRxjFf7Mz\ra+/GJE5wExpDEEQcOFSE9FRUFVSOLRcunFEViQuHqpdIcOBYiSM3rvwNkco/UNQDSCSAHQGpcYgd\rJ4DtOsbx7s7O9OD1JiVJV/q0q9Xo6X3vve8bAXD37l3i2HiXL//wfS6XGwcsRzxBEDjVanV7bW3t\rr4mJiXBxcfHQcwLg0aNHBEHwzbVr15by+fyJ/wO21oqPHz92t7a2Hv7x+PH9k8ViZ2Fh4cA5B8B1\rFY7jeK7rjrmu6zlC+OKIklJ6uVzuq5nTpxd//umn+6urqxMPHjw4HNgYi7UWYwxaa5qtFh8+fDiy\rer0eWKtmZ2cXrl+//vvKysrovXv3DgJjB8DWGKwxxHF8ZBljMMYQhiFKKXnu3Llfbty4sbi0tJS5\rdetWCqwS3QaMk7fveRhjQIhDdQ7DkHa7TavVIgxDd2ws/+vt27ff37x58+GLFy958uTPAWO7j7Ex\rZvCddHJYua7L6OgoYRiysVGj0Wjkpqamfrtz587Zq1d/3GM8ZGoSGbrdLlrrIxkP/+bzeXzfxxt0\rOFmtvit4nlc5IMVQQzeTQSrFl7BCCKy1dD9/Juj3yWQyHD9+nBHfZ6fbxREO0pH7NTZYa1LGQxNt\rwlgAURTRbDaZnJykVCpRLpVQSnHlyhVOnTrFxvv3RFojo/CgebEZON/r9dBxnDLe2dlheWWFeq3G\rd5cuEYYhO90uUkr6/T5Pnz6lVC7T6/XwvOwhqYgHrDOZDMqYVILnz59TqVQAWF5exvd9lJRIKXnz\r9i3b29tordFaE0XyiwExNs2q1hodx4RhSBAEnJ2dJZ/PA9But9ms14mNIYwiKpUKu7u7w3lPt0Gq\rsdmXin6/j7GWeq1GuVxmZmaGkZERms0mQgg8z6NQKADQarUIgmAwZNgB9mGpGCYjNoZavU59c5Ot\r7W1EYmShUGB+fp6pyUmEEHxqNnn27BmdTieJud2TwhqbpsIYg1IKrKXT6SClTEGz2Szfzs9zslhE\rSonjOJwsFrk4N4dSajCt7AM21qSMhyYAXJyb48KFC2SzWYwx+J7HsWPHCMOQSGsirQmCgPHxcXzP\rI451ynhPCmMxSdwirYljjbEWL5vFcRysMSmQVAohBCrpJoyihIw4CGz2T55SCAGr5TIbGxtYwJGS\r/u4ujUaD8+fPI4RACEEcx1Qqf/O518NxxBfmGbNP4xhrQUnJ9PQ0tVqNTMZF65hYa16+ekUQBExP\rf421UKvXWFtbS5n+J26NrS2iKGrVNzdLI75ftGAFYLGMjo1yYmqKT5+aifOG129eU3k3GJgojEAg\rrLGNVqv9j+uqvUVVLBYBnDNnzpxWSuXSW8ARKKkQjki62bsKrTXJYnIQAqJI96rV6joQr6+v8y8s\rweHk83G/dQAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxMC0wNS0yNFQwNzo0MjoyMC0wNjowMDy2EG4A\rAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTAtMDUtMjRUMDc6NDI6MjAtMDY6MDBN66jSAAAANXRFWHRM\raWNlbnNlAGh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL2xpY2Vuc2VzL0xHUEwvMi4xLzvBtBgA\rAAAZdEVYdFNvZnR3YXJlAHd3dy5pbmtzY2FwZS5vcmeb7jwaAAAAD3RFWHRTb3VyY2UAbnVvdmVY\rVDLqIDbcAAAAInRFWHRTb3VyY2VfVVJMAGh0dHA6Ly9udW92ZXh0LnB3c3AubmV0kYnHLQAAAABJ\rRU5ErkJggg\x3D\x3D", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_Text, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAA3WAAAN1gGQb3mcAAAACXZwQWcAAAAWAAAAFgDcxelYAAACx0lEQVQ4y5WUTU8TURSG3/s1\rTG0oNiomNRIksPMfGElkiWzYsCaGhA0L46YJLFiasGTHlt/QRP6AxjUYw4Zo+ZDWNhaRFDq99xwX\r88HItAVvctJZ3L7z3OecOwIA1tbW4Bz509MvX+Tz+fsAGH1Wp9OR1Wr158HBwedisRiUy+We+wQA\rbG9vo9PpPJ+bm6uMjIw8HhTMzKLZbF7U6/WtDzs7G09KpfOlpaXMPgkAxmhIKX1jTMEY40shcqJP\rKaX8fD7/8OnYWPn17OzG/v5+cXNzs3cwEYOZQUSw1uJXq4VGo9G32u02wKwnJiaW5ufn3+/u7g6v\rr69ng8FhMBOBieCc61tEBCJCEATQWqvJyck3CwsL5Uql4i0vLyfBOvIWEke/Od8HEQFC9PQcBAHO\rzs7QarUQBIEpFEberqysHC0uLm7t7X3Bp08fQ2JOERNR+BydpFcZYzA8PIwgCHB8fIJarZYfHR19\rt7q6+mxm5tU1cUxKkYaLiwtYa/sSx/oKhQKmpnLwwxM+qla/P/B9/1tGRezQeB6U1hgQCwagtYYx\rBkop/Dk/hxASUqq0YwIzJcRxE3kAsYiKiUBApDCsLDGFnW+327DODSSGENBKYWhoCL7vh0BRTnYq\rXEjteR400aBYSKVgtIaUMhnBTDARg4mTWbXWgpgHBsNaBJ0OjDHwPC9SyCD6h5hAqam4urqCc27g\rVEgpE1VKqZCauY/j9O2K57Zf46SEEAKU+l/WMXEyFUQErTXUbSpSL4lhmAmcVkFMCbG19m6OoxU3\rOyamjApiUDRuXdtN3tyXVEpopSCECFWQi05+Y9woffO0wYBvfSJBiPCCOGaQc8mnIeWYUo4d7mbh\repMQ6O24Vq+j2+22fpyefr2Xy5X4dtybDRTty8tao9H87RmTNBWlUgkA5Pj4+JjWOv8/ofGytts+\rPDw6BNgdH5/gL8NGX96P3YUKAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDEwLTA1LTI0VDA3OjQyOjIw\rLTA2OjAwPLYQbgAAACV0RVh0ZGF0ZTptb2RpZnkAMjAxMC0wNS0yNFQwNzo0MjoyMC0wNjowME3r\rqNIAAAA1dEVYdExpY2Vuc2UAaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbGljZW5zZXMvTEdQ\rTC8yLjEvO8G0GAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAAPdEVYdFNv\rdXJjZQBudW92ZVhUMuogNtwAAAAidEVYdFNvdXJjZV9VUkwAaHR0cDovL251b3ZleHQucHdzcC5u\rZXSRicctAAAAAElFTkSuQmCC", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_Unknown, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAAJhAAACYQHBMFX6AAAACXZwQWcAAAAWAAAAFgDcxelYAAAC4ElEQVQ4y6WV30tUQRTHP2fu\r/miV1AIlFNstoSWwqDCqt6iHgoXoZSHoRepFEFKQiCQKetjX+heiHvoB29NCPRaB1goVhBuahgrW\raoXrlnXXuff2sHcv++MqUgcOM8zc85nvnDNzRxzHQURCQBxo4/+sAOQcx1kPuAM7E4nExdHR0TMi\r4vwL0XEcSaVSzzOZzF3gawWsotHozt7eA4d+ra2hlCCi3FZwgOn8H1oiAbrawoi4UV4HwuEw0Wg0\rCyiAQN2qXl8Efpdsbj+dx3IcYu0RXnwssPDdZCSxmwvH2pEqcL3VgEUEpcpKlVIMP5hm4HQnR3ta\rEBGunO1m+P4Mt9NzhAxF8nhHOc6NrTZVA1biQddKNq+mVhn7VCwvJkJAKS6f7EQJPBxbQimFoZQ3\rvzHYVSwiBAMGQUPx8uMKytuJIhwsz88um2gbb7xecUMqKvCIITy7dpBw0PACRYTx6VWUCIei24mE\rAjWxG4PBgygRYh1NKBco7nZfzxQxlDCS2F0D3BRMRXEVyGtFWDNt3n4uculkF309rb5AX7Cnrh7u\r+uPxJY7sbeHquVgNsDK/YfG8j6rSIVX+7P03rp/fS8BQNeN+qn2L5+emdtjVto39Xc2bpsA/xxvA\rAT4s/OTyqa4aoGVZ3m1VSm0CFinfojpFIsLhWAvBQDnYtm0sy0Jr7cFDoRBO1T+h4bj5qbVth/Sb\rJfZ0RDja04rWmlKpVOOFQiGfTqezQNG3eNTlTkTIzhYZvjdJ8k4Wy7IolUosLy+zuLiIiJDP59eT\ryWQqn89nKuDGHPsUJt7ZxIl9rfR2N6G1RmtNoVAgHo+Ty+WswcHBG1NTU0+AL5VsNID9bEdzkPRI\rH5ZlYZomWmsMwyCXy+mhoaGbExMT96uhvsdtK2YYBqZprvb399+anJx8VA+tBttzc3M/stnsu608\rTSsrK+sDAwP35ufnn/pBAcR9TIPAfqB1S5JBAzPAkh8U4C+ZqRQt1j0xQwAAACV0RVh0Y3JlYXRl\rLWRhdGUAMjAwOS0xMS0xNVQxNzowMzowNC0wNzowMNeq4s8AAAAldEVYdGRhdGU6Y3JlYXRlADIw\rMTAtMDEtMjVUMDg6MzA6NDEtMDc6MDCprPnAAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDEwLTAxLTEx\rVDA5OjI1OjEwLTA3OjAwS/yergAAAGd0RVh0TGljZW5zZQBodHRwOi8vY3JlYXRpdmVjb21tb25z\rLm9yZy9saWNlbnNlcy9ieS1zYS8zLjAvIG9yIGh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL2xp\rY2Vuc2VzL0xHUEwvMi4xL1uPPGMAAAAldEVYdG1vZGlmeS1kYXRlADIwMDktMDMtMTlUMTA6NTI6\rNDYtMDY6MDB2ZcMWAAAAGXRFWHRTb2Z0d2FyZQB3d3cuaW5rc2NhcGUub3Jnm+48GgAAABN0RVh0\rU291cmNlAE94eWdlbiBJY29uc+wYrugAAAAndEVYdFNvdXJjZV9VUkwAaHR0cDovL3d3dy5veHln\rZW4taWNvbnMub3JnL+83qssAAAAASUVORK5CYII\x3D", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_WAV, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAAN2AAADdgF91YLMAAAACXZwQWcAAAAWAAAAFgDcxelYAAADlElEQVQ4y7WVzWsdVRjGf2fO\rnTs3nUTS3CQEEoVgaCQgtGDQu3AhBrQIIm76Fwh2U6EguHDZnQsRXKn9BwpuXIrECNogJJpEb5EE\rJLFtEm3SkNyPuXO+XhfJvUlsbkDEFw5zzjDndx6e95kZJSL8H1VoT5RSY8DT/5F3X0QenAIDY81m\rdtdai1KAUiilUBzNT16P1Rwr1JpisVgBngCrWr2ONQZd0ABorRERlFIYY+jr60NCoFQqobXGh0Cr\r1cJ7T5IkwPG5J8G0sgwB4mKMcw5rLaVSiYv9/aBg9dEqP/25wG/7S9w/+J3PX79DFEXU63UKhVOo\r02AfPNZa0vQCCrDWMjY6yhufXeVxtMOP24tce+EtBpJ+dhs1rLdYa0GE4H13cKvVQkSIogiUwjuH\rVzkLu3f58NVbfHT1Yy4PX0YVc6Y+mUQrTdZsclayopMLawwSAkopJASMMThyBstPcePFG0wPTrP6\ryyoKRUkXAcjzHGPMofJuikMIOOeIjrrdaDRQKHp0AsDOzg7OOTSKJCoBYIxBRDDGdAc75wghYJ1D\rKUWtVkOhuKB7ANja2kJrTYTuHGaMYX9/v52Ks8EC7O3tca9apZllPN7dRYmiGB1uajab9Pb2krmc\rus0BWF9fxznH8PBwd48VUEwSxsfHeW5ykjRNMcFxYJoADA4OkiQJLWeou8N75XK5k+uuiguFAr1p\rSrlcplarMTIygvGWA9MAYGhoiBACmW9SNxkAxWKR0dHR88FxHBNpjVKKOI65dOkSJrSoHUHKQwN8\ruX2b2dnvqe+0AEjTlFKpRJqm3a1I05RSkqC1pu9iylfN29z6+gP2HtYAuLk2QxwLc4/u8Ew2QkEX\rGBgYIIoienp62m0624ooiojjmPfWXmEh+4693SK9B4fRGoqH+WL3JleefZ63x9+n+muVEIQQPJub\rm9vAX8dJEGm/OZXNrS05qNXEey+fbr8rby6PyLVvKzJ77xvZ2NiQdq2trUkIQUII4r2XpaWfs6mp\rqek2S0ROg7MskyzLxBgj3vsOyHsv1WpVQghijJHFxcUOdGVl2VQqlZdPQp8A53kuWZZJnudijBFr\rrTjnxHsvjUZDQgiSZZnMz8+L916Wl5fMzMzMa/+Eishpj8+ro+bgvSeKIlZWllvXr78zMz+/8MOZ\rG04ofsk511HZVuq97/jZtmJubu7BxMTElbOUtodqf/L+5T/voYj8cd4DfwN9pF2yl1YnnwAAACV0\rRVh0Y3JlYXRlLWRhdGUAMjAwOS0xMS0xNVQxNzowMzowNC0wNzowMNeq4s8AAAAldEVYdGRhdGU6\rY3JlYXRlADIwMTAtMDEtMTFUMDk6MjU6MDYtMDc6MDCV2xO2AAAAJXRFWHRkYXRlOm1vZGlmeQAy\rMDEwLTAxLTExVDA5OjI1OjA2LTA3OjAw5IarCgAAAGd0RVh0TGljZW5zZQBodHRwOi8vY3JlYXRp\rdmVjb21tb25zLm9yZy9saWNlbnNlcy9ieS1zYS8zLjAvIG9yIGh0dHA6Ly9jcmVhdGl2ZWNvbW1v\rbnMub3JnL2xpY2Vuc2VzL0xHUEwvMi4xL1uPPGMAAAAldEVYdG1vZGlmeS1kYXRlADIwMDktMDMt\rMTlUMTA6NTI6NDYtMDY6MDB2ZcMWAAAAGXRFWHRTb2Z0d2FyZQB3d3cuaW5rc2NhcGUub3Jnm+48\rGgAAABN0RVh0U291cmNlAE94eWdlbiBJY29uc+wYrugAAAAndEVYdFNvdXJjZV9VUkwAaHR0cDov\rL3d3dy5veHlnZW4taWNvbnMub3JnL+83qssAAAAASUVORK5CYII\x3D", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_XLS, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAAN2AAADdgF91YLMAAAACXZwQWcAAAAWAAAAFgDcxelYAAADSElEQVQ4y7WVvW8jVRDAf/Pe\rem1nnfWZXBJocgqJrojEKU2gAf6Gk6iRrqBFJAVNChqUgoo28AdQIQpOQoqEUK5AgERHh5CSiHDk\rYkIc2/Hau++9ofAHVj5OQuhWmtXMrN7vzc6HRlSVF/FE04aIrADr/5P5C/BrdMW5/vYnj74UqxgD\r1ipDXRED1oIYxYx8xjLSGdoRHH16tPn9kx9/uwomrjpUHW/df52NpQcszy3x4TcfYc0IYMeXjC8F\ricAKRMYCFgBzFbySLnDvzhxvLL/GZz9/zu+dIyrVQHlmSmqByoxSqRiqsWXGRlRtTMWUbs4xQDP+\rAwi8eneJ9998j3t3lijP+GFqjMViEBGsGAyCEcEwso25HbycvEJBn49/2B4dNFRKJSIRBIMdwcYg\rK4LBYAAjzwE/XH+Izx0q/AsQQcwwUpERxBgEEIYvQbDGsl98EG4Er5TuE2zg+PiYJEl4ltVohZe4\rW+njun+yWLdkWUZcrQKQ5zlxHAOwtraGjgbjGrhWqzHIc/7K5+jamJNLy8rLnlgMhbfUajVEhCRJ\rEBGyLKNareK9v31AAAaDASEEmq5BuR/Rz/4m9gWVcgmRgnq9joiQpukQEEUkSUKv10NEbgeHEFBV\rHtSPmJ2dxc05VldXAXj61JGmKSEE6vX6sF+NmfieG3GSJHjvKYqCfr+P955OpzOJpt1uc3l5SRQN\rj3a7XVSVLMtoNBq3g1ut1iTycfQhBERkok9LnudEUURRFDjnJpxrkze/sECj0cCYYZ+KCNbaiR1F\rEdYOx9Z7P/m7PM/pdruDk5OTFqDXJ+/0FBGhVCpRqVTw3k8KFUIgTVOKoqBcLuOc4+zsjDRNGQwG\ruru7+9XBwcGequq1iBcXF2k0GpMc9/t92u02nU6HXq830c/Pzzk8PGJjY4NSqcT+/pNvt7e3t1S1\reWOOm80mxhjiOKZcLpPn+aTi3nucczjnEBGiyHJ4eMje3t53W1ub76rqs1uLNz8/j3OOLMtI05SL\ri4truR53iDFGv378eG9rc/PRNBQAVZ0I8I73XouiUOeceu/Ve68hBA0hqKpqCEHzPNdWqzXY2dn5\rAlicZoxFpnfef1xNOfCTqp7e9FFe1DL9B8uMrvP98FXPAAAAJXRFWHRjcmVhdGUtZGF0ZQAyMDA5\rLTExLTE1VDE3OjAzOjA0LTA3OjAw16rizwAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxMC0wMS0xMVQw\rOToyNTowNS0wNzowMKQzCSsAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTAtMDEtMTFUMDk6MjU6MDUt\rMDc6MDDVbrGXAAAAZ3RFWHRMaWNlbnNlAGh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL2xpY2Vu\rc2VzL2J5LXNhLzMuMC8gb3IgaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbGljZW5zZXMvTEdQ\rTC8yLjEvW488YwAAACV0RVh0bW9kaWZ5LWRhdGUAMjAwOS0wMy0xOVQxMDo1Mjo0Ni0wNjowMHZl\rwxYAAAAZdEVYdFNvZnR3YXJlAHd3dy5pbmtzY2FwZS5vcmeb7jwaAAAAE3RFWHRTb3VyY2UAT3h5\rZ2VuIEljb25z7Biu6AAAACd0RVh0U291cmNlX1VSTABodHRwOi8vd3d3Lm94eWdlbi1pY29ucy5v\rcmcv7zeqywAAAABJRU5ErkJggg\x3D\x3D", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = MIMEIcon_XML, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\x2CiVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\rWXMAAAN2AAADdgF91YLMAAAACXZwQWcAAAAWAAAAFgDcxelYAAADGElEQVQ4y7WVz2skRRSAv9fV\r1TMxIW52UVbZPQjRlSiCuELiD7ytKHhR/wdZr/EP8O5NPIsH0YOgR0EUAoFZ42ISMCMqCqJRWQ+B\rTGa6u7qr6nnI9GR6J5tFxIKiq6nqr7736nW3qCr/R0ubgYhcAi7/R97vqrrfAgOX8rzo1XWNCCCC\riCCMx9PXE5sTQ2PIsmwNmAFL6RyDwYCjowFpmpIkCSKCxogZ36NKp9ulcg6bZaRpSpZldLtd4GTf\raTCJCJ1Oh7m5+yfQmd6YLyy0jEVasbTBkggheAaHQ2KMnL9wgSzLWlARaaWm0TwbLEKapswvLGCM\rIXhPDagqaZrS6XRmwA0uuRu42Tl4jw+BxBhMkhBjnKRnGtisv6uxtZZOlhFVj0McwxojVUVjxFrL\r7c+2zqs1Oe4+BBg5/Idbx2aqiAj1t79Sf/wNIkL5yU38UYGO584ET2r3x1v49zawVy6SGIO1FuOV\r+NUPZNceO47g8nnKd78kfP/nDHTWWARJEsL7PbqvXyV77hEya0nTlPqLPubRB0gvnsNaS/eZh5l7\r7SpH73x+d+OmbDpvvED92Tb+xi+ICPHWgKr3M3MvPzGBVJs/Mfpgk3vXX+K01jq8JhVm5UHsQ/dR\rfboNz18h/+gG3RcfR+7pTMzqvX3Ovf0qyUL3VLA0XzcRWSvLsue9n1gZY05K7JTSijESY0RVMcaQ\rpumaqn49awx47xkOh8e1HAIxRhYXF3HOYYzBGEOe51RVRVmWeB8wJmE4HP4F/D0BqSpj67XSOc2L\rQoui0NFopKPRSPM81zzPtSgKrapKnXO6u7urMUaNMWoIQXd3d4qVlZWnG5aq3vaCAHVVcXh4OAnP\rWov3HlVlfn6esiw5ODiYSPX7e/X1629e6/f7N+98eIC1lqWlpVaeRYQkSQghYK0lyzJUlb297+r1\r9bde6fV6mzOnN50K55wWRaHOOXXOaV3X6r3XEMIk9OFwqFtbW7qzs12srj717HT4030avOq9n8Aa\r4DQ0xqhVVenGxsb+8vLyk3eCqmqr3P7NP+8PVf3trAX/AMqU0uEnPkl+AAAAJXRFWHRjcmVhdGUt\rZGF0ZQAyMDA5LTExLTE1VDE3OjAzOjA0LTA3OjAw16rizwAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAx\rMC0wMS0xMVQwOToyNTowMS0wNzowMFB8LTgAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTAtMDEtMTFU\rMDk6MjU6MDEtMDc6MDAhIZWEAAAAZ3RFWHRMaWNlbnNlAGh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMu\rb3JnL2xpY2Vuc2VzL2J5LXNhLzMuMC8gb3IgaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbGlj\rZW5zZXMvTEdQTC8yLjEvW488YwAAACV0RVh0bW9kaWZ5LWRhdGUAMjAwOS0wMy0xOVQxMDo1Mjo0\rNi0wNjowMHZlwxYAAAAZdEVYdFNvZnR3YXJlAHd3dy5pbmtzY2FwZS5vcmeb7jwaAAAAE3RFWHRT\rb3VyY2UAT3h5Z2VuIEljb25z7Biu6AAAACd0RVh0U291cmNlX1VSTABodHRwOi8vd3d3Lm94eWdl\rbi1pY29ucy5vcmcv7zeqywAAAABJRU5ErkJggg\x3D\x3D", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = SadMan, Type = String, Dynamic = False, Default = \"data:image/png;charset\x3DUS-ASCII;base64\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\rAAAAAElFTkSuQmCC\r\r\r", Scope = Private
	#tag EndConstant

	#tag Constant, Name = Severity_Caution, Type = Double, Dynamic = False, Default = \"1", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Severity_Debug, Type = Double, Dynamic = False, Default = \"-1", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Severity_Normal, Type = Double, Dynamic = False, Default = \"0", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = VerboseErrors, Type = Boolean, Dynamic = False, Default = \"False", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Address"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowDirectoryIndexPages"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Authenticate"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="KeepListening"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastHTTPCode"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LogLevel"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Port"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InheritedFrom="TCPSocket"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
