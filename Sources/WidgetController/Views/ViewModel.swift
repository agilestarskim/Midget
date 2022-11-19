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
        var index: Int = -1
        
        func detectCollision(id: String, movingFrame: CGRect) {

            for widget in showingWidgets {
                guard let widget = widget else { continue }
                if widget.id == id { continue }
                
                guard let collidedFrame = showingWidgetsGeo[widget.id]?.frame(in: .named("editView")) else { return }
                
                
                if movingFrame.contains(CGPoint(x: collidedFrame.midX, y: collidedFrame.midY)) {
                    
                    withAnimation {
                        collidedWidget = widget
                        if movingFrame.midY > collidedFrame.midY {
                            movingDirection = .downward
                        }else {
                            movingDirection = .upward
                        }
                    }
                    return
                }
            }
            
        }
        
        func setSelectedFixedFrame(frame: CGRect) {
            self.selectedFixedFrame = frame
        }
        
        func remove() {
            guard let widget = showingWidgets[index] else { return }
            hiddenWidgets.append(widget)
            showingWidgets[index] = nil
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
        
    }
}
