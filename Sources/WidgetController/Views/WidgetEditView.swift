import SwiftUI


struct WidgetEditView: View {
    @ObservedObject var vm: WidgetController.ViewModel
    let changeCompletion: ([(String, Bool)]) -> Void
    
    @Binding var isEditMode: Bool
    @State private var showingAddSheet = false
 
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
                        Text("완료")
                            .widgetButtonStyle(padding: 20)
                    }
                    
                }
                .padding(.horizontal)
                
                ForEach(0..<vm.showingWidgets.count, id: \.self){ index in
                    if (vm.showingWidgets[index] != nil) {
                        WidgetView(vm: vm, index: index)
                            .padding()
                            .transition(.scale)
                    }
                }
                   
                
                
            }
            .coordinateSpace(name: "editView")
            .onAppear {
                vm.scrollViewProxy = value
                
            }
        }
        .alert("위젯을 제거하시겠습니까?", isPresented: $vm.showingRemoveAlert) {
            Button("취소", role: .cancel){ vm.setIndexForRemove(index: -1)}
            Button("삭제", role: .destructive){withAnimation{vm.remove()}}
        } message: {
            Text("이 위젯을 제거해도 데이터가 삭제되지 않습니다.")
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

