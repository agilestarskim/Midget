//
//  File.swift
//  
//
//  Created by 김민성 on 2023/03/28.
//

import SwiftUI

extension WidgetController {
    final class ViewModel: ObservableObject {
        
        @Published var widgetInfos: [WidgetInfo]
        @Published var isEditMode: Bool = false
        @Published var showingAddSheet = false
        @Published var showingRemoveAlert = false
        
        var selectedWidget: WidgetInfo? = nil
        
        init(widgetStates: [WidgetState], widgets: [Widget]) {
            // 위젯스테이트와 위젯의 갯수와 아이디가 일치한다고 가정
            // 일치하지 않으면? 사용자의 책임. migration을 확실히 해야함.
            
            var widgetInfos: [WidgetInfo] = []
            
            for widgetState in widgetStates {
                
                guard let widget = widgets.first(where: { widget in
                    widget.identifier == widgetState.id
                }) else { fatalError("no match identifier") }
                
                let id: String = widgetState.id
                let isVisible: Bool = widgetState.isVisible
                let position: CGRect = CGRect()
                let view: AnyView = widget.content
                
                widgetInfos.append(WidgetInfo(identifier: id, isVisible: isVisible, frame: position, view: view))
            }
            
            self.widgetInfos = widgetInfos
        }
        
        func toggleIsVisible(_ widget: WidgetInfo?) {
            guard let index = self.widgetInfos.firstIndex(where: { widgetInfo in
                widgetInfo == widget
            }) else { return }
            widgetInfos[index].isVisible.toggle()
        }
    }
}

