import SwiftUI

public struct WidgetController: View {
    let data: [(String, Bool)]
    let widgets: [Widget]
    let changeCompletion: ([(String, Bool)]) -> Void
    let widgetDescription: WidgetDescription
    @ObservedObject var vm = ViewModel()
    @State private var isEditMode = false
    
    public init(
        data: [(String, Bool)],
        widgets: [Widget],
        widgetDescription: WidgetDescription,
        changeCompletion: @escaping ([(String, Bool)]) -> Void
        
    ){
        
        self.data = data
        self.widgets = widgets
        self.widgetDescription = widgetDescription
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
        vm.changeCompletion = changeCompletion
    }
    
    public var body: some View {
        GeometryReader { globalGeo in
            ScrollView(showsIndicators: false) {
                    if !isEditMode{
                        WidgetMainView(vm: vm, isEditMode: $isEditMode, widgetDescription: widgetDescription)
                    } else {
                        WidgetEditView(vm: vm, isEditMode: $isEditMode, widgetDescription: widgetDescription)
                            .onAppear{ vm.globalScreenSize = globalGeo.size}
                    }
            }
            .coordinateSpace(name: ViewModel.Coordinator.globalView)
        }
        
    }
}


