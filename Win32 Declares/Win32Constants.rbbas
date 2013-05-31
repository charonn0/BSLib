#tag Module
Protected Module Win32Constants
	#tag Method, Flags = &h0
		Function WS_EX_PALETTEWINDOW() As Integer
		  Return WS_EX_WINDOWEDGE Or WS_EX_TOOLWINDOW Or WS_EX_TOPMOST
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return STANDARD_RIGHTS_REQUIRED Or SYNCHRONIZE Or &h1FF
			End Get
		#tag EndGetter
		FILE_ALL_ACCESS As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return STANDARD_RIGHTS_READ Or FILE_READ_DATA Or FILE_READ_ATTRIBUTES Or FILE_READ_EA Or SYNCHRONIZE
			End Get
		#tag EndGetter
		FILE_GENERIC_READ As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #If TargetWin32 Then
			    Dim info As OSVERSIONINFOEX
			    info.StructSize = Info.Size
			    
			    Call GetVersionEx(info)
			    If info.MajorVersion >= 6 Then
			      Return &h1000  'PROCESS_QUERY_LIMITED_INFORMATION
			    Else
			      Return PROCESS_QUERY_INFORMATION  'On old Windows, use the old API
			    End If
			  #endif
			End Get
		#tag EndGetter
		PROCESS_QUERY_LIMITED_INFORMATION As Integer
	#tag EndComputedProperty


	#tag Constant, Name = ACCESS_SYSTEM_SECURITY, Type = Double, Dynamic = False, Default = \"&h01000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = AW_ACTIVATE, Type = Double, Dynamic = False, Default = \"&h00020000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = AW_BLEND, Type = Double, Dynamic = False, Default = \"&h00080000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = AW_CENTER, Type = Double, Dynamic = False, Default = \"&h00000010", Scope = Public
	#tag EndConstant

	#tag Constant, Name = AW_HIDE, Type = Double, Dynamic = False, Default = \"&h00010000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BLACKNESS, Type = Double, Dynamic = False, Default = \"&h00000042", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BusATA, Type = Double, Dynamic = False, Default = \"&h3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BusATAPI, Type = Double, Dynamic = False, Default = \"&h2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BusFibre, Type = Double, Dynamic = False, Default = \"&h6", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BusFileBackedVirtual, Type = Double, Dynamic = False, Default = \"&hF", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BusFirewire, Type = Double, Dynamic = False, Default = \"&h4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BusiSCSI, Type = Double, Dynamic = False, Default = \"&h9", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BusMax, Type = Double, Dynamic = False, Default = \"&h10", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BusMaxReserved, Type = Double, Dynamic = False, Default = \"&h7F", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BusMMC, Type = Double, Dynamic = False, Default = \"&hD", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BusRAID, Type = Double, Dynamic = False, Default = \"&h8", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BusSAS, Type = Double, Dynamic = False, Default = \"&hA", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BusSATA, Type = Double, Dynamic = False, Default = \"&hB", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BusSCSI, Type = Double, Dynamic = False, Default = \"&h1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BusSD, Type = Double, Dynamic = False, Default = \"&hC", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BusSSA, Type = Double, Dynamic = False, Default = \"&h5", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BusUnknown, Type = Double, Dynamic = False, Default = \"&h0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BusUSB, Type = Double, Dynamic = False, Default = \"&h7", Scope = Public
	#tag EndConstant

	#tag Constant, Name = BusVirtual, Type = Double, Dynamic = False, Default = \"&hE", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CALG_3DES, Type = Double, Dynamic = False, Default = \"&h00006603", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CALG_3DES_112, Type = Double, Dynamic = False, Default = \"&h00006609", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CALG_AES, Type = Double, Dynamic = False, Default = \"&h00006611", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CALG_AES128, Type = Double, Dynamic = False, Default = \"&h0000660e", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CALG_AES192, Type = Double, Dynamic = False, Default = \"&h0000660f", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CALG_AES256, Type = Double, Dynamic = False, Default = \"&h00006610", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CALG_DES, Type = Double, Dynamic = False, Default = \"&h00006601", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CALG_HMAC, Type = Double, Dynamic = False, Default = \"&h00008009", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CALG_MAC, Type = Double, Dynamic = False, Default = \"&h00008005", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CALG_MD2, Type = Double, Dynamic = False, Default = \"&h00008001", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CALG_MD4, Type = Double, Dynamic = False, Default = \"&h00008002", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CALG_MD5, Type = Double, Dynamic = False, Default = \"&h00008003", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CALG_RC4, Type = Double, Dynamic = False, Default = \"&h00006801", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CALG_RC5, Type = Double, Dynamic = False, Default = \"&h0000660d", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CALG_SHA1, Type = Double, Dynamic = False, Default = \"&h00008004", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CALG_SHA256, Type = Double, Dynamic = False, Default = \"&h0000800c", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CALG_SHA384, Type = Double, Dynamic = False, Default = \"&h0000800d", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CALG_SHA512, Type = Double, Dynamic = False, Default = \"&h0000800e", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CAPTUREBLT, Type = Double, Dynamic = False, Default = \"&h40000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CREATE_ALWAYS, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CREATE_NEW, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CREATE_NO_WINDOW, Type = Double, Dynamic = False, Default = \"&h08000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = CRYPT_NEWKEYSET, Type = Double, Dynamic = False, Default = \"&h00000008\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = DELETE, Type = Double, Dynamic = False, Default = \"&h00010000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = DESKTOP_SWITCHDESKTOP, Type = Double, Dynamic = False, Default = \"&h100", Scope = Public
	#tag EndConstant

	#tag Constant, Name = DI_MASK, Type = Double, Dynamic = False, Default = \"&h1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = DNS_TYPE_A, Type = Double, Dynamic = False, Default = \"&h0001", Scope = Public
	#tag EndConstant

	#tag Constant, Name = DSTINVERT, Type = Double, Dynamic = False, Default = \"&h00550009", Scope = Public
	#tag EndConstant

	#tag Constant, Name = ERROR_HANDLE_EOF, Type = Double, Dynamic = False, Default = \"&h26", Scope = Public
	#tag EndConstant

	#tag Constant, Name = ERROR_NO_MORE_FILES, Type = Double, Dynamic = False, Default = \"18", Scope = Public
	#tag EndConstant

	#tag Constant, Name = EWX_LOGOFF, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = EWX_REBOOT, Type = Double, Dynamic = False, Default = \"&h00000002", Scope = Public
	#tag EndConstant

	#tag Constant, Name = EWX_SHUTDOWN, Type = Double, Dynamic = False, Default = \"&h00000001", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_ADD_FILE, Type = Double, Dynamic = False, Default = \"&h0002", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_ADD_SUBDIRECTORY, Type = Double, Dynamic = False, Default = \"&h0004", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_APPEND_DATA, Type = Double, Dynamic = False, Default = \"&h0004", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_ATTRIBUTE_ARCHIVE, Type = Double, Dynamic = False, Default = \"&h20", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_ATTRIBUTE_COMPRESSED, Type = Double, Dynamic = False, Default = \"&h800", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_ATTRIBUTE_DEVICE, Type = Double, Dynamic = False, Default = \"&h40", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_ATTRIBUTE_DIRECTORY, Type = Double, Dynamic = False, Default = \"&h10", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_ATTRIBUTE_ENCRYPTED, Type = Double, Dynamic = False, Default = \"&h4000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_ATTRIBUTE_HIDDEN, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_ATTRIBUTE_INTEGRITY_STREAM, Type = Double, Dynamic = False, Default = \"&h8000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_ATTRIBUTE_NORMAL, Type = Double, Dynamic = False, Default = \"&h00000080", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_ATTRIBUTE_NOT_CONTENT_INDEXED, Type = Double, Dynamic = False, Default = \"&h2000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_ATTRIBUTE_NO_SCRUB_DATA, Type = Double, Dynamic = False, Default = \"&h20000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_ATTRIBUTE_OFFLINE, Type = Double, Dynamic = False, Default = \"&h1000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_ATTRIBUTE_READONLY, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_ATTRIBUTE_REPARSE_POINT, Type = Double, Dynamic = False, Default = \"&h400", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_ATTRIBUTE_SPARSE_FILE, Type = Double, Dynamic = False, Default = \"&h200", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_ATTRIBUTE_SYSTEM, Type = Double, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_ATTRIBUTE_TEMPORARY, Type = Double, Dynamic = False, Default = \"&h100", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_ATTRIBUTE_VIRTUAL, Type = Double, Dynamic = False, Default = \"&h10000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_BEGIN, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_CASE_PRESERVED_NAMES, Type = Double, Dynamic = False, Default = \"&h00000002", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_CASE_SENSITIVE_SEARCH, Type = Double, Dynamic = False, Default = \"&h00000001", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_CREATE_PIPE_INSTANCE, Type = Double, Dynamic = False, Default = \"&h0004", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_CURRENT, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_DELETE_CHILD, Type = Double, Dynamic = False, Default = \"&h0040", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_DEVICE_MASS_STORAGE, Type = Double, Dynamic = False, Default = \"&h0000002d", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_END, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_EXECUTE, Type = Double, Dynamic = False, Default = \"&h0020", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_FILE_COMPRESSION, Type = Double, Dynamic = False, Default = \"&h00000010", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_FLAG_BACKUP_SEMANTICS, Type = Double, Dynamic = False, Default = \"&h02000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_FLAG_DELETE_ON_CLOSE, Type = Double, Dynamic = False, Default = \"&h04000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_FLAG_FIRST_PIPE_INSTANCE, Type = Double, Dynamic = False, Default = \"&h00080000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_FLAG_NO_BUFFERING, Type = Double, Dynamic = False, Default = \"&h20000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_FLAG_OPEN_NO_RECALL, Type = Double, Dynamic = False, Default = \"&h00100000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_FLAG_OPEN_REPARSE_POINT, Type = Double, Dynamic = False, Default = \"&h00200000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_FLAG_OVERLAPPED, Type = Double, Dynamic = False, Default = \"&h40000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_FLAG_POSIX_SEMANTICS, Type = Double, Dynamic = False, Default = \"&h0100000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_FLAG_RANDOM_ACCESS, Type = Double, Dynamic = False, Default = \"&h10000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_FLAG_SEQUENTIAL_SCAN, Type = Double, Dynamic = False, Default = \"&h08000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_FLAG_SESSION_AWARE, Type = Double, Dynamic = False, Default = \"&h00800000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_FLAG_WRITE_THROUGH, Type = Double, Dynamic = False, Default = \"&h80000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_LIST_DIRECTORY, Type = Double, Dynamic = False, Default = \"&h0001", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_MAP_READ, Type = Double, Dynamic = False, Default = \"&h0004", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_NAMED_STREAMS, Type = Double, Dynamic = False, Default = \"&h00040000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_NAME_NORMALIZED, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_NAME_OPENED, Type = Double, Dynamic = False, Default = \"&h8", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_NOTIFY_CHANGE_ATTRIBUTES, Type = Double, Dynamic = False, Default = \"&h00000004", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_NOTIFY_CHANGE_DIR_NAME, Type = Double, Dynamic = False, Default = \"&h00000002\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_NOTIFY_CHANGE_FILE_NAME, Type = Double, Dynamic = False, Default = \"&h00000001\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_NOTIFY_CHANGE_LAST_WRITE, Type = Double, Dynamic = False, Default = \"&h00000010", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_NOTIFY_CHANGE_SECURITY, Type = Double, Dynamic = False, Default = \"&h00000100\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_NOTIFY_CHANGE_SIZE, Type = Double, Dynamic = False, Default = \"&h00000008\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_PERSISTENT_ACLS, Type = Double, Dynamic = False, Default = \"&h00000008", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_READ_ACCESS, Type = Double, Dynamic = False, Default = \"&h0001", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_READ_ATTRIBUTES, Type = Double, Dynamic = False, Default = \"&h0080", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_READ_DATA, Type = Double, Dynamic = False, Default = \"&h0001", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_READ_EA, Type = Double, Dynamic = False, Default = \"&h0008", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_READ_ONLY_VOLUME, Type = Double, Dynamic = False, Default = \"&h00080000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_SEQUENTIAL_WRITE_ONCE, Type = Double, Dynamic = False, Default = \"&h00100000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_SHARE_DELETE, Type = Double, Dynamic = False, Default = \"&h00000004", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_SHARE_READ, Type = Double, Dynamic = False, Default = \"&h00000001", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_SHARE_WRITE, Type = Double, Dynamic = False, Default = \"&h2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_SUPPORTS_ENCRYPTION, Type = Double, Dynamic = False, Default = \"&h00020000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_SUPPORTS_EXTENDED_ATTRIBUTES, Type = Double, Dynamic = False, Default = \"&h00800000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_SUPPORTS_HARD_LINKS, Type = Double, Dynamic = False, Default = \"&h00400000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_SUPPORTS_OBJECT_IDS, Type = Double, Dynamic = False, Default = \"&h00010000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_SUPPORTS_OPEN_BY_FILE_ID, Type = Double, Dynamic = False, Default = \"&h01000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_SUPPORTS_REPARSE_POINTS, Type = Double, Dynamic = False, Default = \"&h00000080", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_SUPPORTS_SPARSE_FILES, Type = Double, Dynamic = False, Default = \"&h00000040", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_SUPPORTS_TRANSACTIONS, Type = Double, Dynamic = False, Default = \"&h00200000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_SUPPORTS_USN_JOURNAL, Type = Double, Dynamic = False, Default = \"&h02000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_TRAVERSE, Type = Double, Dynamic = False, Default = \"&h0020", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_UNICODE_ON_DISK, Type = Double, Dynamic = False, Default = \"&h00000004", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_VOLUME_IS_COMPRESSED, Type = Double, Dynamic = False, Default = \"&h00008000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_VOLUME_QUOTAS, Type = Double, Dynamic = False, Default = \"&h00000020", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_WRITE_ATTRIBUTES, Type = Double, Dynamic = False, Default = \"&h0100", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_WRITE_DATA, Type = Double, Dynamic = False, Default = \"&h0002", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILE_WRITE_EA, Type = Double, Dynamic = False, Default = \"&h0010", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FLASHW_ALL, Type = Double, Dynamic = False, Default = \"&h00000003", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FLASHW_CAPTION, Type = Double, Dynamic = False, Default = \"&h00000001", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FLASHW_STOP, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FLASHW_TIMER, Type = Double, Dynamic = False, Default = \"&h00000004", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FLASHW_TIMERNOFG, Type = Double, Dynamic = False, Default = \"&h0000000C", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FLASHW_TRAY, Type = Double, Dynamic = False, Default = \"&h00000002", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FORMAT_MESSAGE_FROM_SYSTEM, Type = Double, Dynamic = False, Default = \"&H1000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = GA_PARENT, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = GA_ROOT, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = GA_ROOTOWNER, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = GENERIC_ALL, Type = Double, Dynamic = False, Default = \"&h10000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = GENERIC_EXECUTE, Type = Double, Dynamic = False, Default = \"&h20000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = GENERIC_READ, Type = Double, Dynamic = False, Default = \"&h80000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = GENERIC_WRITE, Type = Double, Dynamic = False, Default = \"&h40000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = GWL_EXSTYLE, Type = Double, Dynamic = False, Default = \"-20", Scope = Public
	#tag EndConstant

	#tag Constant, Name = GWL_STYLE, Type = Double, Dynamic = False, Default = \"-16", Scope = Public
	#tag EndConstant

	#tag Constant, Name = GWL_WNDPROC, Type = Double, Dynamic = False, Default = \"-4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = GW_HWNDNEXT, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = GW_OWNER, Type = Double, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = HANDLE_FLAG_INHERIT, Type = Double, Dynamic = False, Default = \"&h00000001", Scope = Public
	#tag EndConstant

	#tag Constant, Name = HANDLE_FLAG_PROTECT_FROM_CLOSE, Type = Double, Dynamic = False, Default = \"&h00000002", Scope = Public
	#tag EndConstant

	#tag Constant, Name = ICU_BROWSER_MODE, Type = Double, Dynamic = False, Default = \"&h2000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = IDABORT, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = IDCANCEL, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = IDCONTINUE, Type = Double, Dynamic = False, Default = \"11", Scope = Public
	#tag EndConstant

	#tag Constant, Name = IDIGNORE, Type = Double, Dynamic = False, Default = \"5", Scope = Public
	#tag EndConstant

	#tag Constant, Name = IDNO, Type = Double, Dynamic = False, Default = \"7", Scope = Public
	#tag EndConstant

	#tag Constant, Name = IDOK, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = IDRETRY, Type = Double, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = IDTRYAGAIN, Type = Double, Dynamic = False, Default = \"10", Scope = Public
	#tag EndConstant

	#tag Constant, Name = IDYES, Type = Double, Dynamic = False, Default = \"6", Scope = Public
	#tag EndConstant

	#tag Constant, Name = INVALID_HANDLE_VALUE, Type = Double, Dynamic = False, Default = \"&hffffffff", Scope = Public
	#tag EndConstant

	#tag Constant, Name = INVALID_SET_FILE_POINTER, Type = Double, Dynamic = False, Default = \"-1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = IOCTL_STORAGE_BASE, Type = Double, Dynamic = False, Default = \"&h0000002d", Scope = Public
	#tag EndConstant

	#tag Constant, Name = LR_LOADFROMFILE, Type = Double, Dynamic = False, Default = \"&h00000010", Scope = Public
	#tag EndConstant

	#tag Constant, Name = LWA_ALPHA, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MAXIMUM_ALLOWED, Type = Double, Dynamic = False, Default = \"&h02000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MAX_PATH, Type = Double, Dynamic = False, Default = \"260", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_ABORTRETRYIGNORE, Type = Double, Dynamic = False, Default = \"&h00000002", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_APPLMODAL, Type = Double, Dynamic = False, Default = \"&h00000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_CANCELTRYCONTINUE, Type = Double, Dynamic = False, Default = \"&h00000006", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_DEFAULT_DESKTOP_ONLY, Type = Double, Dynamic = False, Default = \"&h00020000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_DEFBUTTON1, Type = Double, Dynamic = False, Default = \"&h00000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_DEFBUTTON2, Type = Double, Dynamic = False, Default = \"&h00000100", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_DEFBUTTON3, Type = Double, Dynamic = False, Default = \"&h00000200", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_DEFBUTTON4, Type = Double, Dynamic = False, Default = \"&h00000300", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_HELP, Type = Double, Dynamic = False, Default = \"&h00004000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_ICONASTERISK, Type = Double, Dynamic = False, Default = \"&h00000040", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_ICONERROR, Type = Double, Dynamic = False, Default = \"&h00000010", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_ICONEXCLAMATION, Type = Double, Dynamic = False, Default = \"&h00000030", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_ICONHAND, Type = Double, Dynamic = False, Default = \"&h00000010", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_ICONINFORMATION, Type = Double, Dynamic = False, Default = \"&h00000040", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_ICONQUESTION, Type = Double, Dynamic = False, Default = \"&h00000020", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_ICONSTOP, Type = Double, Dynamic = False, Default = \"&h00000010", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_ICONWARNING, Type = Double, Dynamic = False, Default = \"&h00000030", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_OK, Type = Double, Dynamic = False, Default = \"&h00000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_OKCANCEL, Type = Double, Dynamic = False, Default = \"&h00000001", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_RETRYCANCEL, Type = Double, Dynamic = False, Default = \"&h00000005", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_RIGHT, Type = Double, Dynamic = False, Default = \"&h00080000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_RTLREADING, Type = Double, Dynamic = False, Default = \"&h00100000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_SERVICE_NOTIFICATION, Type = Double, Dynamic = False, Default = \"&h00200000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_SETFOREGROUND, Type = Double, Dynamic = False, Default = \"&h00010000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_SYSTEMMODAL, Type = Double, Dynamic = False, Default = \"&h00001000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_TASKMODAL, Type = Double, Dynamic = False, Default = \"&h00002000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_TOPMOST, Type = Double, Dynamic = False, Default = \"&h00040000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_YESNO, Type = Double, Dynamic = False, Default = \"&h00000004", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MB_YESNOCANCEL, Type = Double, Dynamic = False, Default = \"&h00000003", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MERGECOPY, Type = Double, Dynamic = False, Default = \"&h00C000CA", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MERGEPAINT, Type = Double, Dynamic = False, Default = \"&h00BB0226", Scope = Public
	#tag EndConstant

	#tag Constant, Name = METHOD_BUFFERED, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MOD_ALT, Type = Double, Dynamic = False, Default = \"&h1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MOD_CONTROL, Type = Double, Dynamic = False, Default = \"&h2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MOD_SHIFT, Type = Double, Dynamic = False, Default = \"&h4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MOD_WIN, Type = Double, Dynamic = False, Default = \"&h8", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MOVEFILE_COPY_ALLOWED, Type = Double, Dynamic = False, Default = \"&h2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MOVEFILE_CREATE_HARDLINK, Type = Double, Dynamic = False, Default = \"&h10", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MOVEFILE_DELAY_UNTIL_REBOOT, Type = Double, Dynamic = False, Default = \"&h4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MOVEFILE_FAIL_IF_NOT_TRACKABLE, Type = Double, Dynamic = False, Default = \"&h20", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MOVEFILE_REPLACE_EXISTING, Type = Double, Dynamic = False, Default = \"&h1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MOVEFILE_WRITE_THROUGH, Type = Double, Dynamic = False, Default = \"&h8", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MS_DEF_PROV, Type = String, Dynamic = False, Default = \"Microsoft Enhanced RSA and AES Cryptogrphic Provider", Scope = Public
	#tag EndConstant

	#tag Constant, Name = NOTSRCCOPY, Type = Double, Dynamic = False, Default = \"&h00330008", Scope = Public
	#tag EndConstant

	#tag Constant, Name = NOTSRCERASE, Type = Double, Dynamic = False, Default = \"&h001100A6", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OPEN_ALWAYS, Type = Double, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OPEN_EXISTING, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_ADVSERVER, Type = Double, Dynamic = False, Default = \"22", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_ANYSERVER, Type = Double, Dynamic = False, Default = \"29", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_APPLIANCE, Type = Double, Dynamic = False, Default = \"36", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_DATACENTER, Type = Double, Dynamic = False, Default = \"21", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_DOMAINMEMBER, Type = Double, Dynamic = False, Default = \"28", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_EMBEDDED, Type = Double, Dynamic = False, Default = \"13", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_FASTUSERSWITCHING, Type = Double, Dynamic = False, Default = \"26", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_HOME, Type = Double, Dynamic = False, Default = \"19", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_MEDIACENTER, Type = Double, Dynamic = False, Default = \"35", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_MEORGREATER, Type = Double, Dynamic = False, Default = \"17", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_NT, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_NT4ORGREATER, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_PERSONALTERMINALSERVER, Type = Double, Dynamic = False, Default = \"25", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_PROFESSIONAL, Type = Double, Dynamic = False, Default = \"20", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_SERVER, Type = Double, Dynamic = False, Default = \"23", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_SERVERADMINUI, Type = Double, Dynamic = False, Default = \"34", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_SMALLBUSINESSSERVER, Type = Double, Dynamic = False, Default = \"32", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_TABLETPC, Type = Double, Dynamic = False, Default = \"33", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_TERMINALCLIENT, Type = Double, Dynamic = False, Default = \"14", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_TERMINALREMOTEADMIN, Type = Double, Dynamic = False, Default = \"15", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_TERMINALSERVER, Type = Double, Dynamic = False, Default = \"24", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_WEBSERVER, Type = Double, Dynamic = False, Default = \"31", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_WELCOMELOGONUI, Type = Double, Dynamic = False, Default = \"27", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_WIN2000ADVSERVER, Type = Double, Dynamic = False, Default = \"10", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_WIN2000DATACENTER, Type = Double, Dynamic = False, Default = \"11", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_WIN2000ORGREATER, Type = Double, Dynamic = False, Default = \"7", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_WIN2000PRO, Type = Double, Dynamic = False, Default = \"8", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_WIN2000SERVER, Type = Double, Dynamic = False, Default = \"9", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_WIN2000TERMINAL, Type = Double, Dynamic = False, Default = \"12", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_WIN95ORGREATER, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_WIN95_GOLD, Type = Double, Dynamic = False, Default = \"16", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_WIN98ORGREATER, Type = Double, Dynamic = False, Default = \"5", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_WIN98_GOLD, Type = Double, Dynamic = False, Default = \"6", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_WINDOWS, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_WOW6432, Type = Double, Dynamic = False, Default = \"30", Scope = Public
	#tag EndConstant

	#tag Constant, Name = OS_XPORGREATER, Type = Double, Dynamic = False, Default = \"18", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PAGE_READONLY, Type = Double, Dynamic = False, Default = \"&h02", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PATCOPY, Type = Double, Dynamic = False, Default = \"&h00F00021", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PATINVERT, Type = Double, Dynamic = False, Default = \"&h005A0049", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PATPAINT, Type = Double, Dynamic = False, Default = \"&h00FB0A09", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PIPE_TYPE_MESSAGE, Type = Double, Dynamic = False, Default = \"&h00000004", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PIPE_UNLIMITED_INSTANCES, Type = Double, Dynamic = False, Default = \"&hFF", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PRF_CLIENT, Type = Double, Dynamic = False, Default = \"&h00000004", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PRF_DONTFINDLNK, Type = Double, Dynamic = False, Default = \"&h0008", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PRF_FIRSTDIRDEF, Type = Double, Dynamic = False, Default = \"&h0004\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PRF_NONCLIENT, Type = Double, Dynamic = False, Default = \"&h00000002", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PRF_REQUIREABSOLUTE, Type = Double, Dynamic = False, Default = \"&h0010\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PRF_TRYPROGRAMEXTENSIONS, Type = Double, Dynamic = False, Default = \"&h0002", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PRF_VERIFYEXISTS, Type = Double, Dynamic = False, Default = \"&h0001", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PROCESSOR_ARCHITECTURE_AMD64, Type = Double, Dynamic = False, Default = \"9", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PROCESSOR_ARCHITECTURE_IA64, Type = Double, Dynamic = False, Default = \"6", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PROCESSOR_ARCHITECTURE_INTEL, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PROCESSOR_ARCHITECTURE_UNKNOWN, Type = Double, Dynamic = False, Default = \"&hffff", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PROCESS_QUERY_INFORMATION, Type = Double, Dynamic = False, Default = \"&h400", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PROCESS_SET_INFORMATION, Type = Double, Dynamic = False, Default = \"&h200", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PROCESS_TERMINATE, Type = Double, Dynamic = False, Default = \"&h1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PROCESS_VM_READ, Type = Double, Dynamic = False, Default = \"&h10", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PROV_RSA_FULL, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = READ_CONTROL, Type = Double, Dynamic = False, Default = \"&h00020000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = REPLACEFILE_WRITE_THROUGH, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_ASSIGNPRIMARYTOKEN_NAME, Type = String, Dynamic = False, Default = \"SeAssignPrimaryTokenPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_AUDIT_NAME, Type = String, Dynamic = False, Default = \"SeAuditPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_BACKUP_NAME, Type = String, Dynamic = False, Default = \"SeBackupPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_CHANGE_NOTIFY_NAME, Type = String, Dynamic = False, Default = \"SeChangeNotifyPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_CREATE_GLOBAL_PRIVILEGE_NAME, Type = String, Dynamic = False, Default = \"SeCreateGlobalPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_CREATE_PAGEFILE_NAME, Type = String, Dynamic = False, Default = \"SeCreatePagefilePrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_CREATE_PERMANENT_NAME, Type = String, Dynamic = False, Default = \"SeCreatePermanentPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_CREATE_SYMBOLIC_LINK_NAME, Type = String, Dynamic = False, Default = \"SeCreateSymbolicLinkPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_CREATE_TOKEN_NAME, Type = String, Dynamic = False, Default = \"SeCreateTokenPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_DEBUG_PRIVILEGE, Type = String, Dynamic = False, Default = \"SeDebugPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_ENABLE_DELEGATAION_NAME, Type = String, Dynamic = False, Default = \"SeEnableDelegationPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_IMPERSONATE_NAME, Type = String, Dynamic = False, Default = \"SeImpersonatePrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_INCREASE_QUOTA_NAME, Type = String, Dynamic = False, Default = \"SeIncreaseQuotaPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_INC_BASE_PRIORITY_NAME, Type = String, Dynamic = False, Default = \"SeIncreaseBasePriorityPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_INC_WORKING_SET_NAME, Type = String, Dynamic = False, Default = \"SeIncreaseWorkingSetPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_LOAD_DRIVER_NAME, Type = String, Dynamic = False, Default = \"SeLoadDriverPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_LOCK_MEMORY_NAME, Type = String, Dynamic = False, Default = \"SeLockMemoryPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_MACHINE_ACCOUNT_NAME, Type = String, Dynamic = False, Default = \"SeMachineAccountPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_MANAGE_VOLUME_NAME, Type = String, Dynamic = False, Default = \"SeManageVolumePrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_PRIVILEGE_ENABLED, Type = Double, Dynamic = False, Default = \"&h00000002", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_PRIVILEGE_REMOVED, Type = Double, Dynamic = False, Default = \"&h00000004", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_PROF_SINGLE_PROCESS_NAME, Type = String, Dynamic = False, Default = \"SeProfileSingleProcessPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_RELABLE_NAME, Type = String, Dynamic = False, Default = \"SeRelabelPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_REMOTE_SHUTDOWN_NAME, Type = String, Dynamic = False, Default = \"SeRemoteShutdownPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_RESTORE_NAME, Type = String, Dynamic = False, Default = \"SeRestorePrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_SECURITY_NAME, Type = String, Dynamic = False, Default = \"SeSecurityPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_SHUTDOWN_NAME, Type = String, Dynamic = False, Default = \"SeShutdownPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_SYNC_AGENT_NAME, Type = String, Dynamic = False, Default = \"SeSyncAgentPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_SYSTEMTIME_NAME, Type = String, Dynamic = False, Default = \"SeSystemtimePrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_SYSTEM_ENVIRONMENT_NAME, Type = String, Dynamic = False, Default = \"SeSystemEnvironmentPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_SYSTEM_PROFILE_NAME, Type = String, Dynamic = False, Default = \"SeSystemProfilePrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_TAKE_OWNERSHIP_NAME, Type = String, Dynamic = False, Default = \"SeTakeOwnershipPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_TCB_NAME, Type = String, Dynamic = False, Default = \"SeTcbPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_TIME_ZONE_NAME, Type = String, Dynamic = False, Default = \"SeTimeZonePrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_TRUSTED_CREDMAN_ACCESS_NAME, Type = String, Dynamic = False, Default = \"SeTrustedCredManAccessPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_UNDOCK_NAME, Type = String, Dynamic = False, Default = \"SeUndockPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SE_UNSOLICITED_INPUT_NAME, Type = String, Dynamic = False, Default = \"SeUnsolicitedInputPrivilege", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SHGFI_DISPLAYNAME, Type = Double, Dynamic = False, Default = \"&h000000200", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SHGFI_ICON, Type = Double, Dynamic = False, Default = \"&h000000100", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SHGFI_TYPENAME, Type = Double, Dynamic = False, Default = \"&h000000400", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SHGFI_USEFILEATTRIBUTES, Type = Double, Dynamic = False, Default = \"&h000000010", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SM_CLEANBOOT, Type = Double, Dynamic = False, Default = \"67", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SM_CXSIZEFRAME, Type = Double, Dynamic = False, Default = \"32", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SM_CYSIZE, Type = Double, Dynamic = False, Default = \"31", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SM_CYSIZEFRAME, Type = Double, Dynamic = False, Default = \"33", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SM_SHUTTINGDOWN, Type = Double, Dynamic = False, Default = \"&h2000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SPECIFIC_RIGHTS_ALL, Type = Double, Dynamic = False, Default = \"&h0000FFFF", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SRCAND, Type = Double, Dynamic = False, Default = \"&h008800C6", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SRCCOPY, Type = Double, Dynamic = False, Default = \"&h00CC0020", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SRCERASE, Type = Double, Dynamic = False, Default = \"&h00440328", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SRCINVERT, Type = Double, Dynamic = False, Default = \"&h00660046", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SRCPAINT, Type = Double, Dynamic = False, Default = \"&h00EE0086", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SSF_DESKTOPHTML, Type = Double, Dynamic = False, Default = \"&h00000200\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SSF_DONTPRETTYPATH, Type = Double, Dynamic = False, Default = \"&h00000800\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SSF_DOUBLECLICKINWEBVIEW, Type = Double, Dynamic = False, Default = \"&h00000080\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SSF_FILTER, Type = Double, Dynamic = False, Default = \"&h00010000\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SSF_HIDDENFILEEXTS, Type = Double, Dynamic = False, Default = \"&h00000004\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SSF_HIDEICONS, Type = Double, Dynamic = False, Default = \"&h00004000\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SSF_MAPNETDRVBUTTON, Type = Double, Dynamic = False, Default = \"&h00001000\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SSF_NOCONFIRMRECYCLE, Type = Double, Dynamic = False, Default = \"&h00008000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SSF_NONETCRAWLING, Type = Double, Dynamic = False, Default = \"&h00100000\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SSF_SEPPROCESS, Type = Double, Dynamic = False, Default = \"&h00080000\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SSF_SERVERADMINUI, Type = Double, Dynamic = False, Default = \"&h00000004\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SSF_SHOWALLOBJECTS, Type = Double, Dynamic = False, Default = \"&h00000001", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SSF_SHOWATTRIBCOL, Type = Double, Dynamic = False, Default = \"&h00000100\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SSF_SHOWCOMPCOLOR, Type = Double, Dynamic = False, Default = \"&h00000008\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SSF_SHOWEXTENSIONS, Type = Double, Dynamic = False, Default = \"&h00000002\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SSF_SHOWINFOTIP, Type = Double, Dynamic = False, Default = \"&h00002000\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SSF_SHOWSTARTPAGE, Type = Double, Dynamic = False, Default = \"&h00400000\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SSF_SHOWSUPERHIDDEN, Type = Double, Dynamic = False, Default = \"&h00040000\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SSF_SHOWSYSFILES, Type = Double, Dynamic = False, Default = \"&h00000020\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SSF_SORTCOLUMNS, Type = Double, Dynamic = False, Default = \"&h00000010\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SSF_STARTPANELON, Type = Double, Dynamic = False, Default = \"&h00200000\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SSF_WEBVIEW, Type = Double, Dynamic = False, Default = \"&h00020000\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SSF_WIN95CLASSIC, Type = Double, Dynamic = False, Default = \"&h00000400", Scope = Public
	#tag EndConstant

	#tag Constant, Name = STANDARD_RIGHTS_ALL, Type = Double, Dynamic = False, Default = \"&h001F0000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = STANDARD_RIGHTS_EXECUTE, Type = Double, Dynamic = False, Default = \"READ_CONTROL", Scope = Public
	#tag EndConstant

	#tag Constant, Name = STANDARD_RIGHTS_READ, Type = Double, Dynamic = False, Default = \"READ_CONTROL", Scope = Public
	#tag EndConstant

	#tag Constant, Name = STANDARD_RIGHTS_REQUIRED, Type = Double, Dynamic = False, Default = \"&h000F0000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = STANDARD_RIGHTS_WRITE, Type = Double, Dynamic = False, Default = \"READ_CONTROL", Scope = Public
	#tag EndConstant

	#tag Constant, Name = STARTF_USESTDHANDLES, Type = Double, Dynamic = False, Default = \"&h00000100", Scope = Public
	#tag EndConstant

	#tag Constant, Name = STD_ERROR_HANDLE, Type = Double, Dynamic = False, Default = \"-12\r", Scope = Public
	#tag EndConstant

	#tag Constant, Name = STD_INPUT_HANDLE, Type = Double, Dynamic = False, Default = \"-10", Scope = Public
	#tag EndConstant

	#tag Constant, Name = STD_OUTPUT_HANDLE, Type = Double, Dynamic = False, Default = \"-11", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SWP_FRAMECHANGED, Type = Double, Dynamic = False, Default = \"&h20", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SWP_NOMOVE, Type = Double, Dynamic = False, Default = \"&h2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SWP_NOSIZE, Type = Double, Dynamic = False, Default = \"&h1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SWP_NOZORDER, Type = Double, Dynamic = False, Default = \"&h4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SW_FORCEMINIMIZE, Type = Double, Dynamic = False, Default = \"11", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SW_HIDE, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SW_MAXIMIZE, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SW_MINIMIZE, Type = Double, Dynamic = False, Default = \"6", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SW_RESTORE, Type = Double, Dynamic = False, Default = \"9", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SW_SHOW, Type = Double, Dynamic = False, Default = \"5", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SW_SHOWDEFAULT, Type = Double, Dynamic = False, Default = \"10", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SW_SHOWMAXIMIZED, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SW_SHOWMINIMIZED, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SW_SHOWNORMAL, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SYNCHRONIZE, Type = Double, Dynamic = False, Default = \"&h00100000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TOKEN_ADJUST_PRIVILEGES, Type = Double, Dynamic = False, Default = \"&h00000020", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TOKEN_QUERY, Type = Double, Dynamic = False, Default = \"&h00000008", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TRUNCATE_EXISTING, Type = Double, Dynamic = False, Default = \"5", Scope = Public
	#tag EndConstant

	#tag Constant, Name = UOI_FLAGS, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = UOI_HEAPSIZE, Type = Double, Dynamic = False, Default = \"5", Scope = Public
	#tag EndConstant

	#tag Constant, Name = UOI_IO, Type = Double, Dynamic = False, Default = \"6", Scope = Public
	#tag EndConstant

	#tag Constant, Name = UOI_NAME, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = UOI_TYPE, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = UOI_USER_SID, Type = Double, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = VOLUME_NAME_DOS, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = VOLUME_NAME_GUID, Type = Double, Dynamic = False, Default = \"&h1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = VOLUME_NAME_NONE, Type = Double, Dynamic = False, Default = \"&h4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = VOLUME_NAME_NT, Type = Double, Dynamic = False, Default = \"&h2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = WHITENESS, Type = Double, Dynamic = False, Default = \"&h00FF0062", Scope = Public
	#tag EndConstant

	#tag Constant, Name = WM_GETTEXT, Type = Double, Dynamic = False, Default = \"&h000D", Scope = Public
	#tag EndConstant

	#tag Constant, Name = WM_HOTKEY, Type = Double, Dynamic = False, Default = \"&h0312", Scope = Public
	#tag EndConstant

	#tag Constant, Name = WM_PRINT, Type = Double, Dynamic = False, Default = \"&h0317", Scope = Public
	#tag EndConstant

	#tag Constant, Name = WM_SETICON, Type = Double, Dynamic = False, Default = \"&h0080", Scope = Public
	#tag EndConstant

	#tag Constant, Name = WRITE_DAC, Type = Double, Dynamic = False, Default = \"&h00040000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = WRITE_OWNER, Type = Double, Dynamic = False, Default = \"&h00080000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = WS_EX_LAYERED, Type = Double, Dynamic = False, Default = \"&h80000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = WS_EX_TOOLWINDOW, Type = Double, Dynamic = False, Default = \"&h00000080", Scope = Public
	#tag EndConstant

	#tag Constant, Name = WS_EX_TOPMOST, Type = Double, Dynamic = False, Default = \"&h00000008", Scope = Public
	#tag EndConstant

	#tag Constant, Name = WS_EX_WINDOWEDGE, Type = Double, Dynamic = False, Default = \"&h00000100", Scope = Public
	#tag EndConstant

	#tag Constant, Name = WT_EXECUTEONLYONCE, Type = Double, Dynamic = False, Default = \"&h00000008\r", Scope = Public
	#tag EndConstant


	#tag Enum, Name = TOKEN_INFORMATION_CLASS, Type = Integer, Flags = &h0
		TokenUser
		  TokenGroups
		  TokenPrivileges
		  TokenOwner
		  TokenPrimaryGroup
		  TokenDefaultDacl
		  TokenSource
		  TokenType
		  TokenImpersonationLevel
		  TokenStatistics
		  TokenRestrictedSids
		  TokenSessionId
		  TokenGroupsAndPrivileges
		  TokenSessionReference
		  TokenSandboxInert
		  TokenAuditPolicy
		  TokenOrigin
		  TokenElevationType
		  TokenLinkedToken
		  TokenElevation
		  TokenHasRestrictions
		  TokenAccessInformation
		  TokenVirtualizationAllowed
		  TokenVirtualizationEnabled
		  TokenIntegrityLevel
		  TokenUIAccess
		  TokenMandatoryPolicy
		  TokenLogonSid
		  TokenIsAppContainer
		  TokenCapabilities
		  TokenAppContainerSid
		  TokenAppContainerNumber
		  TokenUserClaimAttributes
		  TokenDeviceClaimAttributes
		  TokenRestrictedUserClaimAttributes
		  TokenRestrictedDeviceClaimAttributes
		  TokenDeviceGroups
		  TokenRestrictedDeviceGroups
		  TokenSecurityAttributes
		  TokenIsRestricted
		MaxTokenInfoClass
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="FILE_ALL_ACCESS"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FILE_GENERIC_READ"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
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
			Name="PROCESS_QUERY_LIMITED_INFORMATION"
			Group="Behavior"
			Type="Integer"
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
End Module
#tag EndModule
