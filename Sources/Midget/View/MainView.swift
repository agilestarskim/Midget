import SwiftUI

struct MainView: View {
    @EnvironmentObject var vm: MidgetController.ViewModel
    let scrollDestination: UUID = UUID()
    var body: some View {
        ScrollViewReader{ value in
            VStack {
                Color.clear.id(scrollDestination)
                
                ForEach(vm.visibleMidgets, id: \.identifier) { midget in
                    midget.view
                        .padding()
                        .onTapGesture {
                            midget.onTouch()
                        }
                }
                
                Button(vm.description.edit) {
                    withAnimation{
                        value.scrollTo(scrollDestination)
                    }
                    vm.isEditMode = true
                }.buttonStyle(MidgetButtonStyle())
            }
        }
    }
}
