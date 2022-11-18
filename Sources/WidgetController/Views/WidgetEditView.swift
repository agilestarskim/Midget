import SwiftUI


struct WidgetEditView: View {
    @ObservedObject var vm: WidgetController.ViewModel
    let changeCompletion: ([(String, Bool)]) -> Void
    
    @Binding var isEditMode: Bool
    @State private var showingAddSheet = false
 
    var body: some View {
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
                    complete()
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
        .alert("위젯을 제거하시겠습니까?", isPresented: $vm.showingRemoveAlert) {
            Button("취소", role: .cancel){}
            Button("삭제", role: .destructive){withAnimation{remove()}}
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
    func remove() {
        guard let widget = vm.showingWidgets[vm.index] else { return }
        vm.hiddenWidgets.append(widget)
        vm.showingWidgets[vm.index] = nil
    }
    
    func complete() {
        var showingTuples: [(String, Bool)] = []
        var hiddenTuples: [(String, Bool)] = []
        for sw in vm.showingWidgets {
            if let sw = sw {
                showingTuples.append((sw.id,  true))
            }
        }
        for hw in vm.hiddenWidgets {
            hiddenTuples.append((hw.id, false))
        }
        
        changeCompletion(showingTuples + hiddenTuples)
        
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

