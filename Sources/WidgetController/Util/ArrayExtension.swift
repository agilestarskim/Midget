import SwiftUI

extension Array where Element == (String, Bool) {
    public func encode() -> [String] {
        
        return self.map({ e -> String in
            return "\(e.0),\(e.1)"
        })
    }
}

extension Array where Element == String {
    public func decode() -> [(String, Bool)] {
        return self.map({ e -> (String, Bool) in
            let component = e.components(separatedBy: ",")
            return (component.first!, Bool(component.last!)!)
        })
    }
}
