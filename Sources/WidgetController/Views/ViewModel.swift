import SwiftUI

extension WidgetController {
    class ViewModel: ObservableObject {
        
        enum MovingDirection {
            case none
            case upward
            case downward
        }
        
        enum Coordinator {
            case globalView
            case editView
        }
        
        @Published var showingWidgets: [Widget] = []
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
        
        private var _indexForRemove: Int = -1
        private var _draggingIndex: Int = -1
        private var _collidedIndex: Int = -1
        
        var collidedIndex: Int {
            return self._collidedIndex
        }
        
        func detectCollision(id: String, draggingFrame: CGRect) {
            
            for widget in showingWidgets {
                if widget.id == id { continue }
                
                guard let collidedFrame = showingWidgetsGeo[widget.id]?.frame(in: .named(Coordinator.editView)) else { return }
                
                guard CGRectIntersectsRect(draggingFrame, collidedFrame) else { continue }
                
                if draggingFrame.contains(CGPoint(x: collidedFrame.midX, y: collidedFrame.midY)) {
                    
                    setDraggingIndex(index: showingWidgets.firstIndex(where: {$0.id == id}))
                    setCollidedIndex(index: showingWidgets.firstIndex(of: widget))
                    withAnimation {
                        collidedWidget = widget
                        if draggingFrame.midY > collidedFrame.midY {
                            movingDirection = .downward
                        }else {
                            movingDirection = .upward
                        }
                    }
                    
                    return
                }
            }
            
        }
        
        func setIndexForRemove(index: Int) {
            self._indexForRemove = index
        }
        
        func setDraggingIndex(index: Int?){
            guard let index = index else { return }
            self._draggingIndex = index
        }
        
        func setCollidedIndex(index: Int?){
            guard let index = index else { return }
            self._collidedIndex = index
        }
        
        func setSelectedFixedFrame(frame: CGRect) {
            self.selectedFixedFrame = frame
        }
        
        func remove() {
            guard _indexForRemove != -1 else { return }
            let widget = showingWidgets[_indexForRemove]
            hiddenWidgets.append(widget)
            showingWidgets.remove(at: _indexForRemove)
        }
        
        func complete() {
            var showingTuples: [(String, Bool)] = []
            var hiddenTuples: [(String, Bool)] = []
            for sw in showingWidgets {
                showingTuples.append((sw.id,  true))
            }
            for hw in hiddenWidgets {
                hiddenTuples.append((hw.id, false))
            }
            
            changeCompletion(showingTuples + hiddenTuples)
            
        }
        
        func swapWidget() {
            if movingDirection == .upward {
                showingWidgets.move(fromOffsets: [_draggingIndex], toOffset: collidedIndex)
            } else if movingDirection == .downward {
                showingWidgets.move(fromOffsets: [_draggingIndex], toOffset: collidedIndex + 1)
            }
        }
        

        func initialize() {
            collidedWidget = nil
            setCollidedIndex(index: -1)
            setDraggingIndex(index: -1)
            setIndexForRemove(index: -1)
        }
        
        
    }
}
