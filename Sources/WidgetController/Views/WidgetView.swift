import SwiftUI

struct WidgetView: View {
    
    @ObservedObject var vm: WidgetController.ViewModel
    let widget: Widget
    @State var geoProxy: GeometryProxy? = nil
    @GestureState var dragState = DragState.inactive
    @State private var scrollState: ScrollState = .normal
    
    var editFrame: CGRect {
        return geoProxy?.frame(in: .named(WidgetController.ViewModel.Coordinator.editView)) ?? CGRect()
    }
    
    var globalFrame: CGRect {
        return geoProxy?.frame(in: .named(WidgetController.ViewModel.Coordinator.globalView)) ?? CGRect()
    }
    
    var id: String {
        widget.id
    }
    
    var index: Int {
        vm.showingWidgets.firstIndex(of: widget) ?? -1
    }
    
    var body: some View {
        
        let dragGesture = DragGesture()
            .onChanged{ drag in
                
                guard globalFrame != .zero else { return }
                guard editFrame != .zero else { return }
                guard abs(drag.translation.height) > 20 else { return }
                
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
                vm.detectCollision(id: self.id, draggingFrame: editFrame)
                
            }
        
        let longPressDrag = LongPressGesture().onEnded { _ in
                withAnimation{
                    vm.setSelectedFixedFrame(frame: editFrame)
                }
            }
            .sequenced(before: dragGesture)
            .updating($dragState) { value, state, transaction in
                switch value {
                case .first(true):
                    state = .pressing
                case .second(true, let drag):
                    if drag?.translation == nil {
                        vm.feedback.prepare()
                        state = .pressing
                        vm.feedback.impactOccurred()
                    } else {
                        state = .dragging(translation: drag?.translation ?? .zero)
                    }
                default:
                    state = .inactive
                }
            }
            .onEnded { value in
                guard case .second(true, _) = value else { return }
                scrollState = .normal
                vm.swapWidget()
                vm.initialize()
            }
        
        VStack{
            if dragState.isDragging {
                widget.view
                    .background(GeometryReader { geo in
                        Color.clear
                            .preference(key: GeometryPreferenceKey.self, value: geo)
                            
                    })
                    .offset(dragState.translation)
                    .animation(.linear(duration: 0.1), value: dragState.translation)
                    .frame(height: vm.collidedWidget == nil ? vm.selectedFixedFrame.height : 0)
            }
            else{
                VStack {
                    Color.clear
                        .frame(height: vm.collidedWidget == widget && vm.movingDirection == .upward ?
                               vm.selectedFixedFrame.height : 0 )
                    widget.view
                        .background(GeometryReader { geo in
                            Color.clear
                                .preference(key: GeometryPreferenceKey.self, value: geo)
                                .onAppear {
                                    let id = widget.id
                                    vm.showingWidgetsGeo.updateValue(geo, forKey: id)
                                }
                        })
                        .editable{
                            vm.setIndexForRemove(index: index)
                            vm.showingRemoveAlert = true
                        }
                        .wiggle()
                    
                    Color.clear
                        .frame(height: vm.collidedWidget == widget && vm.movingDirection == .downward ?
                               vm.selectedFixedFrame.height : 0 )
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
        var currentIndex = vm.collidedIndex != -1 ? vm.collidedIndex : index
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { Timer in

            if scrollState == .up && currentIndex >= vm.showingWidgets.startIndex && currentIndex < vm.showingWidgets.endIndex {
                let destination = vm.showingWidgets[currentIndex].id
                withAnimation{
                    vm.scrollViewProxy?.scrollTo(destination)
                }
            } else {
                Timer.invalidate()
            }
            currentIndex -= 1

        })
    }
    
    func scrollToDown() {
        var currentIndex = vm.collidedIndex != -1 ? vm.collidedIndex : index
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { Timer in
            
            if  scrollState == .down && currentIndex >= vm.showingWidgets.startIndex && currentIndex < vm.showingWidgets.endIndex {
                let destination = vm.showingWidgets[currentIndex].id
                withAnimation{
                    vm.scrollViewProxy?.scrollTo(destination)
                }
            } else {
                Timer.invalidate()
            }
            currentIndex += 1
        })
    }
}


extension WidgetView {
    
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
}
