# The ZAZ Artisan Kit

Artisan Kit for Xojo is a module which helps custom control developers get some of the gritty details out of the way, allowing them to focus on the control itself. It handles things like, flicker elimination, pattern fills, and graphic slicing.

## Requirements

Artisan Kit utilizes Xojo API 2 made available in 2019 Release 2. The module will only compile in desktop projects.

## Installation

Download the Artisan Kit project, open the `Artisan Kit.xojo_binary_project` file, then copy the `ArtisanKit` module into the destination project.

## Getting Started

Create a subclass of [ArtisanKit.Control](ArtisanKit.Control.md) and notice it is largely similar to the built-in `Canvas` control. A few differences to be aware of.

- The `Paint` event has one additional parameter: `Highlighted As Boolean`. `Highlighted` is true when the control should be drawn in the foreground.
- The `MouseWheel` event has an additional `WheelData As ArtisanKit.ScrollEvent` parameter. This object contains more details about the scroll event necessary for implementing "snap-back" scrolling. The `DeltaX` and `DeltaY` parameters have been dropped in favor of `PixelsX` and `PixelsY` since OS X now uses per-pixel scrolling instead of per-line scrolling.

## Next Steps

The [ArtisanKit.Control](ArtisanKit.Control.md) class has most of the functionality, so start exploring what it can do for your custom controls.