# WidgetController

iOS Widget control system in swiftUI
you can add, delete and change order your own views

# Screenshots

## remove
![ezgif com-gif-maker-2](https://user-images.githubusercontent.com/79740398/200291433-4a4c62e9-4388-409a-a6e4-ed34f28b15a1.gif)

## add
![ezgif com-gif-maker-3](https://user-images.githubusercontent.com/79740398/200292866-8a73c464-d762-45c4-8167-a83b473c6c41.gif)

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

# Todo

* permanent storage 
* switching view order
* flexible layout
* mutiple language support
