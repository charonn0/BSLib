#tag Module
Protected Module Images
	#tag Method, Flags = &h0
		Sub ApplySepia(Byref pic as picture, depth as Integer)
		  //From: https://alwaysbusycorner.wordpress.com/2012/05/29/realbasic-isolated-project-4-a-sepia-filter/
		  
		  Dim R As Integer
		  Dim G As Integer
		  Dim B As Integer
		  Dim pixelColor As Color
		  Dim picRGB as RGBSurface
		  
		  picRGB = pic.RGBSurface
		  
		  For y As Integer = 0 To pic.Height - 1
		    For x As Integer = 0 To pic.Width - 1
		      pixelColor = picRGB.Pixel(x, y)
		      R = (0.299 * pixelColor.Red) + (0.587 * pixelColor.Green) + (0.114 * pixelColor.Blue)
		      B = R
		      G = B
		      
		      R = R + (depth * 2)
		      If R > 255 Then
		        R = 255
		      End If
		      G = G + depth
		      If G > 255 Then
		        G = 255
		      End If
		      
		      picRGB.Pixel(x, y) = RGB(R,G,B)
		    Next
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CaptureControl(Extends Control As RectControl) As Picture
		  'Calls CaptureRect on the specified RectControl
		  Dim fw As New ForeignWindow(Control.Handle)
		  Return fw.Capture
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CaptureRect(X As Integer, Y As Integer, Width As Integer, Height As Integer) As Picture
		  'Performs a screen capture on the specified on-screen rectangle. All screen contents in that
		  'rectangle will be captured as they appear to the user on screen.
		  If Width = 0 Or Height = 0 Then Return Nil
		  Dim screenCap As Picture
		  
		  #If TargetWin32 Then
		    screenCap = New Picture(Width, Height, 24)
		    Dim deskHWND As Integer = GetDesktopWindow()
		    Dim deskHDC As Integer = GetDC(deskHWND)
		    Call BitBlt(screenCap.Graphics.Handle(Graphics.HandleTypeHDC), 0, 0, Width, Height, DeskHDC, X, Y, SRCCOPY Or CAPTUREBLT)
		    Call ReleaseDC(DeskHWND, deskHDC)
		  #Endif
		  
		  Return screenCap
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CaptureWindow(Extends Win As Window, IncludeBorder As Boolean = True) As Picture
		  'Captures the passed window
		  'If the optional IncludeBorder parameter is False, then only the client area of the window
		  'is captured; if True then the client area, borders, and titlebar are included in the capture.
		  'If the window is a ContainerControl or similar construct (AKA child windows), only the contents of the container
		  'are captured.
		  
		  Dim fw As New ForeignWindow(Win.Handle)
		  Return fw.Capture(IncludeBorder)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CharPic(Char As String, TextColor As Color, BackColor As Color, Font As String, FontSize As Single) As Picture
		  //Similar to TextToPicture but meant for single characters
		  Dim tmp As New Picture(50, 50, 32)
		  tmp.Graphics.ForeColor = BackColor
		  tmp.Graphics.FillRect(0, 0, tmp.Width, tmp.Height)
		  tmp.Graphics.ForeColor = TextColor
		  tmp.Graphics.TextFont = Font
		  tmp.Graphics.TextSize = FontSize
		  
		  Dim reqWidth, reqHeight As Integer
		  reqWidth = tmp.Graphics.StringWidth(Char)
		  reqHeight = tmp.Graphics.StringHeight(Char, reqWidth)
		  #pragma BreakOnExceptions Off
		  Try
		    tmp = New Picture(reqWidth, reqHeight, 32)
		  Catch OutOfBoundsException
		    reqWidth = tmp.Graphics.StringWidth(Chr(&h20))
		    reqHeight = tmp.Graphics.StringHeight(Chr(&h20), reqWidth)
		    tmp = New Picture(reqWidth, reqHeight, 32)
		  End Try
		  #pragma BreakOnExceptions On
		  
		  tmp.Graphics.ForeColor = BackColor
		  tmp.Graphics.FillRect(0, 0, tmp.Width, tmp.Height)
		  tmp.Graphics.ForeColor = TextColor
		  tmp.Graphics.TextFont = Font
		  tmp.Graphics.TextSize = FontSize
		  tmp.Graphics.DrawString(Char, 0, reqHeight * 0.75)
		  
		  Return tmp
		  
		Exception OutOfBoundsException
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ColorToHex(c As Color) As String
		  //Converts a Color to a hex string, with appropriate zeros as spaceholders
		  
		  Return _
		  Right("00" + Hex(c.red), 2) + _
		  Right("00" + Hex(c.Green), 2) + _
		  Right("00" + Hex(c.Blue), 2)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DefaultIconForFileType(extension As String, size As Integer = 32) As Picture
		  //Given a file extension like "html" or "doc", returns a picture of the default icon for that file type.
		  //Optionally, you may pass the requested size, in pixels, of the icon. Not all sizes will be present
		  //in all cases. 32 pixels is pretty safe, however, and it is the default.
		  //If the specified file type doesn't have a default icon, this function returns Nil
		  
		  #If TargetWin32 Then
		    Dim info As SHFILEINFO
		    If SHGetFileInfo("foo." + extension, FILE_ATTRIBUTE_NORMAL, info, info.Size, _
		      SHGFI_DISPLAYNAME Or SHGFI_TYPENAME Or SHGFI_USEFILEATTRIBUTES Or SHGFI_ICON) Then
		      Dim theIcon As Picture = New Picture(size, size, 32)
		      theIcon.Transparent = 1
		      Call DrawIconEx(theIcon.Graphics.Handle(1), 0, 0, info.hIcon, size, size, 0, 0, &h3)
		      Call DestroyIcon(info.hIcon)
		      Return theIcon
		    Else
		      Return Nil
		    End If
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ExtractIcon(Resource as FolderItem, Index As Integer, pixSize As Integer = 32) As Picture
		  //Extracts the specified Icon resource into a RB Picture. Returns Nil on error.
		  //Icons are located in EXE, DLL, etc. type files, and are referenced by their index.
		  
		  #If TargetWin32 Then
		    Dim theIcon As Picture = New Picture(pixsize, pixsize, 32)
		    theIcon.Transparent = 1
		    
		    Dim largeIco As New MemoryBlock(4)
		    Try
		      Call ExtractIconEx(resource.AbsolutePath_, Index, largeIco, Nil, 1)
		      Call DrawIconEx(theIcon.Graphics.Handle(Graphics.HandleTypeHDC), 0, 0, largeIco.Int32Value(0), pixsize, pixsize, 0, 0, &h3)
		    Catch
		      Call DestroyIcon(largeIco.Int32Value(0))
		      Return Nil
		    End Try
		    Call DestroyIcon(largeIco.Int32Value(0))
		    Return theIcon
		  #endif
		  
		Exception
		  Return Nil
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GreyScale(p As Picture)
		  //Converts the passed Picture to greyscale.
		  //Can take a few seconds on very large Pictures
		  //This function was *greatly* optimized by user 'doofus' on the RealSoftware forums:
		  //http://forums.realsoftware.com/viewtopic.php?f=1&t=42327&sid=4e724091fc9dd70fd5705110098adf67
		  
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
		Function IntToColor(extends c as Integer) As Color
		  //From WFS, converts an Integer to a Color
		  
		  Dim mb as new MemoryBlock(4)
		  mb.Long(0) = c
		  Return RGB(mb.Byte(0), mb.Byte(1), mb.Byte(2))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PictureToHTML(MyPic As Picture, AltText As String = "") As String
		  //Given a Picture, returns the base64-encoded HTML representation
		  //e.g.
		  //<img src='data:image/png;base64,iVBORw0KGgoAAAANS...' width=200 height=200 alt='A picture of a cat' />
		  Return "<img src='" + DataURI(MyPic) + "' width=" + Str(MyPic.Width) + " height=" + Str(MyPic.Height) + " alt='" + AltText + "' />"
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Rotate(Extends Pic As Picture, Degrees As Double, Mask As Picture = Nil) As Picture
		  //Rotates the passed Picture counter-clockwise the number of degrees specified around its center.
		  //Optionally, pass a mask which will also be rotated and then applied to the returned Picture object.
		  
		  Dim px As New PixmapShape(Pic)
		  px.X = (Pic.Width * 0.5) - 2
		  px.Y = (Pic.Height * 0.5) - 2
		  px.Rotation = Degrees / 57.2958 //Degrees to radians
		  Dim p As New Picture(px.SourceWidth, Px.SourceHeight, Pic.Depth)
		  p.Graphics.DrawObject(px)
		  
		  //Rotate and apply the mask if it exists
		  If Mask <> Nil Then p.ApplyMask(Mask.Rotate(Degrees))
		  
		  Return p
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Scale(Source As Picture, Ratio As Double = 1.0) As Picture
		  //Returns a scaled version of the passed Picture object.
		  //A ratio of 1.0 is 100% (no change,) 0.5 is 50% (half size) and so forth.
		  
		  If Ratio = 1.0 Then Return Source  //No change, so why bother?
		  
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
		Function SelectIcon(IconResource As FolderItem, DefaultIndex As Integer = 0, pixSize As Integer = 0, Optional HWND As Integer) As Picture
		  //This function will show a Icon Selection dialog to the user. If the user selects an icon, a REALbasic Picture is returned containing the icon.
		  //Otherwise, returns Nil.
		  //Icons are stored in Windows PE images (executables) as accessible resources. You must specify a FolderItem which points to a
		  //.exe, .dll, .scr, .pif, etc. file which contains icon resources. Common Windows icons are located in SpecialFolder.System.Child("shell32.dll")
		  
		  //You may optionally designate the Index of the icon you want to be the default selection (much like the Suggested Name in a GetSaveFolderItem
		  //dialog.) Icons start with Index=0 There is no guarentee that the user will select this icon or even that the selected icon will come from your
		  //specified IconResource as the user may select a different resource file.
		  
		  //If you require that the returned Picture be of a certain size, pass the pixSize parameter. Passing 0 or nothing will return
		  //a picture of the same size as the icon's default size. pixSize is both the width and height.
		  
		  //If you want the Icon Selection Dialog to appear as a child window of a particular Window, then pass the desired Window's Handle property
		  //as the HWND parameter.
		  
		  #If TargetWin32 And TargetHasGUI Then  //The RB Picture object is not available in console applications
		    If IconResource = Nil Then Return Nil
		    
		    Dim resourceLen, Index As Integer
		    Dim resource As New MemoryBlock(1024)
		    resource.WString(0) = IconResource.AbsolutePath_
		    resourceLen = resource.Size
		    Index = DefaultIndex
		    
		    If PickIconDlg(HWND, resource, resourceLen, Index) = 1 Then
		      Dim f As FolderItem = GetFolderItem(resource.WString(0))
		      Dim retpic As Picture = ExtractIcon(f, Index, pixSize)
		      Return retpic
		    End If
		  #Else
		    #pragma Unused IconResource
		    #pragma Unused DefaultIndex
		    #pragma Unused pixSize
		    #pragma Unused HWND
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TextToPicture(Text As String, Font As String = "System", FontSize As Single = 11.0, Bold As Boolean = False, Underline As Boolean = False, Italic As Boolean = False, forecolor As Color = &c000000, BackColor As Color = &cFFFFFF) As Picture
		  //Given any String, returns a picture of that string. Line breaks are honored.
		  //The optional parameters ought to be self-explanitory.
		  
		  If Text = "" Then
		    Return New Picture(1, 1, 32)
		  End If
		  Dim lines() As Picture
		  Dim requiredHeight, requiredWidth As Integer
		  Dim tlines() As String = Split(Text, EndOfLine)
		  
		  For i As Integer = 0 To UBound(tlines)
		    If tlines(i) = "" Then tlines(i) = " "
		    Dim p As New Picture(250, 250, 24)
		    p.Graphics.TextFont = Font
		    p.Graphics.TextSize = FontSize
		    p.Graphics.Bold = Bold
		    p.Graphics.Italic = Italic
		    p.Graphics.Underline = Underline
		    Dim nm As String = tlines(i)
		    Dim strWidth, strHeight As Integer
		    strWidth = p.Graphics.StringWidth(nm) + 5
		    strHeight = p.Graphics.StringHeight(nm, strWidth)
		    p = New Picture(strWidth, strHeight, 32)
		    p.Graphics.ForeColor = BackColor
		    p.Graphics.FillRect(0, 0, p.Width, p.Height)
		    p.Graphics.AntiAlias = True
		    p.Graphics.ForeColor = forecolor
		    p.Graphics.TextFont = Font
		    p.Graphics.TextSize = FontSize
		    p.Graphics.Bold = Bold
		    p.Graphics.Italic = Italic
		    p.Graphics.Underline = Underline
		    p.Graphics.DrawString(nm, 1, ((p.Height\2) + (strHeight\4)))
		    lines.Append(p)
		    requiredHeight = requiredHeight + p.Height
		    If p.Width > requiredWidth Then requiredWidth = p.Width
		  Next
		  Dim txtBuffer As Picture
		  txtBuffer = New Picture(requiredWidth, requiredHeight, 24)
		  Dim x, y As Integer
		  For i As Integer = 0 To UBound(lines)
		    txtBuffer.Graphics.DrawPicture(lines(i), x, y)
		    y = y + lines(i).Height
		  Next
		  txtBuffer.Transparent = 1
		  Return txtBuffer
		End Function
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
