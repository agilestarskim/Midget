//
//  WidgetController.swift
//  ViewBuilderTest
//
//  Created by 김민성 on 2022/11/05.
//

import SwiftUI

public struct WidgetController: View {
    @State var inputViews: [AnyView]
    @State var selectionViews: [AnyView] = []
    
    init<V0: View>(
        @ViewBuilder content: @escaping () -> V0
    ){
        inputViews = [AnyView(content())]
    }
    init<V0: View, V1: View>(
        @ViewBuilder content: @escaping () -> TupleView<(V0, V1)>
    ) {
        let cv = content().value
        inputViews = [AnyView(cv.0), AnyView(cv.1)]
    }

    init<V0: View, V1: View, V2: View>(
        @ViewBuilder content: @escaping () -> TupleView<(V0, V1, V2)>) {
        let cv = content().value
        inputViews = [AnyView(cv.0), AnyView(cv.1), AnyView(cv.2)]
    }

    init<V0: View, V1: View, V2: View, V3: View>(
        @ViewBuilder content: @escaping () -> TupleView<(V0, V1, V2, V3)>) {
        let cv = content().value
        inputViews = [AnyView(cv.0), AnyView(cv.1), AnyView(cv.2), AnyView(cv.3)]
    }
    
    init<V0: View, V1: View, V2: View, V3: View,V4: View>(
        @ViewBuilder content: @escaping () -> TupleView<(V0, V1, V2, V3, V4)>) {
        let cv = content().value
            inputViews = [AnyView(cv.0), AnyView(cv.1), AnyView(cv.2), AnyView(cv.3), AnyView(cv.4)]
    }
    
    init<V0: View, V1: View, V2: View, V3: View,V4: View, V5: View>(
        @ViewBuilder content: @escaping () -> TupleView<(V0, V1, V2, V3, V4, V5)>) {
        let cv = content().value
            inputViews = [AnyView(cv.0), AnyView(cv.1), AnyView(cv.2), AnyView(cv.3), AnyView(cv.4), AnyView(cv.5)]
    }
    
    init<V0: View, V1: View, V2: View, V3: View,V4: View, V5: View, V6: View>(
        @ViewBuilder content: @escaping () -> TupleView<(V0, V1, V2, V3, V4, V5, V6)>) {
        let cv = content().value
            inputViews = [AnyView(cv.0), AnyView(cv.1), AnyView(cv.2), AnyView(cv.3), AnyView(cv.4), AnyView(cv.5), AnyView(cv.6)]
    }
    
    init<V0: View, V1: View, V2: View, V3: View,V4: View, V5: View, V6: View, V7: View>(
        @ViewBuilder content: @escaping () -> TupleView<(V0, V1, V2, V3, V4, V5, V6, V7)>) {
        let cv = content().value
            inputViews = [AnyView(cv.0), AnyView(cv.1), AnyView(cv.2), AnyView(cv.3), AnyView(cv.4), AnyView(cv.5), AnyView(cv.6), AnyView(cv.7)]
    }
    
    init<V0: View, V1: View, V2: View, V3: View,V4: View, V5: View, V6: View, V7: View, V8: View>(
        @ViewBuilder content: @escaping () -> TupleView<(V0, V1, V2, V3, V4, V5, V6, V7, V8)>) {
        let cv = content().value
            inputViews = [AnyView(cv.0), AnyView(cv.1), AnyView(cv.2), AnyView(cv.3), AnyView(cv.4), AnyView(cv.5), AnyView(cv.6), AnyView(cv.7), AnyView(cv.8)]
    }
    
    init<V0: View, V1: View, V2: View, V3: View,V4: View, V5: View, V6: View, V7: View, V8: View, V9: View>(
        @ViewBuilder content: @escaping () -> TupleView<(V0, V1, V2, V3, V4, V5, V6, V7, V8, V9)>) {
        let cv = content().value
            inputViews = [AnyView(cv.0), AnyView(cv.1), AnyView(cv.2), AnyView(cv.3), AnyView(cv.4), AnyView(cv.5), AnyView(cv.6), AnyView(cv.7), AnyView(cv.8), AnyView(cv.9)]
    }

    public var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(0 ..< inputViews.count, id: \.self) { index in
                self.inputViews[index]
                    .padding()
            }
            NavigationLink {
                WidgetEditView(inputViews: $inputViews, selectionViews: $selectionViews)
            } label: {
                Text("편집").widgetTextStyle(padding: 15)
            }

        }
    }
}

