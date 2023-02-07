import SwiftUI

/**
 View that can use iOS widget system
 
    - Parameter:
        - widgetState: Array of tuples that consisting of an ID of the view and an bool value indicating whether the view is displayed or not.
        - widgets: Array of Widgets consisting real view and ID of the view.
        - widgetDescription: Texts in widgetController for custom or localization.
        - changeCompletion: when edit done it's called. it has widget state data 
 */
public struct WidgetController: View {
    
    @Binding var widgetState: WidgetState
    let widgetDescription: WidgetDescription
    let widgets: [Widget]
    @ObservedObject var vm = ViewModel()
    @State private var isEditMode = false
    
    
    public init (
        widgetState: Binding<WidgetState>,
        widgetDescription: WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> Widget
    ){
        self._widgetState = widgetState
        self.widgetDescription = widgetDescription
        let cv = content()
        self.widgets = [cv]
    }
    
    public init (
        widgetState: Binding<WidgetState>,
        widgetDescription: WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget)>
    ) {
        self._widgetState = widgetState
        self.widgetDescription = widgetDescription
        let cv = content().value
        self.widgets = [cv.0, cv.1]
        devideShowingWidgetAndHiddenWidget()
    }

    public init (
        widgetState: Binding<WidgetState>,
        widgetDescription: WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget, Widget)>
    ) {
        self._widgetState = widgetState
        self.widgetDescription = widgetDescription
        let cv = content().value
        self.widgets = [cv.0, cv.1, cv.2]
        devideShowingWidgetAndHiddenWidget()
    }
    
    public init (
        widgetState: Binding<WidgetState>,
        widgetDescription: WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget, Widget, Widget)>
    ) {
        self._widgetState = widgetState
        self.widgetDescription = widgetDescription
        let cv = content().value
        self.widgets = [cv.0, cv.1, cv.2, cv.3]
        devideShowingWidgetAndHiddenWidget()
    }
    
    public init (
        widgetState: Binding<WidgetState>,
        widgetDescription: WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget, Widget, Widget, Widget)>
    ) {
        self._widgetState = widgetState
        self.widgetDescription = widgetDescription
        let cv = content().value
        self.widgets = [cv.0, cv.1, cv.2, cv.3, cv.4]
        devideShowingWidgetAndHiddenWidget()
    }
    
    public init (
        widgetState: Binding<WidgetState>,
        widgetDescription: WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget, Widget, Widget, Widget, Widget)>
    ) {
        self._widgetState = widgetState
        self.widgetDescription = widgetDescription
        let cv = content().value
        self.widgets = [cv.0, cv.1, cv.2, cv.3, cv.4, cv.5]
        devideShowingWidgetAndHiddenWidget()
    }
    
    public init (
        widgetState: Binding<WidgetState>,
        widgetDescription: WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget, Widget, Widget, Widget, Widget, Widget)>
    ) {
        self._widgetState = widgetState
        self.widgetDescription = widgetDescription
        let cv = content().value
        self.widgets = [cv.0, cv.1, cv.2, cv.3, cv.4, cv.5, cv.6]
        devideShowingWidgetAndHiddenWidget()
    }
    
    public init (
        widgetState: Binding<WidgetState>,
        widgetDescription: WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget, Widget, Widget, Widget, Widget, Widget, Widget)>
    ) {
        self._widgetState = widgetState
        self.widgetDescription = widgetDescription
        let cv = content().value
        self.widgets = [cv.0, cv.1, cv.2, cv.3, cv.4, cv.5, cv.6, cv.7]
        devideShowingWidgetAndHiddenWidget()
    }
    
    public init (
        widgetState: Binding<WidgetState>,
        widgetDescription: WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget, Widget, Widget, Widget, Widget, Widget, Widget, Widget)>
    ) {
        self._widgetState = widgetState
        self.widgetDescription = widgetDescription
        let cv = content().value
        self.widgets = [cv.0, cv.1, cv.2, cv.3, cv.4, cv.5, cv.6, cv.7, cv.8]
        devideShowingWidgetAndHiddenWidget()
    }
    
    
    
    private func devideShowingWidgetAndHiddenWidget() {
        for state in self.widgetState.stateList {
            for widget in self.widgets {
                if state.1 && state.0 == widget.identifier {
                    vm.showingWidgets.append(widget)
                } else if !state.1 && state.0 == widget.identifier {
                    vm.hiddenWidgets.append(widget)
                }
            }
        }
    }
    
    
    public var body: some View {
        GeometryReader { globalGeo in
            ScrollView(showsIndicators: false) {
                    if !isEditMode{
                        WidgetMainView(isEditMode: $isEditMode, widgetDescription: widgetDescription)
                    } else {
                        WidgetEditView(
                            isEditMode: $isEditMode,
                            widgetDescription: widgetDescription
                        ){ 
                            changedWidgetState in
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
