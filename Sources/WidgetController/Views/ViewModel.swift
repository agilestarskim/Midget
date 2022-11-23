import SwiftUI

extension WidgetController {
    
    /// Class that can be accessed from each widgets.
    class ViewModel: ObservableObject {
        /// user dragging direction. it defines where empty view comes.
        enum MovingDirection {
            case none
            case upward
            case downward
        }
        /// It defines coordinate space.
        enum Coordinator {
            case globalView
            case editView
        }
        /// User can see and edit these widgets.
        @Published var showingWidgets: [Widget] = []
        /// User can't see these widgets. The user can pull these out of the add sheet view.
        @Published var hiddenWidgets: [Widget] = []
        /// It called when user push edit done button.
        var changeCompletion: ([(String, Bool)]) -> Void = { _ in }
        /// Information of widgets's geometry proxy.
        var showingWidgetsGeo: [String : GeometryProxy] = [:]
        
        @Published var collidedWidget: Widget? = nil
        @Published var movingDirection: MovingDirection = .none
        /// Dragging widget's frame of geometry proxy.
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
        
        /// It checks if widgets are crushed or not
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
        
        /// Function that remove widget and append it in hidden view.
        func remove() {
            guard _indexForRemove != -1 else { return }
            let widget = showingWidgets[_indexForRemove]
            hiddenWidgets.append(widget)
            showingWidgets.remove(at: _indexForRemove)
        }
        
        /// Combine showingWidgets and HiddenWidget and call changeCompletion closure.
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
        /// Swap dragging widget and collided widget
        func swapWidget() {
            if movingDirection == .upward {
                showingWidgets.move(fromOffsets: [_draggingIndex], toOffset: collidedIndex)
            } else if movingDirection == .downward {
                showingWidgets.move(fromOffsets: [_draggingIndex], toOffset: collidedIndex + 1)
            }
        }
        
        /// initialize viewmodel state 
        func initialize() {
            collidedWidget = nil
            movingDirection = .none
            setCollidedIndex(index: -1)
            setDraggingIndex(index: -1)
            setIndexForRemove(index: -1)
        }
        
        
    }
}
