# MidgetController

Mimic iOS Widget control system in swiftUI
you can add, delete and move your own views

# Screenshots

EDIT | ADD | REMOVE | MOVE |
| :---------------: | :---------------: | :---------------: | :---------------: |
| <img src="https://user-images.githubusercontent.com/79740398/202903167-50de45e9-bf16-43ef-b3ee-e24b975d4e8f.gif" width="180" height="400"/>| <img src="https://user-images.githubusercontent.com/79740398/202901369-ec764376-ce0e-47a7-93a9-25043abfc4a3.gif" width="180" height="400"/> |<img src="https://user-images.githubusercontent.com/79740398/202902199-c9082e5b-23fd-48ea-b9a1-2447e9adce0b.gif" width="180" height="400"/>| <img src="https://user-images.githubusercontent.com/79740398/202902134-da105f7a-b15b-4ec2-a280-aeb4f77a7954.gif" width="180" height="400"/> |


# Installing

It requires iOS 15

In Xcode go to File -> Swift Packages -> Add Package Dependency and paste in the repo's url: 

https://github.com/agilestarskim/Midget.git

# Usage

## 1. Import the package in the file you would like to use it

```swift
import Midget
```

## 2. Set Midget state 

```swift
@State private var MidgetState = [   
        MidgetState("viewA", true),
        MidgetState("viewB", true),
        MidgetState("viewC", true),
        MidgetState("viewD", false),
        MidgetState("viewE", false)
]
```

#### What is a MidgetState?

* This is an object for storing and managing the state of Midgets

#### What do I need to make a MidgetState?

* id: Identifier string that can identify the view 
* isVisible: Bool value to set whether or not to show the view initially


## 3. Place MidgetController

```swift
var body: some View {
    MidgetController(MidgetState) {
    
    } onChange: { _ in
    
    }       
}
```  

Place the MidgetController where you want it and pass the just created MidgetState to the constructor parameter.


## 4. Make Midgets.

#### What is a Midget?
* A view that has an ID that can be added, deleted, and moved inside the Midget controller.

#### How to make the Midget?
* simply

```swift
Midget("viewA") {
    VStack {
        Text("This is a Test Label")
    }
}
```

#### How to add?

```swift
var body: some View {
    MidgetController($MidgetState) {
        Midget("viewA") {
            //your view
        }
        Midget("viewB") {
            //your view
        }
        Midget("viewC") {
            //your view
        }
        Midget("viewD") {
            //your view
        }
        Midget("viewE") {
            //your view
        }            
    }   
}
```



## 5. Save the changed MidgetState.

#### What is the changed MidgetState?

* When the user finishes editing and presses the done button, the edited result is returned to the onChaged closure.

```swift
var body: some View {
    MidgetController(MidgetState) {
        // your Midgets
    } onChange: { changedMidget in
        self.MidgetState = changedMidget
        //save it to your DB
    }       
}
```  

As you may have noticed, the values of the key in the MidgetState in step 2 made and the identifier in the Midget must be the same.

## 6. Features

#### onTouch
* When you click a Midget in the non-edit mode, call the closure.
```swift
Midget("viewA") {
    //your view
} onTouch: {
    print("viewA Touched")
}
```
