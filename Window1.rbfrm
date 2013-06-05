#tag Window
Begin Window Window1
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   CloseButton     =   True
   Compatibility   =   ""
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   HasBackColor    =   False
   Height          =   579
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   True
   MaxWidth        =   32000
   MenuBar         =   0
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   True
   Title           =   "BSLib"
   Visible         =   True
   Width           =   986
   Begin Label Label1
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   26
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   0
      TabPanelIndex   =   0
      Text            =   "http://www.boredomsoft.org/bslib.bs"
      TextAlign       =   1
      TextColor       =   &c0000FF00
      TextFont        =   "System"
      TextSize        =   15.0
      TextUnit        =   0
      Top             =   537
      Transparent     =   False
      Underline       =   True
      Visible         =   True
      Width           =   288
   End
   Begin PushButton PushButton1
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   "0"
      Cancel          =   False
      Caption         =   "QNDHTTPd Demo"
      Default         =   False
      Enabled         =   True
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   111
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   503
      Underline       =   False
      Visible         =   True
      Width           =   119
   End
   Begin GroupBox GroupBox1
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   "Window and Control Capture Demo"
      Enabled         =   True
      Height          =   401
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   12
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   9
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   11
      Underline       =   False
      Visible         =   True
      Width           =   962
      Begin Canvas ControlPicture
         AcceptFocus     =   False
         AcceptTabs      =   False
         AutoDeactivate  =   True
         Backdrop        =   0
         DoubleBuffer    =   False
         Enabled         =   True
         EraseBackground =   True
         Height          =   300
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Left            =   20
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Scope           =   0
         TabIndex        =   1
         TabPanelIndex   =   0
         TabStop         =   True
         Top             =   79
         Transparent     =   True
         UseFocusRing    =   True
         Visible         =   True
         Width           =   300
      End
      Begin Canvas ParentPicture
         AcceptFocus     =   False
         AcceptTabs      =   False
         AutoDeactivate  =   True
         Backdrop        =   0
         DoubleBuffer    =   False
         Enabled         =   True
         EraseBackground =   True
         Height          =   300
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Left            =   343
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Scope           =   0
         TabIndex        =   2
         TabPanelIndex   =   0
         TabStop         =   True
         Top             =   79
         Transparent     =   True
         UseFocusRing    =   True
         Visible         =   True
         Width           =   300
      End
      Begin Label Label2
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   False
         Left            =   99
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   4
         TabPanelIndex   =   0
         Text            =   "Control/Window"
         TextAlign       =   1
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   384
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   142
      End
      Begin Label Label3
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   False
         Left            =   380
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   5
         TabPanelIndex   =   0
         Text            =   "Parent"
         TextAlign       =   1
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   384
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   227
      End
      Begin Label Label4
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   False
         Left            =   763
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   6
         TabPanelIndex   =   0
         Text            =   "Parent + Borders"
         TextAlign       =   1
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   384
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   100
      End
      Begin Canvas Canvas1
         AcceptFocus     =   False
         AcceptTabs      =   False
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
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Scope           =   0
         TabIndex        =   7
         TabPanelIndex   =   0
         TabStop         =   True
         Top             =   24
         Transparent     =   True
         UseFocusRing    =   True
         Visible         =   True
         Width           =   50
      End
      Begin Label Label5
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   20
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   False
         Left            =   106
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   8
         TabPanelIndex   =   0
         Text            =   "<-- Drag over any window or control (system-wide)"
         TextAlign       =   0
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   39
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   574
      End
      Begin Canvas BorderedParentPicture
         AcceptFocus     =   False
         AcceptTabs      =   False
         AutoDeactivate  =   True
         Backdrop        =   0
         DoubleBuffer    =   False
         Enabled         =   True
         EraseBackground =   True
         Height          =   300
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Left            =   663
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Scope           =   0
         TabIndex        =   9
         TabPanelIndex   =   0
         TabStop         =   True
         Top             =   79
         Transparent     =   True
         UseFocusRing    =   True
         Visible         =   True
         Width           =   300
      End
   End
   Begin GroupBox GroupBox2
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   "Global Hotkey Demo"
      Enabled         =   True
      Height          =   76
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   712
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   10
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   483
      Underline       =   False
      Visible         =   True
      Width           =   251
      Begin HotKeyListener HotKey
         Height          =   32
         Index           =   -2147483648
         InitialParent   =   "GroupBox2"
         Left            =   914
         LockedInPosition=   False
         Scope           =   0
         TabPanelIndex   =   0
         Top             =   503
         Width           =   32
      End
      Begin Label Label6
         AutoDeactivate  =   True
         Bold            =   False
         DataField       =   ""
         DataSource      =   ""
         Enabled         =   True
         Height          =   56
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox2"
         Italic          =   False
         Left            =   721
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   True
         Scope           =   0
         Selectable      =   False
         TabIndex        =   0
         TabPanelIndex   =   0
         Text            =   "Press Ctrl+Alt+A\r\nWorks even if this window is minimized/invisible."
         TextAlign       =   0
         TextColor       =   &c00000000
         TextFont        =   "System"
         TextSize        =   0.0
         TextUnit        =   0
         Top             =   498
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   175
      End
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  Dim data As String = DecodeBase64(TargetIcon)
		  Target = Picture.FromData(data)
		  Call HotKey.RegisterKey(MOD_CONTROL Or MOD_ALT, HotKey.VirtualKey("a"))
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

	#tag Property, Flags = &h0
		WM As WindowMessenger
	#tag EndProperty


	#tag Constant, Name = htmlsource, Type = String, Dynamic = False, Default = \"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\r<html lang\x3D\"en\"><head>\r<title>Linode - Xen VPS Hosting</title>\r<meta http-equiv\x3D\"content-type\" content\x3D\"text/html;charset\x3Diso-8859-1\">\r<meta name\x3D\"description\" content\x3D\" We\'re a Xen VPS hosting company that aims to provide the best tools to those that need better hosting.\">\r<meta name\x3D\"keywords\" content\x3D\"vps\x2Cxen\x2Cxeno\x2Cxend\x2Cvirtual server\x2Cvirtual servers\x2CVDS\x2CVPS\x2CVirtual Private Server\x2CVirtual Private Servers\x2CVirtual Dedicated Server\x2CVirtual Dedicated Servers\x2Chosting\">\r\r<link rel\x3D\"stylesheet\" type\x3D\"text/css\" href\x3D\"/dsp/css_homepage.css\?19\">\r<link rel\x3D\"stylesheet\" type\x3D\"text/css\" href\x3D\"/dsp/css_common.css\?18\">\r<script src\x3D\"/js/prototype.js\?0\" type\x3D\"text/javascript\"></script>\r\r<!--[if IE]>\r<style type\x3D\"text/css\">\r@import url(\"/dsp/css_homepage_ie.css\?4\");\r</style>\r<![endif]-->\r\r</head>\r<body><a name\x3D\"0\"></a>\r\r<div id\x3D\"navtoprow_container\">\r\t<div id\x3D\"navtoprow_center\">\r\t\t<a href\x3D\"http://www.linode.com/\"><img id\x3D\"logo\" src\x3D\"/images/linode_logo_gray.png\" border\x3D\"0\" alt\x3D\"logo\"></a>\r\r\t\t<div id\x3D\"navtoprow_buttons\">\r\t\t\t<span id\x3D\"button_members\"><a href\x3D\"https://manager.linode.com/\" tabindex\x3D\"1\">Log in</a></span>\r\t\t\t<span id\x3D\"button_signup\"><a href\x3D\"https://manager.linode.com/signup/\">Sign up</a></span>\r\t\t</div>\r\r\t\t<div id\x3D\"navtoprowtabs\">\r\t\t\t<ul id\x3D\"navtop\">\r\t\t\t\t<li><a id\x3D\"navtopactivehome\" href\x3D\"http://www.linode.com/\">Home</a></li>\r\t\t\t\t\r\t\t\t\t<li><a  href\x3D\"http://www.linode.com/tour/\">Take a Tour</a></li>\r\t\t\t\t<li><a  href\x3D\"http://www.linode.com/faq.cfm\">FAQ</a></li>\r\t\t\t\t<li><a  href\x3D\"http://www.linode.com/community/\">Community</a></li>\r\t\t\t\t<li><a  href\x3D\"http://www.linode.com/about/\">About Us</a></li>\r\t\t\t\t<li><a  href\x3D\"http://blog.linode.com/\">Blog</a></li>\r\t\t\t</ul>\r\t\t</div>\r\t</div>\r</div>\r\r\r\r<div class\x3D\"home_top\">\r\t<div class\x3D\"generic_container\">\r\r\r\t\t<div class\x3D\"pitch\">\r\t\t\t<h1>Deploy and Manage Linux Virtual Servers in the Linode Cloud.</h1>\r\t\t\t<h2>Get a server running in seconds with your choice of Linux distro\x2C resources\x2C and node location.</h2>\r\t\t\t<h3>Servers on demand. Support that cares.</h3>\r\t\t</div>\r\t</div>\r</div>\r\r<div id\x3D\"page_container\">\r\t<div id\x3D\"page\" style\x3D\"width: 880px;\">\r\r\r\r\r<div class\x3D\"free_trial\" style\x3D\"padding: 25px 0; text-align: center\">\r\t<form action\x3D\"https://manager.linode.com/session/signup_save\" method\x3D\"post\">\r\t\t<h3>Create Free Account:</h3>\r\t\t<input type\x3D\"text\" name\x3D\"email\" placeholder\x3D\"Email\" autocomplete\x3D\"off\" size\x3D\"16\" />\r\t\t<input type\x3D\"text\" name\x3D\"username\" placeholder\x3D\"Username\" autocomplete\x3D\"off\" size\x3D\"16\" />\r\t\t<input type\x3D\"password\" name\x3D\"password\" placeholder\x3D\"Password\" autocomplete\x3D\"off\" size\x3D\"16\" />\r\t\t<input type\x3D\"submit\" value\x3D\"Let\'s go! &raquo;\" class\x3D\"trialbutton\" style\x3D\"margin-top: 0\"/>\r\t</form>\r\r</div>\r\r\r\r\r<div class\x3D\"sidebox sideboxhome\" style\x3D\"margin-right: 20px\">\r\t<h1 class\x3D\"homeboxheader\">VPS Hosting</h1>\r\r\t<p style\x3D\"color: #000;\">\r\t\tWe\'re a VPS hosting company built upon one simple premise:\r\t\tprovide the best possible tools and services\r\t\tto those that know what they need &mdash; better hosting.\r\t</p>\r\r\t<p style\x3D\"color: #000;\">\r\t\tA Linode VPS means freedom. \r\t\tYou get everything from the kernel and root access on up.\r\t\tAll managed by our simple yet very powerful control panel.\r\t\t\r\t\tDiscover <a href\x3D\"/why.cfm\">why Linode</a> may be right for you.\r\t</p>\r\r</div>\r\r<div class\x3D\"sidebox sideboxhome\" style\x3D\"margin-right: 20px\">\r\t<h1 class\x3D\"homeboxheader\">Features</h1>\r\r\t<ul class\x3D\"cool_list_nobull\" style\x3D\"color: #000;\">\r\t\t<li>Full ssh and <u>root</u> access</li>\r\t\t\r\t\t<li>Guaranteed Resources</li>\r\t\t<li>4 processor Xen instances</li>\r\t\t<li>Out of band console shell</li>\r\t\t<li>Dedicated IP address\x2C premium bw</li>\r\t\t<li><strong>Six</strong> datacenters in the US\x2C Europe\x2C and Asia-Pacific</li>\r\t\t<li>HA and Clustering Support</li>\r\t\t<li>Transfer pooling</li>\r\t\t<li>Managed DNS with API</li>\r\t</ul>\r\r\t<p>\r\t\t<a href\x3D\"/features.cfm\">More features...</a>\r\t</p>\r</div>\r\r<div class\x3D\"sidebox sideboxhome\">\r\t<h1 class\x3D\"homeboxheader\">Recent News</h1>\r\r\tFEBRUARY 2013\r\t<ul class\x3D\"cool_list_nobull\">\r\t\t<li><a href\x3D\"http://blog.linode.com/2013/02/28/create-a-free-account-and-trial-linodes/\">Create a free account and Trial Linodes</a></li>\r\t\t<li><a href\x3D\"http://blog.linode.com/2013/02/28/2013-spring-conferences/\">2013 Spring Conferences</a></li>\r\t</ul>\r\r\tDECEMBER 2012\r\t<ul class\x3D\"cool_list_nobull\">\r\t\t<li><a href\x3D\"http://blog.linode.com/2012/12/14/storage-increased-by-20/\">Storage increased by 20%</a></li>\r\t</ul>\r\r\tNOVEMBER 2012\r\t<ul class\x3D\"cool_list_nobull\">\r\t\t<li><a href\x3D\"http://blog.linode.com/2012/11/06/ubuntu-12-10-quantal-quetzal/\">Ubuntu 12.10 &mdash; Quantal Quetzal</a></li>\r\t</ul>\r\r\tOCTOBER 2012\r\t<ul class\x3D\"cool_list_nobull\">\r\t\t<li><a href\x3D\"http://blog.linode.com/2012/10/09/rails-rumble-2012/\">Rails Rumble 2012</a></li>\r\t</ul>\r\r</div>\r\r\r\r<div class\x3D\"spacer\"></div>\r\r\r<div style\x3D\"float: right; padding: 20px\">\r\t<a style\x3D\"font-weight: normal; font-size: 14px\" href\x3D\"https://manager.linode.com/signup/#plans\">View larger plans &raquo;</a>\r</div>\r\r<div class\x3D\"sidebox\">\r<h1 class\x3D\"mmmcake\">Plans and Availability</h1>\r<p id\x3D\"plans_small\">No set up fees\x2C pay month-to-month\x2C 7 day money back guarantee</p>\r\r<table class\x3D\"plans\" border\x3D0>\r\t<thead>\r\t\t\r\t\t<tr>\r\t\t\t<th>Linode<br><span>512</span></th>\r\t\t\t<th>Linode<br><span>1GB</span></th>\r\t\t\t<th>Linode<br><span>2GB</span></th>\r\t\t\t<th>Linode<br><span>4GB</span></th>\r\t\t\t<th>Linode<br><span>8GB</span></th>\r\t\t</tr>\r\t</thead>\r\t<tbody>\r\t\t<tr class\x3D\"grey\">\r\t\t\t<td>512 MB RAM</td>\r\t\t\t<td>1 GB RAM</td>\r\t\t\t<td>2 GB RAM</td>\r\t\t\t<td>4 GB RAM</td>\r\t\t\t<td>8 GB RAM</td>\r\t\t</tr>\r\t\t<tr>\r\t\t\t<td>4 CPU (1x priority)</td>\r\t\t\t<td>4 CPU (2x priority)</td>\r\t\t\t<td>4 CPU (4x priority)</td>\r\t\t\t<td>4 CPU (8x priority)</td>\r\t\t\t<td>4 CPU (16x priority)</td>\r\t\t</tr>\r\t\t<tr class\x3D\"grey\">\r\t\t\t<td>24 GB Storage</td>\r\t\t\t<td>48 GB Storage</td>\r\t\t\t<td>96 GB Storage</td>\r\t\t\t<td>192 GB Storage</td>\r\t\t\t<td>384 GB Storage</td>\r\t\t</tr>\r\t\t<tr>\r\t\t\t<td>200 GB Transfer</td>\r\t\t\t<td>400 GB Transfer</td>\r\t\t\t<td>800 GB Transfer</td>\r\t\t\t<td>1600 GB Transfer</td>\r\t\t\t<td>2000 GB Transfer</td>\r\t\t</tr>\r\t\t<tr class\x3D\"grey\">\r\t\t\t<td>$19.95 / month</td>\r\t\t\t<td>$39.95 / month</td>\r\t\t\t<td>$79.95 / month</td>\r\t\t\t<td>$159.95 / month</td>\r\t\t\t<td>$319.95 / month</td>\r\t\t</tr>\r\t</tbody>\r\t<tfoot>\r\r\t\t <!-- AVAIL 512 1434 --> \r\t\t\t\t<td>\r\t\t\t\t\t<b>1434 Available</b>\r\t\t\t\t\t<br><br>\r\t\t\t\t\t\r\t\t\t\t\t\t\r\t\t\t\t\t\t<a style\x3D\"font-size: 18px\" href\x3D\"https://manager.linode.com/signup/\?planTag\x3Dlinode512\">Sign Up!</a>\r\t\t\t\t\t\r\t\t\t\t</td>\r\t\t\t <!-- AVAIL 1024 530 --> \r\t\t\t\t<td>\r\t\t\t\t\t<b>530 Available</b>\r\t\t\t\t\t<br><br>\r\t\t\t\t\t\r\t\t\t\t\t\t\r\t\t\t\t\t\t<a style\x3D\"font-size: 18px\" href\x3D\"https://manager.linode.com/signup/\?planTag\x3Dlinode1024\">Sign Up!</a>\r\t\t\t\t\t\r\t\t\t\t</td>\r\t\t\t <!-- AVAIL 2048 221 --> \r\t\t\t\t<td>\r\t\t\t\t\t<b>221 Available</b>\r\t\t\t\t\t<br><br>\r\t\t\t\t\t\r\t\t\t\t\t\t\r\t\t\t\t\t\t<a style\x3D\"font-size: 18px\" href\x3D\"https://manager.linode.com/signup/\?planTag\x3Dlinode2048\">Sign Up!</a>\r\t\t\t\t\t\r\t\t\t\t</td>\r\t\t\t <!-- AVAIL 4096 33 --> \r\t\t\t\t<td>\r\t\t\t\t\t<b>33 Available</b>\r\t\t\t\t\t<br><br>\r\t\t\t\t\t\r\t\t\t\t\t\t\r\t\t\t\t\t\t<a style\x3D\"font-size: 18px\" href\x3D\"https://manager.linode.com/signup/\?planTag\x3Dlinode4096\">Sign Up!</a>\r\t\t\t\t\t\r\t\t\t\t</td>\r\t\t\t <!-- AVAIL 8192 25 --> \r\t\t\t\t<td>\r\t\t\t\t\t<b>25 Available</b>\r\t\t\t\t\t<br><br>\r\t\t\t\t\t\r\t\t\t\t\t\t\r\t\t\t\t\t\t<a style\x3D\"font-size: 18px\" href\x3D\"https://manager.linode.com/signup/\?planTag\x3Dlinode8192\">Sign Up!</a>\r\t\t\t\t\t\r\t\t\t\t</td>\r\t\t\t\r\t\t</tr>\r\r\t</tfoot>\r</table>\r\r</div>\r\r<br>\r\r\r\r\t\t<div class\x3D\"spacer\"></div>\r\t</div> \r</div> \r\r\r<div id\x3D\"testimonials_container\">\r\t<div id\x3D\"testimonials\">\r\r\t\t<div id\x3D\"testimonials_left\">\r\t\t\t<h2>Explore</h2>\r\r\t\t\t<ul>\r\t\t\t\t<li><a href\x3D\"/speedtest/\">Facilities Speedtest</a></li>\r\t\t\t\t<li><a href\x3D\"http://library.linode.com\">Linode Library</a></li>\r\t\t\t\t<li><a href\x3D\"/backups/\">Backup Service</a></li>\r\t\t\t\t<li><a href\x3D\"/nodebalancers/\">NodeBalancers</a></li>\r\t\t\t\t<li><a href\x3D\"/stackscripts/\">StackScripts</a></li>\r\t\t\t\t<li><a href\x3D\"/kernels/\">Kernels</a> (<a href\x3D\"http://www.linode.com/kernels/rss.xml\">rss</a>)</li>\r\t\t\t\t<li><a href\x3D\"/iphone/\">iPhone App</a></li>\r\t\t\t\t<li><a href\x3D\"/IPv6/\">IPv6</a></li>\r\t\t\t\t<li><a href\x3D\"/api/\">API</a></li>\r\t\t\t\t<li><a href\x3D\"/faq.cfm\">FAQ</a></li>\r\t\t\t</ul>\r\r\t\t\t<h2>Keep in touch</h2>\r\r\t\t\t<ul>\r\t\t\t\t<li><a href\x3D\"https://twitter.com/#!/linode\">Follow us on Twitter</a></li>\r\t\t\t\t<li><a href\x3D\"http://www.facebook.com/linode\">Facebook</a></li>\r\t\t\t\t<li><a href\x3D\"http://blog.linode.com/\">Linode Blog</a> (<a href\x3D\"http://blog.linode.com/feed/\">rss</a>)</li>\r\t\t\t\t<li><a href\x3D\"http://forum.linode.com/\">Linode Forum</a> (<a href\x3D\"http://forum.linode.com/rss.php\">rss</a>)</li>\r\t\t\t\t<li><a href\x3D\"http://status.linode.com/\">Linode Status</a> (<a href\x3D\"http://status.linode.com/blog/rss.xml\">rss</a>)</li>\r\t\t\t</ul>\r\r\t\t\t<h2>About</h2>\r\r\t\t\t<ul>\r\t\t\t\t<li><a href\x3D\"/about/\">About Us</a></li>\r\t\t\t\t<li><a href\x3D\"/jobs/\">We\'re hiring!</a></li>\r\t\t\t</ul>\r\r\r\t\t</div>\r\r\t\t<div id\x3D\"testimonials_right\">\r\r\t\t\t<h2>What our customers are saying</h2>\r\r\t\t\t<script language\x3D\"javascript\" src\x3D\"/js/jquery-1.7.2.min.js\" type\x3D\"text/javascript\"></script>\r\t\t\t<script language\x3D\"javascript\" src\x3D\"/js/jquery.tweet.js\?1\" type\x3D\"text/javascript\"></script>\r\t\t\t<link href\x3D\"/dsp/jquery.tweet.css\" media\x3D\"all\" rel\x3D\"stylesheet\" type\x3D\"text/css\"/>\r\r\t\t\t<script type\x3D\"text/javascript\" charset\x3D\"utf-8\">\r\t\t\t\tjQuery(function($){\r\t\t\t\t\t$(\".tweet\").tweet({\r\t\t\t\t\t\tavatar_size: 48\x2C\r\t\t\t\t\t\tcount: 6\x2C\r\t\t\t\t\t\tusername: \"linode\"\x2C\r\t\t\t\t\t\tfavorites: true\x2C\r\t\t\t\t\t\tloading_text: \"checking the tweets!...\"\x2C\r\t\t\t\t\t\ttemplate: \"{avatar}{join}{text}{time} {user}\"\r\t\t\t\t\t}).bind(\"loaded\"\x2Cfunction(){$(this).find(\"a\").attr(\"target\"\x2C\"_blank\");});\r\t\t\t\t});\r\r\t\t\t</script>\r\r\t\t\t<div class\x3D\"tweet\"></div>\r\r\t\t\t<div style\x3D\"text-align:center; padding-top: 20px\">\r\t\t\t\t<a target\x3D\"_blank\" href\x3D\"https://twitter.com/#!/linode/favorites\">More Twitter testimonials</a> |\r\t\t\t\t<a target\x3D\"_blank\" href\x3D\"https://twitter.com/#!/linode\">Follow us on Twitter</a>\r\t\t\t</div>\r\t\t</div>\r\r\t\t\r\r\t</div>\r\r\t<div class\x3D\"spacer\"></div>\r\r</div>\r\r\r\r\r\r\r\r\r\r\r\r<script type\x3D\"text/javascript\"> \rvar _qevents \x3D _qevents || [];\r(function() {\rvar elem \x3D document.createElement(\'script\');\relem.src \x3D (document.location.protocol \x3D\x3D \"https:\" \? \"https://secure\" : \"http://edge\") + \".quantserve.com/quant.js\";\relem.async \x3D true;\relem.type \x3D \"text/javascript\";\rvar scpt \x3D document.getElementsByTagName(\'script\')[0];\rscpt.parentNode.insertBefore(elem\x2C scpt);\r})();\r_qevents.push(\r{qacct:\"p-1dJYGOmeqAblc\"\x2Clabels:\"_fp.event.Linode Homepage\"}\r);\r</script>\r<noscript>\r<img src\x3D\"//pixel.quantserve.com/pixel/p-1dJYGOmeqAblc.gif\?labels\x3D_fp.event.Linode+Homepage\" style\x3D\"display: none;\" border\x3D\"0\" height\x3D\"1\" width\x3D\"1\" />\r</noscript>\r\r\r\r\r<div id\x3D\"bottom_divider\"></div>\r<div id\x3D\"newfooter-container\">\r\t<div id\x3D\"footer\" style\x3D\"width: 880px;\">\r\r\t\t<div id\x3D\"footer-menu\">\r\r\t\t\t<div class\x3D\"footer-menu-group\">\r\t\t\t\t<h5><a href\x3D\"http://www.linode.com/tour/\">Features</a></h5>\r\t\t\t\t<ul>\r\t\t\t\t\t<li><a href\x3D\"http://www.linode.com/tour/\">Take a Tour</a></li>\r\t\t\t\t\t<li><a href\x3D\"http://www.linode.com/linodes/\">Linodes</a></li>\r\t\t\t\t\t<li><a href\x3D\"http://www.linode.com/backups/\">Backups</a></li>\r\t\t\t\t\t<li><a href\x3D\"http://www.linode.com/stackscripts/\">StackScripts</a></li>\r\t\t\t\t\t<li><a href\x3D\"http://www.linode.com/nodebalancers/\">NodeBalancers</a></li>\r\t\t\t\t\t<li><a href\x3D\"http://www.linode.com/iphone/\">iPhone App</a></li>\r\t\t\t\t</ul>\r\t\t\t</div>\r\r\t\t\t<div class\x3D\"footer-menu-group\">\r\t\t\t\t<h5><a href\x3D\"http://www.linode.com/community/\">Community</a></h5>\r\t\t\t\t<ul>\r\t\t\t\t\t<li><a href\x3D\"http://forum.linode.com/\">Linode Forum</a></li>\r\t\t\t\t\t<li><a href\x3D\"http://www.linode.com/irc/\">IRC Chat</a></li>\r\t\t\t\t\t<li><a href\x3D\"http://www.linode.com/wiki/\">Linode Wiki</a></li>\r\t\t\t\t\t<li><a href\x3D\"http://planet.linode.com/\">Planet Linode</a></li>\r\t\t\t\t\t<li><a href\x3D\"http://www.linode.com/api/\">Developer API</a></li>\r\t\t\t\t</ul>\r\t\t\t</div>\r\r\t\t\t<div class\x3D\"footer-menu-group\">\r\t\t\t\t<h5><a href\x3D\"https://manager.linode.com/support\">Support</a></h5>\r\t\t\t\t<ul>\r\t\t\t\t\t<li><a href\x3D\"https://manager.linode.com/support\">Linode Support</a></li>\r\t\t\t\t\t<li><a href\x3D\"http://library.linode.com/\">Linode Library</a></li>\r\t\t\t\t\t<li><a href\x3D\"http://status.linode.com/\">System status</a></li>\r\t\t\t\t\t<li><a href\x3D\"http://www.linode.com/about/\">Contact us</a></li>\r\t\t\t\t</ul>\r\t\t\t</div>\r\r\t\t\t<div class\x3D\"footer-menu-group\">\r\t\t\t\t<h5><a href\x3D\"http://www.linode.com/about/\">Company</a></h5>\r\t\t\t\t<ul>\r\t\t\t\t\t<li><a href\x3D\"http://www.linode.com/about/\">About us</a></li>\r\t\t\t\t\t<li><a href\x3D\"http://blog.linode.com/\">Blog</a></li>\r\t\t\t\t\t<li><a href\x3D\"http://www.linode.com/jobs/\">Careers</a></li>\r\t\t\t\t\t<li><a href\x3D\"http://www.linode.com/tos.cfm\">Terms of service</a></li>\r\t\t\t\t\t<li><a href\x3D\"http://www.linode.com/privacy.cfm\">Privacy policy</a></li>\r\t\t\t\t</ul>\r\t\t\t</div>\r\r\t\t\t<div class\x3D\"footer-menu-group\">\r\t\t\t\t<h5>855-4-LINODE</h5>\r\t\t\t\t<ul>\r\t\t\t\t\t<li>(855-454-6633)</li>\r\t\t\t\t\t<li><a href\x3D\"mailto:service@linode.com\">service@linode.com</a></li>\r\t\t\t\t\t<li>&copy; 2013 Linode\x2C LLC</li>\r\t\t\t\t<ul>\r\t\t\t</div>\r\r\t\t</div>\r\r\t\t<div class\x3D\"clear\"></div>\r\r\t</div>\r</div>\r\r\r\r\r\r<script type\x3D\"text/javascript\">\r  var _gaq \x3D _gaq || [];\r  _gaq.push([\'_setAccount\'\x2C \'UA-177150-1\']);\r  _gaq.push([\'_trackPageview\']);\r\r  (function() {\r    var ga \x3D document.createElement(\'script\'); ga.type \x3D \'text/javascript\'; ga.async \x3D true;\r    ga.src \x3D (\'https:\' \x3D\x3D document.location.protocol \? \'https://ssl\' : \'http://www\') + \'.google-analytics.com/ga.js\';\r    var s \x3D document.getElementsByTagName(\'script\')[0]; s.parentNode.insertBefore(ga\x2C s);\r  })();\r</script>\r\r\r\r<script type\x3D\"text/javascript\">\r/* <![CDATA[ */\rvar google_conversion_id \x3D 1071926901;\rvar google_conversion_language \x3D \"en\";\rvar google_conversion_format \x3D \"3\";\rvar google_conversion_color \x3D \"666666\";\rvar google_conversion_label \x3D \"arLzCN3WggIQ9ZyR_wM\";\rvar google_conversion_value \x3D 0;\rvar prot \x3D ((\"https:\" \x3D\x3D document.location.protocol) \? \"https\" : \"http\");\rdocument.write(unescape(\"%3Cscript src\x3D\'\" + prot + \"://www.googleadservices.com/pagead/conversion.js\' type\x3D\'text/javascript\'%3E%3C/script%3E\"));\r/* ]]> */\r</script>\r<noscript>\r<div style\x3D\"display:inline;\">\r<img height\x3D\"1\" width\x3D\"1\" style\x3D\"border-style:none;\" alt\x3D\"\" src\x3D\"https://www.googleadservices.com/pagead/conversion/1071926901/\?label\x3DarLzCN3WggIQ9ZyR_wM&amp;guid\x3DON&amp;script\x3D0\"/>\r</div>\r</noscript>\r\r\r<img src\x3D\"https://secure.adnxs.com/seg\?add\x3D153827&t\x3D2\" width\x3D\"1\" height\x3D\"1\" />\r\r\r<script type\x3D\"text/javascript\">\radroll_adv_id \x3D \"IL4WBB7BGVAMPP6O6DBOTR\";\radroll_pix_id \x3D \"PYYL6IEEX5AWZGO6IXQDLQ\";\r(function () {\rvar oldonload \x3D window.onload;\rwindow.onload \x3D function(){\r  __adroll_loaded\x3Dtrue;\r  var scr \x3D document.createElement(\"script\");\r  var host \x3D ((\"https:\" \x3D\x3D document.location.protocol) \? \"https://s.adroll.com\" : \"http://a.adroll.com\");\r  scr.setAttribute(\'async\'\x2C \'true\');\r  scr.type \x3D \"text/javascript\";\r  scr.src \x3D host + \"/j/roundtrip.js\";\r  ((document.getElementsByTagName(\'head\') || [null])[0] ||\r   document.getElementsByTagName(\'script\')[0].parentNode).appendChild(scr);\r  if(oldonload){oldonload()}};\r}());\r</script>\r\r<!-- 15 ms -->\r</body>\r</html>", Scope = Public
	#tag EndConstant

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
		Sub Paint(g As Graphics, areas() As REALbasic.Rect)
		  #If RBVersion >= 2012 Then 'areas() was added in RS2012 R1
		    #pragma Unused areas
		  #endif
		  
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
		Sub Paint(g As Graphics, areas() As REALbasic.Rect)
		  #If RBVersion >= 2012 Then 'areas() was added in RS2012 R1
		    #pragma Unused areas
		  #endif
		  If ParentPic <> Nil Then
		    g.DrawPicture(ParentPic, 0, 0, g.Width, g.Height, 0, 0, ParentPic.Width, ParentPic.Height)
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Canvas1
	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  #pragma Unused X
		  #pragma Unused Y
		  Dragging = True
		  Return True
		End Function
	#tag EndEvent
	#tag Event
		Sub Paint(g As Graphics, areas() As REALbasic.Rect)
		  #If RBVersion >= 2012 Then 'areas() was added in RS2012 R1
		    #pragma Unused areas
		  #endif
		  g.DrawPicture(target, 0, 0, g.Width, g.Height, 0, 0, target.Width, target.Height)
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseDrag(X As Integer, Y As Integer)
		  #pragma Unused X
		  #pragma Unused Y
		  Dim d As New DragItem(Self, Me.MouseX, Me.MouseY, Me.Width, Me.Height, target)
		  d.Drag
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseMove(X As Integer, Y As Integer)
		  #pragma Unused X
		  #pragma Unused Y
		  If Dragging Then
		    Break
		  End If
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseUp(X As Integer, Y As Integer)
		  #pragma Unused X
		  #pragma Unused Y
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
		  fw.TrueParent.FlashWindow
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events BorderedParentPicture
	#tag Event
		Sub Paint(g As Graphics, areas() As REALbasic.Rect)
		  #If RBVersion >= 2012 Then 'areas() was added in RS2012 R1
		    #pragma Unused areas
		  #endif
		  If BorderedParentPic <> Nil Then
		    g.DrawPicture(BorderedParentPic, 0, 0, g.Width, g.Height, 0, 0, BorderedParentPic.Width, BorderedParentPic.Height)
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events HotKey
	#tag Event
		Function HotKeyPressed(Identifier As Integer, KeyString As String) As Boolean
		  MsgBox("Hotkey detected: " + KeyString + " (" + Str(Identifier) + ")")
		  Return True
		End Function
	#tag EndEvent
#tag EndEvents
