#tag Class
Protected Class HotKeyListener
Inherits WindowMessenger
	#tag Event
		Function WindowMessage(Message As Integer, WParam As Ptr, LParam As Ptr) As Boolean
		  #pragma Unused Message
		  Dim keystring As String = ConstructKeyString(Integer(LParam))
		  Return HotKeyPressed(Integer(WParam), keystring)
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h1
		Protected Shared Function ConstructKeyString(lParam as Integer) As String
		  Dim lo, high As Integer
		  lo = Bitwise.BitAnd(lParam, &hFFFF)
		  high = Bitwise.ShiftRight(lParam, 16)
		  
		  Dim ret As String
		  If Bitwise.BitAnd(lo, MOD_CONTROL) <> 0 Then
		    ret = ret + "Ctrl "
		  End
		  If Bitwise.BitAnd(lo, MOD_ALT) <> 0 Then
		    ret = ret + "Alt "
		  End
		  If Bitwise.BitAnd(lo, MOD_SHIFT) <> 0 Then
		    ret = ret + "Shift "
		  End
		  If Bitwise.BitAnd(lo, MOD_WIN) <> 0 Then
		    ret = ret + "Meta "
		  End
		  ret = ReplaceAll(ret, " ", "+")
		  
		  Dim scanCode As Integer = MapVirtualKey(high, 0)
		  scanCode = Bitwise.ShiftLeft(scanCode, 16)
		  Dim keyText As New MemoryBlock(32)
		  Dim keyTextLen As Integer
		  keyTextLen = GetKeyNameText(scanCode, keyText, keyText.Size)
		  Return ret + keyText.WString(0)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor()
		  // Calling the overridden superclass constructor.
		  // Constructor() -- From WindowMessenger
		  Super.Constructor()
		  Me.AddMessageFilter(WM_HOTKEY)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(Owner As Window)
		  // Calling the overridden superclass constructor.
		  // Constructor(Owner As Window, ParamArray MessageFilters() As Integer) -- From WindowMessenger
		  Super.Constructor(Owner.Handle, WM_HOTKEY)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Destructor()
		  For Each key As Integer In KeyIDs
		    Me.UnregisterKey(key)
		  Next
		  Super.Destructor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RegisterKey(modifiers as Integer, virtualKey as Integer) As Integer
		  Dim id As Integer
		  id = GlobalAddAtom("BSLibAtom" + Str(NextNum))
		  KeyIDs.Append(id)
		  
		  If RegisterHotKey(Me.ParentWindow, id, modifiers, virtualKey) Then
		    Return id
		  Else
		    Return -1
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UnregisterKey(id as Integer)
		  Call UnregisterHotkey(Me.ParentWindow, id)
		  Call GlobalDeleteAtom(id)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function VirtualKey(Key As String) As Integer
		  Return VkKeyScan(Asc(Key))
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event HotKeyPressed(Identifier As Integer, KeyString As String) As Boolean
	#tag EndHook


	#tag Note, Name = About This Class
		This class allows you to detect specified keyboard shortcuts no matter what application has keyboard input.
		
		For example:
		
		     Dim hotkey As New HotKeyListener()
		     Dim hotkeyID As Integer = HotKey.RegisterKey(MOD_CONTROL Or MOD_ALT, HotKey.VirtualKey("a"))
		
		The above snippet would raise the HotKeyListener.HotKeyPressed event whenever the global hotkey Ctrl+Alt+a is pressed.
		Each instance of the HotKeyListener class can handle an arbitrary number of hotkey comboinations, each being uniquely
		identifiable by their hotkeyID number. A global hotkey combo can be registered to only one application at a time, and
		only the most recent application to register the combo will be notified.
		
		See: http://msdn.microsoft.com/en-us/library/windows/desktop/ms646309%28v=vs.85%29.aspx
	#tag EndNote


	#tag Property, Flags = &h1
		Protected KeyIDs() As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  Static i As Integer
			  i = i + 1
			  Return i
			End Get
		#tag EndGetter
		Private Shared NextNum As Integer
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
