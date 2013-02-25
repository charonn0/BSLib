#tag Window
Begin Window Window1
   BackColor       =   16777215
   Backdrop        =   ""
   CloseButton     =   True
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   HasBackColor    =   False
   Height          =   4.18e+2
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   True
   MaxWidth        =   32000
   MenuBar         =   ""
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   True
   Title           =   "BSLib"
   Visible         =   True
   Width           =   7.36e+2
   Begin Label Label1
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   0
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Multiline       =   ""
      Scope           =   0
      Selectable      =   False
      TabIndex        =   0
      TabPanelIndex   =   0
      Text            =   "http://www.boredomsoft.org/bslib.bs"
      TextAlign       =   1
      TextColor       =   &h000000FF
      TextFont        =   "System"
      TextSize        =   15
      TextUnit        =   0
      Top             =   396
      Transparent     =   False
      Underline       =   True
      Visible         =   True
      Width           =   288
   End
   Begin PushButton PushButton1
      AutoDeactivate  =   True
      Bold            =   ""
      ButtonStyle     =   0
      Cancel          =   ""
      Caption         =   "QNDHTTPd Demo"
      Default         =   ""
      Enabled         =   True
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   12
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   327
      Underline       =   ""
      Visible         =   True
      Width           =   119
   End
   Begin GroupBox GroupBox1
      AutoDeactivate  =   True
      Bold            =   ""
      Caption         =   "Window and Control Capture Demo"
      Enabled         =   True
      Height          =   304
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   12
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Scope           =   0
      TabIndex        =   9
      TabPanelIndex   =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   11
      Underline       =   ""
      Visible         =   True
      Width           =   712
      Begin PushButton PushButton2
         AutoDeactivate  =   True
         Bold            =   ""
         ButtonStyle     =   0
         Cancel          =   ""
         Caption         =   "Capture this button"
         Default         =   ""
         Enabled         =   True
         Height          =   22
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   ""
         Left            =   56
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
         Top             =   34
         Underline       =   ""
         Visible         =   True
         Width           =   181
      End
      Begin Canvas ControlPicture
         AcceptFocus     =   ""
         AcceptTabs      =   ""
         AutoDeactivate  =   True
         Backdrop        =   ""
         DoubleBuffer    =   False
         Enabled         =   True
         EraseBackground =   True
         Height          =   200
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Left            =   56
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Scope           =   0
         TabIndex        =   1
         TabPanelIndex   =   0
         TabStop         =   True
         Top             =   68
         UseFocusRing    =   True
         Visible         =   True
         Width           =   200
      End
      Begin Canvas ParentPicture
         AcceptFocus     =   ""
         AcceptTabs      =   ""
         AutoDeactivate  =   True
         Backdrop        =   ""
         DoubleBuffer    =   False
         Enabled         =   True
         EraseBackground =   True
         Height          =   200
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Left            =   268
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Scope           =   0
         TabIndex        =   2
         TabPanelIndex   =   0
         TabStop         =   True
         Top             =   68
         UseFocusRing    =   True
         Visible         =   True
         Width           =   200
      End
      Begin Canvas BorderedParentPicture
         AcceptFocus     =   ""
         AcceptTabs      =   ""
         AutoDeactivate  =   True
         Backdrop        =   ""
         DoubleBuffer    =   False
         Enabled         =   True
         EraseBackground =   True
         Height          =   200
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Left            =   480
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Scope           =   0
         TabIndex        =   3
         TabPanelIndex   =   0
         TabStop         =   True
         Top             =   68
         UseFocusRing    =   True
         Visible         =   True
         Width           =   200
      End
      Begin Label Label2
         AutoDeactivate  =   True
         Bold            =   ""
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   ""
         Left            =   94
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Multiline       =   ""
         Scope           =   0
         Selectable      =   False
         TabIndex        =   4
         TabPanelIndex   =   0
         Text            =   "Control"
         TextAlign       =   1
         TextColor       =   &h000000
         TextFont        =   "System"
         TextSize        =   0
         TextUnit        =   0
         Top             =   272
         Transparent     =   False
         Underline       =   ""
         Visible         =   True
         Width           =   100
      End
      Begin Label Label3
         AutoDeactivate  =   True
         Bold            =   ""
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   ""
         Left            =   318
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Multiline       =   ""
         Scope           =   0
         Selectable      =   False
         TabIndex        =   5
         TabPanelIndex   =   0
         Text            =   "Parent"
         TextAlign       =   1
         TextColor       =   &h000000
         TextFont        =   "System"
         TextSize        =   0
         TextUnit        =   0
         Top             =   272
         Transparent     =   False
         Underline       =   ""
         Visible         =   True
         Width           =   100
      End
      Begin Label Label4
         AutoDeactivate  =   True
         Bold            =   ""
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   ""
         Left            =   530
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Multiline       =   ""
         Scope           =   0
         Selectable      =   False
         TabIndex        =   6
         TabPanelIndex   =   0
         Text            =   "Parent + Borders"
         TextAlign       =   1
         TextColor       =   &h000000
         TextFont        =   "System"
         TextSize        =   0
         TextUnit        =   0
         Top             =   272
         Transparent     =   False
         Underline       =   ""
         Visible         =   True
         Width           =   100
      End
   End
End
#tag EndWindow

#tag WindowCode
	#tag Property, Flags = &h21
		Private BorderedParentPic As Picture
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ContPic As Picture
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ParentPic As Picture
	#tag EndProperty


#tag EndWindowCode

#tag Events Label1
	#tag Event
		Sub MouseEnter()
		  Me.MouseCursor = System.Cursors.FingerPointer
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseExit()
		  Me.MouseCursor = System.Cursors.StandardPointer
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseUp(X As Integer, Y As Integer)
		  #pragma Unused X
		  #pragma Unused Y
		  ShowURL(Me.Text)
		  Me.TextColor = &c0000FF00
		End Sub
	#tag EndEvent
	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  #pragma Unused X
		  #pragma Unused Y
		  Me.TextColor = &cFF000000
		  Return True
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events PushButton1
	#tag Event
		Sub Action()
		  QnDHTTPdDemo.Show
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton2
	#tag Event
		Sub Action()
		  Dim fw As New ForeignWindow(Me.Handle)
		  ContPic = fw.Capture
		  ParentPic = fw.TrueParent.Capture(False)
		  BorderedParentPic = fw.TrueParent.Capture
		  
		  ParentPicture.Refresh
		  BorderedParentPicture.Refresh
		  ControlPicture.Refresh
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ControlPicture
	#tag Event
		Sub Paint(g As Graphics)
		  If ContPic <> Nil Then
		    g.DrawPicture(ContPic, 0, 0)
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ParentPicture
	#tag Event
		Sub Paint(g As Graphics)
		  If ParentPic <> Nil Then
		    g.DrawPicture(ParentPic, 0, 0, g.Width, g.Height, 0, 0, ParentPic.Width, ParentPic.Height)
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events BorderedParentPicture
	#tag Event
		Sub Paint(g As Graphics)
		  If BorderedParentPic <> Nil Then
		    g.DrawPicture(BorderedParentPic, 0, 0, g.Width, g.Height, 0, 0, BorderedParentPic.Width, BorderedParentPic.Height)
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
