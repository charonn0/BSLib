#tag Module
Protected Module Kernel32
	#tag ExternalMethod, Flags = &h0
		Soft Declare Function Beep Lib "Kernel32" Alias "WinBeep" (freq As Integer, duration As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function CloseHandle Lib "Kernel32" (handle As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function CreateFile Lib "Kernel32" Alias "CreateFileW" (name As WString, access As Integer, sharemode As Integer, SecAtrribs As Integer, CreateDisp As Integer, flags As Integer, template As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Soft Declare Function CreateHardLink Lib "Kernel32" Alias "CreateHardLinkW" (NewPath As WString, ExistingFile As WString, Reserved As Ptr) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function CreateProcess Lib "Kernel32" Alias "CreateProcessW" (AppName As WString, commandline As Ptr, ProcessAttribs As SECURITY_ATTRIBUTES, ThreadAttribs As SECURITY_ATTRIBUTES, inheritHandles As Boolean, flags As Integer, environ As Ptr, currentDir As Ptr, startInfo As STARTUPINFO, ByRef info As PROCESS_INFORMATION) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Soft Declare Function CreateSymbolicLink Lib "Kernel32" Alias "CreateSymbolicLinkW" (NewPath As WString, ExistingFile As WString, Flags As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function DeleteFile Lib "Kernel32" Alias "DeleteFileW" (Path As WString) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function DeviceIoControl Lib "Kernel32" (hDevice As Integer, dwIoControlCode As Integer, lpInBuffer As Ptr, nInBufferSize As Integer, lpOutBuffer As Ptr, nOutBufferSize As Integer, lpBytesReturned As Ptr, lpOverlapped As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function ExpandEnvironmentStrings Lib "Kernel32" Alias "ExpandEnvironmentStringsW" (EnvString As WString, parsedString As Ptr, buffSize As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Soft Declare Function FatalAppExit Lib "Kernel32" Alias "FatalAppExitW" (Action As Integer, Message As WString) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function FileTimeToSystemTime Lib "Kernel32" (fileTime As Ptr, systemTime As Ptr) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function FillConsoleOutputAttribute Lib "Kernel32" (cHandle As Integer, attrib As UInt16, len As Integer, startCoord As COORD, ByRef charsWritten As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function FillConsoleOutputCharacter Lib "Kernel32" Alias "FillConsoleOutputCharacterW" (cHandle As Integer, character As Integer, length As Integer, startCoord As COORD, ByRef charsWritten As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Soft Declare Function FindClose Lib "Kernel32" (FindHandle As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function FindFirstChangeNotification Lib "Kernel32" Alias "FindFirstChangeNotificationW" (dirPath As WString, watchChildren As Boolean, eventTypeFilter As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Soft Declare Function FindFirstStream Lib "Kernel32" Alias "FindFirstStreamW" (filename As WString, InfoLevel As Integer, ByRef buffer As WIN32_FIND_STREAM_DATA, Reserved As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Soft Declare Function FindNextStream Lib "Kernel32" Alias "FindNextStreamW" (FindHandle As Integer, ByRef buffer As WIN32_FIND_STREAM_DATA) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function FormatMessage Lib "Kernel32" Alias "FormatMessageW" (dwFlags As Integer, lpSource As Integer, dwMessageId As Integer, dwLanguageId As Integer, lpBuffer As ptr, nSize As Integer, Arguments As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GenerateConsoleCtrlEvent Lib "Kernel32" (cHandle As Integer, character As Integer, length As Integer, startCoord As COORD, ByRef charsWritten As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetBinaryType Lib "Kernel32" Alias "GetBinaryTypeW" (appFile As WString, ByRef binType As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetComputerName Lib "Kernel32" Alias "GetComputerNameW" (name As Ptr, ByRef size As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetConsoleCursorInfo Lib "Kernel32" (cHandle As Integer, ByRef CurseInfo As CONSOLE_CURSOR_INFO) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetConsoleDisplayMode Lib "Kernel32" (ByRef flags As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Soft Declare Function GetConsoleOriginalTitle Lib "Kernel32" Alias "GetConsoleOriginalTitleW" (Contitle As Ptr, mbsize As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Soft Declare Function GetConsoleScreenBufferInfo Lib "Kernel32" (hConsole As Integer, ByRef buffinfo As CONSOLE_SCREEN_BUFFER_INFO) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetCurrentProcess Lib "Kernel32" () As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetCurrentThreadId Lib "Kernel32" () As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetDevicePowerState Lib "Kernel32" (dHandle As Integer, ByRef IsOn As Boolean) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetDiskFreeSpaceEx Lib "Kernel32" Alias "GetDiskFreeSpaceExW" (dirname As WString, ByRef freeBytesAvailable As UInt64, ByRef totalbytes As UInt64, ByRef totalFreeBytes As UInt64) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetFileAttributes Lib "Kernel32" Alias "GetFileAttributesW" (path As WString) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetLargestConsoleWindowSize Lib "Kernel32" (cHandle As Integer) As COORD
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetLastError Lib "Kernel32" () As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Soft Declare Sub GetNativeSystemInfo Lib "Kernel32" (ByRef info As SYSTEM_INFO)
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Soft Declare Function GetProcessImageFileName Lib "Kernel32" Alias "GetProcessImageFileNameW" (pHandle As Integer, path As Ptr, pathsize As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetStdHandle Lib "Kernel32" (hIOStreamType As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Soft Declare Function GetSystemDefaultLocaleName Lib "Kernel32" (buffer As Ptr, bufferSize As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Soft Declare Sub GetSystemInfo Lib "Kernel32" (ByRef info As SYSTEM_INFO)
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetSystemTimes Lib "Kernel32" (idleTime As Ptr, kernelTime As Ptr, userTime As Ptr) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Soft Declare Function GetTimeZoneInformation Lib "Kernel32" (ByRef TZInfo As TIME_ZONE_INFORMATION) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Soft Declare Function GetVersionEx Lib "Kernel32" Alias "GetVersionExA" (ByRef info As OSVERSIONINFOEX) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Soft Declare Function GetVolumeInformation Lib "Kernel32" Alias "GetVolumeInformationW" (path As WString, volumeName As Ptr, volnameSize As Integer, volumeSerialNumber As Ptr, ByRef maximumNameLength As Integer, ByRef FSFlags As Integer, filesystem As Ptr, fsNameSize As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function GetVolumeNameForVolumeMountPoint Lib "Kernel32" Alias "GetVolumeNameForVolumeMountPointW" (mountPoint As WString, volumeName As Ptr, bufferSize As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Soft Declare Function GlobalMemoryStatusEx Lib "Kernel32" (ByRef MemStatus As MEMORYSTATUSEX) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function IsWow64Process Lib "Kernel32" (handle As Integer, ByRef is64 As Boolean) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function LockFile Lib "Kernel32" (FileHandle As Integer, dwFileOffsetLow As Integer, dwFileOffsetHigh As Integer, nNumberOfBytesToLockLow As Integer, nNumberOfBytesToLockHigh As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function MoveFileEx Lib "Kernel32" Alias "MoveFileExW" (sourceFile As WString, destinationFile As WString, flags As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Soft Declare Function OpenProcess Lib "Kernel32" (dwDesiredAccessAs As Integer, bInheritHandle As Integer, dwProcId As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Soft Declare Function QueryDosDevice Lib "Kernel32" Alias "QueryDosDeviceW" (devicePath As WString, drivePath As Ptr, drivePathSize As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function ReadConsoleOutputCharacter Lib "Kernel32" Alias "ReadConsoleOutputCharacterW" (cHandle As Integer, chars As Ptr, Length As Integer, buffCords As COORD, charsRead As Ptr) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function RegisterWaitForSingleObject Lib "Kernel32" (ByRef waitHandle As Integer, objectHandle As Integer, callback As Ptr, context As Ptr, waitMilliseconds As Integer, flags As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function ReplaceFile Lib "Kernel32" Alias "ReplaceFileW" (SourceFile As WString, destinationFile As WString, backupFile As Ptr, flags As Integer, Reserved1 As Integer, Reserved2 As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function SetConsoleCtrlHandler Lib "Kernel32" (handlerRoutine As Ptr, add As Boolean) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function SetConsoleCursorInfo Lib "Kernel32" (cHandle As Integer, ByRef CurseInfo As CONSOLE_CURSOR_INFO) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function SetConsoleCursorPosition Lib "Kernel32" (cHandle As Integer, NewCoords As COORD) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function SetConsoleScreenBufferInfoEx Lib "Kernel32" (cHandle As Integer, info As CONSOLE_SCREEN_BUFFER_INFOEX) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Soft Declare Function SetConsoleScreenBufferSize Lib "Kernel32" (Handle As Integer, NewSize As COORD) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function SetConsoleTextAttribute Lib "Kernel32" (hConsole As Integer, attribs As UInt16) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function SetConsoleTitle Lib "Kernel32" Alias "SetConsoleTitleW" (NewTitle As WString) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function SetConsoleWindowInfo Lib "Kernel32" (cHandle As Integer, Absolute As Boolean, ByRef coords As SMALL_RECT) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function SetFileAttributes Lib "Kernel32" Alias "SetFileAttributesW" (path As WString, fattribs As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function UnlockFile Lib "Kernel32" (FileHandle As Integer, dwFileOffsetLow As integer, dwFileOffsetHigh As integer, nNumberOfBytesToUnlockLow As integer, nNumberOfBytesToUnlockHigh As integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function UnregisterWait Lib "Kernel32" (WaitHandle As Integer) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h0
		Declare Function WriteConsoleOutputCharacter Lib "Kernel32" Alias "WriteConsoleOutputCharacterW" (cHandle As Integer, chars As Ptr, Length As Integer, buffCoords As COORD, charWritten As Ptr) As Boolean
	#tag EndExternalMethod


	#tag ViewBehavior
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