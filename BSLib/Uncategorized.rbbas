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
