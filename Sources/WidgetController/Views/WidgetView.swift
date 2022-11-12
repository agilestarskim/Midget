import SwiftUI

struct WidgetView: View {
    
    enum DragState {
        case inactive
        case pressing
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .inactive, .pressing:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
        
        var isActive: Bool {
            switch self {
            case .inactive:
                return false
            case .pressing, .dragging:
                return true
            }
        }
        
        var isDragging: Bool {
            switch self {
            case .inactive, .pressing:
                return false
            case .dragging:
                return true
            }
        }
    }
        
    @GestureState var dragState = DragState.inactive
    @ObservedObject var vm: WidgetController.ViewModel
    let index: Int
    @State var geo: GeometryProxy? = nil
    @Binding var showingRemoveAlert: Bool
    
    var body: some View {
        
        let dragGesture = DragGesture()
            .onChanged{ _ in
                //TODO: Check switch
            }
        
        let longPressDrag = LongPressGesture(minimumDuration: 0.1)
            .sequenced(before: dragGesture)
            .updating($dragState) { value, state, transaction in
                switch value {
                // Long press begins.
                case .first(true):
                    // will be not excuted because of view.onTapGesure {} for scrollview
                    state = .pressing
                // Long press confirmed, dragging may begin.
                case .second(true, let drag):
                    if drag?.translation == nil {
                        vm.feedback.prepare()
                        state = .pressing
                        vm.feedback.impactOccurred()
                    }else {
                        state = .dragging(translation: drag?.translation ?? .zero)
                    }
                // Dragging ended or the long press cancelled.
                default:
                    state = .inactive
                }
            }
//            .onEnded { value in
//                guard case .second(true, let drag?) = value else { return }
//            }
        
        VStack {
            if !dragState.isDragging {
                vm.showingWidgets[index]?.view
                    .editable{
                        vm.index = index
                        showingRemoveAlert = true
                    }
                    .wiggle()
            }
            else{
                vm.showingWidgets[index]?.view
                    .offset(dragState.translation)
                    .animation(.linear(duration: 0.1), value: dragState.translation)
            }
        }
        
        .zIndex(dragState.isActive ? 1 : 0)
        .scaleEffect(dragState.isActive ? 1.05 : 1.0)
        .animation(.linear(duration: 0.1), value: dragState.isActive)
        .onTapGesture { }
        .gesture(longPressDrag)
        
    }
}
