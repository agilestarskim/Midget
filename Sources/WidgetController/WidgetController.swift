import SwiftUI

extension WidgetController {
    class ViewModel: ObservableObject {
        
        enum MovingDirection {
            case none // not create any space
            case upward // create space on the view
            case downward // create space under the view
        }
        
        @Published var showingWidgets: [Widget?] = []
        @Published var hiddenWidgets: [Widget] = []
        
        
        var showingWidgetsGeo: [String : GeometryProxy] = [:]
        @Published var collidedWidget: Widget? = nil
        @Published var movingDirection: MovingDirection = .none
        
        var selectedMovingFrame: CGRect = CGRect()
        var selectedFixedFrame: CGRect = CGRect()
        
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        var scrollViewProxy: ScrollViewProxy? = nil
        var globalScreenSize: CGSize = .zero
        @Published var showingRemoveAlert = false
        var index: Int = -1
        
        
        func detectCollision(id: String) {

            for widget in showingWidgets {
                guard let widget = widget else { continue }
                if widget.id == id { continue }
                
                guard let collidedFrame = showingWidgetsGeo[widget.id]?.frame(in: .named("editView")) else { return }
                
                if selectedMovingFrame.contains(CGPoint(x: collidedFrame.midX, y: collidedFrame.midY)) {
        
                    withAnimation {
                        collidedWidget = widget
                        if selectedMovingFrame.midY > collidedFrame.midY {
                            movingDirection = .downward
                        }else {
                            movingDirection = .upward
                        }
                    }
                    return
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


