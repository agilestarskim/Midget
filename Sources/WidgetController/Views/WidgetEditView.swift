import SwiftUI


struct WidgetEditView: View {
    @ObservedObject var vm: WidgetController.ViewModel
    @Binding var isEditMode: Bool
    @State private var showingAddSheet = false
    let widgetDescription: WidgetDescription
    
    var body: some View {
        ScrollViewReader { value in
            VStack{
                HStack {
                    Button{
                        showingAddSheet = true
                    } label: {
                        Text("+")
                            .widgetButtonStyle(padding: 25)
                    }
                    
                    Spacer()
                    
                    Button{
                        vm.complete()
                        isEditMode = false
                    } label: {
                        Text(widgetDescription.done)
                            .widgetButtonStyle(padding: 20)
                    }
                    
                }
                .padding(.horizontal)
                
                ForEach(vm.showingWidgets){ widget in
                    WidgetView(vm: vm, widget: widget)
                        .padding()
                        .transition(.scale)
                }
            }
            .coordinateSpace(name: WidgetController.ViewModel.Coordinator.editView)
            .onAppear {
                vm.scrollViewProxy = value
                
            }
        }
        .alert(widgetDescription.alertTitle, isPresented: $vm.showingRemoveAlert) {
            Button(widgetDescription.alertCancel, role: .cancel){ vm.setIndexForRemove(index: -1)}
            Button(widgetDescription.alertRemove, role: .destructive){withAnimation{vm.remove()}}
        } message: {
            Text(widgetDescription.alertMessage)
        }
        .modify{
            if #available(iOS 16.0, * ){
                $0.sheet(isPresented: $showingAddSheet){
                    WidgetSheetView(vm: vm)
                        .presentationDetents([.medium])
                }
            }else {
                $0.customBottomSheet(isPresented: $showingAddSheet){
                    WidgetSheetView(vm: vm)
                }
            }
        }
        
        
    }

    
}

//version branch
extension View {
    @ViewBuilder
    func modify<Content: View>(@ViewBuilder _ transform: (Self) -> Content?) -> some View {
        if let view = transform(self), !(view is EmptyView) {
            view
        } else {
            self
        }
    }
}

