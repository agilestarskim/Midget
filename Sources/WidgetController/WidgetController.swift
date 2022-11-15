import SwiftUI

extension WidgetController {
    class ViewModel: ObservableObject {
        @Published var showingWidgets: [Widget?] = []
        @Published var hiddenWidgets: [Widget] = []
        @Published var index: Int = 0
        var showingWidgetsGeo: [String : GeometryProxy] = [:]
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        var scrollViewProxy: ScrollViewProxy? = nil
        var globalScreenSize: CGSize = .zero
        
        @Published var collidedWidget: Widget? = nil
        var tempPosition: CGPoint = CGPoint()
        var selectedFrame: CGRect = CGRect()
        
        func detectCollision(id: String) {
            
            for widget in showingWidgets {
                guard let widget = widget else { continue }
                if widget.id == id { continue }
                let point = CGPoint(
                    x: showingWidgetsGeo[widget.id]?.frame(in: .named("editView")).midX ?? 0,
                    y: showingWidgetsGeo[widget.id]?.frame(in: .named("editView")).midY ?? 0
                )
                
                
                if selectedFrame.contains(point) {
                    collidedWidget = widget
                }
            }
            
        }
        
    }
}


public struct WidgetController: View {
    let data: [(String, Bool)]
    let widgets: [Widget]
    let changeCompletion: ([(String, Bool)]) -> Void
    @ObservedObject var vm = ViewModel()
    @State private var isEditMode = false
    
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
        GeometryReader { globalGeo in
            ScrollView(showsIndicators: false) {
                    if !isEditMode{
                        ScrollViewReader{ value in
                            VStack{
                                ForEach(0 ..< vm.showingWidgets.count, id: \.self) { index in
                                    vm.showingWidgets[index]?.view
                                        .padding()
                                }
                                Button("편집") {
                                    withAnimation{
                                        value.scrollTo(0)
                                    }
                                    isEditMode = true
                                }.widgetButtonStyle(padding: 15)
                            }
                        }
                    }
                    else {
                        ScrollViewReader{ value in
                            WidgetEditView(vm: vm, changeCompletion: changeCompletion, isEditMode: $isEditMode)
                                .coordinateSpace(name: "editView")
                                .onAppear{
                                    vm.scrollViewProxy = value
                                    vm.globalScreenSize = globalGeo.size
                                }
                        }
                       
                    }
            }
            .coordinateSpace(name: "globalView")
            
        }
        
    }
}


