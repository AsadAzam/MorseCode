# Morse Code

![GitHub](https://img.shields.io/github/license/AsadAzam/MorseCode?style=for-the-badge)
![GitHub](https://img.shields.io/github/issues-raw/AsadAzam/MorseCode?style=for-the-badge)
![GitHub](https://img.shields.io/github/issues-closed-raw/AsadAzam/MorseCode?style=for-the-badge)
![GitHub](https://img.shields.io/github/issues-pr/AsadAzam/MorseCode?style=for-the-badge)
![GitHub](https://img.shields.io/github/last-commit/AsadAzam/MorseCode?style=for-the-badge)

# Screenshots
<p float="left">
  <img src="https://user-images.githubusercontent.com/32137859/90597714-464c1700-e20f-11ea-821a-9846b74e615a.png" alt="MainScreen" width="200"/>
  <img src="https://user-images.githubusercontent.com/32137859/90598375-865fc980-e210-11ea-9240-32f9dd21ee2d.png" alt="SoundScreen" width="200"/>
  <img src="https://user-images.githubusercontent.com/32137859/90598545-dd659e80-e210-11ea-90f3-e3b8aa378134.png" alt="VibrationScreen" width="200"/>
  <img src="https://user-images.githubusercontent.com/32137859/90598610-fbcb9a00-e210-11ea-97fb-3576cf8da652.png" alt="FlashScreen" width="200"/>
</p>

# Usage
<p float="left">
  <img src="https://user-images.githubusercontent.com/32137859/90598751-451be980-e211-11ea-8940-32a0a2bd59fa.png" alt="Use1" width="200"/>
  <img src="https://user-images.githubusercontent.com/32137859/90598775-51a04200-e211-11ea-8124-ddefb059acc0.png" alt="Use2" width="200"/>  
</p>

#### Morse Code is an iOS app which can convert text to
- ##### Sound
- ##### Vibration
- ##### Flashes (using flashlight)

#### Features!
  - Sound, vibration and flash can be set to infinitely loop
  - The WPM of sound can be adjusted between 15 - 20 WPM
  - The sound is generated through the device rather than being played from a file which makes changes/ modifications super easy.
  - The vibration strength has been adjusted so as to clearly differentiate between dit and dah
  - Flashes run at full brightness and is synchronised so as it is visible from a far distance
  - The UI is super simple

#### Tech

Morse Code is built completely on swift and has been tested on an iPhone XS
It uses the following frameworks:

* UIKit - For all the graphical interface
* AVFoundation - To generate audio signals and play them, and also for Flashlight
* CoreHaptics - To compose and play vibration patterns

#### Installation
Morse Code requires Xcode to build and run, to test features such as vibration and flash we need an iOS device running on iOS 13.6
