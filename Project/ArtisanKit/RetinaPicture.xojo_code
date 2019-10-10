#tag Class
Protected Class RetinaPicture
Inherits Picture
	#tag Method, Flags = &h0
		Shared Function CreateFrom(LowRes As Picture, HiRes As Picture) As ArtisanKit.RetinaPicture
		  Var Result As New ArtisanKit.RetinaPicture(LowRes.Width, LowRes.Height)
		  Result.Graphics.DrawPicture(LowRes, 0, 0)
		  Result.HiRes = HiRes
		  Result.HiRes.HorizontalResolution = Result.HorizontalResolution * 2
		  Result.HiRes.VerticalResolution = Result.VerticalResolution * 2
		  Return Result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Open(File As FolderItem) As ArtisanKit.RetinaPicture
		  Var FilenameLow, FilenameHigh As String
		  If File.Name.IndexOf("@2x") > -1 Then
		    FilenameHigh = File.Name
		    FilenameLow = Replace(File.Name, "@2x", "")
		  Else
		    FilenameLow = File.Name
		    Var Extension As String = FilenameLow.NthField(".", FilenameLow.CountFields("."))
		    If Extension = FilenameLow Then
		      // No extension
		      FilenameHigh = FilenameLow + "@2x"
		    Else
		      Extension = "." + Extension
		      FilenameHigh = Replace(FilenameLow, Extension, "@2x" + Extension)
		    End If
		  End If
		  
		  Var Container As FolderItem = File.Parent
		  Var LowResFile As FolderItem = Container.Child(FilenameLow)
		  Var HighResFile As FolderItem = Container.Child(FilenameHigh)
		  Var LowResPic, HighResPic As Picture
		  
		  If LowResFile.Exists Then
		    LowResPic = Picture.Open(LowResFile)
		  End If
		  If HighResFile.Exists Then
		    HighResPic = Picture.Open(HighResFile)
		  End If
		  
		  Var Result As ArtisanKit.RetinaPicture
		  If LowResPic = Nil And HighResPic <> Nil Then
		    // Scale the high res down to low res
		    Result = New ArtisanKit.RetinaPicture(HighResPic.Width / 2, HighResPic.Height / 2)
		    Result.Graphics.DrawPicture(HighResPic, 0, 0, Result.Width, Result.Height, 0, 0, HighResPic.Width, HighResPic.Height)
		    Result.HiRes = HighResPic
		  ElseIf LowResPic <> Nil And HighResPic = Nil Then
		    // Scale the low res up to high res
		    Result = New ArtisanKit.RetinaPicture(LowResPic.Width, LowResPic.Height)
		    Result.Graphics.DrawPicture(LowResPic, 0, 0)
		    Result.HiRes = New Picture(LowResPic.Width * 2, LowResPic.Height * 2)
		    Result.HiRes.Graphics.DrawPicture(LowResPic, 0, 0, Result.HiRes.Width, Result.HiRes.Height, 0, 0, LowResPic.Width, LowResPic.Height)
		  ElseIf LowResPic <> Nil And HighResPic <> Nil Then
		    // Two unique resources
		    Result = New ArtisanKit.RetinaPicture(LowResPic.Width, LowResPic.Height)
		    Result.Graphics.DrawPicture(LowResPic, 0, 0)
		    Result.HiRes = HighResPic
		  End If
		  Result.HiRes.HorizontalResolution = Result.HorizontalResolution * 2
		  Result.HiRes.VerticalResolution = Result.VerticalResolution * 2
		  Return Result
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		HiRes As Picture
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="IsAlphaChannel"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Depth"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasAlphaChannel"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HiRes"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HorizontalResolution"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ImageCount"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
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
		#tag ViewProperty
			Name="Transparent"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Type"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Types"
			EditorType="Enum"
			#tag EnumValues
				"0 - Image"
				"1 - Vector"
				"2 - MutableBitmap"
				"3 - ImmutableBitmap"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="VerticalResolution"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
