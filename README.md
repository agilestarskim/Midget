# WidgetController

iOS Widget control system in swiftUI
you can add, delete and change order your own views

![widgetTestgif](https://user-images.githubusercontent.com/79740398/200125484-722e9631-0f15-4a49-9e16-d23416a3110b.gif)


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
