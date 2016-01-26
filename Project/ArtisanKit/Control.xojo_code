#tag Class
Protected Class Control
Inherits Canvas
	#tag Event
		Sub Activate()
		  RaiseEvent Activate
		  Self.Invalidate
		End Sub
	#tag EndEvent

	#tag Event
		Sub Deactivate()
		  RaiseEvent Deactivate
		  Self.Invalidate
		End Sub
	#tag EndEvent

	#tag Event
		Sub GotFocus()
		  Self.mHasFocus = True
		  RaiseEvent GotFocus
		  Self.Invalidate
		End Sub
	#tag EndEvent

	#tag Event
		Sub LostFocus()
		  Self.mHasFocus = False
		  RaiseEvent LostFocus
		  Self.Invalidate
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseWheel(X As Integer, Y As Integer, deltaX as Integer, deltaY as Integer) As Boolean
		  Dim WheelData As New ArtisanKit.ScrollEvent(Self.ScrollSpeed, DeltaX, DeltaY)
		  Return MouseWheel(X, Y, WheelData.ScrollX, WheelData.ScrollY, WheelData)
		End Function
	#tag EndEvent

	#tag Event
		Sub Open()
		  RaiseEvent Open
		  Self.DoubleBuffer = TargetWin32
		  Self.EraseBackground = Not Self.DoubleBuffer
		  #if XojoVersion >= 2013.04
		    Self.Transparent = Self.EraseBackground
		  #endif
		  Self.TabStop = Self.TabStop And Self.AcceptFocus And ArtisanKit.FullKeyboardAccessEnabled
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics, areas() As REALbasic.Rect)
		  If Self.mLastPaintWidth <> G.Width Or Self.mLastPaintHeight <> G.Height Then
		    RaiseEvent Resized
		    Self.mLastPaintWidth = G.Width
		    Self.mLastPaintHeight = G.Height
		  End If
		  
		  If Not Self.EraseBackground Then
		    Dim BackgroundColor As Color
		    If Self.TrueWindow.HasBackColor Then
		      BackgroundColor = Self.TrueWindow.BackColor
		    Else
		      BackgroundColor = FillColor
		    End If
		    G.ForeColor = BackgroundColor
		    G.FillRect(0,0,G.Width,G.Height)
		  End If
		  
		  Dim Highlighted As Boolean
		  If Self.Enabled Then
		    #if TargetCocoa
		      Declare Function IsMainWindow Lib "Cocoa.framework" Selector "isMainWindow" (Target As Integer) As Boolean
		      Declare Function IsKeyWindow Lib "Cocoa.framework" Selector "isKeyWindow" (Target As Integer) As Boolean
		      Highlighted = IsKeyWindow(Self.TrueWindow.Handle) Or IsMainWindow(Self.TrueWindow.Handle)
		    #else
		      Highlighted = True
		    #endif
		  End If
		  
		  RaiseEvent Paint(G,Areas,G.ScalingFactor,Highlighted)
		  Self.mInvalidated = False
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub AnimationTimerAction(Sender As Timer)
		  #pragma Unused Sender
		  
		  For I As Integer = Self.mAnimations.Count - 1 DownTo 0
		    Dim Key As String = Self.mAnimations.Key(I)
		    Dim Details As AnimationDetails = Self.mAnimations.Value(Key)
		    Dim Elapsed As Double = (Microseconds - Details.StartTime) / 1000000
		    Dim ChangeInValue As Double = Details.EndValue - Details.StartValue
		    Dim Value As Double
		    If Elapsed >= Details.Duration Then
		      // Finished
		      Value = Details.EndValue
		    Else
		      If Details.Ease Then
		        Value = (ChangeInValue * Sin((Elapsed / Details.Duration) * (Self.PI / 2))) + Details.StartValue
		      Else
		        Value = (ChangeInValue * (Elapsed / Details.Duration)) + Details.StartValue
		      End If
		      If Details.EndValue > Details.StartValue Then
		        Value = Min(Value,Details.EndValue)
		      ElseIf Details.EndValue < Details.StartValue Then
		        Value = Max(Value,Details.EndValue)
		      Else
		        Value = Details.StartValue
		      End If
		    End If
		    If Value = Details.EndValue Then
		      Self.mAnimations.Remove(Key)
		    End If
		    RaiseEvent AnimationStep(Key,Value,Value = Details.EndValue)
		    Self.Invalidate
		  Next
		  If Self.mAnimations.Count = 0 Then
		    RemoveHandler mAnimationTimer.Action, WeakAddressOf AnimationTimerAction
		    Self.mAnimationTimer.Mode = Timer.ModeOff
		    Self.mAnimationTimer = Nil
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub BeginFocusRing(G As Graphics)
		  #if TargetCocoa
		    Declare Sub NSSetFocusRingStyle Lib "Cocoa.framework" (Placement As Integer)
		    Declare Sub CGContextBeginTransparencyLayer Lib "Cocoa.framework" (Context As Integer, AuxInfo As Integer)
		    
		    Const NSFocusRingAbove = 2
		    
		    Dim Context As Integer = G.Handle(G.HandleTypeCGContextRef)
		    NSSetFocusRingStyle(NSFocusRingAbove)
		    CGContextBeginTransparencyLayer(Context,0)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub CancelAnimation(Key As String, Finish As Boolean = False)
		  If Self.mAnimations = Nil Or Self.mAnimations.HasKey(Key) = False Then
		    Return
		  End If
		  
		  Dim Details As AnimationDetails = Self.mAnimations.Value(Key)
		  Self.mAnimations.Remove(Key)
		  If Finish Then
		    RaiseEvent AnimationStep(Key,Details.EndValue,True)
		    Self.Invalidate
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub EndFocusRing(G As Graphics)
		  #if TargetCocoa
		    Declare Sub CGContextEndTransparencyLayer Lib "Cocoa.framework" (Context As Integer)
		    
		    Dim Context As Integer = G.Handle(G.HandleTypeCGContextRef)
		    CGContextEndTransparencyLayer(Context)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Graphics() As Graphics
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Invalidate(eraseBackground As Boolean = True)
		  If Not Self.mInvalidated Then
		    Super.Invalidate(EraseBackground And Self.EraseBackground)
		    Self.mInvalidated = True
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Invalidate(x As Integer, y As Integer, width As Integer, height As Integer, eraseBackground As Boolean = True)
		  If Not Self.mInvalidated Then
		    Super.Invalidate(X,Y,Width,Height,EraseBackground And Self.EraseBackground)
		    Self.mInvalidated = True
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Refresh(eraseBackground As Boolean = True)
		  Super.Refresh(EraseBackground And Self.EraseBackground)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RefreshRect(x As Integer, y As Integer, width As Integer, height As Integer, eraseBackground As Boolean = True)
		  Super.RefreshRect(X,Y,Width,Height,EraseBackground And Self.EraseBackground)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Render(Width As Integer, Height As Integer) As ArtisanKit.RetinaPicture
		  Dim Areas(0) As REALbasic.Rect
		  Areas(0) = New REALbasic.Rect(0,0,Width,Height)
		  Dim LowRes As New Picture(Width,Height)
		  RaiseEvent Paint(LowRes.Graphics,Areas,1,True)
		  Dim HighRes As New Picture(Width * 2,Height * 2)
		  HighRes.VerticalResolution = LowRes.VerticalResolution * 2
		  HighRes.HorizontalResolution = LowRes.HorizontalResolution * 2
		  Areas(0) = New REALbasic.Rect(0,0,Width * 2,Height * 2)
		  RaiseEvent Paint(HighRes.Graphics,Areas,2,True)
		  Return ArtisanKit.RetinaPicture.CreateFrom(LowRes,HighRes)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub StartAnimation(Key As String, StartValue As Double, EndValue As Double, Duration As Double, Ease As Boolean = True)
		  If Self.mAnimations = Nil Then
		    Self.mAnimations = New Dictionary
		  End If
		  
		  Dim Details As AnimationDetails
		  Details.StartValue = StartValue
		  Details.EndValue = EndValue
		  Details.StartTime = Microseconds
		  Details.Duration = Duration
		  Details.Ease = Ease
		  
		  Self.mAnimations.Value(Key) = Details
		  
		  If Self.mAnimationTimer = Nil Then
		    Dim AnimTimer As New Timer
		    AnimTimer.Mode = Timer.ModeMultiple
		    AnimTimer.Period = 16
		    AddHandler AnimTimer.Action, WeakAddressOf AnimationTimerAction
		    Self.mAnimationTimer = AnimTimer
		  End If
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Activate()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event AnimationStep(Key As String, Value As Double, Finished As Boolean)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Deactivate()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event GotFocus()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event LostFocus()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseWheel(MouseX As Integer, MouseY As Integer, PixelsX As Integer, PixelsY As Integer, WheelData As ArtisanKit.ScrollEvent) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Open()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Paint(G As Graphics, Areas() As REALbasic.Rect, ScalingFactor As Double, Highlighted As Boolean)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Resized()
	#tag EndHook


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Nil
			End Get
		#tag EndGetter
		Backdrop As Picture
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mHasFocus
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mHasFocus <> Value Then
			    If Value Then
			      Self.SetFocus()
			    Else
			      Self.TrueWindow.SetFocus()
			    End If
			  End If
			End Set
		#tag EndSetter
		HasFocus As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mAnimations As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mAnimationTimer As Timer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHasFocus As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInvalidated As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastPaintHeight As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastPaintWidth As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ScrollSpeed As Integer = 20
	#tag EndProperty


	#tag Constant, Name = PI, Type = Double, Dynamic = False, Default = \"3.14159265358979323846264338327950", Scope = Private
	#tag EndConstant


	#tag Structure, Name = AnimationDetails, Flags = &h21
		StartValue As Double
		  EndValue As Double
		  StartTime As Double
		  Duration As Double
		Ease As Boolean
	#tag EndStructure


	#tag ViewBehavior
		#tag ViewProperty
			Name="AcceptFocus"
			Visible=true
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AcceptTabs"
			Visible=true
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backdrop"
			Group="Appearance"
			Type="Picture"
			EditorType="Picture"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DoubleBuffer"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EraseBackground"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasFocus"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HelpTag"
			Visible=true
			Group="Appearance"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialParent"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ScrollSpeed"
			Group="Behavior"
			InitialValue="20"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Transparent"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UseFocusRing"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
