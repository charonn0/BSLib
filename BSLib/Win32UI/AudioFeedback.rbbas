#tag Module
Protected Module AudioFeedback
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


End Module
#tag EndModule
