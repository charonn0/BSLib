#tag Module
Protected Module IOStreams
	#tag Method, Flags = &h0
		Function OpenWithPermissions(Extends tos As TextOutputStream, File As FolderItem, Perms As PermissionsMask) As TextOutputStream
		  Dim handle As Integer = _
		  Platform.CreateFile( _
		  File.AbsolutePath, _
		  Perms.Access, _
		  Perms.ShareMode, _
		  Perms.SecurityAttributes, _
		  Perms.CreateDisposition, _
		  Perms.Flags, _
		  Perms.Template)
		  If handle > 0 Then
		    Return New TextOutputStream(handle, 1)
		  End If
		  
		End Function
	#tag EndMethod


	#tag Structure, Name = PermissionsMask, Flags = &h0
		Access As Integer
		  ShareMode As Integer
		  SecurityAttributes As Integer
		  CreateDisposition As Integer
		  Flags As Integer
		Template As Integer
	#tag EndStructure


End Module
#tag EndModule
