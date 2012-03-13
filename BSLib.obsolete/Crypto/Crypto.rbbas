#tag Module
Protected Module Crypto
	#tag Method, Flags = &h0
		Function RC4(strData As String, strKey As String) As String
		  //Credit: http://forums.realsoftware.com/viewtopic.php?f=1&t=19930
		  //Encodes or decodes the strData string with the RC4 symmetric ciper, using the strKey as the key.
		  //On success, returns the En/Decoded string. On error, returns an empty string.
		  
		  Dim MM As MemoryBlock = strData
		  Dim MM2 As New MemoryBlock(LenB(strData))
		  Dim memAsciiArray(255), memKeyArray(255), memJump, memTemp, memY, intKeyLength, intIndex, intT, intX As integer
		  
		  intKeyLength = len(strKey)
		  
		  For intIndex = 0 to 255
		    memKeyArray(intIndex) = asc(mid(strKey, ((intIndex) mod (intKeyLength)) + 1, 1))
		  next
		  
		  For intIndex = 0 to 255
		    memAsciiArray(intIndex) = intIndex
		  next
		  
		  For intIndex = 0 to 255
		    memJump = (memJump + memAsciiArray(intIndex) + memKeyArray(intIndex)) mod 256
		    memTemp = memAsciiArray(intIndex)
		    memAsciiArray(intIndex) = memAsciiArray(memJump)
		    memAsciiArray(memJump) = memTemp
		  next
		  
		  intIndex = 0
		  memJump = 0
		  
		  For intX = 1 to MM2.Size
		    intIndex = (intIndex + 1) mod 256
		    memJump = (memJump + memAsciiArray(intIndex)) mod 256
		    intT = (memAsciiArray(intIndex) + memAsciiArray(memJump)) mod 256
		    memTemp = memAsciiArray(intIndex)
		    memAsciiArray(intIndex) = memAsciiArray(memJump)
		    memAsciiArray(memJump) = memTemp
		    memY = memAsciiArray(intT)
		    mm2.Byte(intX - 1) = bitwise.bitxor(val("&h" + hex(MM.byte(IntX - 1))), bitwise.bitxor(memTemp,memY))
		  next
		  
		  return MM2
		  
		Exception
		  Return ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XorWith(Extends input As MemoryBlock, xorBy As MemoryBlock) As MemoryBlock
		  //XOR's the passed MemoryBlocks
		  
		  If input.Size <> xorBy.Size Then
		    Return Nil
		  End If
		  
		  For i As Integer = 0 To input.Size - 1
		    Dim in1, in2, out As Integer
		    in1 = input.Byte(i)
		    in2 = xorBy.Byte(i)
		    out = BitwiseXor(in1, in2)
		    input.Byte(i) = out
		  Next
		  
		  Return input
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function XorWith(Extends input As String, xorBy As String) As String
		  //Xors the passed strings
		  Dim mb1 As New MemoryBlock(input.LenB)
		  Dim mb2 As New MemoryBlock(input.LenB)
		  mb1.StringValue(0, mb1.Size) = input
		  While input.LenB > xorBy.LenB
		    xorBy = xorBy + xorBy
		  Wend
		  mb2.StringValue(0, mb2.Size) = xorBy
		  
		  Return mb1.XorWith(mb2).StringValue(0, mb1.Size)
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
