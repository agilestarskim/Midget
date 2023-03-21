import SwiftUI


/// View container for using widget controllers
///
/// Deliver the WidgetState and WidgetDescription to the constructor parameter and put Widget in the tracking closure.
///
///     var body: some View {
///         WidgetController($widgetStateList) {
///             Widget(identifier: "viewA") {
///                 RoundedRectangle(cornerRadius: 15).fill(.red).frame(height: 100)
///             }
///             Widget(identifier: "viewB") {
///                    RoundedRectangle(cornerRadius: 15).fill(.orange).frame(height: 100)
///             }
///             Widget(identifier: "viewC") {
///                  RoundedRectangle(cornerRadius: 15).fill(.yellow).frame(height: 100)
///             }
///         }
///     }
/// 
public struct WidgetController: View {
    
    @Binding var widgetState: WidgetState
    let widgetDescription: WidgetDescription
    let widgets: [Widget]
    @ObservedObject var vm = ViewModel()
    @State private var isEditMode = false
    
    /// create widget controller that display widgets
    /// - Parameters:
    ///     - widgetState: The widget status list received from the user is manipulated in the internal view and then bound to the parent view.
    ///     - widgetDescription: Objects that can localize or customize text in the UI
    ///     - content: widget
    public init (
        _ widgetState: Binding<WidgetState>,
        _ widgetDescription:WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> Widget
    ){
        self._widgetState = widgetState
        self.widgetDescription = widgetDescription
        let cv = content()
        self.widgets = [cv]
        devideShowingWidgetAndHiddenWidget()
    }
    
    public init (
        _ widgetState: Binding<WidgetState>,
        _ widgetDescription:WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget)>
    ) {
        self._widgetState = widgetState
        self.widgetDescription = widgetDescription
        let cv = content().value
        self.widgets = [cv.0, cv.1]
        devideShowingWidgetAndHiddenWidget()
    }

    public init (
        _ widgetState: Binding<WidgetState>,
        _ widgetDescription:WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget, Widget)>
    ) {
        self._widgetState = widgetState
        self.widgetDescription = widgetDescription
        let cv = content().value
        self.widgets = [cv.0, cv.1, cv.2]
        devideShowingWidgetAndHiddenWidget()
    }
    
    public init (
        _ widgetState: Binding<WidgetState>,
        _ widgetDescription:WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget, Widget, Widget)>
    ) {
        self._widgetState = widgetState
        self.widgetDescription = widgetDescription
        let cv = content().value
        self.widgets = [cv.0, cv.1, cv.2, cv.3]
        devideShowingWidgetAndHiddenWidget()
    }
    
    public init (
        _ widgetState: Binding<WidgetState>,
        _ widgetDescription:WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget, Widget, Widget, Widget)>
    ) {
        self._widgetState = widgetState
        self.widgetDescription = widgetDescription
        let cv = content().value
        self.widgets = [cv.0, cv.1, cv.2, cv.3, cv.4]
        devideShowingWidgetAndHiddenWidget()
    }
    
    public init (
        _ widgetState: Binding<WidgetState>,
        _ widgetDescription:WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget, Widget, Widget, Widget, Widget)>
    ) {
        self._widgetState = widgetState
        self.widgetDescription = widgetDescription
        let cv = content().value
        self.widgets = [cv.0, cv.1, cv.2, cv.3, cv.4, cv.5]
        devideShowingWidgetAndHiddenWidget()
    }
    
    public init (
        _ widgetState: Binding<WidgetState>,
        _ widgetDescription:WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget, Widget, Widget, Widget, Widget, Widget)>
    ) {
        self._widgetState = widgetState
        self.widgetDescription = widgetDescription
        let cv = content().value
        self.widgets = [cv.0, cv.1, cv.2, cv.3, cv.4, cv.5, cv.6]
        devideShowingWidgetAndHiddenWidget()
    }
    
    public init (
        _ widgetState: Binding<WidgetState>,
        _ widgetDescription:WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget, Widget, Widget, Widget, Widget, Widget, Widget)>
    ) {
        self._widgetState = widgetState
        self.widgetDescription = widgetDescription
        let cv = content().value
        self.widgets = [cv.0, cv.1, cv.2, cv.3, cv.4, cv.5, cv.6, cv.7]
        devideShowingWidgetAndHiddenWidget()
    }
    
    public init (
        _ widgetState: Binding<WidgetState>,
        _ widgetDescription:WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget, Widget, Widget, Widget, Widget, Widget, Widget, Widget)>
    ) {
        self._widgetState = widgetState
        self.widgetDescription = widgetDescription
        let cv = content().value
        self.widgets = [cv.0, cv.1, cv.2, cv.3, cv.4, cv.5, cv.6, cv.7, cv.8]
        devideShowingWidgetAndHiddenWidget()
    }
    
    /// Make sure that the key in the widgetStateList matches the ID value of the widget
    /// and decide whether to show the view based on the value in the widgetStateList.
    private func devideShowingWidgetAndHiddenWidget() {
    
        
        let calibratedState = calibrateIncorrectIdentifier(self.widgetState.stateList, widgets.map { $0.identifier })
        
        for state in calibratedState {
            for widget in widgets {
                if state.1 && state.0 == widget.identifier {
                    vm.showingWidgets.append(widget)
                } else if !state.1 && state.0 == widget.identifier {
                    vm.hiddenWidgets.append(widget)
                }
                
            }
        }
    }
    
    ///Calibrate incorrect identifier.
    private func calibrateIncorrectIdentifier(_ widgetState: [(String,Bool)], _ widgetIDs: [String]) -> [(String, Bool)] {
        
        if widgetState.count != Set(widgetIDs).count {
            debugPrint("[WidgetController] The number of widget managed by widgetState does not match the number of widget declared in widgetController.")
        }
        let incorrectIDs = widgetIDs.filter { widgetID in
            !widgetState.map { state in state.0 }.contains(widgetID)
        }
        
        let incorrectIDsWithState: [(String, Bool)] = incorrectIDs.map { id in
            switch self.widgetState.option {
            case .showIncorrectID:
                return (id, true)
            case .hideIncorrectID:
                return (id, false)
            }
        }
        
        let correctIDs = widgetIDs.filter { widgetID in
            widgetState.map { state in state.0 }.contains(widgetID)
        }
        
        let correctIDsWithState: [(String, Bool)] = correctIDs.map { id in
            var isShow: Bool = false
            for state in widgetState {
                if state.0 == id {
                    isShow = state.1
                }
            }
            return (id, isShow)
        }
        
        self.widgetState.saveWidgetStateToUserDefaults(correctIDsWithState + incorrectIDsWithState)
        
        return correctIDsWithState + incorrectIDsWithState
    }
    
    public var body: some View {
        GeometryReader { globalGeo in
            ScrollView(showsIndicators: false) {
                    if !isEditMode{
                        WidgetMainView(isEditMode: $isEditMode, widgetDescription: widgetDescription)
                    } else {
                        WidgetEditView(isEditMode: $isEditMode, widgetDescription: widgetDescription){ changedWidgetState in
                            self.widgetState.stateList = changedWidgetState
                        }
                        .onAppear{ vm.globalScreenSize = globalGeo.size}
                    }
            }
            .coordinateSpace(name: ViewModel.Coordinator.globalView)
        }
        .environmentObject(vm)
    }
}
