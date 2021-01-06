# Version History

## Version 1.2.1 - January 6th, 2020

- Fixed some event names that Xojo decided not to rename.
- Cleaned up more API 2 deprecation warnings introduced in Xojo 2020r2.
- Control now has an Animated property that will automatically prevent all animations triggered by StartAnimation.
- Custom focus ring drawing seems to have stopped working. No solution has been found at this time.
- Added Color.AtOpacity method for decreasing the opacity of colors.
- Added Graphics.NewPicture method for creating picture objects that match the Graphics object's scaling settings.

## Version 1.2.0 - October 10th, 2019

- Added support for Xojo's API 2.
- Removed RetinaPicture. This will break code compatibility, but the class was cumbersome now with Xojo's official support for HiDPI.

## Version 1.0.2 - January 26th, 2016

- Fixed ArtisanKit.Control.CancelAnimation's Key As Text parameter. This should have been Key As String. As a result, it was not possible to cancel animations.

## Version 1.0.1 - January 3rd, 2016

- It is now possible to start or update an animation from the ArtisanKit.Control.AnimationStep event. Previously, if the animation was on the final step, a newly started animation would be stopped too. This essentially prevented looping animations.
- Added `Finished As Boolean` parameter to ArtisanKit.Control.AnimationStep event. This will be true when the final step of an animation is being executed.
- Added `Ease As Boolean = True` parameter to ArtisanKit.Control.StartAnimation method. Previously, all animations would use an 'ease-out' effect. Now, when `Ease` is false, the animation will run at a steady pace.

## Version 1.0 - October 28th, 2015

- Initial 1.0 release.