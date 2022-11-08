//
//  WidgetController.swift
//  ViewBuilderTest
//
//  Created by 김민성 on 2022/11/05.
//

import SwiftUI

public struct WidgetController: View {
    let data: [(String, Bool)]
    let widgets: [Widget]
    let changeCompletion: ([(String, Bool)]) -> Void
    @State var showingWidgets: [Widget?]
    @State var hiddenWidgets: [Widget]
    
    public init(
        data: [(String, Bool)],
        widgets: [Widget],
        changeCompletion: @escaping ([(String, Bool)]) -> Void
    ){
        
        self.data = data
        self.widgets = widgets
        self.changeCompletion = changeCompletion
        
        var showingView: [Widget] = []
        var hiddenView: [Widget] = []
        for view in data {
            for widget in widgets {
                if view.0 == widget.id {
                    if view.1 {
                        showingView.append(widget)
                    }else {
                        hiddenView.append(widget)
                    }
                    break
                }
            }
        }
        
        self._showingWidgets = State(initialValue: showingView)
        self._hiddenWidgets = State(initialValue: hiddenView)
    }
    
    
    

    public var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(0 ..< showingWidgets.count, id: \.self) { index in
                self.showingWidgets[index]?.view
                    .padding()
            }
            NavigationLink {
                WidgetEditView(showingWidgets: $showingWidgets, hiddenWidgets: $hiddenWidgets, changeCompletion: changeCompletion)
            } label: {
                Text("편집").widgetTextStyle(padding: 15)
            }

        }
    }
    
    
}

