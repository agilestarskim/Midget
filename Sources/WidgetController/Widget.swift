import SwiftUI

public struct Widget: Equatable, Hashable, Identifiable{
    
    let view: AnyView
    public let id: String
    
    public init(view: AnyView, id: String) {
        self.view = view
        self.id = id
    }
    
    public static func == (lhs: Widget, rhs: Widget) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
    
}

