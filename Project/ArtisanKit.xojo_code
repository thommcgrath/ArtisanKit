#tag Module
Protected Module ArtisanKit
	#tag CompatibilityFlags = ( TargetHasGUI )
	#tag Method, Flags = &h1
		Protected Sub BeginFocusRing()
		  #if TargetCocoa
		    Const NSFocusRingAbove = 2
		    
		    Declare Function NSClassFromString Lib "Cocoa.framework" (ClassName As CFStringRef) As Ptr
		    Declare Sub SaveGraphicsState Lib "Cocoa.framework" Selector "saveGraphicsState" (Target As Ptr)
		    Declare Sub NSSetFocusRingStyle Lib "Cocoa.framework" (Placement As Integer)
		    
		    Var GraphicsContextClass As Ptr = NSClassFromString("NSGraphicsContext")
		    SaveGraphicsState(GraphicsContextClass)
		    NSSetFocusRingStyle(NSFocusRingAbove)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function BlendColors(Color1 As Color, Color2 As Color, Color2Opacity As Double = 1) As Color
		  if Color1.Alpha <> 0 Or Color2.Alpha <> 0 Then
		    Var Err As New UnsupportedOperationException
		    Err.Message = "Cannot blend colors which have alpha channels."
		    Raise Err
		  end if
		  
		  Var RedAmt As Integer = (Color2Opacity * Color2.Red) + ((1 - Color2Opacity) * Color1.Red)
		  Var GreenAmt As Integer = (Color2Opacity * Color2.Green) + ((1 - Color2Opacity) * Color1.Red)
		  Var BlueAmt As Integer = (Color2Opacity * Color2.Blue) + ((1 - Color2Opacity) * Color1.Blue)
		  
		  Return RGB(RedAmt, GreenAmt, BlueAmt)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target32Bit or Target64Bit))
		Function CapHeight(Extends G As Graphics) As Double
		  #if TargetCocoa
		    Declare Function objc_getClass Lib "Cocoa.framework" (ClassName As CString) As Ptr
		    Var NSFont As Ptr = objc_getClass("NSFont")
		    If NSFont = Nil Then
		      #if DebugBuild
		        System.DebugLog("Unable to get class reference to NSFont.")
		      #endif
		      Return G.FontAscent * 0.8
		    End If
		    
		    Var FontObject As Ptr
		    If G.FontName = "SmallSystem" And G.FontSize = 0 Then
		      If G.Bold Then
		        Declare Function SystemFontOfSize Lib "Cocoa.framework" Selector "boldSystemFontOfSize:" (Target As Ptr, Size As Double) As Ptr
		        FontObject = SystemFontOfSize(NSFont, 11)
		      Else
		        Declare Function SystemFontOfSize Lib "Cocoa.framework" Selector "systemFontOfSize:" (Target As Ptr, Size As Double) As Ptr
		        FontObject = SystemFontOfSize(NSFont, 11)
		      End If
		    ElseIf G.FontName = "System" Or G.FontName = "SmallSystem" Then
		      If G.Bold Then
		        Declare Function SystemFontOfSize Lib "Cocoa.framework" Selector "boldSystemFontOfSize:" (Target As Ptr, Size As Double) As Ptr
		        FontObject = SystemFontOfSize(NSFont, G.FontSize)
		      Else
		        Declare Function SystemFontOfSize Lib "Cocoa.framework" Selector "systemFontOfSize:" (Target As Ptr, Size As Double) As Ptr
		        FontObject = SystemFontOfSize(NSFont, G.FontSize)
		      End If
		    Else
		      Declare Function FontWithName Lib "Cocoa.framework" Selector "fontWithName:size:" (Target As Ptr, FontName As CFStringRef, Size As Double) As Ptr
		      FontObject = FontWithName(NSFont, G.FontName, G.FontSize)
		    End If
		    
		    If FontObject = Nil Then
		      #if DebugBuild
		        System.DebugLog("Unable to get font object.")
		      #endif
		      Return G.FontAscent * 0.8
		    End If
		    
		    Declare Function GetCapHeight Lib "Cocoa.framework" Selector "capHeight" (Target As Ptr) As Double
		    Return GetCapHeight(FontObject)
		  #elseif TargetWin32
		    Return G.FontAscent * 0.75
		  #else
		    Return G.FontAscent
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ColorBrightness(C As Color) As Integer
		  Return Exp(Log((C.Red * C.Red * 0.241) + (C.Green * C.Green * 0.691) + (C.Blue * C.Blue * 0.068)) * 0.5)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ColorIsBright(Source As Color) As Boolean
		  Return ColorLuminance(Source) > 0.65 Or ColorBrightness(Source) >= 170
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ColorLuminance(Source As Color) As Double
		  If Source.Red = Source.Green And Source.Green = Source.Blue Then
		    Return Source.Red / 255
		  End If
		  
		  Var Red As Double = (Source.Red / 255) ^ 2.2
		  Var Green As Double = (Source.Green / 255) ^ 2.2
		  Var Blue As Double = (Source.Blue / 255) ^ 2.2
		  Return (0.2126 * Red) + (0.7151 * Green) + (0.0721 * Blue)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawRetinaPicture(Extends G As Graphics, Source As ArtisanKit.RetinaPicture, Left As Integer, Top As Integer)
		  G.DrawRetinaPicture(Source, Left, Top, Source.Width, Source.Height, 0, 0, Source.Width, Source.Height)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawRetinaPicture(Extends G As Graphics, Source As ArtisanKit.RetinaPicture, Left As Integer, Top As Integer, Width As Integer, Height As Integer)
		  G.DrawRetinaPicture(Source, Left, Top, Width, Height, 0, 0, Source.Width, Source.Height)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawRetinaPicture(Extends G As Graphics, Source As ArtisanKit.RetinaPicture, Left As Integer, Top As Integer, Width As Integer, Height As Integer, SourceLeft As Integer, SourceTop As Integer, SourceWidth As Integer, SourceHeight As Integer)
		  Var Factor As Double = G.ScalingFactor
		  Var BestResolution As Picture = Source
		  If Factor > 1 Then
		    BestResolution = Source.HiRes
		  End If
		  
		  G.DrawPicture(BestResolution, Left, Top, Width, Height, SourceLeft * Factor, SourceTop * Factor, SourceWidth * Factor, SourceHeight * Factor)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrawStretchedPicture(Extends G As Graphics, Source As Picture, Destination As Xojo.Rect, StretchVertical As Boolean = True, StretchHorizontal As Boolean = True)
		  If StretchHorizontal Then
		    If Source.Width Mod 3 <> 0 Then
		      Var Err As New UnsupportedFormatException
		      Err.Message = "Source picture width must be a multiple of 3"
		      Raise Err
		      Return
		    End If
		  End If
		  If StretchVertical Then
		    If Source.Height Mod 3 <> 0 Then
		      Var Err As New UnsupportedFormatException
		      Err.Message = "Source picture height must be a multiple of 3"
		      Raise Err
		      Return
		    End If
		  End If
		  If Destination.Width < Source.Width Then
		    Var Err As New UnsupportedFormatException
		    Err.Message = "Destination width must be greater than source picture width"
		    Raise Err
		    Return
		  End If
		  If Destination.Height < Source.Height Then
		    Var Err As New UnsupportedFormatException
		    Err.Message = "Destination height must be greater than source picture height"
		    Raise Err
		    Return
		  End If
		  
		  Var CellWidth, CellHeight, CellCount As Integer
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
		  
		  Var DestinationCells(-1), SourceCells(-1) As Xojo.Rect
		  DestinationCells.ResizeTo(CellCount - 1)
		  SourceCells.ResizeTo(CellCount - 1)
		  
		  If StretchHorizontal Then
		    DestinationCells(0) = New Xojo.Rect(Destination.Left, Destination.Top, CellWidth, CellHeight)
		    DestinationCells(1) = New Xojo.Rect(Destination.Left + CellWidth, Destination.Top, Destination.Width - (CellWidth * 2), CellHeight)
		    DestinationCells(2) = New Xojo.Rect(Destination.Right - CellWidth, Destination.Top, CellWidth, CellHeight)
		  ElseIf StretchVertical Then
		    DestinationCells(0) = New Xojo.Rect(Destination.Left, Destination.Top, CellWidth, CellHeight)
		    DestinationCells(1) = New Xojo.Rect(Destination.Left, Destination.Top + CellHeight, CellWidth, Destination.Height - (CellHeight * 2))
		    DestinationCells(2) = New Xojo.Rect(Destination.Left, Destination.Bottom - CellHeight, CellWidth, CellHeight)
		  End If
		  
		  SourceCells(0) = New Xojo.Rect(CellWidth * 0, CellHeight * 0, CellWidth, CellHeight)
		  SourceCells(1) = New Xojo.Rect(CellWidth * 1, CellHeight * 0, CellWidth, CellHeight)
		  SourceCells(2) = New Xojo.Rect(CellWidth * 2, CellHeight * 0, CellWidth, CellHeight)
		  
		  If StretchHorizontal And StretchVertical Then
		    DestinationCells(3) = New Xojo.Rect(Destination.Left, Destination.Top + CellHeight, CellWidth, Destination.Height - (CellHeight * 2))
		    DestinationCells(4) = New Xojo.Rect(Destination.Left + CellWidth, Destination.Top + CellHeight, Destination.Width - (CellWidth * 2), Destination.Height - (CellHeight * 2))
		    DestinationCells(5) = New Xojo.Rect(Destination.Right - CellWidth, Destination.Top + CellHeight, CellWidth, Destination.Height - (CellHeight * 2))
		    
		    DestinationCells(6) = New Xojo.Rect(Destination.Left, Destination.Bottom - CellHeight, CellWidth, CellHeight)
		    DestinationCells(7) = New Xojo.Rect(Destination.Left + CellWidth, Destination.Bottom - CellHeight, Destination.Width - (CellWidth * 2), CellHeight)
		    DestinationCells(8) = New Xojo.Rect(Destination.Right - CellWidth, Destination.Bottom - CellHeight, CellWidth, CellHeight)
		    
		    SourceCells(3) = New Xojo.Rect(CellWidth * 0, CellHeight * 1, CellWidth, CellHeight)
		    SourceCells(4) = New Xojo.Rect(CellWidth * 1, CellHeight * 1, CellWidth, CellHeight)
		    SourceCells(5) = New Xojo.Rect(CellWidth * 2, CellHeight * 1, CellWidth, CellHeight)
		    
		    SourceCells(6) = New Xojo.Rect(CellWidth * 0, CellHeight * 2, CellWidth, CellHeight)
		    SourceCells(7) = New Xojo.Rect(CellWidth * 1, CellHeight * 2, CellWidth, CellHeight)
		    SourceCells(8) = New Xojo.Rect(CellWidth * 2, CellHeight * 2, CellWidth, CellHeight)
		  End If
		  
		  For I As Integer = 0 To CellCount - 1
		    Var Dest As Xojo.Rect = DestinationCells(I)
		    Var Src As Xojo.Rect = SourceCells(I)
		    If Source IsA ArtisanKit.RetinaPicture Then
		      G.DrawRetinaPicture(ArtisanKit.RetinaPicture(Source), Dest.Left, Dest.Top, Dest.Width, Dest.Height, Src.Left, Src.Top, Src.Width, Src.Height)
		    Else
		      G.DrawPicture(Source, Dest.Left, Dest.Top, Dest.Width, Dest.Height, Src.Left, Src.Top, Src.Width, Src.Height)
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub EndFocusRing()
		  #if TargetCocoa
		    Declare Function NSClassFromString Lib "Cocoa.framework" (ClassName As CFStringRef) As Ptr
		    Declare Sub RestoreGraphicsState Lib "Cocoa.framework" Selector "restoreGraphicsState" (Target As Ptr)
		    
		    Var GraphicsContextClass As Ptr = NSClassFromString("NSGraphicsContext")
		    RestoreGraphicsState(GraphicsContextClass)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FillWithPattern(Extends G As Graphics, Source As Picture, Area As Xojo.Rect, SourcePortion As Xojo.Rect = Nil)
		  Var Factor As Double = G.ScalingFactor
		  Var Destination As Graphics = G.Clip(Area.Left, Area.Top, Area.Width, Area.Height)
		  If SourcePortion = Nil Then
		    SourcePortion = New Xojo.Rect(0, 0, Source.Width, Source.Height)
		  End If
		  
		  Var SourceWidth, SourceHeight As Integer
		  SourceWidth = SourcePortion.Width
		  SourceHeight = SourcePortion.Height
		  If Not (Source IsA ArtisanKit.RetinaPicture) Then
		    SourceWidth = SourceWidth / Factor
		    SourceHeight = SourceHeight / Factor
		  End If
		  
		  Var X, Y As Integer
		  For X = 0 To Area.Width Step SourceWidth
		    For Y = 0 To Area.Height Step SourceHeight
		      If Source IsA ArtisanKit.RetinaPicture Then
		        Destination.DrawRetinaPicture(ArtisanKit.RetinaPicture(Source), X, Y, SourceWidth, SourceHeight, SourcePortion.Left, SourcePortion.Top, SourcePortion.Width, SourcePortion.Height)
		      Else
		        Destination.DrawPicture(Source, X, Y, SourceWidth, SourceHeight / Factor, SourcePortion.Left, SourcePortion.Top, SourcePortion.Width, SourcePortion.Height)
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
		    
		    Var NSApplication As Ptr = objc_getClass("NSApplication")
		    If NSApplication <> Nil Then
		      Var SharedApplication As Ptr = GetSharedApplication(NSApplication)
		      If SharedApplication <> Nil Then
		        Return IsFullKeyboardAccessEnabled(SharedApplication)
		      End If
		    End If
		  #endif
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsDarkMode() As Boolean
		  Return REALbasic.IsDarkMode
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ScalingFactor(Extends G As Graphics) As Single
		  Return G.ScaleX
		End Function
	#tag EndMethod


	#tag Note, Name = Documentation
		
		Documentation can be found at http://docs.thezaz.com/artisankit/1.0.2
	#tag EndNote

	#tag Note, Name = Version
		
		1.1.0
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
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
