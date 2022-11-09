import SwiftUI

extension View {
    public func glassBackground(padding: Int = 0) -> some View {
        modifier(GlassBackground(padding: padding))
    }
}

public struct GlassBackground: ViewModifier {
    let padding: CGFloat
    init(padding: Int) {
        self.padding = CGFloat(padding)
    }
    public func body(content: Content) -> some View {
        content
            .padding(padding)
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

