import SwiftUI

struct WidgetSheetView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: WidgetController.ViewModel
    
    var body: some View {
        ScrollView {
            ForEach(0..<vm.hiddenWidgets.count, id: \.self){ index in
                vm.hiddenWidgets[index].view
                .shadow(radius: 10, x: 10, y: 10)
                .padding()
                .onTapGesture {
                    withAnimation{
                        vm.showingWidgets.append(vm.hiddenWidgets[index])
                        vm.hiddenWidgets.remove(at: index)
                        dismiss()
                    }
                }
            }
        }
    }
}
