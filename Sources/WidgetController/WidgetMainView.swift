import SwiftUI

struct WidgetMainView: View {
    @EnvironmentObject var vm: WidgetController.ViewModel
    let widgetDescription: WidgetDescription
    let scrollDestination: UUID = UUID()
    var body: some View {
        ScrollViewReader{ value in
            VStack {
                Color.clear.id(scrollDestination)
                
                ForEach(vm.widgetInfos.filter {$0.isVisible}, id: \.identifier) { widget in
                    widget.view
                        .padding()
                }
                
                Button(widgetDescription.edit) {
                    withAnimation{
                        value.scrollTo(scrollDestination)
                    }
                    vm.isEditMode = true
                }.widgetButtonStyle(padding: 15)
            }
        }
    }
}
