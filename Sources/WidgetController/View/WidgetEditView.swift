import SwiftUI

struct WidgetEditView: View {
    @EnvironmentObject var vm: WidgetController.ViewModel
    
    var body: some View {

        ScrollViewReader { value in
            VStack{
                HStack {
                    Button("+"){
                        vm.showingAddSheet = true
                    }.buttonStyle(WidgetButtonStyle())

                    Spacer()

                    Button(vm.description.done){
                        vm.complete()
                        vm.isEditMode = false
                    }.buttonStyle(WidgetButtonStyle())

                }
                .padding(.horizontal)
                
                
                ForEach(vm.visibleWidgets, id: \.identifier){ widget in                    
                    WidgetView(widget: widget)
                }                
            }
            .onAppear { vm.scrollProxy = value }
            .coordinateSpace(name: "scrollSpace")
        }
        .alert(vm.description.alertTitle, isPresented: $vm.showingRemoveAlert) {
            Button(vm.description.alertCancel, role: .cancel){
                vm.selectedWidget = nil
            }
            Button(vm.description.alertRemove, role: .destructive){
                withAnimation {
                    vm.toggleVisibility(of: vm.selectedWidget)
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
//        .onPreferenceChange(GeometryPreferenceKey.self) { value in
//            guard let value = value else { return }
//            print(value.frame(in: .global))
//        }
    }
}

