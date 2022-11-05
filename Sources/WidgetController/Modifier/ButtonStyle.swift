//
//  ButtonModifier.swift
//  ViewBuilderTest
//
//  Created by 김민성 on 2022/11/05.
//

import SwiftUI

extension View {
    func widgetButtonStyle() -> some View {
        modifier(WidgetButtonStyle())
    }
    
    func widgetTextStyle(padding: Int) -> some View {
        modifier(WidgetTextStyle(padding: padding))
    }
}

struct WidgetButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.primary)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            
    }
}

struct WidgetTextStyle: ViewModifier {
    let padding: Int
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, CGFloat(padding))
            .padding(.vertical, 5)
            .foregroundColor(Color.primary.opacity(0.7))
            .background(Capsule().fill(Color.secondary.opacity(0.7)))
    }
}


