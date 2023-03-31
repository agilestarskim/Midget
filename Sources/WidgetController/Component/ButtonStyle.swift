import SwiftUI

extension View {
    public func widgetButtonStyle(padding: Int) -> some View {
        modifier(WidgetButtonStyle(padding: padding))
    }
}

struct WidgetButtonStyle: ViewModifier {
    let padding: Int
    func body(content: Content) -> some View {
        content
            .font(.system(size: 17, weight: .bold))
            .padding(.horizontal, CGFloat(padding))
            .padding(.vertical, 5)
            .foregroundColor(Color.primary.opacity(0.8))
            .background(Capsule().fill(.ultraThickMaterial))
    }
}


