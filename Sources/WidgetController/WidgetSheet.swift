//
//  SelectionView.swift
//  ViewBuilderTest
//
//  Created by 김민성 on 2022/11/05.
//

import SwiftUI

struct WidgetSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showingViews: [AnyView?]
    @Binding var hiddenViews: [AnyView]
    
    var body: some View {
        ScrollView {
            ForEach(0..<hiddenViews.count, id: \.self){ index in
                hiddenViews[index]
                    .shadow(radius: 10, x: 10, y: 10)
                    .padding()
                    .onTapGesture {
                        withAnimation{
                            if let foundIndex = showingViews.firstIndex(where: {$0 == nil}) {
                                showingViews[foundIndex] = hiddenViews[index]
                            }else {
                                showingViews.append(hiddenViews[index])
                            }
                            hiddenViews.remove(at: index)
                            dismiss()
                        }
                    }
            }
        }
    }
}
