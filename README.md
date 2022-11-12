# WidgetController

iOS Widget control system in swiftUI
you can add, delete and change order your own views

# Screenshots

on taking..

# Installing

It requires iOS 15

In Xcode go to File -> Swift Packages -> Add Package Dependency and paste in the repo's url: 

https://github.com/agilestarskim/WidgetController.git

# Usage

## 1. Import the package in the file you would like to use it

```swift
import WidgetController
```

## 2. Set widget state list 

```swift
@State private var widgetStateList: [(String, Bool)] = 
[
    ("viewA", true), 
    ("viewB", false), 
    ("viewC", true), 
    ("viewD", false), 
    ("viewE", true)
]
```
Array's element order is widget's order. 

Tuple's first element is ID of views.

You can name it whatever you want.

Tuple's second element is bool variable that define whether view is shown or not.

If it's true, view will be shown.

If it's false, view won't be shown.

## 3. Define your own view

here is a sample code

```swift
let viewA: some View  = RoundedRectangle(cornerRadius: 15).fill(.red).frame(height: 100)
let viewB: some View  = RoundedRectangle(cornerRadius: 15).fill(.orange).frame(height: 100)
let viewC: some View  = RoundedRectangle(cornerRadius: 15).fill(.green).frame(height: 100)
let viewD: some View  = RoundedRectangle(cornerRadius: 15).fill(.blue).frame(height: 100)
let viewE: some View  = RoundedRectangle(cornerRadius: 15).fill(.indigo).frame(height: 100)
```

## 4. Place WidgetController

```swift
    var body: some View {
        WidgetController(
            data: [],
            widgets: []
        ){ _ in
            
        }
    }
```  

## 5. Put proper data into the parameter

```swift
WidgetController(
    data: widgetStateList,
    widgets: [
        Widget(view: AnyView(viewA), id: "viewA"),
        Widget(view: AnyView(viewB), id: "viewB"),
        Widget(view: AnyView(viewC), id: "viewC"),
        Widget(view: AnyView(viewD), id: "viewD"),
        Widget(view: AnyView(viewE), id: "viewE") 
    ]
){ _ in
    
}
```

```swift
Widget(view: AnyView(yourView), id: "yourViewKey")
```
Your view has to be covered by Widget with id. 

Because widgetStateList tracks and finds your view by id.

So don't forget to match Widget's id and Tuple's first string.

```swift
var widgetStateList = [("viewA", true), ("viewB", false), ("viewC", true)]

widgets: [
    Widget(view: AnyView(viewA), id: "viewA"),
    Widget(view: AnyView(viewB), id: "viewB"),
    Widget(view: AnyView(viewC), id: "viewC")
]
```
If those are different, widgetcontroller can't find view.

**Widgets array's order doesn't impact on real widget's order**

This widgetStateList's order is important.
```swift
var widgetStateList = [("viewA", true), ("viewB", false), ("viewC", true)]
```

This widgets list's order is not important.
```swift
widgets: [
    Widget(view: AnyView(viewA), id: "viewA"),
    Widget(view: AnyView(viewB), id: "viewB"),
    Widget(view: AnyView(viewC), id: "viewC")
]
```

## 6. Store permanently Widget's State

When app close and delete everything, Widgetcontroller is useless as product. 

So you can save widget's state by using closure.

It returns chaged widget state list when user complete editing.


```swift
WidgetController(
    data: [],
    widgets: []
){ changedWidgetState in
    //rerender view
    widgetStateList = chagedWidgetStateList
    //save widgetState as [String]
    UserDefaults.standard.set(widgetStateList.encode(), forKey: "whateveryouwant")
}
```

`.encode() : [(String, Bool)] -> [String]`


And you can initialize widget state list  

```swift
init() {
    let stringDataFromDB = UserDefaults.standard.array(forKey: "whateveryouwant") as? [String] ?? []
    if stringDataFromDB.isEmpty {
        //set default
        self._widgetStateList = State(initialValue: [("viewA", true), ("viewB", false), ("viewC", true), ("viewD", false), ("viewE", true)])
    }else {
        //decode: [String] -> [(String, Bool)]
        self._widgetStateList = State(initialValue: stringDataFromDB.decode())
    }
    
}
```
`.decode() : [String] -> [(String, Bool)]`

## 7. Try glassBackgound modifier

```swift
Widget(view: AnyView(viewA.glassBackground(padding: 10)), id: "viewA")
```

This view modifier will make it beautiful.

# Sample Code 

<details>   
<summary>open</summary>

Sample code is uploaded with package

```swift
import SwiftUI
//import WidgetController

struct ContentView: View {
    
    @State private var widgetStateList: [(String, Bool)]
    
    //load widgetStateList from DB
    init() {
        let stringDataFromDB = UserDefaults.standard.array(forKey: "whateveryouwant") as? [String] ?? []
        if stringDataFromDB.isEmpty {
            //set default state
            self._widgetStateList = State(initialValue: [("viewA", true), ("viewB", false), ("viewC", true), ("viewD", false), ("viewE", true)])
        }else {
            //decode: [String] -> [(String, Bool)]
            self._widgetStateList = State(initialValue: stringDataFromDB.decode())
        }
        
    }
    
    //your custom view here
    let viewA: some View  = RoundedRectangle(cornerRadius: 15).fill(.red).frame(height: 100)
    let viewB: some View  = RoundedRectangle(cornerRadius: 15).fill(.orange).frame(height: 100)
    let viewC: some View  = RoundedRectangle(cornerRadius: 15).fill(.green).frame(height: 100)
    let viewD: some View  = RoundedRectangle(cornerRadius: 15).fill(.blue).frame(height: 100)
    let viewE: some View  = RoundedRectangle(cornerRadius: 15).fill(.indigo).frame(height: 100)
    
    
    var body: some View {
        WidgetController(
            data: widgetStateList,
            widgets: [
                Widget(view: AnyView(viewA.glassBackground(padding: 10)), id: "viewA"),
                Widget(view: AnyView(viewB.glassBackground(padding: 10)), id: "viewB"),
                Widget(view: AnyView(viewC), id: "viewC"),
                Widget(view: AnyView(viewD), id: "viewD"),
                Widget(view: AnyView(viewE.glassBackground(padding: 10)), id: "viewE")
            ]
        ){ chagedWidgetStateList in
            //rerender view
            widgetStateList = chagedWidgetStateList
            //save widgetState as [String]
            UserDefaults.standard.set(widgetStateList.encode(), forKey: "whateveryouwant")
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

# Todo

* switching view order
* flexible layout
* mutiple language support
