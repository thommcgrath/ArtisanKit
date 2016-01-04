# ArtisanKit.Control

ArtisanKit.Control is the workhorse of the module. It handles features like automatic double-buffering, high resolution, appearance state, focus rings, and simple animation.

## Events

<pre id="event.animationstep"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Event</span> AnimationStep (Key <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">String</span>, Value <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Double</span>, Finished <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span>)</span></pre>
After having started an animation, this event will fire as necessary to instruct the control the value being animated as changed. For example, animating a value from 1.0 to 2.0 might fire the event 10 times: 1.1, 1.2, 1.3, etc. The `Finished` parameter is true on the final step of the animation.

<pre id="event.mousewheel"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Event</span> MouseWheel (MouseX <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>, MouseY <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>, PixelsX <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>, PixelsY <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>, WheelData <span style="color: #0000FF;">As</span> ArtisanKit.ScrollEvent) <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span></span></pre>
Based on the built-in `MouseWheel` event, this version automatically uses pixels instead of lines. `PixelsX` and `PixelsY` will set to the number of _pixels_ that should be adjusted, instead of the traditional `DeltaX` and `DeltaY` which describe the number of lines that should be adjusted.

The `WheelData` parameter is an instance of [ArtisanKit.ScrollEvent](ArtisanKit.ScrollEvent.md) which contains additional details about the scrolling action. Usage of this object is completely optional, but does provide the information necessary to implement "snap-back" scrolling that is now familiar to OS X and iOS.

<pre id="event.paint"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Event</span> Paint (G <span style="color: #0000FF;">As</span> Graphics, Areas() <span style="color: #0000FF;">As</span> REALbasic.Rect, ScalingFactor <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Double</span>, Highlighted <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span>)</span></pre>
The standard `Paint` event has two additional parameters: `ScalingFactor` and `Highlighted`.

`ScalingFactor` is a measurement by which drawing should be multiplied to produce nice results on the screen. However, this is only relevant when creating or loading a Picture, since the Xojo graphics object handles scaling automatically.

For example, if you wanted to create an picture that is 32x32 inside your `Paint` event, you probably need to draw it like so:

<pre><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Dim</span> Pic <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">New</span> Picture(<span style="color: #336698;">32</span> * ScalingFactor, <span style="color: #336698;">32</span> * ScalingFactor)
Pic.ForeColor = &amp;c<span style="color: #FF0000;">00</span><span style="color: #00BB00;">FF</span><span style="color: #0000FF;">00</span>
Pic.FillRect(<span style="color: #336698;">0</span>, <span style="color: #336698;">0</span>, Pic.Width, Pic.Height)
G.DrawPicture(Pic, <span style="color: #336698;">0</span>, <span style="color: #336698;">0</span>, Pic / ScalingFactor, Pic / ScalingFactor, <span style="color: #336698;">0</span>, <span style="color: #336698;">0</span>, Pic.Width, Pic.Height)</span></pre>

`Highlighted` will be true when the control should be drawn in the foreground/active window.

## Properties

<pre id="property.backdrop"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">Backdrop <span style="color: #0000FF;">As</span> Picture = <span style="color: #0000FF;">Nil</span> <span style="color: #800000;">// Read Only</span></span></pre>
The `Backdrop` property has been shadowed and cannot be set. This control is for custom controls, and should not be used for simple bitmap display.

<pre id="property.hasfocus"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">HasFocus <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span> = <span style="color: #0000FF;">False</span></span></pre>
Indicates wether or not the control has the focus. Setting to `True` will grab the focus, setting to `False` pushes the focus to the parent window.

<pre id="property.scrollspeed"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">ScrollSpeed <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span> = <span style="color: #336698;">20</span></span></pre>
The number of pixels a single "step" of a traditional scroll wheel should move the content. This value is identical to the `ScrollBar.LineHeight` property.

## Methods

<pre id="method.beginfocusring"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Protected</span> <span style="color: #0000FF;">Sub</span> BeginFocusRing (G <span style="color: #0000FF;">As</span> Graphics)</span></pre>
Begin drawing a focus ring. Each future `Graphics` action will create a new focus ring, until stopped. It is best advised to begin a focus ring, draw the control's backdrop, and end the focus ring.

<pre id="method.cancelanimation"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Protected</span> <span style="color: #0000FF;">Sub</span> CancelAnimation (Key <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Text</span>, Finish <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span> = <span style="color: #0000FF;">False</span>)</span></pre>
Stops the animation with key `Key`. If `Finish` is `True`, a final `AnimationStep` event will be triggered with the ending value. Otherwise, the value will remain in its last state.

<pre id="method.endfocusring"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Protected</span> <span style="color: #0000FF;">Sub</span> EndFocusRing (G <span style="color: #0000FF;">As</span> Graphics)</span></pre>
Stops drawing focus rings around each `Graphics` action.

<pre id="method.render"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Function</span> Render (Width <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>, Height <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>) <span style="color: #0000FF;">As</span> ArtisanKit.RetinaPicture</span></pre>
Creates a [ArtisanKit.RetinaPicture](ArtisanKit.RetinaPicture.md) object with the control drawn at the given `Width` and `Height`. This will cause two `Paint` events, one with a `ScalingFactor` of `1.0` and the other with `2.0`.

<pre id="method.startanimation"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Protected</span> <span style="color: #0000FF;">Sub</span> StartAnimation (Key <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">String</span>, StartValue <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Double</span>, EndValue <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Double</span>, Duration <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Double</span>, Ease <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span> = <span style="color: #0000FF;">True</span>)</span></pre>
Begin an animation. `Key` is used to identify multiple animations to prevent collisions. `StartValue` is the value to begin animating from, `EndValue` is the value to animate to. `Duration` is the number of seconds the animation should require to complete. If the `Ease` parameter is true, the animation will have a slight weight to it. It will start faster and slow down towards the end. If `Ease` is false, the rate of animation will be steady.

## Subclassing

The `Graphics` property will always return `Nil`. It is impossible to try to draw to the control from outside the `Paint` event.

`Invalidate`, `Refresh`, and `RefreshRect` will always use an `EraseBackground` value of `False` no matter what is passed to them. `EraseBackground` causes flicker, so it cannot be used.

## See Also

[ArtisanKit.ScrollEvent](ArtisanKit.ScrollEvent.md)