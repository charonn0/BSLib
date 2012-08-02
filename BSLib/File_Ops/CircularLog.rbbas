#tag Class
Protected Class CircularLog
Implements Readable, Writeable
	#tag Method, Flags = &h1000
		Sub Constructor(file As FolderItem, readwrite As Boolean = True)
		  If file.Exists Then
		    IOStream = BinaryStream.Open(file, readwrite)
		  Else
		    IOStream = BinaryStream.Create(file, False)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EOF() As Boolean
		  // Part of the Readable interface.
		  Return False
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Flush()
		  // Part of the Writeable interface.
		  IOStream.Flush()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Read(Count As Integer, encoding As TextEncoding = Nil) As String
		  // Part of the Readable interface.
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
		Function ReadError() As Boolean
		  // Part of the Readable interface.
		  Return IOStream.ReadError()
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Write(text As String)
		  // Part of the Writeable interface.
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
		Function WriteError() As Boolean
		  // Part of the Writeable interface.
		  Return IOStream.WriteError()
		End Function
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

	#tag Property, Flags = &h0
		MaxLength As UInt64
	#tag EndProperty


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
End Class
#tag EndClass
