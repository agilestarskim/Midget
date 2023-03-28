import SwiftUI


/// View container for using widget controllers
///
/// Deliver the WidgetState and WidgetDescription to the constructor parameter and put Widget in the tracking closure.
///
///     var body: some View {
///         WidgetController($widgetStates) {
///             Widget("viewA") {
///                 RoundedRectangle(cornerRadius: 15).fill(.red).frame(height: 100)
///             }
///             Widget("viewB") {
///                 RoundedRectangle(cornerRadius: 15).fill(.orange).frame(height: 100)
///             }
///             Widget("viewC") {
///                 RoundedRectangle(cornerRadius: 15).fill(.yellow).frame(height: 100)
///             }
///         }
///     }
/// 
public struct WidgetController: View {
    
    @ObservedObject var vm: WidgetController.ViewModel
    @State private var isEditMode = false
    
    /// create widget controller that display widgets
    /// - Parameters:
    ///     - widgetState: The widget status list received from the user is manipulated in the internal view and then bound to the parent view.
    ///     - widgetDescription: Objects that can localize or customize text in the UI
    ///     - content: widget
    public init (
        _ widgetStates: [WidgetState],
        _ widgetDescription:WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> Widget,
        onChanged: @escaping ([WidgetState]) -> Void
    ){
        
        let widget = content()
        
        self.vm = ViewModel(widgetStates: widgetStates, widgets: [widget], onChanged: onChanged, description: widgetDescription)
    }
    
    public init (
        _ widgetStates: [WidgetState],
        _ widgetDescription:WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget)>,
        onChanged: @escaping ([WidgetState]) -> Void
    ) {
        let widget = content().value
        let widgets = [widget.0, widget.1]
        self.vm = ViewModel(widgetStates: widgetStates, widgets: widgets, onChanged: onChanged, description: widgetDescription)
    }

    public init (
        _ widgetStates: [WidgetState],
        _ widgetDescription:WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget, Widget)>,
        onChanged: @escaping ([WidgetState]) -> Void
    ) {
        let widget = content().value
        let widgets = [widget.0, widget.1, widget.2]
        self.vm = ViewModel(widgetStates: widgetStates, widgets: widgets, onChanged: onChanged, description: widgetDescription)
    }
    
    public init (
        _ widgetStates: [WidgetState],
        _ widgetDescription:WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget, Widget, Widget)>,
        onChanged: @escaping ([WidgetState]) -> Void
    ) {
        let widget = content().value
        let widgets = [widget.0, widget.1, widget.2, widget.3]
        self.vm = ViewModel(widgetStates: widgetStates, widgets: widgets, onChanged: onChanged, description: widgetDescription)
    }
    
    public init (
        _ widgetStates: [WidgetState],
        _ widgetDescription:WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget, Widget, Widget, Widget)>,
        onChanged: @escaping ([WidgetState]) -> Void
    ) {
        let widget = content().value
        let widgets = [widget.0, widget.1, widget.2, widget.3, widget.4]
        self.vm = ViewModel(widgetStates: widgetStates, widgets: widgets, onChanged: onChanged, description: widgetDescription)
    }
    
    public init (
        _ widgetStates: [WidgetState],
        _ widgetDescription:WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget, Widget, Widget, Widget, Widget)>,
        onChanged: @escaping ([WidgetState]) -> Void
    ) {
        let widget = content().value
        let widgets = [widget.0, widget.1, widget.2, widget.3, widget.4, widget.5]
        self.vm = ViewModel(widgetStates: widgetStates, widgets: widgets, onChanged: onChanged, description: widgetDescription)
    }
    
    public init (
        _ widgetStates: [WidgetState],
        _ widgetDescription:WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget, Widget, Widget, Widget, Widget, Widget)>,
        onChanged: @escaping ([WidgetState]) -> Void
    ) {
        let widget = content().value
        let widgets = [widget.0, widget.1, widget.2, widget.3, widget.4, widget.5, widget.6]
        self.vm = ViewModel(widgetStates: widgetStates, widgets: widgets, onChanged: onChanged, description: widgetDescription)
    }
    
    public init (
        _ widgetStates: [WidgetState],
        _ widgetDescription:WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget, Widget, Widget, Widget, Widget, Widget, Widget)>,
        onChanged: @escaping ([WidgetState]) -> Void
    ) {
        let widget = content().value
        let widgets = [widget.0, widget.1, widget.2, widget.3, widget.4, widget.5, widget.6, widget.7]
        self.vm = ViewModel(widgetStates: widgetStates, widgets: widgets, onChanged: onChanged, description: widgetDescription)
    }
    
    public init (
        _ widgetStates: [WidgetState],
        _ widgetDescription:WidgetDescription = WidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Widget, Widget, Widget, Widget, Widget, Widget, Widget, Widget, Widget)>,
        onChanged: @escaping ([WidgetState]) -> Void
    ) {
        let widget = content().value
        let widgets = [widget.0, widget.1, widget.2, widget.3, widget.4, widget.5, widget.6, widget.7, widget.8]
        self.vm = ViewModel(widgetStates: widgetStates, widgets: widgets, onChanged: onChanged, description: widgetDescription)
    }

    
    public var body: some View {
        ScrollView {
            if vm.isEditMode {
                WidgetEditView()
            } else {
                WidgetMainView()
            }
        }
        .environmentObject(vm)
    }
}
