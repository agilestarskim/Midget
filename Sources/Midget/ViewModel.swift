//
//  File.swift
//  
//
//  Created by 김민성 on 2023/03/28.
//

import SwiftUI


extension MidgetController {
    
    final class ViewModel: ObservableObject {
        
        enum ScrollState { case up, normal, down }
        
        let description: MidgetDescription
        let onChanged: ([MidgetState]) -> Void
        
        @Published var visibleMidgets: [MidgetInfo]
        @Published var invisibleMidgets: [MidgetInfo]
        @Published var isEditMode: Bool = false
        @Published var showingAddSheet: Bool = false
        @Published var showingRemoveAlert: Bool = false
        
        @Published var selectedMidget: MidgetInfo? = nil
        @Published var scrollState: ScrollState = .normal
        @Published var hasMoved: Bool = false
                
        var deviceSize: CGSize? = nil
        var scrollProxy: ScrollViewProxy? = nil
        
        init(midgetStates: [MidgetState], midgets: [Midget], onChanged: @escaping ([MidgetState]) -> Void, description: MidgetDescription) {
            // 위젯스테이트와 위젯의 갯수와 아이디가 일치한다고 가정
            // 일치하지 않으면? 사용자의 책임. migration을 확실히 해야함.
            
            var visibleMidgets: [MidgetInfo] = []
            var invisibleMidgets: [MidgetInfo] = []
            
            for midgetState in midgetStates {
                
                guard let midget = midgets.first(where: { midget in
                    midget.identifier == midgetState.id
                }) else { fatalError("no match identifier") }
                
                let id: String = midgetState.id
                let isVisible: Bool = midgetState.isVisible
                let view: AnyView = midget.content
                let onTouch: () -> Void = midget.onTouch
                
                if isVisible {
                    visibleMidgets.append(MidgetInfo(identifier: id, isVisible: isVisible, view: view, onTouch: onTouch))
                } else {
                    invisibleMidgets.append(MidgetInfo(identifier: id, isVisible: isVisible, view: view, onTouch: onTouch))
                }
            }
            
            self.visibleMidgets = visibleMidgets
            self.invisibleMidgets = invisibleMidgets
            self.description = description
            self.onChanged = onChanged
            
        }
        
        func toggleVisibility(of midget: MidgetInfo?) {
            guard let midget = midget else { return }
            // turn into invisible
            if visibleMidgets.contains(midget) {
                guard let index = visibleMidgets.firstIndex(of: midget) else { return }
                visibleMidgets.remove(at: index)
                invisibleMidgets.append(midget)
                
            }
            // turn into visible
            else if invisibleMidgets.contains(midget) {
                guard let index = invisibleMidgets.firstIndex(of: midget) else { return }
                invisibleMidgets.remove(at: index)
                visibleMidgets.insert(midget, at: visibleMidgets.startIndex)
            }
        }
        
        func complete() {
            let visiblemidgetState: [MidgetState] = visibleMidgets.map { MidgetState($0.identifier, true) }
            let invisiblemidgetState: [MidgetState] = invisibleMidgets.map { MidgetState($0.identifier, false) }
            
            let midgetState: [MidgetState] = visiblemidgetState + invisiblemidgetState
            onChanged(midgetState)
        }
        
        func updateFrame(of midget: MidgetInfo, into frame: CGRect) {
            guard let index = self.visibleMidgets.firstIndex(of: midget) else { return }
            self.visibleMidgets[index].frame = frame
        }
        
        func detectCollision(using frame: CGRect, of midget: MidgetInfo) {
            guard let index = self.visibleMidgets.firstIndex(of: midget) else { return }
            let pre: MidgetInfo? = self.visibleMidgets[safe: index - 1]
            let post: MidgetInfo? = self.visibleMidgets[safe: index + 1]
            guard let preIndex = self.visibleMidgets.firstIndex(of: pre ?? midget) else { return }
            guard let postIndex = self.visibleMidgets.firstIndex(of: post ?? midget) else { return }
            
            withAnimation(.easeInOut(duration: 0.33)) {
                if frame.midY < pre?.frame?.midY ?? .zero {
                    self.visibleMidgets.move(fromOffsets: [index], toOffset: preIndex)
                    self.hasMoved.toggle()
                } else if frame.midY > post?.frame?.midY ?? .infinity {
                    self.visibleMidgets.move(fromOffsets: [index], toOffset: postIndex + 1)
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
            guard let selectedMidget = self.selectedMidget else { return }            
            var currentIndex = self.visibleMidgets.firstIndex(of: selectedMidget) ?? 0
            
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { Timer in
                // check valid index of showingmidgets.
                if  self.scrollState != .normal && self.visibleMidgets.startIndex..<self.visibleMidgets.endIndex ~= currentIndex {
                    let destination = self.visibleMidgets[currentIndex].identifier
                    withAnimation{
                        self.scrollProxy?.scrollTo(destination)
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

