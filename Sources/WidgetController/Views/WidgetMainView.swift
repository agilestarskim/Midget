import SwiftUI

struct WidgetMainView: View {
    @ObservedObject var vm: WidgetController.ViewModel
    @Binding var isEditMode: Bool
    var body: some View {
        ScrollViewReader{ value in
            VStack{
                ForEach(0 ..< vm.showingWidgets.count, id: \.self) { index in
                    vm.showingWidgets[index]?.view
                        .padding()
                }
                Button("편집") {
                    withAnimation{
                        value.scrollTo(0)
                    }
                    isEditMode = true
                }.widgetButtonStyle(padding: 15)
            }
        }
    }
}
