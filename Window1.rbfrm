#tag Window
Begin Window Window1
   BackColor       =   16777215
   Backdrop        =   ""
   CloseButton     =   True
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   HasBackColor    =   False
   Height          =   5.2e+2
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
   Width           =   9.86e+2
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
      Left            =   349
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
      Top             =   491
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
      Left            =   434
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
      Top             =   457
      Underline       =   ""
      Visible         =   True
      Width           =   119
   End
   Begin GroupBox GroupBox1
      AutoDeactivate  =   True
      Bold            =   ""
      Caption         =   "Window and Control Capture Demo"
      Enabled         =   True
      Height          =   401
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
      Width           =   962
      Begin Canvas ControlPicture
         AcceptFocus     =   ""
         AcceptTabs      =   ""
         AutoDeactivate  =   True
         Backdrop        =   ""
         DoubleBuffer    =   False
         Enabled         =   True
         EraseBackground =   True
         Height          =   300
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Left            =   20
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Scope           =   0
         TabIndex        =   1
         TabPanelIndex   =   0
         TabStop         =   True
         Top             =   79
         UseFocusRing    =   True
         Visible         =   True
         Width           =   300
      End
      Begin Canvas ParentPicture
         AcceptFocus     =   ""
         AcceptTabs      =   ""
         AutoDeactivate  =   True
         Backdrop        =   ""
         DoubleBuffer    =   False
         Enabled         =   True
         EraseBackground =   True
         Height          =   300
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Left            =   343
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Scope           =   0
         TabIndex        =   2
         TabPanelIndex   =   0
         TabStop         =   True
         Top             =   79
         UseFocusRing    =   True
         Visible         =   True
         Width           =   300
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
         Left            =   99
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
         Text            =   "Control/Window"
         TextAlign       =   1
         TextColor       =   &h000000
         TextFont        =   "System"
         TextSize        =   0
         TextUnit        =   0
         Top             =   384
         Transparent     =   False
         Underline       =   ""
         Visible         =   True
         Width           =   142
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
         Left            =   380
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
         Top             =   384
         Transparent     =   False
         Underline       =   ""
         Visible         =   True
         Width           =   227
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
         Left            =   763
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
         Top             =   384
         Transparent     =   False
         Underline       =   ""
         Visible         =   True
         Width           =   100
      End
      Begin Canvas Canvas1
         AcceptFocus     =   ""
         AcceptTabs      =   ""
         AutoDeactivate  =   True
         Backdrop        =   459339775
         DoubleBuffer    =   False
         Enabled         =   True
         EraseBackground =   True
         Height          =   50
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Left            =   20
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Scope           =   0
         TabIndex        =   7
         TabPanelIndex   =   0
         TabStop         =   True
         Top             =   24
         UseFocusRing    =   True
         Visible         =   True
         Width           =   50
      End
      Begin Label Label5
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
         Left            =   106
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Multiline       =   ""
         Scope           =   0
         Selectable      =   False
         TabIndex        =   8
         TabPanelIndex   =   0
         Text            =   "<-- Drag over any window or control (system-wide)"
         TextAlign       =   0
         TextColor       =   &h000000
         TextFont        =   "System"
         TextSize        =   0
         TextUnit        =   0
         Top             =   39
         Transparent     =   False
         Underline       =   ""
         Visible         =   True
         Width           =   574
      End
      Begin Canvas BorderedParentPicture
         AcceptFocus     =   ""
         AcceptTabs      =   ""
         AutoDeactivate  =   True
         Backdrop        =   ""
         DoubleBuffer    =   False
         Enabled         =   True
         EraseBackground =   True
         Height          =   300
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Left            =   663
         LockBottom      =   ""
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   ""
         LockTop         =   True
         Scope           =   0
         TabIndex        =   9
         TabPanelIndex   =   0
         TabStop         =   True
         Top             =   79
         UseFocusRing    =   True
         Visible         =   True
         Width           =   300
      End
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  Dim data As String = DecodeBase64(TargetIcon)
		  Target = Picture.FromData(data)
		End Sub
	#tag EndEvent


	#tag Property, Flags = &h21
		Private BorderedParentPic As Picture
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ContPic As Picture
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Dragging As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ParentPic As Picture
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Target As Picture
	#tag EndProperty


	#tag Constant, Name = TargetIcon, Type = String, Dynamic = False, Default = \"iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAKmSURBVGhD7ZjPZyRREMebJYQlf0DIKf/BXvc/yDWEEJaQU67L/gF7WkKuSwg55ZRryHWvIYQ5DSGEZVlC2FOYrc+oGjVverrT3dM1Md6j9HS/evXqW9+q92OK0WhUrIKsBAiIyEDeWzpmRjIjPa2SObVyauXUqj6B5BrJNZJrJLBGiqL4KLIvcilyK/IiIkfT8ZN3vtOP3tzWJm0XUuzi0ZrIschfdRznqwQ99Bk305YCRLzYFrlPHIeBK5Gf+p0n78aQgWQc46daOBCZ/XPCwkDe95JI47Q1GKAfPQMDO9iZtFAgGsk/zqHv8vvD+LaWBDj9gJ4I+gYGOxNmwoBoxH06HfjJ3wDEVA4cGOyNayYSyFfPRDpxAyCoema+hQGRidZFLKWGRLEGyGNJavlPpBl2SDPsrocwIhNRrJbbe2WT1jhe1l1rsw5c43wULy4UyL950WsBBJaxR4Au6pwuDV7TQTKRLZ3X88a2AMKQawUyaOpTq/+1ZDLb1E4WDOREgbxEAak6egxL9pEygp5cnc3YiwLyrE6cLZiRM7X7HAXkTie8WTCQG7V7FwXkfFVWrV2X31NHE4tki1Xri7O5G8UIa/5vnfhBnnU7Oxeq0nuHAqYPOxQ9dmN2dl2V/Fnr9A1nrY0Klk4dG9htvEm32kcUCFG0oieSxzWn33lAuCXa8ou92NOvgtmUif195IelRRJ9HE2BkJ7o+/sI9sYtpEaSyH9y9YJTnHQPE8c9EADRj56BoC6wM2nhQJSZrSTNcPBV5JeI3dlZsnnnu9/JSSfGT7WlAFEw3CmOEnaqjjKwgD7jZtrSgLj9g2LdUSZYdm2Z5sk7DNFftRzH10ibyPU1phX6vpzpYjcD6RK9PsZmRvqIahebmZEu0etjbGakj6h2sfkfqnYCHXFezywAAAAASUVORK5CYII\x3D", Scope = Private
	#tag EndConstant


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
#tag Events ControlPicture
	#tag Event
		Sub Paint(g As Graphics)
		  If ContPic <> Nil Then
		    If ContPic.Width > g.Width Or ContPic.Height > g.Height Then
		      g.DrawPicture(ContPic, 0, 0, g.Width, g.Height, 0, 0, ContPic.Width, ContPic.Height)
		    Else
		      g.DrawPicture(ContPic, 0, 0)
		    End If
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
#tag Events Canvas1
	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  Dragging = True
		  Return True
		End Function
	#tag EndEvent
	#tag Event
		Sub Paint(g As Graphics)
		  g.DrawPicture(target, 0, 0, g.Width, g.Height, 0, 0, target.Width, target.Height)
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseDrag(X As Integer, Y As Integer)
		  Dim d As New DragItem(Self, Me.MouseX, Me.MouseY, Me.Width, Me.Height, target)
		  d.Drag
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseMove(X As Integer, Y As Integer)
		  If Dragging Then
		    Break
		  End If
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseUp(X As Integer, Y As Integer)
		  Dragging = False
		  Dim trueX, trueY As Integer
		  trueX = System.MouseX
		  trueY = System.MouseY
		  Dim fw As ForeignWindow = ForeignWindow.FromXY(trueX, trueY)
		  ContPic = fw.Capture
		  ParentPic = fw.TrueParent.Capture(False)
		  BorderedParentPic = fw.TrueParent.Capture
		  
		  ParentPicture.Refresh
		  BorderedParentPicture.Refresh
		  ControlPicture.Refresh
		  
		  fw.Hilight
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
