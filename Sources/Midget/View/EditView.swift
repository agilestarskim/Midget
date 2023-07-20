import SwiftUI

struct EditView: View {
    @EnvironmentObject var vm: MidgetController.ViewModel
    
    var body: some View {

        ScrollViewReader { value in
            VStack{
                HStack {
                    Button("+"){
                        vm.showingAddSheet = true
                    }.buttonStyle(MidgetButtonStyle())

                    Spacer()

                    Button(vm.description.done){
                        vm.complete()
                        vm.isEditMode = false
                    }.buttonStyle(MidgetButtonStyle())

                }
                .padding(.horizontal)
                
                
                ForEach(vm.visibleMidgets, id: \.identifier){ midget in
                    MidgetView(midget: midget)
                }                
            }
            .onAppear { vm.scrollProxy = value }
            .coordinateSpace(name: "scrollSpace")
        }
        .alert(vm.description.alertTitle, isPresented: $vm.showingRemoveAlert) {
            Button(vm.description.alertCancel, role: .cancel){
                vm.selectedMidget = nil
            }
            Button(vm.description.alertRemove, role: .destructive){
                withAnimation {
                    vm.toggleVisibility(of: vm.selectedMidget)
                }                
                vm.selectedMidget = nil
            }
        } message: {
            Text(vm.description.alertMessage)
        }
        .sheet(isPresented: $vm.showingAddSheet) {
            HalfSheet {
                AddView()
            }
        }
//        .onPreferenceChange(GeometryPreferenceKey.self) { value in
//            guard let value = value else { return }
//            print(value.frame(in: .global))
//        }
    }
}

