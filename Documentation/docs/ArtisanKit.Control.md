# ArtisanKit.Control

ArtisanKit.Control is the workhorse of the module. It handles features like automatic double-buffering, high resolution, appearance state, focus rings, and simple animation.

## Events

<pre id="event.animationstep"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Event</span> AnimationStep (Key <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">String</span>, Value <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Double</span>, Finished <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span>)</span></pre>
After having started an animation, this event will fire as necessary to instruct the control the value being animated as changed. For example, animating a value from 1.0 to 2.0 might fire the event 10 times: 1.1, 1.2, 1.3, etc. The `Finished` parameter is true on the final step of the animation.

<pre id="event.mousewheel"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Event</span> MouseWheel (MouseX <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>, MouseY <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>, PixelsX <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>, PixelsY <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>, WheelData <span style="color: #0000FF;">As</span> ArtisanKit.ScrollEvent) <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span></span></pre>
Based on the built-in `MouseWheel` event, this version automatically uses pixels instead of lines. `PixelsX` and `PixelsY` will set to the number of _pixels_ that should be adjusted, instead of the traditional `DeltaX` and `DeltaY` which describe the number of lines that should be adjusted.

The `WheelData` parameter is an instance of [ArtisanKit.ScrollEvent](ArtisanKit.ScrollEvent.md) which contains additional details about the scrolling action. Usage of this object is completely optional, but does provide the information necessary to implement "snap-back" scrolling that is now familiar to OS X and iOS.

<pre id="event.paint"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Event</span> Paint (G <span style="color: #0000FF;">As</span> Graphics, Areas() <span style="color: #0000FF;">As</span> REALbasic.Rect, Highlighted <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span>)</span></pre>
The additional `Highlighted` parameter will be true when the control should be drawn in the foreground/active window.

## Properties

<pre id="property.animated"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">Animated <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span> = <span style="color: #0000FF;">True</span></span></pre>
When `False` animations triggered with `StartAnimation` finish immediately.

<pre id="property.hasfocus"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">HasFocus <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span> = <span style="color: #0000FF;">False</span></span></pre>
Indicates wether or not the control has the focus. Setting to `True` will grab the focus, setting to `False` pushes the focus to the parent window.

<pre id="property.needsfullkeyboardaccessforfocus"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">NeedsFullKeyboardAccessForFocus <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span> = <span style="color: #0000FF;">True</span></span></pre>
Some controls, such as text fields, should be able to get the focus without the user's Full Keyboard Access being enabled. Other controls, such as check boxes, should only get the focus if Full Keyboard Access is enabled. Set to false to accept focus even if Full Keyboard Access is disabled.

<pre id="property.scrollspeed"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">ScrollSpeed <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span> = <span style="color: #336698;">20</span></span></pre>
The number of pixels a single "step" of a traditional scroll wheel should move the content. This value is identical to the `ScrollBar.LineHeight` property.

## Methods

<pre id="method.cancelanimation"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Protected</span> <span style="color: #0000FF;">Sub</span> CancelAnimation (Key <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">String</span>, Finish <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span> = <span style="color: #0000FF;">False</span>)</span></pre>
Stops the animation with key `Key`. If `Finish` is `True`, a final `AnimationStep` event will be triggered with the ending value. Otherwise, the value will remain in its last state.

<pre id="method.render"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000ff;">Function</span> Render (Width <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">Integer</span>, Height <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">Integer</span>, Highlighted <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">Boolean</span> = <span style="color: #0000ff;">True</span>, MinScale <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">Double</span> = <span style="color: #006633;">1.0</span>, MaxScale <span style="color: #0000ff;">As</span> <span style="color: #0000ff;">Double</span> = <span style="color: #006633;">3.0</span>) <span style="color: #0000ff;">As</span> Picture</span></span></pre>
Creates a multi-resolution `Picture` object with the control drawn at the given `Width` and `Height`. The `Highlighted` parameter can be used to control wether or not the control is drawn in the foreground. The `MinScale` and `MaxScale` parameters are used to control the number of resolutions included in the picture. This will fire multiple `Paint` events if necessary.

<pre id="method.startanimation"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Protected</span> <span style="color: #0000FF;">Sub</span> StartAnimation (Key <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">String</span>, StartValue <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Double</span>, EndValue <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Double</span>, Duration <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Double</span>, Ease <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Boolean</span> = <span style="color: #0000FF;">True</span>)</span></pre>
Begin an animation. `Key` is used to identify multiple animations to prevent collisions. `StartValue` is the value to begin animating from, `EndValue` is the value to animate to. `Duration` is the number of seconds the animation should require to complete. If the `Ease` parameter is true, the animation will have a slight weight to it. It will start faster and slow down towards the end. If `Ease` is false, the rate of animation will be steady.

## Subclassing

The `Graphics` property will always return `Nil`. It is impossible to try to draw to the control from outside the `Paint` event.

`Invalidate`, `Refresh`, and `RefreshRect` will always use an `EraseBackground` value of `False` no matter what is passed to them. `EraseBackground` causes flicker, so it cannot be used.

## See Also

[ArtisanKit.ScrollEvent](ArtisanKit.ScrollEvent.md)