import SwiftUI

/**
 This is view holder with user's custom view and ID.
 
    - Parameter :
        - view: user's custom view covered AnyView
        - id: view's id that can track view. duplicate is prohibited.
 */

public struct Widget: IdentifiableView {
    
    public let identifier: String
    public let content: AnyView
    
    public init(identifier: String, @ViewBuilder content: () -> some View){
        self.identifier = identifier
        self.content = AnyView(content())
    }
    
    public var body: some View {
        content
    }
    
    public static func == (lhs: Widget, rhs: Widget) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

public protocol IdentifiableView: View, Equatable {
    var identifier: String { get }
    var content: AnyView { get }
}
