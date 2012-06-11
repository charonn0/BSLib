#tag Module
Protected Module AudioFeedback
	#tag Method, Flags = &h1
		Protected Sub Beep(freq As Integer, duration As Integer)
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

	#tag Method, Flags = &h21
		Private Sub Beeper(type As Integer)
		  Declare Function MessageBeep Lib "User32" (type As Integer) As Boolean
		  Call MessageBeep(type)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Beep_Asterisk()
		  Beeper(MB_ICONASTERISK)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Beep_Error()
		  Beeper(MB_ICONERROR)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Beep_Exclamation()
		  Beeper(MB_ICONEXCLAMATION)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Beep_Generic()
		  Beeper(&hFFFFFFFF)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Beep_Hand()
		  Beeper(MB_ICONHAND)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Beep_Information()
		  Beeper(MB_ICONINFORMATION)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Beep_OK()
		  Beeper(MB_OK)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Beep_Question()
		  Beeper(MB_ICONQUESTION)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Beep_Stop()
		  Beeper(MB_ICONSTOP)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Beep_Warning()
		  Beeper(MB_ICONWARNING)
		End Sub
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
