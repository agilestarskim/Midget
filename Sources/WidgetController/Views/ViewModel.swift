import SwiftUI

extension WidgetController {
    class ViewModel: ObservableObject {
        @Published var showingWidgets: [Widget?] = []
        @Published var hiddenWidgets: [Widget] = []
        @Published var index: Int = 0
    }
}
