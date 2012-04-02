#tag Module
Protected Module Explorer
	#tag Method, Flags = &h21
		Private Function ShellGetSettings() As SHELLFLAGSTATE
		  
		  #If TargetWin32 Then
		    Declare Sub SHGetSettings Lib "Shell32" (ByRef flagStruct As SHELLFLAGSTATE, flags As Integer)
		    Dim info As SHELLFLAGSTATE
		    Const AllFlags = &h7FFFBF
		    SHGetSettings(info, AllFlags)
		    Return info
		  #endif
		  
		  
		  
		  
		  'Const SSF_SHOWALLOBJECTS = &h00000001
		  'Const SSF_SHOWEXTENSIONS = &h00000002
		  'Const SSF_HIDDENFILEEXTS = &h00000004
		  'Const SSF_SERVERADMINUI = &h00000004
		  'Const SSF_SHOWCOMPCOLOR = &h00000008
		  'Const SSF_SORTCOLUMNS = &h00000010
		  'Const SSF_SHOWSYSFILES = &h00000020
		  'Const SSF_DOUBLECLICKINWEBVIEW = &h00000080
		  'Const SSF_SHOWATTRIBCOL = &h00000100
		  'Const SSF_DESKTOPHTML = &h00000200
		  'Const SSF_WIN95CLASSIC = &h00000400
		  'Const SSF_DONTPRETTYPATH = &h00000800
		  'Const SSF_SHOWINFOTIP = &h00002000
		  'Const SSF_MAPNETDRVBUTTON = &h00001000
		  'Const SSF_NOCONFIRMRECYCLE = &h00008000
		  'Const SSF_HIDEICONS = &h00004000
		  'Const SSF_FILTER = &h00010000
		  'Const SSF_WEBVIEW = &h00020000
		  'Const SSF_SHOWSUPERHIDDEN = &h00040000
		  'Const SSF_SEPPROCESS = &h00080000
		  'Const SSF_NONETCRAWLING = &h00100000
		  'Const SSF_STARTPANELON = &h00200000
		  'Const SSF_SHOWSTARTPAGE = &h00400000
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //Returns True if Windows Explorer is set to open files when double clicked (as opposed to single-click)
			  #If TargetWin32 Then
			    Return ShellGetSettings.DoubleClickInWebView
			  #endif
			End Get
		#tag EndGetter
		Protected ConfirmDelete As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //Returns True if Windows Explorer is set to use the "Windows classic" UI.
			  #If TargetWin32 Then
			    Return Not ShellGetSettings.HideIcons
			  #endif
			End Get
		#tag EndGetter
		Protected DesktopIconsHidden As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //Returns True if Windows Explorer is set to request confirmation when emptying the Recycle Bin
			  #If TargetWin32 Then
			    Return Not ShellGetSettings.NoConfirmRecycle
			  #endif
			End Get
		#tag EndGetter
		Protected DoubleClickOpens As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //Returns True if Windows Explorer is set to use the "Windows classic" UI.
			  #If TargetWin32 Then
			    Return ShellGetSettings.Win95Classic
			  #endif
			End Get
		#tag EndGetter
		Protected ExplorerIsInClassicMode As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //Returns True if Windows Explorer is set to show all files.
			  #If TargetWin32 Then
			    Return ShellGetSettings.ShowAllObjects
			  #endif
			End Get
		#tag EndGetter
		Protected ExplorerShowsAll As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //Returns True if Windows Explorer is set to use a web page as its desktop.
			  #If TargetWin32 Then
			    Return ShellGetSettings.DesktopHTML
			  #endif
			End Get
		#tag EndGetter
		Protected HsActiveDesktop As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //Returns True if Windows Explorer is set to show all file extensions.
			  #If TargetWin32 Then
			    Return ShellGetSettings.ShowExtensions
			  #endif
			End Get
		#tag EndGetter
		Protected ShowAllExtensions As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //Returns True if Windows Explorer is set to show filenames in a different color if the file
			  //is encrypted or compressed.
			  #If TargetWin32 Then
			    Return ShellGetSettings.ShowSystemFiles
			  #endif
			End Get
		#tag EndGetter
		Protected ShowColoredNames As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //Returns True if Windows Explorer is set to show system files.
			  #If TargetWin32 Then
			    Return ShellGetSettings.ShowSystemFiles
			  #endif
			End Get
		#tag EndGetter
		Protected ShowSystemFiles As Boolean
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
