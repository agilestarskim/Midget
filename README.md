# WidgetController

iOS Widget control system in swiftUI
you can add, delete and move your own views

# Screenshots

EDIT | ADD | REMOVE | MOVE |
| :---------------: | :---------------: | :---------------: | :---------------: |
| <img src="https://user-images.githubusercontent.com/79740398/202903167-50de45e9-bf16-43ef-b3ee-e24b975d4e8f.gif" width="180" height="400"/>| <img src="https://user-images.githubusercontent.com/79740398/202901369-ec764376-ce0e-47a7-93a9-25043abfc4a3.gif" width="180" height="400"/> |<img src="https://user-images.githubusercontent.com/79740398/202902199-c9082e5b-23fd-48ea-b9a1-2447e9adce0b.gif" width="180" height="400"/>| <img src="https://user-images.githubusercontent.com/79740398/202902134-da105f7a-b15b-4ec2-a280-aeb4f77a7954.gif" width="180" height="400"/> |


# Installing

It requires iOS 15

In Xcode go to File -> Swift Packages -> Add Package Dependency and paste in the repo's url: 

https://github.com/agilestarskim/WidgetController.git

# Usage

## 1. Import the package in the file you would like to use it

```swift
import WidgetController
```

## 2. Set widget state 

```swift
@State private var widgetState = [   
        WidgetState("viewA", true),
        WidgetState("viewB", true),
        WidgetState("viewC", true),
        WidgetState("viewD", false),
        WidgetState("viewE", false)
    ]
)
```

#### What is a widgetState?

* This is an object for storing and managing the state of widgets

#### What do I need to make a WidgetState?

* id: Identifier string that can identify the view 
* isVisible: Bool value to set whether or not to show the view initially


## 3. Place WidgetController

```swift
var body: some View {
    WidgetController(widgetState) {
    
    } onChange: { _ in
    
    }       
}
```  

Place the WidgetController where you want it and pass the just created WidgetState to the constructor parameter.


## 4. Make Widgets.

#### What is a Widget?
* A view that has an ID that can be added, deleted, and moved inside the widget controller.

#### How to make the widget?
* simply

```swift
Widget("viewA") {
    VStack {
        Text("This is a Test Label")
    }
}
```

#### How to add?

```swift
var body: some View {
    WidgetController($widgetState) {
        Widget("viewA") {
            //your view
        }
        Widget("viewB") {
            //your view
        }
        Widget("viewC") {
            //your view
        }
        Widget("viewD") {
            //your view
        }
        Widget("viewE") {
            //your view
        }            
    }   
}
```



## 5. Save the changed widgetState.

#### What is the changed widgetState?

* When the user finishes editing and presses the done button, the edited result is returned to the onChaged closure.

```swift
var body: some View {
    WidgetController(widgetState) {
        // your widgets
    } onChange: { changedWidget in
        self.widgetState = changedWidget
        //save it to your DB
    }       
}
```  

As you may have noticed, the values of the key in the widgetState in step 2 made and the identifier in the widget must be the same.

## 6. Features

#### onTouch
* When you click a widget in the non-edit mode, call the closure.
```swift
Widget("viewA") {
    //your view
} onTouch: {
    print("viewA Touched")
}
```
