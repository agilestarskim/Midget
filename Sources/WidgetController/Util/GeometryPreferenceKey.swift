import SwiftUI

struct GeometryPreferenceKey: PreferenceKey {
    static var defaultValue: GeometryProxy? = nil
    static func reduce(value: inout GeometryProxy?, nextValue: () -> GeometryProxy?) {
        value = nextValue()
    }
}
