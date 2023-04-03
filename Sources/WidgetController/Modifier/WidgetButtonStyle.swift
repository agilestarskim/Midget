import SwiftUI

struct WidgetButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 70, height: 35)
            .font(.system(size: 17, weight: .bold))
            .minimumScaleFactor(0.001)
            .background(Capsule().fill(.ultraThinMaterial))
    }
}
