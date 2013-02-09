#tag Class
Protected Class App
Inherits Application
	#tag Event
		Sub Open()
		  Call MsgBox("Hello :-)", 64, "BSLib")
		  
		  Dim f As FolderItem = GetSaveFolderItem("", "test.log")
		  Dim log As New CircularLog(f, 1024, 4096)
		  For i As Integer = 0 To 500
		    log.WriteLine("Hello.")
		  Next
		  log.Close
		  f.Launch
		  Break
		  f.Delete
		  Quit
		  
		End Sub
	#tag EndEvent


	#tag Constant, Name = kEditClear, Type = String, Dynamic = False, Default = \"&Delete", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"&Delete"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"&Delete"
	#tag EndConstant

	#tag Constant, Name = kFileQuit, Type = String, Dynamic = False, Default = \"&Quit", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"E&xit"
	#tag EndConstant

	#tag Constant, Name = kFileQuitShortcut, Type = String, Dynamic = False, Default = \"", Scope = Public
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Cmd+Q"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"Ctrl+Q"
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
