# ArtisanKit.RetinaPicture

A `Picture` subclass which contains an additional high resolution representation.

## Shared Methods

<pre id="method.open"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Shared</span> <span style="color: #0000FF;">Function</span> Open (File <span style="color: #0000FF;">As</span> FolderItem) <span style="color: #0000FF;">As</span> ArtisanKit.RetinaPicture</span></pre>
Based on the `File` parameter, searches for a counterpart file in the same directory. For example, if the file is "Icon.png", this method will look for a "Icon@2x.png" sibling. If the file is "Icon@2x.png", the method will search for the "Icon.png" sibling. If a sibling is not found, the provided file will create the sibling by scaling the provided file up or down as necessary.

<pre id="method.createfrom"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;"><span style="color: #0000FF;">Shared</span> <span style="color: #0000FF;">Function</span> CreateFrom (LowRes <span style="color: #0000FF;">As</span> Picture, HiRes <span style="color: #0000FF;">As</span> Picture) <span style="color: #0000FF;">As</span> ArtisanKit.RetinaPicture</span></pre>
Creates a new `ArtisanKit.RetainPicture` from the provided `LowRes` and `HighRes` parameters.

## Properties

<pre id="property.hires"><span style="font-family: 'source-code-pro', 'menlo', 'courier', monospace; color: #000000;">HiRes <span style="color: #0000FF;">As</span> Picture</span></pre>
The high resolution representation.