# WidgetController

iOS Widget control system in swiftUI
you can add, delete and move your own views

# Screenshots


<p align="center">
<img src="https://user-images.githubusercontent.com/79740398/202902073-6ad6cc83-13b1-4e84-a5c4-fe4fc8615e28.gif" width="200"/>
<img src="https://user-images.githubusercontent.com/79740398/202901369-ec764376-ce0e-47a7-93a9-25043abfc4a3.gif" width="200"/>
<img src="https://user-images.githubusercontent.com/79740398/202902199-c9082e5b-23fd-48ea-b9a1-2447e9adce0b.gif" width="200"/>
<img src="https://user-images.githubusercontent.com/79740398/202902134-da105f7a-b15b-4ec2-a280-aeb4f77a7954.gif" width="200"/>
</p>



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

widgetState : Array of tuples that consisting of an ID of the view and an bool value indicating whether the view is displayed or not. 

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

You can name it whatever you want. But duplicate is prohibited.

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
            widgetState: [],
            widgets: [],
        ){ _ in
            
        }
    }
```  

## 5. Put proper data into the parameter

```swift
WidgetController(
    widgetState: widgetStateList,
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
 
Widgets is array of Widget consisting of your view covered by AnyView and id.

id is important. Because widgetState tracks and finds your view by id.

So don't forget to match Widget's id and widgetState's id

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

## 6. Store Widget's State permanently

When app close and delete everything, Widgetcontroller is useless as product. 

So you can save widget's state by using closure.

It returns chaged widget state list when user complete editing.


```swift
WidgetController(
    widgetState: [],
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
            widgetState: widgetStateList,
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
