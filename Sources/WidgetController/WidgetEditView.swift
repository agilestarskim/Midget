import SwiftUI

struct WidgetEditView: View {
    @EnvironmentObject var vm: WidgetController.ViewModel
    let widgetDescription: WidgetDescription
    
    
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
                        vm.isEditMode = false
                    } label: {
                        Text(widgetDescription.done)
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
        .alert(widgetDescription.alertTitle, isPresented: $vm.showingRemoveAlert) {
            Button(widgetDescription.alertCancel, role: .cancel){
                vm.selectedWidget = nil
            }
            Button(widgetDescription.alertRemove, role: .destructive){
                withAnimation {
                    vm.toggleIsVisible(vm.selectedWidget)
                }                
                vm.selectedWidget = nil
            }
        } message: {
            Text(widgetDescription.alertMessage)
        }
        .sheet(isPresented: $vm.showingAddSheet) {
            HalfSheet {
                WidgetAddView()
            }
        }
    }
}

