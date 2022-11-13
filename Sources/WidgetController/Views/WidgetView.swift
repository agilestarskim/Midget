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
    @Binding var showingRemoveAlert: Bool
    @State var geoProxy: GeometryProxy? = nil
    
    var position: CGPoint {
        return CGPoint(
            x: geoProxy?.frame(in: .named("editView")).midX ?? 0,
            y: geoProxy?.frame(in: .named("editView")).midY ?? 0
        )
    }
    
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
        VStack{
            if dragState.isDragging {
                vm.showingWidgets[index]?.view
                    .background(GeometryReader { geo in
                        Color.clear
                            .preference(key: GeometryPreferenceKey.self, value: geo)
                    })
                    .offset(dragState.translation)
                    .animation(.linear(duration: 0.1), value: dragState.translation)
                    
            }
            else{
                vm.showingWidgets[index]?.view
                    .editable{
                        vm.index = index
                        showingRemoveAlert = true
                    }
                    .wiggle()
                    .background(GeometryReader { geo in
                        Color.clear
                            .preference(key: GeometryPreferenceKey.self, value: geo)
                            .onAppear{
                               //TODO: set midY
                            }
                    })

            }
        }
        .zIndex(dragState.isActive ? 1 : 0)
        .scaleEffect(dragState.isActive ? 1.05 : 1.0)
        .animation(.linear(duration: 0.1), value: dragState.isActive)
        .onTapGesture { }
        .gesture(longPressDrag)
        .onPreferenceChange(GeometryPreferenceKey.self) { value in
            guard let value = value else { return }
            geoProxy = value
        }
    }
}
