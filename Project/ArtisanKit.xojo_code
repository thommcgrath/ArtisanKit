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
		    
		    Dim GraphicsContextClass As Ptr = NSClassFromString("NSGraphicsContext")
		    SaveGraphicsState(GraphicsContextClass)
		    NSSetFocusRingStyle(NSFocusRingAbove)
		  #endif
		End Sub
	#tag EndMethod

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
		  
		  Return RGB(RedAmt, GreenAmt, BlueAmt)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target32Bit or Target64Bit))
		Function CapHeight(Extends G As Graphics) As Double
		  Dim FontName As String
		  Dim FontSize As Single
		  Dim Bold As Boolean = G.Bold
		  Dim FontAscent As Double
		  #if XojoVersion >= 2019.02
		    FontName = G.FontName
		    FontSize = G.FontSize
		    FontAscent = G.FontAscent
		  #else
		    FontName = G.TextFont
		    FontSize = G.TextSize
		    FontAscent = G.TextAscent
		  #endif
		  
		  #if TargetCocoa
		    Declare Function objc_getClass Lib "Cocoa.framework" (ClassName As CString) As Ptr
		    Dim NSFont As Ptr = objc_getClass("NSFont")
		    If NSFont = Nil Then
		      #if DebugBuild
		        System.DebugLog("Unable to get class reference to NSFont.")
		      #endif
		      Return FontAscent * 0.8
		    End If
		    
		    #if Target64Bit
		      Declare Function SystemFontOfSize Lib "Cocoa.framework" Selector "systemFontOfSize:" (Target As Ptr, Size As Double) As Ptr
		      Declare Function BoldSystemFontOfSize Lib "Cocoa.framework" Selector "boldSystemFontOfSize:" (Target As Ptr, Size As Double) As Ptr
		      Declare Function FontWithName Lib "Cocoa.framework" Selector "fontWithName:size:" (Target As Ptr, FontName As CFStringRef, Size As Double) As Ptr
		      Declare Function GetCapHeight Lib "Cocoa.framework" Selector "capHeight" (Target As Ptr) As Double
		    #else
		      Declare Function SystemFontOfSize Lib "Cocoa.framework" Selector "systemFontOfSize:" (Target As Ptr, Size As Single) As Ptr
		      Declare Function BoldSystemFontOfSize Lib "Cocoa.framework" Selector "boldSystemFontOfSize:" (Target As Ptr, Size As Single) As Ptr
		      Declare Function FontWithName Lib "Cocoa.framework" Selector "fontWithName:size:" (Target As Ptr, FontName As CFStringRef, Size As Single) As Ptr
		      Declare Function GetCapHeight Lib "Cocoa.framework" Selector "capHeight" (Target As Ptr) As Single
		    #endif
		    
		    Dim FontObject As Ptr
		    If FontName = "SmallSystem" And FontSize = 0 Then
		      If Bold Then
		        FontObject = BoldSystemFontOfSize(NSFont, 11)
		      Else
		        FontObject = SystemFontOfSize(NSFont, 11)
		      End If
		    ElseIf FontName = "System" Or FontName = "SmallSystem" Then
		      If Bold Then
		        FontObject = BoldSystemFontOfSize(NSFont, FontSize)
		      Else
		        FontObject = SystemFontOfSize(NSFont, FontSize)
		      End If
		    Else
		      FontObject = FontWithName(NSFont, FontName, FontSize)
		    End If
		    
		    If FontObject = Nil Then
		      #if DebugBuild
		        System.DebugLog("Unable to get font object.")
		      #endif
		      Return FontAscent * 0.8
		    End If
		    
		    Return GetCapHeight(FontObject)
		  #elseif TargetWin32
		    Return FontAscent * 0.75
		  #else
		    Return FontAscent
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
		  
		  Dim Red As Double = (Source.Red / 255) ^ 2.2
		  Dim Green As Double = (Source.Green / 255) ^ 2.2
		  Dim Blue As Double = (Source.Blue / 255) ^ 2.2
		  Return (0.2126 * Red) + (0.7151 * Green) + (0.0721 * Blue)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CreateMultiResPicture(ParamArray Pictures() As Picture) As Picture
		  #if XojoVersion >= 2019.02
		    If Pictures = Nil Or Pictures.LastRowIndex = -1 Then
		      Return Nil
		    End If
		  #else
		    If Pictures = Nil Or Pictures.Ubound = -1 Then
		      Return Nil
		    End If
		  #endif
		  
		  Return New Picture(Pictures(0).Width, Pictures(0).Height, Pictures)
		End Function
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
		    DestinationCells(0) = New REALbasic.Rect(Destination.Left, Destination.Top, CellWidth, CellHeight)
		    DestinationCells(1) = New REALbasic.Rect(Destination.Left + CellWidth, Destination.Top, Destination.Width - (CellWidth * 2), CellHeight)
		    DestinationCells(2) = New REALbasic.Rect(Destination.Right - CellWidth, Destination.Top, CellWidth, CellHeight)
		  ElseIf StretchVertical Then
		    DestinationCells(0) = New REALbasic.Rect(Destination.Left, Destination.Top, CellWidth, CellHeight)
		    DestinationCells(1) = New REALbasic.Rect(Destination.Left, Destination.Top + CellHeight, CellWidth, Destination.Height - (CellHeight * 2))
		    DestinationCells(2) = New REALbasic.Rect(Destination.Left, Destination.Bottom - CellHeight, CellWidth, CellHeight)
		  End If
		  
		  SourceCells(0) = New REALbasic.Rect(CellWidth * 0, CellHeight * 0, CellWidth, CellHeight)
		  SourceCells(1) = New REALbasic.Rect(CellWidth * 1, CellHeight * 0, CellWidth, CellHeight)
		  SourceCells(2) = New REALbasic.Rect(CellWidth * 2, CellHeight * 0, CellWidth, CellHeight)
		  
		  If StretchHorizontal And StretchVertical Then
		    DestinationCells(3) = New REALbasic.Rect(Destination.Left, Destination.Top + CellHeight, CellWidth, Destination.Height - (CellHeight * 2))
		    DestinationCells(4) = New REALbasic.Rect(Destination.Left + CellWidth, Destination.Top + CellHeight, Destination.Width - (CellWidth * 2), Destination.Height - (CellHeight * 2))
		    DestinationCells(5) = New REALbasic.Rect(Destination.Right - CellWidth, Destination.Top + CellHeight, CellWidth, Destination.Height - (CellHeight * 2))
		    
		    DestinationCells(6) = New REALbasic.Rect(Destination.Left, Destination.Bottom - CellHeight, CellWidth, CellHeight)
		    DestinationCells(7) = New REALbasic.Rect(Destination.Left + CellWidth, Destination.Bottom - CellHeight, Destination.Width - (CellWidth * 2), CellHeight)
		    DestinationCells(8) = New REALbasic.Rect(Destination.Right - CellWidth, Destination.Bottom - CellHeight, CellWidth, CellHeight)
		    
		    SourceCells(3) = New REALbasic.Rect(CellWidth * 0, CellHeight * 1, CellWidth, CellHeight)
		    SourceCells(4) = New REALbasic.Rect(CellWidth * 1, CellHeight * 1, CellWidth, CellHeight)
		    SourceCells(5) = New REALbasic.Rect(CellWidth * 2, CellHeight * 1, CellWidth, CellHeight)
		    
		    SourceCells(6) = New REALbasic.Rect(CellWidth * 0, CellHeight * 2, CellWidth, CellHeight)
		    SourceCells(7) = New REALbasic.Rect(CellWidth * 1, CellHeight * 2, CellWidth, CellHeight)
		    SourceCells(8) = New REALbasic.Rect(CellWidth * 2, CellHeight * 2, CellWidth, CellHeight)
		  End If
		  
		  For I As Integer = 0 To CellCount - 1
		    Dim Dest As REALbasic.Rect = DestinationCells(I)
		    Dim Src As REALbasic.Rect = SourceCells(I)
		    G.DrawPicture(Source, Dest.Left, Dest.Top, Dest.Width, Dest.Height, Src.Left, Src.Top, Src.Width, Src.Height)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = API2Only
		Sub DrawStretchedPicture(Extends G As Graphics, Source As Picture, Destination As Xojo.Rect, StretchVertical As Boolean = True, StretchHorizontal As Boolean = True)
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
		  
		  Dim DestinationCells(-1), SourceCells(-1) As Xojo.Rect
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
		    Dim Dest As Xojo.Rect = DestinationCells(I)
		    Dim Src As Xojo.Rect = SourceCells(I)
		    G.DrawPicture(Source, Dest.Left, Dest.Top, Dest.Width, Dest.Height, Src.Left, Src.Top, Src.Width, Src.Height)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub EndFocusRing()
		  #if TargetCocoa
		    Declare Function NSClassFromString Lib "Cocoa.framework" (ClassName As CFStringRef) As Ptr
		    Declare Sub RestoreGraphicsState Lib "Cocoa.framework" Selector "restoreGraphicsState" (Target As Ptr)
		    
		    Dim GraphicsContextClass As Ptr = NSClassFromString("NSGraphicsContext")
		    RestoreGraphicsState(GraphicsContextClass)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FillWithPattern(Extends G As Graphics, Source As Picture, Area As REALbasic.Rect, SourcePortion As REALbasic.Rect = Nil)
		  Dim Destination As Graphics = G.Clip(Area.Left, Area.Top, Area.Width, Area.Height)
		  If SourcePortion = Nil Then
		    SourcePortion = New REALbasic.Rect(0, 0, Source.Width, Source.Height)
		  End If
		  
		  Dim SourceWidth, SourceHeight As Integer
		  SourceWidth = SourcePortion.Width
		  SourceHeight = SourcePortion.Height
		  
		  Dim X, Y As Integer
		  For X = 0 To Area.Width Step SourceWidth
		    For Y = 0 To Area.Height Step SourceHeight
		      Destination.DrawPicture(Source, X, Y, SourceWidth, SourceHeight, SourcePortion.Left, SourcePortion.Top, SourcePortion.Width, SourcePortion.Height)
		    Next
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = API2Only
		Sub FillWithPattern(Extends G As Graphics, Source As Picture, Area As Xojo.Rect, SourcePortion As Xojo.Rect = Nil)
		  Dim Destination As Graphics = G.Clip(Area.Left, Area.Top, Area.Width, Area.Height)
		  If SourcePortion = Nil Then
		    SourcePortion = New Xojo.Rect(0, 0, Source.Width, Source.Height)
		  End If
		  
		  Dim SourceWidth, SourceHeight As Integer
		  SourceWidth = SourcePortion.Width
		  SourceHeight = SourcePortion.Height
		  
		  Dim X, Y As Integer
		  For X = 0 To Area.Width Step SourceWidth
		    For Y = 0 To Area.Height Step SourceHeight
		      Destination.DrawPicture(Source, X, Y, SourceWidth, SourceHeight, SourcePortion.Left, SourcePortion.Top, SourcePortion.Width, SourcePortion.Height)
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

	#tag Method, Flags = &h1
		Protected Function OpenMultiResPicture(File As FolderItem) As Picture
		  Dim Basename As String = File.Name
		  Dim Extension As String
		  Dim Parts() As String = Basename.Split(".")
		  
		  #if XojoVersion >= 2019.02
		    If Parts.LastRowIndex > 0 Then
		      Extension = Parts(Parts.LastRowIndex)
		      Parts.RemoveRowAt(Parts.LastRowIndex)
		      Basename = String.FromArray(Parts, ".")
		    End If
		  #else
		    If Parts.Ubound > 0 Then
		      Extension = Parts(Parts.Ubound)
		      Parts.Remove(Parts.Ubound)
		      Basename = Join(Parts, ".")
		    End If
		  #endif
		  
		  #if XojoVersion >= 2019.02
		    Dim Pos As Integer = Basename.IndexOf("@")
		  #else
		    Dim Pos As Integer = Basename.InStr("@") - 1
		  #endif
		  If Pos > -1 Then
		    Basename = Basename.Left(Pos)
		  End If
		  
		  Dim Parent As FolderItem = File.Parent
		  Dim Bitmaps() As Picture
		  Dim BaseWidth, BaseHeight As Integer
		  For Factor As Integer = 1 To 3
		    Dim Filename As String = Basename
		    If Factor > 1 Then
		      #if XojoVersion >= 2019.02
		        Filename = Filename + "@" + Factor.ToString + "x"
		      #else
		        Filename = Filename + "@" + Str(Factor) + "x"
		      #endif
		    End If
		    
		    Dim Child As FolderItem = Parent.Child(Filename)
		    If Child <> Nil And Child.Exists Then
		      Dim Pic As Picture = Picture.Open(Child)
		      If Pic <> Nil Then
		        If BaseWidth = 0 Or BaseHeight = 0 Then
		          BaseWidth = Pic.Width / Factor
		          BaseHeight = Pic.Height / Factor
		        End If
		        #if XojoVersion >= 2019.02
		          Bitmaps.AddRow(Pic)
		        #else
		          Bitmaps.Append(Pic)
		        #endif
		      End If
		    End If
		  Next
		  
		  #if XojoVersion >= 2019.02
		    If Bitmaps.LastRowIndex = -1 Then
		      Return Nil
		    End If
		  #else
		    If Bitmaps.Ubound = -1 Then
		      Return Nil
		    End If
		  #endif
		  
		  Return New Picture(BaseWidth, BaseHeight, Bitmaps)
		End Function
	#tag EndMethod


	#tag Note, Name = Documentation
		
		Documentation can be found at http://docs.thezaz.com/artisankit/1.2.0
	#tag EndNote

	#tag Note, Name = Version
		
		1.2.0
	#tag EndNote


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
