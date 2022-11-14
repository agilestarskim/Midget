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
    enum ScrollState {
        case up
        case normal
        case down
    }
    @GestureState var dragState = DragState.inactive
    @ObservedObject var vm: WidgetController.ViewModel
    let index: Int
    @Binding var showingRemoveAlert: Bool
    @State var geoProxy: GeometryProxy? = nil
    @State private var scrollState: ScrollState = .normal
    
    var editFrame: CGRect {
        return geoProxy?.frame(in: .named("editView")) ?? CGRect()
    }
    
    var globalFrame: CGRect {
        return geoProxy?.frame(in: .named("globalView")) ?? CGRect()
    }

    
    var body: some View {
        
        let dragGesture = DragGesture()
            .onChanged{ drag in
        
                //상단에 닿을 때
                guard globalFrame != .zero else { return }
                guard abs(drag.translation.height) > 20 else { return }
                if globalFrame.minY < 10  {
                    scrollState = .up
                }
                //하단에 닿을 때
                if vm.globalScreenSize.height - globalFrame.maxY < 10 {
                    scrollState = .down
                }

                //TODO: Check switch
            }
        
        let longPressDrag = LongPressGesture()
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
                    // will be not excuted i don't know why
                    state = .inactive
                }
            }
            .onEnded { value in
                guard case .second(true, _) = value else { return }
                scrollState = .normal
            }
        
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
        .onChange(of: scrollState){ ss in
            if ss == .up {
                withAnimation{
                    vm.scrollViewProxy?.scrollTo("start", anchor: .top)
                }
            }
            
            if ss == .down {
                withAnimation{
                    vm.scrollViewProxy?.scrollTo("end", anchor: .bottom)
                }
            }
        }
    }
}
