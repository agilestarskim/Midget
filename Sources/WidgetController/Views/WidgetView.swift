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
    
    @ObservedObject var vm: WidgetController.ViewModel
    let index: Int
 
    @State var geoProxy: GeometryProxy? = nil
    @GestureState var dragState = DragState.inactive
    @State private var scrollState: ScrollState = .normal
    @State private var indexForScroll = 0
    
    var editFrame: CGRect {
        return geoProxy?.frame(in: .named("editView")) ?? CGRect()
    }
    
    var globalFrame: CGRect {
        return geoProxy?.frame(in: .named("globalView")) ?? CGRect()
    }
    
    var id: String {
        vm.showingWidgets[index]!.id
    }
    
    var body: some View {
        
        let dragGesture = DragGesture()
            .onChanged{ drag in
                
                guard globalFrame != .zero else { return }
                guard editFrame != .zero else { return }
                guard abs(drag.translation.height) > 20 else { return }
                //TODO: 걸쳐있는 뷰 예외처리
                if globalFrame.minY < 0 {
                    scrollState = .up
                }
                else if vm.globalScreenSize.height - globalFrame.maxY < 0 {
                    scrollState = .down
                }
                else {
                    scrollState = .normal
                }
                //TODO: Check switch
                vm.detectCollision(id: self.id, movingFrame: editFrame)
                
            }
        
        let longPressDrag = LongPressGesture().onEnded { _ in
                withAnimation{
                    vm.setSelectedFixedFrame(frame: editFrame)
                    indexForScroll = index
                }
            }
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
                    } else {
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
                withAnimation{
                    scrollState = .normal
                    vm.collidedWidget = nil
                    vm.movingDirection = .none
                }
                
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
                    .frame(height: vm.movingDirection == .none ? vm.selectedFixedFrame.height : 0)
            }
            else{
                VStack {
                    if vm.collidedWidget == vm.showingWidgets[index] && vm.movingDirection == .upward {
                        Color.clear
                            .frame(height: vm.selectedFixedFrame.height) 
                    }
                    
                    vm.showingWidgets[index]?.view
                        .background(GeometryReader { geo in
                            Color.clear
                                .preference(key: GeometryPreferenceKey.self, value: geo)
                                .onAppear {
                                    guard let id = vm.showingWidgets[index]?.id else { return }
                                    vm.showingWidgetsGeo.updateValue(geo, forKey: id)
                                }
                        })
                        .editable{
                            vm.index = index
                            vm.showingRemoveAlert = true
                        }
                        .wiggle()
                        
                    
                    if vm.collidedWidget == vm.showingWidgets[index] && vm.movingDirection == .downward {
                        Color.clear
                            .frame(height: vm.selectedFixedFrame.height)
                    }
                    
                }
                
            }
        }
        .zIndex(dragState.isActive ? 1 : 0)
        .scaleEffect(dragState.isActive ? 1.05 : 1.0)
        .animation(.linear(duration: 0.2), value: dragState.isActive)
        .onTapGesture { }
        .gesture(longPressDrag)
        .onPreferenceChange(GeometryPreferenceKey.self) { value in
            guard let value = value else { return }
            geoProxy = value
        }
        .onChange(of: scrollState){ ss in
            if ss == .up {
                scrollToUP()
            } else if ss == .down {
                scrollToDown()
            }
        }
        
        
        
    }
    
    func scrollToUP() {
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { Timer in
            if indexForScroll > 0  && scrollState == .up {
                indexForScroll = indexForScroll - 1
                withAnimation {
                    vm.scrollViewProxy?.scrollTo(indexForScroll)
                }
            }else {
                Timer.invalidate()
            }
            
        })
    }
    
    func scrollToDown() {
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { Timer in
            if indexForScroll < vm.showingWidgets.count - 1 && scrollState == .down {
                indexForScroll = indexForScroll + 1
                withAnimation {
                    vm.scrollViewProxy?.scrollTo(indexForScroll)
                }

            }else{
                Timer.invalidate()
            }
        })
    }
    
    
    
    
    
    
}
