# Morse Code

#### Morse Code is an iOS app which can convert text to
- ##### Sound
- ##### Vibration
- ##### Flashes (using flashlight)

#### Features!
  - Sound, vibration and flash can be set to infinitely loop
  - The WPM of sound can be adjusted between 15 - 20 WPM
  - The sound is generated through the device rather than being played from a file which makes changes/ modifications super easy.
  - The vibration strength has been adjust so as to clearly differentiate between dit and dah
  - Flashes run at full brightness and is synchronised so as it is visible from a far distance
  - The UI is super simple

#### Tech

Morse Code is built completely on swift and has been tested on an iPhone XS
It uses the following frameworks:

* UIKit - For all the graphical interface
* AVFoundation - To generate audio signals and play them, and also for Flashlight
* CoreHaptics - To compose and play vibration patters

#### Installation
Morse Code requires Xcode to build and run, to test features such as vibration and flash we need an iOS device running on iOS 13.6
