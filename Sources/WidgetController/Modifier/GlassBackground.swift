//
//  File.swift
//  
//
//  Created by 김민성 on 2022/11/06.
//

import SwiftUI

extension View {
    public func glassBackground() -> some View {
        modifier(GlassBackground())
    }
}

public struct GlassBackground: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .background(RoundedRectangle(cornerRadius: 15)
                .fill(.regularMaterial))
    }
}

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.red)
            .frame(height: 150)
            .padding()
            .glassBackground()
    }
}

