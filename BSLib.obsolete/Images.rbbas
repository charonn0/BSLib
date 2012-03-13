#tag Module
Protected Module Images
	#tag Method, Flags = &h0
		Function ColorToHex(Extends c As Color) As String
		  //Converts a Color to a hex string.
		  //This function should be cross-platform safe.
		  
		  Dim ret As String
		  
		  If Hex(c.red).len = 1 Then
		    ret = ret + "0" + Hex(c.red)
		  Else
		    ret = ret + Hex(c.red)
		  End If
		  
		  If Hex(c.green).len = 1 Then
		    ret = ret + "0" + Hex(c.green)
		  Else
		    ret = ret + Hex(c.green)
		  End If
		  
		  If Hex(c.blue).len = 1 Then
		    ret = ret + "0" + Hex(c.blue)
		  Else
		    ret = ret + Hex(c.blue)
		  End If
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DefaultIconForFileType(extension As String, size As Integer = 32) As Picture
		  Declare Function SHGetFileInfoW Lib "shell32" (path As WString, attribs As Integer, ByRef info As SHFILEINFO, infosize As Integer, flags As Integer) As Boolean
		  Declare Function DrawIconEx Lib "user32" ( hDC As Integer, xLeft As Integer, yTop As Integer, hIcon As Integer, cxWidth As Integer, cyWidth As Integer, istepIfAniCur As Integer, _
		  hbrFlickerFreeDraw As Integer, diFlags As Integer ) As Integer
		  Declare Function DestroyIcon Lib "user32" ( hIcon As Integer ) As Integer
		  
		  Const FILE_ATTRIBUTE_NORMAL = &h80
		  Const SHGFI_USEFILEATTRIBUTES = &h000000010
		  Const SHGFI_DISPLAYNAME = &h000000200
		  Const SHGFI_TYPENAME = &h000000400
		  Const SHGFI_ICON = &h000000100
		  
		  Dim info As SHFILEINFO
		  If SHGetFileInfoW("foo." + extension, FILE_ATTRIBUTE_NORMAL, info, info.Size, SHGFI_DISPLAYNAME Or SHGFI_TYPENAME Or SHGFI_USEFILEATTRIBUTES Or SHGFI_ICON) Then
		    Dim theIcon As Picture = New Picture(size, size, 32)
		    theIcon.Transparent = 1
		    Call DrawIconEx(theIcon.Graphics.Handle(1), 0, 0, info.hIcon, size, size, 0, 0, &H3)
		    Call DestroyIcon(info.hIcon)
		    Return theIcon
		  Else
		    Return Nil
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GreyScale(p As Picture)
		  //Converts the passed Picture to greyscale.
		  //Can take a few seconds on very large Pictures
		  //This function was *greatly* optimized by user 'doofus' on the RealSoftware forums:
		  //http://forums.realsoftware.com/viewtopic.php?f=1&t=42327&sid=4e724091fc9dd70fd5705110098adf67
		  //This function should be cross-platform safe.
		  
		  If p = Nil Then Raise New NilObjectException
		  Dim w As Integer = p.Width
		  Dim h As Integer = p.Height
		  Dim surf As RGBSurface = p.RGBSurface
		  
		  If surf = Nil Then Raise New NilObjectException
		  
		  Dim greyColor(255) As Color //precompute the 256 grey colors
		  For i As Integer = 0 To 255
		    greyColor(i) = RGB(i, i, i)
		  Next
		  
		  Dim X, Y, intensity As Integer, c As Color
		  For X = 0 To w
		    For Y = 0 To h
		      c = surf.Pixel(X, Y)
		      intensity = c.Red * 0.30 + c.Green * 0.59 + c.Blue * 0.11
		      surf.Pixel(X, Y) = greyColor(intensity) //lookup grey
		    Next
		  Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IconToPicture(Resource as FolderItem, Index As Integer, pixSize As Integer = 0) As Picture
		  //Extracts the specified Icon resource into a RB Picture. Returns Nil on error.
		  //Icons are located in EXE, DLL, etc. type files, and are referenced by their index.
		  
		  #If TargetWin32 Then
		    Declare Function ExtractIconExW Lib "Shell32" ( lpszFile As WString, ByVal nIconIndex As Integer, phiconLarge As ptr, phiconSmall As ptr, ByVal nIcons As Integer ) As Integer
		    Declare Function DrawIconEx Lib "User32" (hDC As Integer, xLeft As Integer, yTop As Integer, hIcon As Integer, cxWidth As Integer, cyWidth As Integer, istepIfAniCur As Integer, _
		    hbrFlickerFreeDraw As Integer, diFlags As Integer) As Integer
		    Declare Function DestroyIcon Lib "User32" (hIcon As Integer) As Integer
		    
		    Dim theIcon As Picture = New Picture(pixsize, pixsize, 32)
		    theIcon.Transparent = 1
		    
		    Dim small As New MemoryBlock(4)
		    Dim large As New MemoryBlock(4)
		    Try
		      Call ExtractIconExW(resource.AbsolutePath, Index, large, small, 1)
		      Call DrawIconEx(theIcon.Graphics.Handle(1), 0, 0, large.Long(0), pixsize, pixsize, 0, 0, &h3)
		    Catch
		      Call DestroyIcon(small.Long(0))
		      Call DestroyIcon(large.Long(0))
		      Return Nil
		    End Try
		    Call DestroyIcon(small.Long(0))
		    Call DestroyIcon(large.Long(0))
		    Return theIcon
		  #endif
		  
		Exception
		  Return theIcon
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IntToColor(extends c as Integer) As Color
		  //From WFS, converts an Integer to a Color
		  //This function should be cross-platform safe.
		  Dim mb as new MemoryBlock(4)
		  mb.Long(0) = c
		  Return RGB(mb.Byte(0), mb.Byte(1), mb.Byte(2))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Scale(Source As Picture, Ratio As Double = 1.0) As Picture
		  //Returns a scaled version of the passed Picture object.
		  //A ratio of 1.0 is 100% (no change,) 0.5 is 50% (half size) and so forth.
		  //This function should be cross-platform safe.
		  
		  Dim wRatio, hRatio As Double
		  wRatio = (Ratio * Source.width)
		  hRatio = (Ratio * Source.Height)
		  If wRatio = Source.Width And hRatio = Source.Height Then Return Source
		  Dim photo As New Picture(wRatio, hRatio, Source.Depth)
		  Photo.Graphics.DrawPicture(Source, 0, 0, Photo.Width, Photo.Height, 0, 0, Source.Width, Source.Height)
		  Return photo
		  
		Exception
		  Return Source
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SelectIcon(IconResource As FolderItem, DefaultIndex As Integer = 0, pixSize As Integer = 0, Optional parentWindow As Window) As Picture
		  //This function will not compile in a ConsoleApplication
		  //
		  //This function will show a Icon Selection dialog to the user. If the user selects an icon, a REALbasic Picture is returned containing the icon.
		  //Otherwise, returns Nil.
		  //Icons are stored in Windows PE images (executables) as accessible resources. You must specify a FolderItem which points to a
		  //.exe, .dll, .scr, .pif, etc. file which contains icon resources. Common Windows icons are located in SpecialFolder.System.Child("shell32.dll")
		  
		  //You may optionally designate the Index of the icon you want to be the default selection (much like the Suggested Name in a GetSaveFolderItem
		  //dialog.) Icons start with Index=0 There is no guarentee that the user will select this icon or even that the selected icon will come from your
		  //specified IconResource as the user may select a different resource file.
		  
		  //If you require that the returned Picture be of a certain size, pass the pixSize parameter. Passing 0 or nothing will return
		  //a picture of the same size as the icon's default size. pixSize is both the width and height.
		  
		  //If you want the Icon Selection Dialog to appear as a child window of a particular Window, then pass the desired Window Object as the parentWindow
		  //parameter.
		  
		  #If TargetWin32 Then
		    Declare Function PickIconDlg Lib "Shell32" (HWND As Integer, resource As Ptr, resourceLen As Integer, ByRef Index As Integer) As Integer
		    
		    If IconResource = Nil Then Return Nil
		    
		    Dim HWND, resourceLen, Index As Integer
		    Dim resource As New MemoryBlock(1024)
		    resource.WString(0) = IconResource.AbsolutePath
		    resourceLen = resource.Size
		    Index = DefaultIndex
		    If parentWindow <> Nil Then HWND = parentWindow.Handle
		    
		    If PickIconDlg(HWND, resource, resourceLen, Index) = 1 Then
		      Dim f As FolderItem = GetFolderItem(resource.WString(0))
		      Dim retpic As Picture = IconToPicture(f, Index, pixSize)
		      Return retpic
		    End If
		  #endif
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
