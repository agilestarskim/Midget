import SwiftUI

extension Array where Element == WidgetState {
    public func encode() -> [String] {
        
        return self.map({ e -> String in
            return "\(e.id),\(e.isVisible)"
        })
    }
}

extension Array where Element == String {
    public func decode() -> [WidgetState] {
        return self.map({ e -> (id: String, isVisible: Bool) in
            let component = e.components(separatedBy: ",")
            return (id: component.first!, isVisible: Bool(component.last!)!)
        })
    }
}
