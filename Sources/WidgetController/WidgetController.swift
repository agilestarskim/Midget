import SwiftUI

public struct WidgetController: View {
    let data: [(String, Bool)]
    let widgets: [Widget]
    let changeCompletion: ([(String, Bool)]) -> Void
    @ObservedObject var vm = ViewModel()
    
    public init(
        data: [(String, Bool)],
        widgets: [Widget],
        changeCompletion: @escaping ([(String, Bool)]) -> Void
    ){
        
        self.data = data
        self.widgets = widgets
        self.changeCompletion = changeCompletion
        
        var tempShowingWidgets: [Widget] = []
        var tempHiddenWidgets: [Widget] = []
        for view in data {
            for widget in widgets {
                if view.0 == widget.id {
                    if view.1 {
                        tempShowingWidgets.append(widget)
                    }else {
                        tempHiddenWidgets.append(widget)
                    }
                    break
                }
            }
        }
        
        vm.showingWidgets = tempShowingWidgets
        vm.hiddenWidgets = tempHiddenWidgets
    }
    
    public var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(0 ..< vm.showingWidgets.count, id: \.self) { index in
                vm.showingWidgets[index]?.view
                    .padding()
            }
            
            NavigationLink {
                WidgetEditView(vm: vm, changeCompletion: changeCompletion)
            } label: {
                Text("편집").widgetTextStyle(padding: 15)
            }
        }
    }
}


