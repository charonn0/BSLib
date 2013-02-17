#tag Class
Protected Class CaughtException
Inherits RuntimeException
	#tag Method, Flags = &h21
		Private Shared Function CleanMangledFunction(item as string) As string
		  'This method was written by SirG3 <TheSirG3@gmail.com>; http://fireyesoftware.com/developer/stackcleaner/
		  #If rbVersion >= 2005.5
		    
		    Static blacklist() As String
		    If UBound(blacklist) <= -1 Then
		      blacklist = Array(_
		      "REALbasic._RuntimeRegisterAppObject%%o<Application>", _
		      "_NewAppInstance", _'
		      "_Main", _
		      "% main", _
		      "REALbasic._RuntimeRun" _
		      )
		    End If
		    
		    If blacklist.indexOf( item ) >= 0 Then _
		    Exit Function
		    
		    Dim parts() As String = item.Split( "%" )
		    If ubound( parts ) < 2 Then _
		    Exit Function
		    
		    Dim func As String = parts( 0 )
		    Dim returnType As String
		    If parts( 1 ) <> "" Then _
		    returnType = parseParams( parts( 1 ) ).pop
		    Dim args() As String = parseParams( parts( 2 ) )
		    
		    If func.InStr( "$" ) > 0 Then
		      args( 0 ) = "extends " + args( 0 )
		      func = func.ReplaceAll( "$", "" )
		      
		    Elseif ubound( args ) >= 0 And func.NthField( ".", 1 ) = args( 0 ) Then
		      args.remove( 0 )
		      
		    End If
		    
		    If func.InStr( "=" ) > 0 Then
		      Dim index As Integer = ubound( args )
		      
		      args( index ) = "assigns " + args( index )
		      func = func.ReplaceAll( "=", "" )
		    End If
		    
		    If func.InStr( "*" ) > 0 Then
		      Dim index As Integer = ubound( args )
		      
		      args( index ) = "paramarray " + args( index )
		      func = func.ReplaceAll( "*", "" )
		    End If
		    
		    Dim sig As String
		    If func.InStr( "#" ) > 0 Then
		      sig = "Event"
		      func = func.ReplaceAll( "#", "" )
		      
		    Elseif returnType = "" Then
		      sig = "Sub"
		      
		    Else
		      sig = "Function"
		      
		    End If
		    
		    If ubound( args ) >= 0 Then
		      sig = sig + " " + func + "( " + Join( args, ", " ) + " )"
		      
		    Else
		      sig = sig + " " + func + "()"
		      
		    End If
		    
		    
		    If returnType <> "" Then
		      sig = sig + " as " + returnType
		    End If
		    
		    Return sig
		    
		  #Else
		    Return ""
		    
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function CleanStack(error as RuntimeException) As string()
		  'This method was written by SirG3 <TheSirG3@gmail.com>; http://fireyesoftware.com/developer/stackcleaner/
		  Dim result() As String
		  
		  #If rbVersion >= 2005.5
		    For Each s As String In error.stack
		      Dim tmp As String = cleanMangledFunction( s )
		      
		      If tmp <> "" Then _
		      result.append( tmp )
		    Next
		    
		  #Else
		    // leave result empty
		    
		  #EndIf
		  
		  // we must return some sort of array (even if empty), otherwise REALbasic will return a "nil" array, causing a crash when trying to use the array.
		  // see http://realsoftware.com/feedback/viewreport.php?reportid=urvbevct
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Error as RuntimeException)
		  If Error IsA CaughtException Then
		    'Cast the Error as a CaughtException then copy the original exception
		    Error = CaughtException(Error).OriginalException
		  End If
		  Self.OriginalException = Error
		  Me.ErrorNumber = Error.ErrorNumber
		  Me.Message = Error.Message
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function ParseParams(input as string) As string()
		  'This method was written by SirG3 <TheSirG3@gmail.com>; http://fireyesoftware.com/developer/stackcleaner/
		  
		  Const kParamMode = 0
		  Const kObjectMode = 1
		  Const kIntMode = 2
		  Const kUIntMode = 3
		  Const kFloatingMode = 4
		  Const kArrayMode = 5
		  
		  Dim chars() As String = Input.Split( "" )
		  Dim funcTypes(), buffer As String
		  Dim arrays(), arrayDims(), byrefs(), mode As Integer
		  
		  For Each char As String In chars
		    Select Case mode
		    Case kParamMode
		      Select Case char
		      Case "i"
		        mode = kIntMode
		        
		      Case "u"
		        mode = kUIntMode
		        
		      Case "o"
		        mode = kObjectMode
		        
		      Case "b"
		        funcTypes.append( "boolean" )
		        
		      Case "s"
		        funcTypes.append( "string" )
		        
		      Case "f"
		        mode = kFloatingMode
		        
		      Case "c"
		        funcTypes.append( "color" )
		        
		      Case "A"
		        mode = kArrayMode
		        
		      Case "&"
		        byrefs.append( ubound( funcTypes ) + 1 )
		        
		      End Select
		      
		      
		    Case kObjectMode
		      If char = "<" Then _
		      Continue
		      
		      If char = ">" Then
		        funcTypes.append( buffer )
		        buffer = ""
		        mode = kParamMode
		        
		        Continue
		      End If
		      
		      buffer = buffer + char
		      
		      
		    Case kIntMode, kUIntMode
		      Dim intType As String = "int"
		      
		      If mode = kUIntMode Then _
		      intType = "uint"
		      
		      funcTypes.append( intType + Str( Val( char ) * 8 ) )
		      mode = kParamMode
		      
		      
		    Case kFloatingMode
		      If char = "4" Then
		        funcTypes.append( "single" )
		        
		      Elseif char = "8" Then
		        funcTypes.append( "double" )
		        
		      End If
		      
		      mode = kParamMode
		      
		    Case kArrayMode
		      arrays.append( ubound( funcTypes ) + 1 )
		      arrayDims.append( Val( char ) )
		      mode = kParamMode
		      
		    End Select
		  Next
		  
		  For i As Integer = 0 To ubound( arrays )
		    Dim arr As Integer = arrays( i )
		    Dim s As String = funcTypes( arr ) + "("
		    
		    For i2 As Integer = 2 To arrayDims( i )
		      s = s + ","
		    Next
		    
		    funcTypes( arr ) = s + ")"
		  Next
		  
		  For Each b As Integer In byrefs
		    funcTypes( b ) = "byref " + funcTypes( b )
		  Next
		  
		  Return funcTypes
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Stack() As String()
		  'Returns the Call stack for the OriginalException
		  'If UseStackCleaner = True then the stack is cleaned before being returned
		  
		  #If UseStackCleaner Then
		    Return CleanStack(Self.OriginalException)
		  #Else
		    Return Self.OriginalException.Stack
		  #endif
		End Function
	#tag EndMethod


	#tag Note, Name = About
		Code for this class was originally posted by Thomas Tempelmann on the RealSoftware blog
		at http://www.realsoftwareblog.com/2012/07/preserving-stack-trace-when-catching.html
		
		This class also incorporates code from Fireeye Software's StackCleaner project: 
		http://web.archive.org/web/20090528003537/http://fireyesoftware.com/developer/stackcleaner/
	#tag EndNote

	#tag Note, Name = Useage
		Used in conjunction with the ReRaise method, this class adds two handy features to the RuntimeException class.
		
		First, by using the ReRaise method instead of the Raise keyword when re-raising an exception, the original exception's
		stack trace will be preserved rather than replaced by the stack at the moment Raise is called.
		
		Second, if the CaughtException.UseStackCleaner constant is changed to True at compile-time, the stack trace will be cleaned
		up when read from the exception (in an uncleaned stack, the function names are mangled somewhat.)
		
		Further discussion and code from:
		http://www.realsoftwareblog.com/2012/07/preserving-stack-trace-when-catching.html
		http://fireyesoftware.com/developer/stackcleaner/
		
		
		
		  Example usage:
		  Try
		     //Blah blah
		  Catch Error As SomeException
		     //Cleanup the db, maybe logging and user notification, etc.
		     //all done, ReRaise it.
		      ReRaise Error 'Calls CaughtException.Constructor(Error), then Raises the CaughtException.
		  End Try
	#tag EndNote


	#tag Property, Flags = &h21
		Private OriginalException As RuntimeException
	#tag EndProperty


	#tag Constant, Name = UseStackCleaner, Type = Boolean, Dynamic = False, Default = \"False", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="ErrorNumber"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="RuntimeException"
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
			Name="Message"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="RuntimeException"
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
