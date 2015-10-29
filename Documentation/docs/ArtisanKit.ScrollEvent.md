# ArtisanKit.ScrollEvent

A more detailed set of information about the current scrolling status.

## Constructors

<pre><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">LineHeight <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>, DeltaX <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span>, DeltaY <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span></span></pre>
**Must be created from within a `RectControl.MouseWheel` event!**
Calculates values and status given the provided deltas and line height.

## Properties

<pre id="property.lineheight"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">LineHeight <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span> <span style="color: #800000;">// Read Only</span></span></pre>
The number of pixels moved by a single "step" of a traditional scroll wheel.

<pre id="property.momentumphase"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">MomentumPhase <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span> <span style="color: #800000;">// Read Only</span></span></pre>
See [[NSEvent momentumPhase]](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ApplicationKit/Classes/NSEvent_Class/#//apple_ref/occ/instp/NSEvent/momentumPhase) for more information. Possible return values are any the Phase constants.

<pre id="property.phase"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">Phase <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span> <span style="color: #800000;">// Read Only</span></span></pre>
See [[NSEvent phase]](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ApplicationKit/Classes/NSEvent_Class/#//apple_ref/occ/instp/NSEvent/phase) for more information. Possible return values are any of the Phase constants.

The value returned indicates the user's finger state on the trackpad or mouse. This only applies for gesture-based input devices. All other devices will always return `PhaseNone`. For example, `PhaseMayBegin` should be returned when the user has placed their fingers on a trackpad, but has not yet moved them to cause a scroll.

By combining the various phases, it should be possible to build a "snap-back" or "rubber band" form of scrolling that is now familiar on OS X and iOS.

<pre id="property.scrollx"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">ScrollX <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span> <span style="color: #800000;">// Read Only</span></span></pre>
Number of pixels to adjust the horizontal scroll position.

<pre id="property.scrolly"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">ScrollY <span style="color: #0000FF;">As</span> <span style="color: #0000FF;">Integer</span> <span style="color: #800000;">// Read Only</span></span></pre>
Number of pixels to adjust the vertical scroll position.

## Constants

<pre><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Const</span> PhaseBegan = <span style="color: #336698;">1</span>
<span style="color: #0000FF;">Const</span> PhaseCancelled = <span style="color: #336698;">16</span>
<span style="color: #0000FF;">Const</span> PhaseChanged = <span style="color: #336698;">4</span>
<span style="color: #0000FF;">Const</span> PhaseEnded = <span style="color: #336698;">8</span>
<span style="color: #0000FF;">Const</span> PhaseMayBegin = <span style="color: #336698;">32</span>
<span style="color: #0000FF;">Const</span> PhaseNone = <span style="color: #336698;">0</span>
<span style="color: #0000FF;">Const</span> PhaseStationary = <span style="color: #336698;">2</span></span></pre>