import SwiftUI

public struct Widget {
    let view: AnyView
    let id: String
    
    public init(view: AnyView, id: String) {
        self.view = view
        self.id = id
    }
    
}
