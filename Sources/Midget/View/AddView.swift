import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm: MidgetController.ViewModel
    
    var body: some View {
        ScrollView {
            ForEach(vm.invisibleMidgets, id: \.identifier){ midget in
                midget.view
                .shadow(radius: 10, x: 10, y: 10)
                .padding()
                .onTapGesture {
                    withAnimation{
                        vm.toggleVisibility(of: midget)
                        dismiss()
                    }
                }
            }
        }
    }
}
