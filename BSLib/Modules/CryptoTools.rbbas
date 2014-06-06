#tag Module
Protected Module CryptoTools
	#tag Method, Flags = &h0
		Function Adler32(Data As MemoryBlock) As UInt32
		  ' https://en.wikipedia.org/wiki/Adler-32
		  Const adler = 65521
		  Dim a, b As UInt32
		  a = 1
		  
		  For i As Integer = 0 To Data.Size - 1
		    a = (a + Data.Byte(i)) Mod adler
		    b = (b + a) Mod adler
		  Next
		  
		  Return ShiftLeft(b, 16) Or a
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HashData(provider as Integer, data as String, ByRef handle as Integer, algorithm As Integer) As MemoryBlock
		  #If TargetWin32 Then
		    Const HP_HASHVAL = &h0002  // Hash value
		    Const HP_HASHSIZE = &h0004  // Hash value size
		    
		    Dim hashHandle as Integer
		    If Not CryptCreateHash(provider, algorithm, 0, 0, hashHandle) Then
		      Return Nil
		    End If
		    Dim dataPtr As New MemoryBlock(Len(data))
		    dataPtr = data
		    If Not CryptHashData(hashHandle, dataPtr, dataPtr.Size, 0) Then
		      Return Nil
		    End If
		    Dim size as Integer = 4
		    Dim toss As New MemoryBlock(4)
		    If Not CryptGetHashParam(hashHandle, HP_HASHSIZE, toss, size, 0) Then
		      Return Nil
		    End If
		    size = toss.UInt32Value(0)
		    Dim hashValue As New MemoryBlock(size)
		    If Not CryptGetHashParam(hashHandle, HP_HASHVAL, hashValue, size, 0) Then
		      Return Nil
		    End If
		    handle = hashHandle
		    
		    Return hashValue
		  #endif
		End Function
	#tag EndMethod

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
		Attributes( deprecated = "Crypto.Hash" )  Function Win32Hash(data As String, algorithm As Integer) As String
		  //Hashes the data string using the specified hash algorithm (see the constants for this Module for available algorithms.)
		  //Returns a hex-formatted string of the binary hash
		  
		  #If TargetWin32 Then
		    Dim hashHandle As Integer
		    Dim hashPtr As MemoryBlock = HashData(baseCryptoProvider, data, hashHandle, algorithm)
		    If hashPtr = Nil Then Return ""
		    Dim ret As String = EncodeHex(hashPtr.StringValue(0, hashPtr.Size))
		    CryptDestroyHash(hashHandle)
		    Return ret
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( deprecated )  Function XorData(Extends input As MemoryBlock, xorBy As MemoryBlock) As MemoryBlock
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


	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  //Returns 0 on error, positive integer on success
			  //For use with certain algorithms
			  
			  #If TargetWin32 Then
			    Static provider As Integer
			    
			    If provider = 0 Then
			      If Not CryptAcquireContext(provider, 0, MS_DEF_PROV, PROV_RSA_FULL, 0) Then
			        If Not CryptAcquireContext(provider, 0, MS_DEF_PROV, PROV_RSA_FULL, CRYPT_NEWKEYSET) Then
			          Return 0
			        End If
			      End If
			    end if
			  #endif
			  
			  Return provider
			End Get
		#tag EndGetter
		Private AESProvider As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  //Returns 0 on error, positive integer on success
			  
			  #If TargetWin32 Then
			    Static provider As Integer
			    
			    If provider = 0 Then
			      If Not CryptAcquireContext(provider, 0, MS_DEF_PROV, PROV_RSA_FULL, 0) Then
			        If Not CryptAcquireContext(provider, 0, MS_DEF_PROV, PROV_RSA_FULL, CRYPT_NEWKEYSET) Then
			          Return 0
			        End If
			      End If
			    end if
			  #endif
			  
			  Return provider
			End Get
		#tag EndGetter
		Private baseCryptoProvider As Integer
	#tag EndComputedProperty


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
