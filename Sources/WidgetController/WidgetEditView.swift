import SwiftUI

struct WidgetEditView: View {
    @EnvironmentObject var vm: WidgetController.ViewModel
    var body: some View {
        ScrollViewReader { value in
            VStack{
                HStack {
                    Button{
                        vm.showingAddSheet = true
                    } label: {
                        Text("+")
                            .widgetButtonStyle(padding: 25)
                    }

                    Spacer()

                    Button{
                        vm.complete()
                        vm.isEditMode = false
                    } label: {
                        Text(vm.description.done)
                            .widgetButtonStyle(padding: 20)
                    }

                }
                .padding(.horizontal)
                
                ForEach(vm.widgetInfos.filter {$0.isVisible}, id: \.identifier){ widget in
                    widget.view
                        .editable {
                            vm.selectedWidget = widget
                            vm.showingRemoveAlert = true
                        }
                        .wiggle()
                        .padding()
                }

            }
        }
        .alert(vm.description.alertTitle, isPresented: $vm.showingRemoveAlert) {
            Button(vm.description.alertCancel, role: .cancel){
                vm.selectedWidget = nil
            }
            Button(vm.description.alertRemove, role: .destructive){
                withAnimation {
                    vm.toggleIsVisible(vm.selectedWidget)
                }                
                vm.selectedWidget = nil
            }
        } message: {
            Text(vm.description.alertMessage)
        }
        .sheet(isPresented: $vm.showingAddSheet) {
            HalfSheet {
                WidgetAddView()
            }
        }
    }
}

