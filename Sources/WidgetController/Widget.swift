import SwiftUI

public struct Widget: Equatable{
    
    public static func == (lhs: Widget, rhs: Widget) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    let view: AnyView
    let id: String
    
    public init(view: AnyView, id: String) {
        self.view = view
        self.id = id
    }
}

