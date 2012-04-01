#tag Module
Protected Module PowerState
	#tag Method, Flags = &h21
		Private Function BatteryState() As SYSTEM_BATTERY_STATE()
		  #If TargetWin32 Then
		    Declare Function CallNtPowerInformation Lib "PowrProf" (infoLevel As Integer, InputBuffer As Ptr, _
		    buffSize As Integer, OutputBuffer As Ptr, outbufferSize As Integer) As Integer
		    
		    Const Battery = 5
		    
		    Dim info As New MemoryBlock(32 * NumberOfProcessors)
		    Call CallNtPowerInformation(Battery, Nil, 0, info, info.Size)
		    
		    Dim ret() As SYSTEM_BATTERY_STATE
		    For i As Integer = 0 To info.Size - 24 Step 24
		      Dim ppi As SYSTEM_BATTERY_STATE
		      ppi.ACOnline = info.BooleanValue(i)
		      ppi.BatteryPresent = info.BooleanValue(i + 1)
		      ppi.Charging = info.BooleanValue(i + 2)
		      ppi.Discharging = info.BooleanValue(i + 3)
		      ppi.MaxCapacity = info.Int32Value(i + 7)
		      ppi.RemainingCapacity = info.Int32Value(i + 11)
		      ppi.Rate = info.Int32Value(i + 15)
		      ppi.EstimatedTimer = info.Int32Value(i + 19)
		      ppi.DefaultAlert1 = info.Int32Value(i + 23)
		      ppi.DefaultAlert2 = info.Int32Value(i + 27)
		      
		      ret.Append(ppi)
		    Next
		    Return ret
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsDevicePoweredUp(devHandle As Integer) As Boolean
		  Declare Function GetDevicePowerState Lib "Kernel32" (dHandle As Integer, ByRef IsOn As Boolean) As Boolean
		  Dim ret As Boolean
		  Call GetDevicePowerState(devHandle, ret)
		  Return ret
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsFileOnActiveDrive(target As FolderItem) As Boolean
		  #If TargetWin32 Then
		    Declare Function GetVolumeNameForVolumeMountPointW Lib "Kernel32" (mountPoint As WString, volumeName As Ptr, bufferSize As Integer) As Boolean
		    
		    Dim dhandle As Integer
		    Dim drvRoot As String = target.AbsolutePath
		    dhandle = Platform.CreateFile(drvRoot, GENERIC_READ, FILE_SHARE_READ Or FILE_SHARE_WRITE, 0, OPEN_EXISTING, 0, 0)
		    If dhandle = -1 Then
		      dhandle = Platform.LastErrorCode
		      Return True
		    End If
		    
		    Dim ret As Boolean = IsDevicePoweredUp(dhandle)
		    Call Platform.CloseHandle(dhandle)
		    Return ret
		  #endif
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //Returns the current battery (dis)charge rate in milliwatt hours. Negative values
			  //indicate that the battery is discharging whereas positive values indicate that the
			  //battery is charging. Not all batteries report charging rates.
			  
			  
			  Dim procs() As SYSTEM_BATTERY_STATE = BatteryState()
			  Return procs(0).Rate
			End Get
		#tag EndGetter
		Protected BatteryDischargeRate As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //Returns True if the computer has at least one battery.
			  
			  
			  Dim procs() As SYSTEM_BATTERY_STATE = BatteryState()
			  Return procs(0).BatteryPresent
			End Get
		#tag EndGetter
		Protected BatteryPresent As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //Returns the remaining capacity of the battery or batteries in milliwatt hours.
			  
			  
			  Dim procs() As SYSTEM_BATTERY_STATE = BatteryState()
			  Return procs(0).EstimatedTimer
			End Get
		#tag EndGetter
		Protected BatteryTimeRemaining As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //Returns True if a battery is charging.
			  
			  
			  Dim procs() As SYSTEM_BATTERY_STATE = BatteryState()
			  Return procs(0).Charging
			End Get
		#tag EndGetter
		Protected Charging As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //Returns the recommended remaining battery capacity at which a critical battery alert should be given.
			  
			  
			  Dim procs() As SYSTEM_BATTERY_STATE = BatteryState()
			  Return procs(0).DefaultAlert2
			End Get
		#tag EndGetter
		Protected CriticalBatteryLevel As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //Returns the recommended remaining battery capacity at which a low-battery notice should be given.
			  
			  
			  Dim procs() As SYSTEM_BATTERY_STATE = BatteryState()
			  Return procs(0).DefaultAlert1
			End Get
		#tag EndGetter
		Protected LowBatteryLevel As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //Returns the maximum capacity of the battery in milliwatt hours.
			  
			  
			  Dim procs() As SYSTEM_BATTERY_STATE = BatteryState()
			  Return procs(0).MaxCapacity
			End Get
		#tag EndGetter
		Protected MaxBatteryCapacity As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //Returns True if the computer is plugged into the mains rather than running on batteries.
			  
			  
			  Dim procs() As SYSTEM_BATTERY_STATE = BatteryState()
			  Return procs(0).ACOnline
			End Get
		#tag EndGetter
		Protected OnAcPower As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //Returns True if the computer is running on batteries.
			  
			  
			  Dim procs() As SYSTEM_BATTERY_STATE = BatteryState()
			  Return procs(0).Discharging
			End Get
		#tag EndGetter
		Protected OnBatteries As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //Returns the remaining capacity of the battery in milliwatt hours.
			  
			  
			  Dim procs() As SYSTEM_BATTERY_STATE = BatteryState()
			  Return procs(0).RemainingCapacity
			End Get
		#tag EndGetter
		Protected RemainingBatteryCapacity As Integer
	#tag EndComputedProperty


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
