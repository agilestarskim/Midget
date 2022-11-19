import SwiftUI

extension WidgetController {
    class ViewModel: ObservableObject {
        
        enum MovingDirection {
            case none // not create any space
            case upward // create space on the view
            case downward // create space under the view
        }
        
        @Published var showingWidgets: [Widget?] = []
        @Published var hiddenWidgets: [Widget] = []
        var changeCompletion: ([(String, Bool)]) -> Void = { _ in }
        
        var showingWidgetsGeo: [String : GeometryProxy] = [:]
        @Published var collidedWidget: Widget? = nil
        @Published var movingDirection: MovingDirection = .none
        
        var selectedFixedFrame: CGRect = CGRect()
        
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        var scrollViewProxy: ScrollViewProxy? = nil
        var globalScreenSize: CGSize = .zero
        @Published var showingRemoveAlert = false
        
        private var indexForRemove: Int = -1
        private var draggingIndex: Int = -1
        private var collidedIndex: Int = -1
        
        func detectCollision(id: String, movingFrame: CGRect) {

            for widget in showingWidgets {
                guard let widget = widget else { continue }
                if widget.id == id { continue }
                
                guard let collidedFrame = showingWidgetsGeo[widget.id]?.frame(in: .named("editView")) else { return }
                
                guard CGRectIntersectsRect(movingFrame, collidedFrame) else { continue }
                
                if movingFrame.contains(CGPoint(x: collidedFrame.midX, y: collidedFrame.midY)) {
                    
                    withAnimation {
                        collidedWidget = widget
                        if movingFrame.midY > collidedFrame.midY {
                            movingDirection = .downward
                        }else {
                            movingDirection = .upward
                        }
                    }
                    setDraggingIndex(index: showingWidgets.firstIndex(where: {$0?.id == id}))
                    setCollidedIndex(index: showingWidgets.firstIndex(of: widget))
                    return
                }
            }
            
        }
        
        func setIndexForRemove(index: Int) {
            self.indexForRemove = index
        }
        
        func setDraggingIndex(index: Int?){
            guard let index = index else { return }
            self.draggingIndex = index
        }
        
        func setCollidedIndex(index: Int?){
            guard let index = index else { return }
            self.collidedIndex = index
        }
        
        func setSelectedFixedFrame(frame: CGRect) {
            self.selectedFixedFrame = frame
        }
        
        func remove() {
            guard indexForRemove != -1 else { return }
            guard let widget = showingWidgets[indexForRemove] else { return }
            hiddenWidgets.append(widget)
            showingWidgets[indexForRemove] = nil
        }
        
        func complete() {
            var showingTuples: [(String, Bool)] = []
            var hiddenTuples: [(String, Bool)] = []
            for sw in showingWidgets {
                if let sw = sw {
                    showingTuples.append((sw.id,  true))
                }
            }
            for hw in hiddenWidgets {
                hiddenTuples.append((hw.id, false))
            }
            
            changeCompletion(showingTuples + hiddenTuples)
            
        }
        
        func swapWidget() {
            guard draggingIndex != -1 || collidedIndex != -1 else { return }
            guard collidedWidget != nil else { return }
            let dragWidget = showingWidgets[draggingIndex]
            if draggingIndex > collidedIndex {
                if movingDirection == .upward {
                    showingWidgets.insert(dragWidget, at: collidedIndex)
                    showingWidgets.remove(at: draggingIndex + 1)
                    return
                }else if movingDirection == .downward {
                    showingWidgets.insert(dragWidget, at: collidedIndex + 1)
                    showingWidgets.remove(at: draggingIndex + 1)
                    return
                }
            } else {
                if movingDirection == .upward {
                    showingWidgets.insert(dragWidget, at: collidedIndex)
                    showingWidgets.remove(at: draggingIndex)
                    return
                }else if movingDirection == .downward {
                    if collidedIndex == showingWidgets.endIndex {
                        showingWidgets.append(dragWidget)
                    }else {
                        showingWidgets.insert(dragWidget, at: collidedIndex + 1)
                    }
                    showingWidgets.remove(at: draggingIndex)
                    return
                }
            }
            //showingWidgets.swapAt(draggingIndex, collidedIndex)
        }
        
        func initialize() {
            collidedWidget = nil
            movingDirection = .none
            setCollidedIndex(index: -1)
            setDraggingIndex(index: -1)
            setIndexForRemove(index: -1)
        }
        
        
    }
}
