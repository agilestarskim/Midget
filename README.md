# WidgetController

iOS Widget control system in swiftUI
you can add, delete and change order your own views

![RPReplay_Final1667813604](https://user-images.githubusercontent.com/79740398/200287349-955d8530-1087-4d25-83e3-6b9e38ddd136.gif)

# Installing

It requires iOS 15

In Xcode go to File -> Swift Packages -> Add Package Dependency and paste in the repo's url: 

https://github.com/agilestarskim/WidgetController.git

# Usage

import the package in the file you would like to use it

```swift
import WidgetController
```

place WidgetController in the parent view

**important: You shoud put WidgetController inside NavigationView !!**

```swift
Struct ContentView: View {
    var body: some View {
        NavigationView {
            WidgetController {
                YourCustomView()
                YourCustomView()
                YourCustomView()
            }
        }   
    }
}
```

# permanent storage

on developing..
