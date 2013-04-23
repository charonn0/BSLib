#tag Class
Protected Class WindowMessenger
	#tag Method, Flags = &h0
		Sub AddMessageFilter(MsgID As Integer)
		  Me.MessageFilter.Value(MsgID) = "&h" + Hex(MsgID)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(HWND As Integer = 0, ParamArray Filters As Integer)
		  If HWND = 0 Then HWND = Window(0).Handle
		  Me.ParentWindow = HWND
		  For Each filter As Integer In Filters
		    AddMessageFilter(Filter)
		  Next
		  Subclass(ParentWindow, Me)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function DefWindowProc(HWND as Integer, msg as Integer, wParam as Ptr, lParam as Ptr) As Integer
		  #If TargetWin32 Then
		    For Each wndclass As Dictionary In Subclasses
		      If wndclass.HasKey(HWND) Then
		        Dim subclass As WindowMessenger = wndclass.Value(HWND)
		        If subclass <> Nil And subclass.WndProc(HWND, msg, wParam, lParam) Then
		          Return 1
		        End If
		      End
		    Next
		    Dim nextWndProc As Integer
		    nextWndProc = WndProcs.Lookup(HWND, INVALID_HANDLE_VALUE)
		    If nextWndProc <> INVALID_HANDLE_VALUE Then
		      Return CallWindowProc(nextWndProc, HWND, msg, wParam, lParam)
		    End If
		  #Else
		    #pragma Warning "This class supports Win32 applications only"
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Destructor()
		  UnSubclass(Me.ParentWindow)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PostMessage(HWND As Integer, Msg As Integer, WParam As Ptr, LParam As Ptr) As Boolean
		  'Posts the Window Message to the target window's message queue and returns immediately
		  Return User32.PostMessage(HWND, Msg, WParam, LParam)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveMessageFilter(MsgID As Integer)
		  If Me.MessageFilter.HasKey(MsgID) Then
		    Me.MessageFilter.Remove(MsgID)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SendMessage(HWND As Integer, Msg As Integer, WParam As Ptr, LParam As Ptr) As Integer
		  'Sends the Window Message to the target window and waits for a response
		  Return User32.SendMessage(HWND, Msg, WParam, LParam)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Sub Subclass(SuperWin As Integer, SubWin As WindowMessenger)
		  #If TargetWin32 Then
		    If WndProcs.HasKey(SuperWin) Then
		      Dim d As New Dictionary
		      d.Value(SuperWin) = SubWin
		      Subclasses.Append(d)
		      Return
		    End
		    Dim windproc As Ptr = AddressOf DefWindowProc
		    Dim oldWndProc As Integer = SetWindowLong(SuperWin, GWL_WNDPROC, windproc)
		    WndProcs.Value(SuperWin) = oldWndProc
		    Dim d As New Dictionary
		    d.Value(SuperWin) = SubWin
		    Subclasses.Append(d)
		  #Else
		    #pragma Warning "This class supports Win32 applications only"
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Sub UnSubclass(SuperWin As Integer)
		  #If TargetWin32 Then
		    If Not WndProcs.HasKey(SuperWin) Then Return
		    Dim oldWndProc As Ptr = WndProcs.Value(SuperWin)
		    Call SetWindowLong(SuperWin, GWL_WNDPROC, oldWndProc)
		    WndProcs.Remove(SuperWin)
		    Dim wndclass As Dictionary
		    For i As Integer = UBound(Subclasses) DownTo 0
		      wndclass = Subclasses(i)
		      If wndclass.HasKey(SuperWin) Then
		        Subclasses.Remove(i)
		      End
		    Next
		  #Else
		    #pragma Warning "This class supports Win32 applications only"
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function WndProc(HWND as Integer, msg as Integer, wParam as Ptr, lParam as Ptr) As Boolean
		  #pragma Unused HWND
		  If Me.MessageFilter.HasKey(msg) Then
		    Return WindowMessage(msg, wParam, lParam)
		  End If
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event WindowMessage(Message As Integer, WParam As Ptr, LParam As Ptr) As Boolean
	#tag EndHook


	#tag Note, Name = About this class
		This class allows RB applications to capture Window Messages sent by the system to a window or control.
		Window Messages are used to inform applications of user actions, events, and other useful things. For example
		the WM_PAINT message tells a window to repaint itself and WM_HOTKEY indicates that a global hotkey combo was 
		pressed. See the HotKeyListener class for using Hotkeys.
		
		By default, all window messages are immediately passed on to the RB framework for normal processing. Use the 
		AddMessageFilter method to specify which window messages you would like to receive. Return True from the 
		WindowMessage event to prevent the message from being passed on to the framework.
		
		Each WindowMessenger instance must belong to a window or a control. If no window/control is specified to the 
		Constructor (specifically, the handle property of the Window/Control) then your app's frontmost window will 
		be used (AKA Window(0)  See: http://docs.realsoftware.com/index.php/Window_Method)
		
		Each instance can handle any number of message types, but can only have one owning window/control.
		
		See: http://msdn.microsoft.com/en-us/library/windows/desktop/ff381405%28v=vs.85%29.aspx
		
		
		CAUTION:
		Avoid performing any lengthy actions directly in the WindowMessage event. Otherwise Windows may report that
		the application is "Not Responding." 
		
		
		
		------------------------------------------------------------------------------------------------------------------------------------------
		
		Copyright (c) 2013 Andrew Lambert
		
		Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
		to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
		and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
		
		The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
		
		    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
		    WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
		    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
		    ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	#tag EndNote


	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  If mMessageFilter = Nil Then mMessageFilter = New Dictionary
			  return mMessageFilter
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mMessageFilter = value
			End Set
		#tag EndSetter
		Protected MessageFilter As Dictionary
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mMessageFilter As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared mWndProcs As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected ParentWindow As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared Subclasses() As Dictionary
	#tag EndProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  If mWndProcs = Nil Then mWndProcs = New Dictionary
			  return mWndProcs
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mWndProcs = value
			End Set
		#tag EndSetter
		Protected Shared WndProcs As Dictionary
	#tag EndComputedProperty


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
End Class
#tag EndClass
