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
@State private var widgetState = WidgetState(
    [   
        ("viewA", true),
        ("viewB", true),
        ("viewC", true),
        ("viewD", true),
        ("viewE", true)
    ]
)
```

#### what is a widgetState?

* This is an object for storing and managing the state of widgets

#### What do I need to make a WidgetState?

* you need **stateList** and **saveKey**
* stateList is a tuple array that stores the state of the widget 
* savekey is name to store in the userDefaults (persistent storage).

#### How to make
* widgetState: Array of tuples that consisting of an ID of the view and an bool value indicating whether the view is displayed or not.

* \[optional] saveKey: You can write the key name you want.


## 3. Place WidgetController

```swift
    var body: some View {
        WidgetController($widgetState) {
        
        }       
    }
```  

Place the WidgetController where you want it and pass the just created WidgetState to the constructor factor as the binding value.


## 4. Make Widgets.

#### What is a Widget?
* A widget is a view that has an ID.

#### How to make the widget?
* simply

```swift
Widget(identifier: "viewA") {
    VStack {
        Text("This is a Test Label")
    }
}
```


## 5. Complete


```swift
var body: some View {
    WidgetController($widgetState) {
        Widget(identifier: "viewA") {
            //your view
        }
        Widget(identifier: "viewB") {
            //your view
        }
        Widget(identifier: "viewC") {
            //your view
        }
        Widget(identifier: "viewD") {
            //your view
        }
        Widget(identifier: "viewE") {
            //your view
        }            
    }   
}
```

As you may have noticed, the values of the key in the widgetState in step 2 made and the identifier in the widget must be the same.


# Sample Code 

<details>   
<summary>open</summary>

Sample code is uploaded with package

```swift
import SwiftUI
import WidgetController

struct ContentView: View {
    
    @State private var widgetStateList = WidgetState([("viewA", true),("viewB", true),("viewC", true),("viewD", true),("viewE", true),("viewF", true),("viewG", true),("viewH", true)])
        
    var body: some View {
        WidgetController($widgetStateList) {
            Widget(identifier: "viewA") {
                RoundedRectangle(cornerRadius: 15).fill(.red).frame(height: 100)
            }
            Widget(identifier: "viewB") {
                RoundedRectangle(cornerRadius: 15).fill(.orange).frame(height: 100)
            }
            Widget(identifier: "viewC") {
                RoundedRectangle(cornerRadius: 15).fill(.yellow).frame(height: 100)
            }
            Widget(identifier: "viewD") {
                RoundedRectangle(cornerRadius: 15).fill(.green).frame(height: 100)
            }
            Widget(identifier: "viewE") {
                RoundedRectangle(cornerRadius: 15).fill(.blue).frame(height: 100)
            }
            Widget(identifier: "viewF") {
                RoundedRectangle(cornerRadius: 15).fill(.cyan).frame(height: 100)
            }
            Widget(identifier: "viewG") {
                RoundedRectangle(cornerRadius: 15).fill(.indigo).frame(height: 100)
            }
            Widget(identifier: "viewH") {
                RoundedRectangle(cornerRadius: 15).fill(.pink).frame(height: 100)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

</details>
