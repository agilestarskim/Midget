import SwiftUI

/// View container for using MidgetControllers
///
/// Deliver the MidgetState and MidgetDescription to the constructor parameter and put Midget in the tracking closure.
///
///     var body: some View {
///         MidgetController(MidgetStates) {
///             Midget("viewA") {
///                 RoundedRectangle(cornerRadius: 15).fill(.red).frame(height: 100)
///             }
///             Midget("viewB") {
///                 RoundedRectangle(cornerRadius: 15).fill(.orange).frame(height: 100)
///             }
///             Midget("viewC") {
///                 RoundedRectangle(cornerRadius: 15).fill(.yellow).frame(height: 100)
///             }
///         }
///     }
/// 
public struct MidgetController: View {
    
    @ObservedObject var vm: MidgetController.ViewModel
    
    /// create Midget controller that display Midgets
    /// - Parameters:
    ///     - midgetState: The midget status list received from the user is manipulated in the internal view and then bound to the parent view.
    ///     - midgetDescription: Objects that can localize or customize text in the UI
    ///     - content: midget
    public init (
        _ midgetStates: [MidgetState],
        _ midgetDescription:MidgetDescription = MidgetDescription(),
        @ViewBuilder content: @escaping () -> Midget,
        onChanged: @escaping ([MidgetState]) -> Void
    ){
        
        let midget = content()
        
        self.vm = ViewModel(midgetStates: midgetStates, midgets: [midget], onChanged: onChanged, description: midgetDescription)
    }
    
    public init (
        _ midgetStates: [MidgetState],
        _ midgetDescription:MidgetDescription = MidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Midget, Midget)>,
        onChanged: @escaping ([MidgetState]) -> Void
    ) {
        let midget = content().value
        let midgets = [midget.0, midget.1]
        self.vm = ViewModel(midgetStates: midgetStates, midgets: midgets, onChanged: onChanged, description: midgetDescription)
    }

    public init (
        _ midgetStates: [MidgetState],
        _ midgetDescription:MidgetDescription = MidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Midget, Midget, Midget)>,
        onChanged: @escaping ([MidgetState]) -> Void
    ) {
        let midget = content().value
        let midgets = [midget.0, midget.1, midget.2]
        self.vm = ViewModel(midgetStates: midgetStates, midgets: midgets, onChanged: onChanged, description: midgetDescription)
    }
    
    public init (
        _ midgetStates: [MidgetState],
        _ midgetDescription:MidgetDescription = MidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Midget, Midget, Midget, Midget)>,
        onChanged: @escaping ([MidgetState]) -> Void
    ) {
        let midget = content().value
        let midgets = [midget.0, midget.1, midget.2, midget.3]
        self.vm = ViewModel(midgetStates: midgetStates, midgets: midgets, onChanged: onChanged, description: midgetDescription)
    }
    
    public init (
        _ midgetStates: [MidgetState],
        _ midgetDescription:MidgetDescription = MidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Midget, Midget, Midget, Midget, Midget)>,
        onChanged: @escaping ([MidgetState]) -> Void
    ) {
        let midget = content().value
        let midgets = [midget.0, midget.1, midget.2, midget.3, midget.4]
        self.vm = ViewModel(midgetStates: midgetStates, midgets: midgets, onChanged: onChanged, description: midgetDescription)
    }
    
    public init (
        _ midgetStates: [MidgetState],
        _ midgetDescription:MidgetDescription = MidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Midget, Midget, Midget, Midget, Midget, Midget)>,
        onChanged: @escaping ([MidgetState]) -> Void
    ) {
        let midget = content().value
        let midgets = [midget.0, midget.1, midget.2, midget.3, midget.4, midget.5]
        self.vm = ViewModel(midgetStates: midgetStates, midgets: midgets, onChanged: onChanged, description: midgetDescription)
    }
    
    public init (
        _ midgetStates: [MidgetState],
        _ midgetDescription:MidgetDescription = MidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Midget, Midget, Midget, Midget, Midget, Midget, Midget)>,
        onChanged: @escaping ([MidgetState]) -> Void
    ) {
        let midget = content().value
        let midgets = [midget.0, midget.1, midget.2, midget.3, midget.4, midget.5, midget.6]
        self.vm = ViewModel(midgetStates: midgetStates, midgets: midgets, onChanged: onChanged, description: midgetDescription)
    }
    
    public init (
        _ midgetStates: [MidgetState],
        _ midgetDescription:MidgetDescription = MidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Midget, Midget, Midget, Midget, Midget, Midget, Midget, Midget)>,
        onChanged: @escaping ([MidgetState]) -> Void
    ) {
        let midget = content().value
        let midgets = [midget.0, midget.1, midget.2, midget.3, midget.4, midget.5, midget.6, midget.7]
        self.vm = ViewModel(midgetStates: midgetStates, midgets: midgets, onChanged: onChanged, description: midgetDescription)
    }
    
    public init (
        _ midgetStates: [MidgetState],
        _ midgetDescription:MidgetDescription = MidgetDescription(),
        @ViewBuilder content: @escaping () -> TupleView<(Midget, Midget, Midget, Midget, Midget, Midget, Midget, Midget, Midget)>,
        onChanged: @escaping ([MidgetState]) -> Void
    ) {
        let midget = content().value
        let midgets = [midget.0, midget.1, midget.2, midget.3, midget.4, midget.5, midget.6, midget.7, midget.8]
        self.vm = ViewModel(midgetStates: midgetStates, midgets: midgets, onChanged: onChanged, description: midgetDescription)
    }

    public var body: some View {
        GeometryReader { globalGeo in
            ScrollView(showsIndicators: false) {
                if vm.isEditMode {
                    EditView()
                } else {
                    MainView()
                }
            }
            .onAppear {
                vm.deviceSize = globalGeo.size
            }            
            .environmentObject(vm)
        }
    }
}
