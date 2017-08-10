#tag Module
Protected Module ArtisanKit
	#tag CompatibilityFlags = ( TargetHasGUI )
	#tag Method, Flags = &h1
		Protected Function BlendColors(Color1 As Color, Color2 As Color, Color2Opacity As Double = 1) As Color
		  if Color1.Alpha <> 0 Or Color2.Alpha <> 0 Then
		    Dim Err As New UnsupportedOperationException
		    Err.Message = "Cannot blend colors which have alpha channels."
		    Raise Err
		  end if
		  
		  Dim RedAmt As Integer = (Color2Opacity * Color2.Red) + ((1 - Color2Opacity) * Color1.Red)
		  Dim GreenAmt As Integer = (Color2Opacity * Color2.Green) + ((1 - Color2Opacity) * Color1.Red)
		  Dim BlueAmt As Integer = (Color2Opacity * Color2.Blue) + ((1 - Color2Opacity) * Color1.Blue)
		  
		  Return RGB(RedAmt,GreenAmt,BlueAmt)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target32Bit or Target64Bit))
		Function CapHeight(Extends G As Graphics) As Double
		  #if TargetCocoa
		    Declare Function objc_getClass Lib "Cocoa.framework" (ClassName As CString) As Ptr
		    Dim NSFont As Ptr = objc_getClass("NSFont")
		    If NSFont = Nil Then
		      #if DebugBuild
		        System.DebugLog("Unable to get class reference to NSFont.")
		      #endif
		      Return G.TextAscent * 0.8
		    End If
		    
		    Dim FontObject As Ptr
		    If G.TextFont = "SmallSystem" And G.TextSize = 0 Then
		      If G.Bold Then
		        #if Target64Bit
		          Declare Function SystemFontOfSize Lib "Cocoa.framework" Selector "boldSystemFontOfSize:" (Target As Ptr, Size As Double) As Ptr
		        #else
		          Declare Function SystemFontOfSize Lib "Cocoa.framework" Selector "boldSystemFontOfSize:" (Target As Ptr, Size As Single) As Ptr
		        #endif
		        FontObject = SystemFontOfSize(NSFont,11)
		      Else
		        #if Target64Bit
		          Declare Function SystemFontOfSize Lib "Cocoa.framework" Selector "systemFontOfSize:" (Target As Ptr, Size As Double) As Ptr
		        #else
		          Declare Function SystemFontOfSize Lib "Cocoa.framework" Selector "systemFontOfSize:" (Target As Ptr, Size As Single) As Ptr
		        #endif
		        FontObject = SystemFontOfSize(NSFont,11)
		      End If
		    ElseIf G.TextFont = "System" Or G.TextFont = "SmallSystem" Then
		      If G.Bold Then
		        #if Target64Bit
		          Declare Function SystemFontOfSize Lib "Cocoa.framework" Selector "boldSystemFontOfSize:" (Target As Ptr, Size As Double) As Ptr
		        #else
		          Declare Function SystemFontOfSize Lib "Cocoa.framework" Selector "boldSystemFontOfSize:" (Target As Ptr, Size As Single) As Ptr
		        #endif
		        FontObject = SystemFontOfSize(NSFont,G.TextSize)
		      Else
		        #if Target64Bit
		          Declare Function SystemFontOfSize Lib "Cocoa.framework" Selector "systemFontOfSize:" (Target As Ptr, Size As Double) As Ptr
		        #else
		          Declare Function SystemFontOfSize Lib "Cocoa.framework" Selector "systemFontOfSize:" (Target As Ptr, Size As Single) As Ptr
		        #endif
		        FontObject = SystemFontOfSize(NSFont,G.TextSize)
		      End If
		    Else
		      #if Target64Bit
		        Declare Function FontWithName Lib "Cocoa.framework" Selector "fontWithName:size:" (Target As Ptr, FontName As CFStringRef, Size As Double) As Ptr
		      #else
		        Declare Function FontWithName Lib "Cocoa.framework" Selector "fontWithName:size:" (Target As Ptr, FontName As CFStringRef, Size As Single) As Ptr
		      #endif
		      FontObject = FontWithName(NSFont,G.TextFont,G.TextSize)
		    End If
		    
		    If FontObject = Nil Then
		      #if DebugBuild
		        System.DebugLog("Unable to get font object.")
		      #endif
		      Return G.TextAscent * 0.8
		    End If
		    
		    #if Target64Bit
		      Declare Function GetCapHeight Lib "Cocoa.framework" Selector "capHeight" (Target As Ptr) As Double
		    #else
		      Declare Function GetCapHeight Lib "Cocoa.framework" Selector "capHeight" (Target As Ptr) As Single
		    #endif
		    Return GetCapHeight(FontObject)
		  #elseif TargetWin32
		    Return G.TextAscent * 0.75
		  #elseif TargetCarbon
		    Return G.TextAscent * 0.80
		  #else
		    Return G.TextAscent
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ColorBrightness(C As Color) As Integer
		  Return Exp(Log((C.Red * C.Red * 0.241) + (C.Green * C.Green * 0.691) + (C.Blue * C.Blue * 0.068)) * 0.5)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawRetinaPicture(Extends G As Graphics, Source As ArtisanKit.RetinaPicture, Left As Integer, Top As Integer)
		  G.DrawRetinaPicture(Source,Left,Top,Source.Width,Source.Height,0,0,Source.Width,Source.Height)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawRetinaPicture(Extends G As Graphics, Source As ArtisanKit.RetinaPicture, Left As Integer, Top As Integer, Width As Integer, Height As Integer)
		  G.DrawRetinaPicture(Source,Left,Top,Width,Height,0,0,Source.Width,Source.Height)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawRetinaPicture(Extends G As Graphics, Source As ArtisanKit.RetinaPicture, Left As Integer, Top As Integer, Width As Integer, Height As Integer, SourceLeft As Integer, SourceTop As Integer, SourceWidth As Integer, SourceHeight As Integer)
		  Dim Factor As Double = G.ScalingFactor
		  Dim BestResolution As Picture = Source
		  If Factor > 1 Then
		    BestResolution = Source.HiRes
		  End If
		  
		  G.DrawPicture(BestResolution,Left,Top,Width,Height,SourceLeft * Factor,SourceTop * Factor,SourceWidth * Factor,SourceHeight * Factor)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawStretchedPicture(Extends G As Graphics, Source As Picture, Destination As REALbasic.Rect, StretchVertical As Boolean = True, StretchHorizontal As Boolean = True)
		  If StretchHorizontal Then
		    If Source.Width Mod 3 <> 0 Then
		      Dim Err As New UnsupportedFormatException
		      Err.Message = "Source picture width must be a multiple of 3"
		      Raise Err
		      Return
		    End If
		  End If
		  If StretchVertical Then
		    If Source.Height Mod 3 <> 0 Then
		      Dim Err As New UnsupportedFormatException
		      Err.Message = "Source picture height must be a multiple of 3"
		      Raise Err
		      Return
		    End If
		  End If
		  If Destination.Width < Source.Width Then
		    Dim Err As New UnsupportedFormatException
		    Err.Message = "Destination width must be greater than source picture width"
		    Raise Err
		    Return
		  End If
		  If Destination.Height < Source.Height Then
		    Dim Err As New UnsupportedFormatException
		    Err.Message = "Destination height must be greater than source picture height"
		    Raise Err
		    Return
		  End If
		  
		  Dim CellWidth, CellHeight, CellCount As Integer
		  If StretchVertical And StretchHorizontal Then
		    CellWidth = Source.Width / 3
		    CellHeight = Source.Height / 3
		    CellCount = 9
		  ElseIf StretchVertical Then
		    CellWidth = Source.Width
		    CellHeight = Source.Height / 3
		    CellCount = 3
		  ElseIf StretchHorizontal Then
		    CellWidth = Source.Width / 3
		    CellHeight = Source.Height
		    CellCount = 3
		  End If
		  
		  Dim DestinationCells(-1), SourceCells(-1) As REALbasic.Rect
		  Redim DestinationCells(CellCount - 1)
		  Redim SourceCells(CellCount - 1)
		  
		  If StretchHorizontal Then
		    DestinationCells(0) = New REALbasic.Rect(Destination.Left,Destination.Top,CellWidth,CellHeight)
		    DestinationCells(1) = New REALbasic.Rect(Destination.Left + CellWidth,Destination.Top,Destination.Width - (CellWidth * 2),CellHeight)
		    DestinationCells(2) = New REALbasic.Rect(Destination.Right - CellWidth,Destination.Top,CellWidth,CellHeight)
		  ElseIf StretchVertical Then
		    DestinationCells(0) = New REALbasic.Rect(Destination.Left,Destination.Top,CellWidth,CellHeight)
		    DestinationCells(1) = New REALbasic.Rect(Destination.Left,Destination.Top + CellHeight,CellWidth,Destination.Height - (CellHeight * 2))
		    DestinationCells(2) = New REALbasic.Rect(Destination.Left,Destination.Bottom - CellHeight,CellWidth,CellHeight)
		  End If
		  
		  SourceCells(0) = New REALbasic.Rect(CellWidth * 0,CellHeight * 0,CellWidth,CellHeight)
		  SourceCells(1) = New REALbasic.Rect(CellWidth * 1,CellHeight * 0,CellWidth,CellHeight)
		  SourceCells(2) = New REALbasic.Rect(CellWidth * 2,CellHeight * 0,CellWidth,CellHeight)
		  
		  If StretchHorizontal And StretchVertical Then
		    DestinationCells(3) = New REALbasic.Rect(Destination.Left,Destination.Top + CellHeight,CellWidth,Destination.Height - (CellHeight * 2))
		    DestinationCells(4) = New REALbasic.Rect(Destination.Left + CellWidth,Destination.Top + CellHeight,Destination.Width - (CellWidth * 2),Destination.Height - (CellHeight * 2))
		    DestinationCells(5) = New REALbasic.Rect(Destination.Right - CellWidth,Destination.Top + CellHeight,CellWidth,Destination.Height - (CellHeight * 2))
		    
		    DestinationCells(6) = New REALbasic.Rect(Destination.Left,Destination.Bottom - CellHeight,CellWidth,CellHeight)
		    DestinationCells(7) = New REALbasic.Rect(Destination.Left + CellWidth,Destination.Bottom - CellHeight,Destination.Width - (CellWidth * 2),CellHeight)
		    DestinationCells(8) = New REALbasic.Rect(Destination.Right - CellWidth,Destination.Bottom - CellHeight,CellWidth,CellHeight)
		    
		    SourceCells(3) = New REALbasic.Rect(CellWidth * 0,CellHeight * 1,CellWidth,CellHeight)
		    SourceCells(4) = New REALbasic.Rect(CellWidth * 1,CellHeight * 1,CellWidth,CellHeight)
		    SourceCells(5) = New REALbasic.Rect(CellWidth * 2,CellHeight * 1,CellWidth,CellHeight)
		    
		    SourceCells(6) = New REALbasic.Rect(CellWidth * 0,CellHeight * 2,CellWidth,CellHeight)
		    SourceCells(7) = New REALbasic.Rect(CellWidth * 1,CellHeight * 2,CellWidth,CellHeight)
		    SourceCells(8) = New REALbasic.Rect(CellWidth * 2,CellHeight * 2,CellWidth,CellHeight)
		  End If
		  
		  For I As Integer = 0 To CellCount - 1
		    Dim Dest As REALbasic.Rect = DestinationCells(I)
		    Dim Src As REALbasic.Rect = SourceCells(I)
		    If Source IsA ArtisanKit.RetinaPicture Then
		      G.DrawRetinaPicture(ArtisanKit.RetinaPicture(Source),Dest.Left,Dest.Top,Dest.Width,Dest.Height,Src.Left,Src.Top,Src.Width,Src.Height)
		    Else
		      G.DrawPicture(Source,Dest.Left,Dest.Top,Dest.Width,Dest.Height,Src.Left,Src.Top,Src.Width,Src.Height)
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FillWithPattern(Extends G As Graphics, Source As Picture, Area As REALbasic.Rect, SourcePortion As REALbasic.Rect = Nil)
		  Dim Factor As Double = G.ScalingFactor
		  Dim Destination As Graphics = G.Clip(Area.Left,Area.Top,Area.Width,Area.Height)
		  If SourcePortion = Nil Then
		    SourcePortion = New REALbasic.Rect(0,0,Source.Width,Source.Height)
		  End If
		  
		  Dim SourceWidth, SourceHeight As Integer
		  SourceWidth = SourcePortion.Width
		  SourceHeight = SourcePortion.Height
		  If Not (Source IsA ArtisanKit.RetinaPicture) Then
		    SourceWidth = SourceWidth / Factor
		    SourceHeight = SourceHeight / Factor
		  End If
		  
		  Dim X, Y As Integer
		  For X = 0 To Area.Width Step SourceWidth
		    For Y = 0 To Area.Height Step SourceHeight
		      If Source IsA ArtisanKit.RetinaPicture Then
		        Destination.DrawRetinaPicture(ArtisanKit.RetinaPicture(Source),X,Y,SourceWidth,SourceHeight,SourcePortion.Left,SourcePortion.Top,SourcePortion.Width,SourcePortion.Height)
		      Else
		        Destination.DrawPicture(Source,X,Y,SourceWidth,SourceHeight / Factor,SourcePortion.Left,SourcePortion.Top,SourcePortion.Width,SourcePortion.Height)
		      End If
		    Next
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function FullKeyboardAccessEnabled() As Boolean
		  #if TargetCocoa
		    Declare Function objc_getClass Lib "Cocoa.framework" (aClassName As CString) As Ptr
		    Declare Function GetSharedApplication Lib "Cocoa.framework" Selector "sharedApplication" (target As Ptr) As Ptr
		    Declare Function IsFullKeyboardAccessEnabled Lib "Cocoa.framework" Selector "isFullKeyboardAccessEnabled" (target As Ptr) As Boolean
		    
		    Dim NSApplication As Ptr = objc_getClass("NSApplication")
		    If NSApplication <> Nil Then
		      Dim SharedApplication As Ptr = GetSharedApplication(NSApplication)
		      If SharedApplication <> Nil Then
		        Return IsFullKeyboardAccessEnabled(SharedApplication)
		      End If
		    End If
		  #endif
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ScalingFactor(Extends G As Graphics) As Single
		  #if XojoVersion >= 2016.04
		    Return G.ScaleX
		  #endif
		  
		  #if TargetCocoa
		    #if Target64Bit
		      Dim UserSize, DeviceSize As CGSize64
		      Declare Function CGContextConvertSizeToDeviceSpace Lib "Cocoa.framework" (Context As Integer, UserSize As CGSize64) As CGSize64
		    #else
		      Dim UserSize, DeviceSize As CGSize
		      Declare Function CGContextConvertSizeToDeviceSpace Lib "Cocoa.framework" (Context As Integer, UserSize As CGSize) As CGSize
		    #endif
		    
		    If System.IsFunctionAvailable("CGContextConvertSizeToDeviceSpace","Cocoa.framework") Then
		      UserSize.Width = 100
		      UserSize.Height = 100
		      Dim Handle As Integer = G.Handle(Graphics.HandleTypeCGContextRef)
		      DeviceSize = CGContextConvertSizeToDeviceSpace(Handle, UserSize)
		      Return DeviceSize.Width / UserSize.Width
		    End If
		  #endif
		  Return 1
		End Function
	#tag EndMethod


	#tag Note, Name = Documentation
		
		Documentation can be found at http://docs.thezaz.com/artisankit/1.0.2
	#tag EndNote

	#tag Note, Name = Version
		
		1.0.2
	#tag EndNote


	#tag Structure, Name = CGSize, Flags = &h21
		Width As Single
		Height As Single
	#tag EndStructure

	#tag Structure, Name = CGSize64, Flags = &h21
		Width As Double
		Height As Double
	#tag EndStructure


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
