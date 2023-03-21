import SwiftUI


typealias IdentifiableView = View & Equatable

/// Identifiable View
///
/// A non-redundant key that can recognize the view is passed to the constructor factor and the view is passed to the trailing closure.
///
///         Widget(identifier: "viewA") {
///             VStack {
///                 Text("This is a Test Label")
///             }
///         }
///
public struct Widget: IdentifiableView {
    
    public let identifier: String
    public let content: AnyView
    public let onTouch: () -> Void
    
    ///  - Parameters:
    ///     - identefier: string key to distinguish views
    public init(_ identifier: String,
                @ViewBuilder content: () -> some View,
                onTouch: @escaping () -> Void = {}
    ){
        self.identifier = identifier
        self.content = AnyView(content().frame(maxWidth: .infinity))
        self.onTouch = onTouch
    }
    
    public var body: some View {
        content
    }
    
    public static func == (lhs: Widget, rhs: Widget) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
