# BBAppRater

BBAppRater is swift 3 class for rating your app.

![Alt][screenshot1]

[screenshot1]:https://github.com/BhavinBhadani/BBAppRater/blob/master/BBAppRaterSS.png

## Requirements

- iOS 9.0+
- Xcode 8.1+
- Swift 3.0+

## Installation

Just add `BBAppRater` folder to your app and you are done.


## Usage

Use this code in your AppDelegate.swift file.

```swift
let appRater = BBAppRater.sharedInstance
appRater.appId = "YOUR_APP_ID"
appRater.requiredLaunchesBeforeRating = 7 // optional. default is 0
```

## Author

Bhavin Bhdanai  

contact me on skype: bhavin.bhadani


## License

BBAppRater is available under the MIT license. See the LICENSE file for more info.
