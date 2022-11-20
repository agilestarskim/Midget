import SwiftUI

struct WidgetMainView: View {
    @ObservedObject var vm: WidgetController.ViewModel
    @Binding var isEditMode: Bool
    let widgetDescription: WidgetDescription
    let scrollDestination: UUID = UUID()
    var body: some View {
        ScrollViewReader{ value in
            VStack{
                Color.clear.id(scrollDestination)
                ForEach(vm.showingWidgets, id: \.self) { widget in
                    widget.view
                        .padding()
                }
                Button(widgetDescription.edit) {
                    withAnimation{
                        value.scrollTo(scrollDestination)
                    }
                    isEditMode = true
                }.widgetButtonStyle(padding: 15)
            }
        }
    }
}
