# Version History

## Version 1.0.2 - January 26th, 2016

- Fixed ArtisanKit.Control.CancelAnimation's Key As Text parameter. This should have been Key As String. As a result, it was not possible to cancel animations.

## Version 1.0.1 - January 3rd, 2016

- It is now possible to start or update an animation from the ArtisanKit.Control.AnimationStep event. Previously, if the animation was on the final step, a newly started animation would be stopped too. This essentially prevented looping animations.
- Added `Finished As Boolean` parameter to ArtisanKit.Control.AnimationStep event. This will be true when the final step of an animation is being executed.
- Added `Ease As Boolean = True` parameter to ArtisanKit.Control.StartAnimation method. Previously, all animations would use an 'ease-out' effect. Now, when `Ease` is false, the animation will run at a steady pace.

## Version 1.0 - October 28th, 2015

- Initial 1.0 release.