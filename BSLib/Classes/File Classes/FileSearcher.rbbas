#tag Class
Protected Class FileSearcher
Inherits Thread
	#tag Event
		Sub Run()
		  List(RootDirectory)
		  If Not GUISafe Then
		    RaiseEvent Done()
		  Else
		    FoundItems.Insert(0, Nil)
		  End If
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub GUITimerHandler(Sender As Timer)
		  #pragma Unused Sender
		  While UBound(FoundItems) > -1
		    Dim item As FolderItem = FoundItems.Pop
		    If item <> Nil Then
		      If RaiseEvent FoundItem(item) Then Me.Kill
		    Else
		      RaiseEvent Done()
		    End If
		  Wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub List(Dir As FolderItem)
		  Depth = Depth + 1
		  If Depth > MaximumDepth And MaximumDepth > 0 Then
		    Depth = Depth - 1
		    Return
		  End If
		  
		  Dim fe As FileEnumerator
		  
		  If Me.Mode = Mode_Depth_First Then
		    fe = New FileEnumerator(Dir)
		    Do
		      Dim folder As FolderItem = fe.NextFolderItem(True)
		      If folder <> Nil Then
		        List(folder)
		        App.YieldToNextThread()
		      End If
		    Loop Until fe.LastError <> 0
		  End If
		  
		  
		  fe = New FileEnumerator(Dir, Pattern)
		  Dim i As Integer
		  Do
		    Dim file As FolderItem = fe.NextFolderItem()
		    If file <> Nil Then
		      If Not GUISafe Then
		        If RaiseEvent FoundItem(file) Then Me.Kill
		      Else
		        FoundItems.Insert(0, file)
		      End If
		    End If
		    If i Mod 5 = 0 Then App.YieldToNextThread
		    i = i + 1
		  Loop Until fe.LastError <> 0
		  
		  If Me.Mode = Mode_Breadth_First Then
		    fe = New FileEnumerator(Dir)
		    Do
		      Dim folder As FolderItem = fe.NextFolderItem(True)
		      If folder <> Nil Then
		        List(folder)
		        App.YieldToNextThread()
		      End If
		    Loop Until fe.LastError <> 0
		  End If
		  
		  Depth = Depth - 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Run()
		  Super.Run
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Search(Root As FolderItem, Pattern As String = "*", GUISafe As Boolean = True, Mode As Integer = Mode_Depth_First)
		  Depth = 0
		  ReDim FoundItems(-1)
		  mRootDirectory = Root
		  mPattern = Pattern
		  Me.GUISafe = GUISafe
		  Me.Mode = Mode
		  Me.Run
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Done()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event FoundItem(Found As FolderItem) As Boolean
	#tag EndHook


	#tag Note, Name = About this class
		This class performs an asynchronous, depth-first, recursive search of the specified root directory 
		for all file and folder names matching a particular pattern.
		
		Each matching file or folder will be passed to the FoundItem event. If GUISafe=True, then the
		FoundItem event is raised on the main thread, otherwise the event is raised on the current thread.
		
		Return True from the FoundItem event to stop searching and kill the thread.
	#tag EndNote


	#tag Property, Flags = &h21
		Private Depth As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private FoundItems() As FolderItem
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mGUISafe
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value Then
			    GUITimer = New Timer
			    GUITimer.Period = 10
			    AddHandler GUITimer.Action, WeakAddressOf Me.GUITimerHandler
			    GUITimer.Mode = Timer.ModeMultiple
			  Else
			    GUITimer = Nil
			  End If
			  mGUISafe = value
			End Set
		#tag EndSetter
		GUISafe As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private GUITimer As Timer
	#tag EndProperty

	#tag Property, Flags = &h0
		MaximumDepth As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGUISafe As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Mode As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPattern As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRootDirectory As FolderItem
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mPattern
			End Get
		#tag EndGetter
		Pattern As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mRootDirectory
			End Get
		#tag EndGetter
		RootDirectory As FolderItem
	#tag EndComputedProperty


	#tag Constant, Name = Mode_Breadth_First, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Mode_Depth_First, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="GUISafe"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			InheritedFrom="Thread"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="Thread"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MaximumDepth"
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Thread"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Pattern"
			Group="Behavior"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Priority"
			Visible=true
			Group="Behavior"
			InitialValue="5"
			Type="Integer"
			InheritedFrom="Thread"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StackSize"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="Thread"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Thread"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			Type="Integer"
			InheritedFrom="Thread"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
