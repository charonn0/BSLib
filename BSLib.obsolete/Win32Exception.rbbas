#tag Class
Protected Class Win32Exception
Inherits RuntimeException
	#tag Method, Flags = &h1000
		Sub Constructor(Win32ErrorNumber As Integer)
		  #If TargetWin32 Then
		    Declare Function FormatMessageW Lib "Kernel32" (dwFlags As Integer, lpSource As Integer, dwMessageId As Integer, dwLanguageId As Integer, lpBuffer As ptr, _
		    nSize As Integer, Arguments As Integer) As Integer
		    
		    Me.ErrorNumber = Win32ErrorNumber
		    Dim buffer As New MemoryBlock(2048)
		    If FormatMessageW(FORMAT_MESSAGE_FROM_SYSTEM, 0, Me.ErrorNumber, 0 , Buffer, Buffer.Size, 0) <> 0 Then
		      Me.Message = Buffer.WString(0)
		    Else
		      Me.Message = "An unknown error was reported by Win32. Error number: " + Str(Me.ErrorNumber)
		    End If
		  #Else
		    Me.Message = "Win32 API calls cannot be used on this platform."
		    Me.ErrorNumber = -1
		  #endif
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="ErrorNumber"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="RuntimeException"
		#tag EndViewProperty
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
			Name="Message"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="RuntimeException"
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
