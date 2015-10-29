# The ZAZ Artisan Kit

Artisan Kit for Xojo is a module which helps custom control developers get some of the gritty details out of the way, allowing them to focus on the control itself. It handles things like focus rings, flicker elimination, retina graphics, pattern fills, and graphic slicing.

## Requirements

Artisan Kit utilizes the new Xojo Framework made available in 2015 Release 1. The module will only compile in desktop projects.

## Installation

Download the Artisan Kit project, open the `Artisan Kit.xojo_binary_project` file, then copy the `ArtisanKit` module into the destination project.

## Getting Started

Create a subclass of [ArtisanKit.Control](ArtisanKit.Control.md) and notice it is largely similar to the built-in `Canvas` control. A few differences to be aware of.

- The `Paint` event has two additional parameters: `ScalingFactor As Double` and `Highlighted As Boolean`. `ScalingFactor` will be 1.0 on most screens, 2.0 on retina screens. It is a factor by which drawing will be multiplied. Most drawing will be automatically scaled, however drawing bitmaps will require the scaling factor to draw correctly. `Highlighted` is true when the control should be drawn in the foreground.
- The `MouseWheel` event has an additional `WheelData As ArtisanKit.ScrollEvent` parameter. This object contains more details about the scroll event necessary for implementing "snap-back" scrolling. The `DeltaX` and `DeltaY` parameters have been dropped in favor of `PixelsX` and `PixelsY` since OS X now uses per-pixel scrolling instead of per-line scrolling.

## Next Steps

The [ArtisanKit.RetinaPicture](ArtisanKit.RetinaPicture.md) is an important class for drawing high resolution graphics. And there is much more available to the [ArtisanKit.Control](ArtisanKit.Control.md) class, such as animation and focus rings.