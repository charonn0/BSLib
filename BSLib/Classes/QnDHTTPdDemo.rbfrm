#tag Window
Begin Window QnDHTTPdDemo
   BackColor       =   16777215
   Backdrop        =   ""
   CloseButton     =   True
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   HasBackColor    =   False
   Height          =   401
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   False
   MaxWidth        =   32000
   MenuBar         =   1027555327
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   True
   Title           =   "Server Demo"
   Visible         =   True
   Width           =   779
   Begin PushButton PushButton1
      AutoDeactivate  =   True
      Bold            =   ""
      ButtonStyle     =   0
      Cancel          =   ""
      Caption         =   "Host Folder"
      Default         =   ""
      Enabled         =   True
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   13
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   12
      Underline       =   ""
      Visible         =   True
      Width           =   80
   End
   Begin PushButton PushButton2
      AutoDeactivate  =   True
      Bold            =   ""
      ButtonStyle     =   0
      Cancel          =   ""
      Caption         =   "Host File"
      Default         =   ""
      Enabled         =   True
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   13
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   46
      Underline       =   ""
      Visible         =   True
      Width           =   80
   End
   Begin TextArea TextArea1
      AcceptTabs      =   ""
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   True
      BackColor       =   16777215
      Bold            =   ""
      Border          =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   399
      HelpTag         =   ""
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   ""
      Left            =   185
      LimitText       =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Mask            =   ""
      Multiline       =   True
      ReadOnly        =   ""
      Scope           =   0
      ScrollbarHorizontal=   ""
      ScrollbarVertical=   True
      Styled          =   True
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   2
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   594
   End
   Begin CheckBox CheckBox1
      AutoDeactivate  =   True
      Bold            =   ""
      Caption         =   "Enable GZip Compression"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   5
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Scope           =   0
      State           =   0
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   11
      TextUnit        =   0
      Top             =   181
      Underline       =   ""
      Value           =   False
      Visible         =   True
      Width           =   175
   End
   Begin TextField port
      AcceptTabs      =   ""
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   16777215
      Bold            =   ""
      Border          =   True
      CueText         =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   ""
      Left            =   13
      LimitText       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Mask            =   ""
      Password        =   ""
      ReadOnly        =   ""
      Scope           =   0
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   8080
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   112
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   53
   End
   Begin ComboBox nic
      AutoComplete    =   False
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialValue    =   ""
      Italic          =   ""
      Left            =   13
      ListIndex       =   0
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   80
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   132
   End
   Begin TextField Username
      AcceptTabs      =   ""
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   16777215
      Bold            =   ""
      Border          =   True
      CueText         =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   ""
      Left            =   5
      LimitText       =   0
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Mask            =   ""
      Password        =   ""
      ReadOnly        =   ""
      Scope           =   0
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Username"
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   281
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   162
   End
   Begin CheckBox CheckBox2
      AutoDeactivate  =   True
      Bold            =   ""
      Caption         =   "Authenticate"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   5
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Scope           =   0
      State           =   0
      TabIndex        =   8
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   257
      Underline       =   ""
      Value           =   False
      Visible         =   True
      Width           =   100
   End
   Begin TextField password
      AcceptTabs      =   ""
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   16777215
      Bold            =   ""
      Border          =   True
      CueText         =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   ""
      Left            =   5
      LimitText       =   0
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Mask            =   ""
      Password        =   ""
      ReadOnly        =   ""
      Scope           =   0
      TabIndex        =   9
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Password"
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   305
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   162
   End
   Begin QnDHTTPd Sock
      Address         =   ""
      AllowDirectoryIndexPages=   True
      Authenticate    =   False
      Height          =   32
      Index           =   -2147483648
      KeepListening   =   True
      LastHTTPCode    =   0
      Left            =   135
      LockedInPosition=   False
      LogLevel        =   0
      Port            =   0
      Scope           =   0
      TabIndex        =   9
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   12
      Width           =   32
   End
   Begin ComboBox LogLevel
      AutoComplete    =   False
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialValue    =   "Caution Only\r\nNormal\r\nAll"
      Italic          =   ""
      Left            =   5
      ListIndex       =   1
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   10
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   218
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   88
   End
   Begin PushButton PushButton3
      AutoDeactivate  =   True
      Bold            =   ""
      ButtonStyle     =   0
      Cancel          =   ""
      Caption         =   "Set Logfile"
      Default         =   ""
      Enabled         =   True
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   93
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Scope           =   0
      TabIndex        =   11
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   218
      Underline       =   ""
      Visible         =   True
      Width           =   80
   End
   Begin ProgressBar ProgressBar1
      AutoDeactivate  =   True
      Enabled         =   True
      Height          =   9
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   11
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Maximum         =   100
      Scope           =   0
      TabIndex        =   12
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   203
      Value           =   0
      Visible         =   True
      Width           =   162
   End
   Begin TextField realmtext
      AcceptTabs      =   ""
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   16777215
      Bold            =   ""
      Border          =   True
      CueText         =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   ""
      Left            =   5
      LimitText       =   0
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Mask            =   ""
      Password        =   ""
      ReadOnly        =   ""
      Scope           =   0
      TabIndex        =   12
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "realm"
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   329
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   162
   End
   Begin CheckBox CheckBox3
      AutoDeactivate  =   True
      Bold            =   ""
      Caption         =   "Directory Browsing"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   5
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Scope           =   0
      State           =   0
      TabIndex        =   13
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   160
      Underline       =   ""
      Value           =   False
      Visible         =   True
      Width           =   162
   End
