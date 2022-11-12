import SwiftUI
//import WidgetController

struct SampleView: View {
    
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

struct SampleView_Previews: PreviewProvider {
    static var previews: some View {
        SampleView()
    }
}
