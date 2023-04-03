//
//  File.swift
//  
//
//  Created by 김민성 on 2023/03/28.
//

import SwiftUI


extension WidgetController {
    
    
    final class ViewModel: ObservableObject {
        
        enum ScrollState { case up, normal, down }
        
        let description: WidgetDescription
        let onChanged: ([WidgetState]) -> Void
        
        @Published var visibleWidgets: [WidgetInfo]
        @Published var invisibleWidgets: [WidgetInfo]
        @Published var isEditMode: Bool = false
        @Published var showingAddSheet: Bool = false
        @Published var showingRemoveAlert: Bool = false
        
        @Published var selectedWidget: WidgetInfo? = nil        
        @Published var scrollState: ScrollState = .normal
        @Published var hasMoved: Bool = false
                
        var deviceSize: CGSize? = nil
        var scrollProxy: ScrollViewProxy? = nil
        
        init(widgetStates: [WidgetState], widgets: [Widget], onChanged: @escaping ([WidgetState]) -> Void, description: WidgetDescription) {
            // 위젯스테이트와 위젯의 갯수와 아이디가 일치한다고 가정
            // 일치하지 않으면? 사용자의 책임. migration을 확실히 해야함.
            
            var visibleWidgets: [WidgetInfo] = []
            var invisibleWidgets: [WidgetInfo] = []
            
            for widgetState in widgetStates {
                
                guard let widget = widgets.first(where: { widget in
                    widget.identifier == widgetState.id
                }) else { fatalError("no match identifier") }
                
                let id: String = widgetState.id
                let isVisible: Bool = widgetState.isVisible
                let view: AnyView = widget.content
                let onTouch: () -> Void = widget.onTouch
                
                if isVisible {
                    visibleWidgets.append(WidgetInfo(identifier: id, isVisible: isVisible, view: view, onTouch: onTouch))
                } else {
                    invisibleWidgets.append(WidgetInfo(identifier: id, isVisible: isVisible, view: view, onTouch: onTouch))
                }
            }
            
            self.visibleWidgets = visibleWidgets
            self.invisibleWidgets = invisibleWidgets
            self.description = description
            self.onChanged = onChanged
            
        }
        
        func toggleVisibility(of widget: WidgetInfo?) {
            guard let widget = widget else { return }
            // turn into invisible
            if visibleWidgets.contains(widget) {
                guard let index = visibleWidgets.firstIndex(of: widget) else { return }
                visibleWidgets.remove(at: index)
                invisibleWidgets.append(widget)
                
            }
            // turn into visible
            else if invisibleWidgets.contains(widget) {
                guard let index = invisibleWidgets.firstIndex(of: widget) else { return }
                invisibleWidgets.remove(at: index)
                visibleWidgets.insert(widget, at: visibleWidgets.startIndex)                
            }
        }
        
        func complete() {
            let visibleWidgetState: [WidgetState] = visibleWidgets.map { WidgetState($0.identifier, true) }
            let invisibleWidgetState: [WidgetState] = invisibleWidgets.map { WidgetState($0.identifier, false) }
            
            let widgetState: [WidgetState] = visibleWidgetState + invisibleWidgetState
            onChanged(widgetState)
        }
        
        func updateFrame(of widget: WidgetInfo, into frame: CGRect) {            
            guard let index = self.visibleWidgets.firstIndex(of: widget) else { return }
            self.visibleWidgets[index].frame = frame
        }
        
        func detectCollision(using frame: CGRect, of widget: WidgetInfo) {
            guard let index = self.visibleWidgets.firstIndex(of: widget) else { return }
            let pre: WidgetInfo? = self.visibleWidgets[safe: index - 1]
            let post: WidgetInfo? = self.visibleWidgets[safe: index + 1]
            guard let preIndex = self.visibleWidgets.firstIndex(of: pre ?? widget) else { return }
            guard let postIndex = self.visibleWidgets.firstIndex(of: post ?? widget) else { return }
            
            withAnimation(.easeInOut(duration: 0.33)) {
                if frame.midY < pre?.frame?.midY ?? .zero {
                    self.visibleWidgets.move(fromOffsets: [index], toOffset: preIndex)
                    self.hasMoved.toggle()
                } else if frame.midY > post?.frame?.midY ?? .infinity {
                    self.visibleWidgets.move(fromOffsets: [index], toOffset: postIndex + 1)
                    self.hasMoved.toggle()
                }
            }
        }
                
        func checkTouchDevice(using frame: CGRect) {
            guard let deviceSize = self.deviceSize else { return }
            
            if frame.minY < 10  {
                self.scrollState = .up
            } else if deviceSize.height - frame.maxY < 10 {
                self.scrollState = .down
            } else {
                self.scrollState = .normal
            }
        }
  
        func scroll(to direction: ScrollState) {
            guard let selectedWidget = self.selectedWidget else { return }
            guard let scrollProxy = self.scrollProxy else { return }
            var currentIndex = self.visibleWidgets.firstIndex(of: selectedWidget) ?? 0
            
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { Timer in
                // check valid index of showingWidgets.
                if  self.scrollState != .normal && self.visibleWidgets.startIndex..<self.visibleWidgets.endIndex ~= currentIndex {
                    let destination = self.visibleWidgets[currentIndex].identifier
                    withAnimation{
                        scrollProxy.scrollTo(destination)
                    }
                    if direction == .up {
                        currentIndex -= 1
                    } else if direction == .down {
                        currentIndex += 1
                    }
                }
                else {                    
                    Timer.invalidate()
                }
            })
        }
    }
}

