import SwiftUI

extension View {
    public func wiggle() -> some View {
        return modifier(WiggleModifier())
    }
}

struct WiggleModifier: ViewModifier {
    @State private var isWiggling = false

    private static func randomize(interval: TimeInterval, withVariance variance: Double) -> TimeInterval {
       let random = (Double(arc4random_uniform(1000)) - 500.0) / 500.0
       return interval + variance * random
    }

    private let rotateAnimation = Animation
       .easeInOut(
           duration: WiggleModifier.randomize(
               interval: 0.14,
               withVariance: 0.025
           )
       )
       .repeatForever(autoreverses: true)

    private let bounceAnimation = Animation
       .easeInOut(
           duration: WiggleModifier.randomize(
               interval: 0.18,
               withVariance: 0.025
           )
       )
       .repeatForever(autoreverses: true)

    func body(content: Content) -> some View {
        content
        .rotationEffect(.degrees(isWiggling ? 1.0 : -1.0))
        .animation(rotateAnimation, value: isWiggling)
        .offset(x: 0, y: isWiggling ? 1.0 : -1.0)
        .animation(bounceAnimation, value: isWiggling)
        .onAppear() {
             isWiggling.toggle()
        }
    }
}
