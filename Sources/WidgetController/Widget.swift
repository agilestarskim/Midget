import SwiftUI

/**
 This is view holder with user's custom view and ID.
 
    - Parameter :
        - view: user's custom view covered AnyView
        - id: view's id that can track view. duplicate is prohibited.
 */
public struct Widget: Equatable, Hashable, Identifiable{
    /// user's custom view.
    let view: AnyView
    /// view's ID 
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

