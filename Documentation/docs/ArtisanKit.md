# ArtisanKit Module

This module provides a number of classes, methods, and extension methods useful in custom control authoring.

# Classes

- [ArtisanKit.Control](ArtisanKit.Control.md)
- [ArtisanKit.RetinaPicture](ArtisanKit.RetinaPicture.md)
- [ArtisanKit.ScrollEvent](ArtisanKit.ScrollEvent.md)

# Methods

<pre id="method.blendcolors"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> ArtisanKit.BlendColors (Color1 <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Color</span>, Color2 <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Color</span>, Color2Opacity <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Double</span> = <span style="color: #336698;">1</span>) <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Color</span></span></pre>
This method blends `Color1` with `Color2` at the ratio specified in `Color2Opacity`. An opacity of `1` means 100% `Color2` and 0% `Color1`. An opacity of `0.5` means 50% `Color2` and 50% `Color1`. Alpha channels are not supported and will fire an `UnsupportedOperationException`.

<pre id="method.colorbrightness"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> ArtisanKit.ColorBrightness (C <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Color</span>) <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span></span></pre>
Estimates the perceived brightness of a color. Experimentation will be necessary, though generally a value less than 170 should be considered dark. This is useful for custom background colors, so the foreground/text color can be switched from black to white to provide clear contrast.

<pre id="method.colorisbright"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> ArtisanKit.ColorIsBright (Source <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Color</span>) <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span></span></pre>
Uses the brightness and luminance of a color to determine wether or not a color appears light on the screen.

<pre id="method.colorluminance"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> ArtisanKit.ColorLuminance (Source <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Color</span>) <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Double</span></span></pre>
Calculates the relative luminance of a color. Returns a value between 0 and 1. Values greater than 0.65 should be considered light colors. Luminance is most useful for calculating the contrast between two colors.

<pre id="method.fullkeyboardaccessenabled"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> ArtisanKit.FullKeyboardAccessEnabled () <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span></span></pre>
In OS X Keyboard Preferences, under Shortcuts there is a setting called "Full Keyboard Access." This method returns `True` when this option is set to "All controls." The control will automatically accept tabs if the user is tabbing through controls, and the user should be able to use the keyboard to interact with the control.

On other platforms, this method always returns `True`.

<pre id="method.isdarkmode"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> ArtisanKit.IsDarkMode () <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span></span></pre>
A simple wrapper for the REALbasic.IsDarkMode method introduced in 2018r3. For older versions, this method always returns false. This method simply saves the caller from having to detect the Xojo version with conditional compilation.

# Extension Methods

<pre id="method.graphics.capheight"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> Graphics.CapHeight (<span style="color: #0000FF;">Extends</span> G <span style="color: #0000FF;">As</span> Graphics) <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Double</span></span></pre>
A font's CapHeight is the measurement from the baseline to the top of a capital letter. This is similar to `Graphics.TextAscent`, but the ascent of the font includes space for diacritical marks. This method uses system declares on OS X, but must rely on guesswork on Windows and Linux.

When trying to vertically center some text, the CapHeight will produce a much more visually pleasing result than TextAscent or TextHeight.

<pre id="method.graphics.drawretinapicture"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Sub</span> Graphics.DrawRetinaPicture (<span style="color: #0000FF;">Extends</span> G <span style="color: #0000FF;">As</span> Graphics, Source <span style="color: #0000FF;">As</span> ArtisanKit.RetinaPicture, Left <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>, Top <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>)</span></pre>
<pre><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Sub</span> Graphics.DrawRetinaPicture (<span style="color: #0000FF;">Extends</span> G <span style="color: #0000FF;">As</span> Graphics, Source <span style="color: #0000FF;">As</span> ArtisanKit.RetinaPicture, Left <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>, Top <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>, Width <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>, Height <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>)</span></pre>
<pre><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Sub</span> Graphics.DrawRetinaPicture (<span style="color: #0000FF;">Extends</span> G <span style="color: #0000FF;">As</span> Graphics, Source <span style="color: #0000FF;">As</span> ArtisanKit.RetinaPicture, Left <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>, Top <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>, Width <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>, Height <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>, SourceLeft <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>, SourceTop <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>, SourceWidth <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>, SourceHeight <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>)</span></pre>
Draws a [ArtisanKit.RetinaPicture](ArtisanKit.RetinaPicture.md) to the `Graphics` object. Like `Graphics.DrawPicture`, there are multiple signatures useful for scaling and clipping the `Source`.

<pre id="method.graphics.drawstretchedpicture"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Sub</span> Graphics.DrawStretchedPicture (<span style="color: #0000FF;">Extends</span> G <span style="color: #0000FF;">As</span> Graphics, Source <span style="color: #0000FF;">As</span> Picture, Destination <span style="color: #0000FF;">As</span> REALbasic.Rect, StretchVertical <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span> = <span style="color: #0000FF;">True</span>, StretchHorizontal <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span> = <span style="color: #0000FF;">True</span>)</span></pre>
Stretches the `Source` picture to fill the `Destination` rect. If `StretchVertical` is `True`, the picture will be vertically divided into 3 equal parts, with the middle stretching to fill the height, the first and third parts used to "cap" the fill. `StretchHorizonal` does the same for the width. The width must be a multiple of 3 when `StretchHorizontal` is `True`, the height must be a multiple of 3 when `StrechVertical` is `True`. The `Destination` dimensions must be greater than the `Source` dimensions.

<pre id="method.graphics.fillwithpattern"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Sub</span> Graphics.FillWithPattern (<span style="color: #0000FF;">Extends</span> G <span style="color: #0000FF;">As</span> Graphics, Source <span style="color: #0000FF;">As</span> Picture, Area <span style="color: #0000FF;">As</span> REALbasic.Rect, SourcePortion <span style="color: #0000FF;">As</span> REALbasic.Rect = <span style="color: #0000FF;">Nil</span>)</span></pre>
Pattern fills the area given by `Area` with the `Source` picture. The `SourcePortion` rect can be added to use only a portion of the `Source` picture for the fill.

<pre id="method.graphics.scalingfactor"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> Graphics.ScalingFactor (<span style="color: #0000FF;">Extends</span> G <span style="color: #0000FF;">As</span> Graphics) <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Single</span></span></pre>
Returns the scaling factor for the given `Graphics` object. See [ArtisanKit.Control.Paint](ArtisanKit.Control.md#event.paint) for more information about the scaling factor.