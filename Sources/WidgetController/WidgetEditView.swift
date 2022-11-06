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
    @Binding var showingViews: [AnyView?]
    @Binding var hiddenViews: [AnyView]
    
    var body: some View {
        ScrollView(showsIndicators: false){
            ForEach(0..<showingViews.count, id: \.self){ index in
                if (showingViews[index] != nil) {
                    showingViews[index]
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
                    WidgetSheetView(showingViews: $showingViews, hiddenViews: $hiddenViews)
                        .presentationDetents([.medium])
                }
            }else {
                $0.customBottomSheet(isPresented: $showingAddSheet){
                    WidgetSheetView(showingViews: $showingViews, hiddenViews: $hiddenViews)
                }
            }
        }
    }
    
    func remove(index: Int) {
        guard let view = showingViews[index] else { return }
        hiddenViews.append(view)
        showingViews[index] = nil
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

