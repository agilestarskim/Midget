import SwiftUI

struct WidgetView: View {
    
    @EnvironmentObject var vm: WidgetController.ViewModel
    @State private var isDragging: Bool = false
    @State private var offset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var dragTranslation: CGFloat = .zero
        
    @State private var geo: GeometryProxy? = nil
    
    func frame(space: CoordinateSpace) -> CGRect {
        geo?.frame(in: space) ?? .zero
    }
    
    let widget: WidgetInfo
    
    var body: some View {
        ZStack {
            if isDragging {
                widget.view
            } else {
                widget.view
                    .editable {
                        vm.selectedWidget = widget
                        vm.showingRemoveAlert = true
                    }
                    .wiggle()
            }
            GeometryReader { geo in
                Color.clear
                    .preference(key: GeometryPreferenceKey.self, value: geo)
            }
        }
        .offset(offset)
        .onPreferenceChange(GeometryPreferenceKey.self) { value in
            guard let value = value else { return }
            self.geo = value
        }
        .onChange(of: vm.selectedWidget) { widget in
            guard widget != nil else { return }
            vm.updateFrame(of: self.widget, into: frame(space: .named("scrollSpace")))
        }
        .onChange(of: vm.hasMoved) { _ in
            vm.updateFrame(of: self.widget, into: frame(space: .named("scrollSpace")))
        }
        .onChange(of: vm.scrollState) { state in
            guard vm.selectedWidget == widget else { return }
            if state == .up {
                vm.scroll(to: .up)
            } else if state == .down {
                vm.scroll(to: .down)
            }
        }        
        .scaleEffect(scale)
        .padding()
        .delayedInput(delay: 0.1)
        .gesture(
            LongPressGesture(minimumDuration: 0.3)
                .onEnded{ _ in
                    withAnimation(.easeIn(duration: 0.1)) {
                        scale = 1.05
                    }
                    isDragging = true
                    vm.selectedWidget = widget
                }
                .sequenced(before: DragGesture(minimumDistance: 0)
                    .onChanged{ drag in
                        withAnimation(.linear(duration: 0.2)) {
                            self.offset = drag.translation
                        }
                        //너무 자주 업데이트 되는 것을 방지하기 위해 20pt만큼 움직일 때 마다 트리거
                        guard abs(self.dragTranslation - drag.translation.height) > 15 else { return }
                        
                        self.dragTranslation = drag.translation.height
                        
                        let scrollFrame = frame(space: .named("scrollSpace"))
                        let deviceFrame = frame(space: .global)
                        //충돌확인
                        vm.detectCollision(using: scrollFrame, of: widget)
                        //자동 스크롤
                        vm.checkTouchDevice(using: deviceFrame)                                                
                    }
                    .onEnded { _ in
                        self.isDragging = false
                        self.offset = .zero
                        self.scale = 1.0
                        vm.selectedWidget = nil                        
                        vm.scrollState = .normal
                    }
            )
        )
        .zIndex(isDragging ? 1: 0)
    }
}
