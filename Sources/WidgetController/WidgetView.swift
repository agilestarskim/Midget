import SwiftUI

struct WidgetView: View {
    
    @EnvironmentObject var vm: WidgetController.ViewModel
    @State private var isDragging: Bool = false
    @State private var offset: CGSize = .zero
    let widget: WidgetInfo
    
    
    var body: some View {
        VStack {
            if isDragging {
                widget.view
                    .offset(offset)
                    .scaleEffect(1.05)
            } else {
                widget.view
                    .editable {
                        vm.selectedWidget = widget
                        vm.showingRemoveAlert = true
                    }
                    .wiggle()
                    .scaleEffect(1.0)
            }
        }
        .padding()
        .delayedInput(delay: 0.1)
        .gesture(
            LongPressGesture(minimumDuration: 0.3)
                .onEnded{ _ in
                    isDragging = true
                }
                .sequenced(before: DragGesture(minimumDistance: 0)
                    .onChanged{ value in
                        withAnimation(.linear(duration: 0.2)) {
                            self.offset = value.translation
                        }
                    }
                    .onEnded { _ in
                        self.isDragging = false
                        self.offset = .zero
                    }
            )
        )
        .zIndex(isDragging ? 1: 0)
    }
//    var body: some View {
        
        
//        VStack{
//            if dragState.isDragging {
//                widget.content
//                    .background(GeometryReader { geo in
//                        Color.clear
//                            .preference(key: GeometryPreferenceKey.self, value: geo)
//
//                    })
//                    .offset(dragState.translation)
//                    .animation(.linear(duration: 0.1), value: dragState.translation)
//                    .frame(height: vm.collidedWidget == nil ? vm.selectedFixedFrame.height : 0)
//            }
//            else{
//                VStack {
//                    // This view is for moving collided widget.
//                    // It's like a trick pretending to swap widget position for a moment.
//                    Color.clear
//                        .frame(height: vm.collidedWidget == widget && vm.movingDirection == .upward ?
//                               vm.selectedFixedFrame.height : 0 )
//                    widget.content
//                        .background(GeometryReader { geo in
//                            Color.clear
//                                .preference(key: GeometryPreferenceKey.self, value: geo)
//                                // When view appears, set geo dictionary for detecting collid
//                                .onAppear {
//                                    let id = widget.identifier
//                                    vm.showingWidgetsGeo.updateValue(geo, forKey: id)
//                                }
//                        })
//                        .editable{
//                            // When user pushes remove button, set the index to remove index and show alert.
//                            vm.setIndexForRemove(index: index)
//                            vm.showingRemoveAlert = true
//                        }
//                        .wiggle()
//                    // Trick view to swap widget moving underward.
//                    Color.clear
//                        .frame(height: vm.collidedWidget == widget && vm.movingDirection == .downward ?
//                               vm.selectedFixedFrame.height : 0 )
//                }
//            }
//        }
//        .zIndex(dragState.isActive ? 1 : 0)
//        .scaleEffect(dragState.isActive ? 1.05 : 1.0)
//        .animation(.linear(duration: 0.2), value: dragState.isActive)
//        .onTapGesture { }
//        .gesture(longPressDrag)
//        .onPreferenceChange(GeometryPreferenceKey.self) { value in
//            guard let value = value else { return }
//            geoProxy = value
//        }
//        .onChange(of: scrollState){ ss in
//            if ss == .up {
//                scrollToUP()
//            } else if ss == .down {
//                scrollToDown()
//            }
//        }
//    }
    
//    func scrollToUP() {
//        // currentIndex is showingWidget's index, and it's for enumerating in loop
//        var currentIndex = vm.collidedIndex != -1 ? vm.collidedIndex : index
//
//        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { Timer in
//            // check valid index of showingWidgets.
//            if scrollState == .up && currentIndex >= vm.showingWidgets.startIndex && currentIndex < vm.showingWidgets.endIndex {
//                // convert index to id
//                let destination = vm.showingWidgets[currentIndex].identifier
//                withAnimation{
//                    vm.scrollViewProxy?.scrollTo(destination)
//                }
//            } else {
//                Timer.invalidate()
//            }
//            currentIndex -= 1
//
//        })
//    }
//
//    func scrollToDown() {
//        var currentIndex = vm.collidedIndex != -1 ? vm.collidedIndex : index
//        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { Timer in
//
//            if  scrollState == .down && currentIndex >= vm.showingWidgets.startIndex && currentIndex < vm.showingWidgets.endIndex {
//                let destination = vm.showingWidgets[currentIndex].identifier
//                withAnimation{
//                    vm.scrollViewProxy?.scrollTo(destination)
//                }
//            } else {
//                Timer.invalidate()
//            }
//            currentIndex += 1
//        })
//    }
}
