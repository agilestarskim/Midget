import SwiftUI

struct WidgetView: View {
    
    @ObservedObject var vm: WidgetController.ViewModel
    let index: Int
    let geo: GeometryProxy
    @State private var isWiggle = true
    @Binding var showingRemoveAlert: Bool
    let longPress = LongPressGesture().onEnded { _ in  }
    let drag = DragGesture().onChanged { _ in }.onEnded{_ in }
    
    
    var body: some View {
        vm.showingWidgets[index]?.view
            .editable{
                vm.index = index
                showingRemoveAlert = true
            }
            .wiggle(isOn: isWiggle)
            .transition(.scale)
            .gesture(longPress.sequenced(before: drag))
    }
}