End
#tag EndWindow

#tag WindowCode
	#tag Method, Flags = &h0
		Sub Begin()
		  If Sock.IsConnected Then
		    If Not MsgBox("This will reset all open sockets. Proceed?", 36, "Change Network Interface") = 6 Then Return
		  End If
		  Sock.Close
		  If nic.Text.Trim <> "" Then
		    Sock.NetworkInterface = nic.RowTag(nic.ListIndex)
		  Else
		    sock.NetworkInterface = System.GetNetworkInterface(0)
		  End If
		  Sock.Port = Val(port.Text)
		  Sock.Page = SharedFile
		  Sock.Authenticate = CheckBox2.Value
		  Sock.Listen
		  ShowURL("http://" + Sock.NetworkInterface.IPAddress + ":" + Str(Sock.Port) + "/")
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private SharedFile As FolderItem
	#tag EndProperty


#tag EndWindowCode

#tag Events PushButton1
	#tag Event
		Sub Action()
		  SharedFile = SelectFolder()'GetOpenFolderItem("")
		  If SharedFile = Nil Then Return
		  Begin()
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton2
	#tag Event
		Sub Action()
		  SharedFile = GetOpenFolderItem("")
		  If SharedFile = Nil Then Return
		  Begin()
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events CheckBox1
	#tag Event
		Sub Open()
		  Me.Value = QnDHTTPd.GZIPAvailable
		  Me.Enabled = QnDHTTPd.GZIPAvailable
		End Sub
	#tag EndEvent
	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  #pragma Unused X
		  #pragma Unused Y
		  MsgBox("Must be (en/dis)abled at compile time.")
		  Return True
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events port
	#tag Event
		Sub TextChange()
		  Sock.Port = Val(Me.Text)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events nic
	#tag Event
		Sub Open()
		  Dim i As Integer
		  For i = 0 To System.NetworkInterfaceCount - 1
		    Me.AddRow(System.GetNetworkInterface(i).IPAddress)
		    Me.RowTag(i) = System.GetNetworkInterface(i)
		  Next
		  'Me.AddRow("Auto")
		  Me.ListIndex = i
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events CheckBox2
	#tag Event
		Sub Action()
		  Username.Enabled = Me.Value
		  Password.Enabled = Me.Value
		  realmtext.Enabled = Me.Value
		  sock.Authenticate = True
		  Sock.Close
		  Sock.Listen
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  Me.Value = Sock.Authenticate
		  Username.Enabled = Me.Value
		  Password.Enabled = Me.Value
		  realmtext.Enabled = Me.Value
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Sock
	#tag Event
		Function TamperResponseHeaders(ByRef Headers As InternetHeaders) As Boolean
		  If Me.LastHTTPCode = 200 Then
		    Headers.AppendHeader("X-Judgement-Render", "Your request is granted.")
		  ElseIf Me.LastHTTPCode = 302 Then
		    Headers.AppendHeader("X-Judgement-Render", "Your request is pending.")
		  Else
		    Headers.AppendHeader("X-Judgement-Render", "Your request is denied.")
		  End If
		  Headers.AppendHeader("Set-Cookie", "time=" + Format(Microseconds, "####"))
		  Return True
		  
		End Function
	#tag EndEvent
	#tag Event
		Function HandleRequest(HTTPVerb As String, PostContent As String, HTTPPath As String, Headers As InternetHeaders, HTTPVersion As Single, ByRef MIMEType As String, ByRef HTTPCode As Integer) As String
		  #pragma Unused HTTPVerb
		  #pragma Unused PostContent
		  #pragma Unused HTTPPath
		  #pragma Unused Headers
		  #pragma Unused HTTPVersion
		  #pragma Unused MIMEType
		  #pragma Unused HTTPCode
		  
		  'Return the HTML source or raw file data you want to respond to the request with. Also, you can set the HTTPCode and MIMEType parameters
		  'if you are returning any data. To let the default handling take place, return an empty string.
		  
		  'For example, this code would cause the default 404 error page to be returned for every request.
		  
		  'MIMEType = "text/html"
		  'HTTPCode = 404
		  'Return Me.ErrorPage(404, HTTPPath)
		End Function
	#tag EndEvent
	#tag Event
		Sub Log(LogLine As String)
		  TextArea1.AppendText(LogLine + EndOfLine)
		End Sub
	#tag EndEvent
	#tag Event
		Function SendProgress(bytesSent as Integer, bytesLeft as Integer) As Boolean
		  ProgressBar1.Value = bytesSent * 100 / (bytesSent + bytesLeft)
		End Function
	#tag EndEvent
	#tag Event
		Function CheckAuthentication(AuthString As String, ByRef Realm As String) As Boolean
		  Dim bpw As String = DecodeBase64(AuthString) 'Fixme: Find a way not to use DecodeBase64: it creates external libs
		  If Username.Text + ":" + Password.Text = bpw Then
		    Return True
		  End If
		  Realm = realmtext.Text
		  Return False
		End Function
	#tag EndEvent
	#tag Event
		Sub Error()
		  If Me.KeepListening Then
		    Me.Listen
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events LogLevel
	#tag Event
		Sub Change()
		  Select Case Me.ListIndex
		  Case 0
		    Sock.LogLevel = 0
		  Case 1
		    Sock.LogLevel = -1
		  Case 2
		    Sock.LogLevel = -2
		  End Select
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton3
	#tag Event
		Sub Action()
		  Dim f As FolderItem = GetSaveFolderItem("", "QnDHTTPServer.log")
		  If f <> Nil Then
		    Dim bs As BinaryStream
		    bs = BinaryStream.Create(f, True)
		    Sock.Logstream = bs
		  Else
		    Sock.Logstream = Nil
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events CheckBox3
	#tag Event
		Sub Open()
		  Me.Value = Sock.AllowDirectoryIndexPages
		End Sub
	#tag EndEvent
	#tag Event
		Sub Action()
		  Sock.AllowDirectoryIndexPages = Me.Value
		End Sub
	#tag EndEvent
#tag EndEvents
