import SwiftUI

struct WidgetAddView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm: WidgetController.ViewModel
    
    var body: some View {
        ScrollView {
            ForEach(vm.invisibleWidgets, id: \.identifier){ widget in
                widget.view
                .shadow(radius: 10, x: 10, y: 10)
                .padding()
                .onTapGesture {
                    withAnimation{
                        vm.toggleVisibility(of: widget)                        
                        dismiss()
                    }
                }
            }
        }
    }
}
