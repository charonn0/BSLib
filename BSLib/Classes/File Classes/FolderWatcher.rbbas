#tag Class
Protected Class FolderWatcher
Inherits Win32Waiter
	#tag Event
		Sub Signalled()
		  StopWatching()
		  RaiseEvent ChangeDetected()
		  
		  'Declare Function ReadDirectoryChanges Lib "Kernel32" Alias "ReadDirectoryChangesW" (hDirectory As Integer, Buffer As Ptr, _
		  'BuffLen As Integer, WatchSubTree As Boolean, Filter As Integer, ByRef BytesReturned As Integer, Overlapped As Ptr, _
		  'OverlappedCompleteCallback As Ptr) As Boolean
		  '
		  'Dim mb As New MemoryBlock(1024 * 4) '4kb
		  'Dim filter As Integer
		  'If NameChanges Then filter = filter Or FILE_NOTIFY_CHANGE_DIR_NAME
		  'Dim sz As Integer
		  'Dim i As Integer
		  'Dim path As String = "//?/" + ReplaceAll(RootDir.AbsolutePath_, "/", "//")
		  'If Right(path, 1) = "\" Then path = Left(path, path.Len - 1)
		  'Dim hDir As Integer = _
		  'CreateFile(path, _
		  'FILE_LIST_DIRECTORY Or GENERIC_ALL, _
		  'FILE_SHARE_READ Or FILE_SHARE_DELETE Or FILE_SHARE_WRITE, _
		  '0, _
		  'OPEN_EXISTING, _
		  '0, _
		  '0)
		  'i = GetLastError
		  'If ReadDirectoryChanges(hDir, mb, mb.Size, True, filter, sz, Nil, Nil) Then
		  'Dim nextoffset As Integer
		  'Dim created, deleted, modified, renamed As Boolean
		  'Dim f As FolderItem
		  'While nextoffset < mb.Size
		  'Dim name As String = mb.WString(nextoffset + 12)
		  'Dim action As Integer = mb.UInt32Value(nextoffset + 4)
		  'created = (BitAnd(action, &h00000001) = &h00000001)
		  'deleted = (BitAnd(action, &h00000002) = &h00000002)
		  'modified = (BitAnd(action, &h00000003) = &h00000003)
		  'renamed = (BitAnd(action, &h00000004) = &h00000004)
		  'f = GetFolderItem(RootDir.AbsolutePath_ + name)
		  'RaiseEvent ChangeDetected(f, created, deleted, modified, renamed)
		  'nextoffset = mb.UInt32Value(0)
		  'Wend
		  'End If
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor(Root As FolderItem)
		  Super.Constructor()
		  Me.RootDir = Root
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Destructor()
		  Super.Destructor()
		  Call FindCloseChangeNotification(WatchHandle)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StopWatching()
		  Call FindCloseChangeNotification(WatchHandle)
		  Super.StopWaiting
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Watch()
		  Dim allFilters As Integer = FILE_NOTIFY_CHANGE_ATTRIBUTES Or FILE_NOTIFY_CHANGE_DIR_NAME Or FILE_NOTIFY_CHANGE_FILE_NAME Or _
		  FILE_NOTIFY_CHANGE_LAST_WRITE Or FILE_NOTIFY_CHANGE_SECURITY Or FILE_NOTIFY_CHANGE_SIZE
		  
		  WatchHandle = FindFirstChangeNotification(Me.RootDir.AbsolutePath_, True, allFilters)
		  If WatchHandle > 0 Then
		    Super.Wait(WatchHandle)
		  End If
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event ChangeDetected()
	#tag EndHook


	#tag Note, Name = EXPERIMENTAL
		And crashy
		
	#tag EndNote


	#tag Property, Flags = &h0
		NameChanges As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected RootDir As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		SizeChanges As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected WatchHandle As Integer
	#tag EndProperty


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
			Name="NameChanges"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SizeChanges"
			Group="Behavior"
			Type="Boolean"
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
End Class
#tag EndClass
