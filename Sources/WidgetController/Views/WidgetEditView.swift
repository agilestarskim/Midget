//  ViewBuilderTest
//
//  Created by 김민성 on 2022/11/05.
//

import SwiftUI


struct WidgetEditView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingAddSheet = false
    @State private var showingRemoveAlert = false
    @State private var index = 0
    @Binding var showingWidgets: [Widget?]
    @Binding var hiddenWidgets: [Widget]
    let changeCompletion: ([(String, Bool)]) -> Void
    
    var body: some View {
        ScrollView(showsIndicators: false){
            ForEach(0..<showingWidgets.count, id: \.self){ index in
                if (showingWidgets[index] != nil) {
                    showingWidgets[index]?.view
                        .editable{
                            self.index = index
                            showingRemoveAlert = true
                        }
                        .wiggle()
                        .transition(.scale)
                }
            }
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading){
                Button{
                    showingAddSheet = true
                } label: {
                    Text("+")
                        .widgetTextStyle(padding: 25)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing){
                Button{
                    complete()
                    dismiss()
                } label: {
                    Text("완료")
                        .widgetTextStyle(padding: 20)
                }
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showingRemoveAlert) {
            Alert(title: Text("위젯을 제거하겠습니까?"),
                  message: Text("이 위젯을 제거해도 데이터가 삭제되지 않습니다."),
                  primaryButton: .destructive(Text("제거"), action: { withAnimation{ remove(index: index) } }),
                  secondaryButton: .cancel(Text("취소"))
            )
        }
        .modify{
            if #available(iOS 16.0, * ){
                $0.sheet(isPresented: $showingAddSheet){
                    WidgetSheetView(showingWidgets: $showingWidgets, hiddenWidgets: $hiddenWidgets)
                        .presentationDetents([.medium])
                }
            }else {
                $0.customBottomSheet(isPresented: $showingAddSheet){
                    WidgetSheetView(showingWidgets: $showingWidgets, hiddenWidgets: $hiddenWidgets)
                }
            }
        }
    }
    
    func remove(index: Int) {
        guard let widget = showingWidgets[index] else { return }
        hiddenWidgets.append(widget)
        showingWidgets[index] = nil
    }
    
    func complete() {
        var showingTuples: [(String, Bool)] = []
        var hiddenTuples: [(String, Bool)] = []
        for sw in showingWidgets {
            if let sw = sw {
                showingTuples.append((sw.id,  true))
            }
        }
        for hw in hiddenWidgets {
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

