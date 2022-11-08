//
//  SelectionView.swift
//  ViewBuilderTest
//
//  Created by 김민성 on 2022/11/05.
//

import SwiftUI

struct WidgetSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showingWidgets: [Widget?]
    @Binding var hiddenWidgets: [Widget]
    
    var body: some View {
        ScrollView {
            ForEach(0..<hiddenWidgets.count, id: \.self){ index in
                hiddenWidgets[index].view
                .shadow(radius: 10, x: 10, y: 10)
                .padding()
                .onTapGesture {
                    withAnimation{
                        if let foundIndex = showingWidgets.firstIndex(where: {$0 == nil}) {
                            showingWidgets[foundIndex] = hiddenWidgets[index]
                        }else {
                            showingWidgets.append(hiddenWidgets[index])
                        }
                        hiddenWidgets.remove(at: index)
                        dismiss()
                    }
                }
            }
        }
    }
}
