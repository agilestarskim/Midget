//
//  SelectionView.swift
//  ViewBuilderTest
//
//  Created by 김민성 on 2022/11/05.
//

import SwiftUI

struct SelectionView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var inputViews: [AnyView?]
    @Binding var selectionViews: [AnyView]
    
    var body: some View {
        ScrollView {
            ForEach(0..<selectionViews.count, id: \.self){ index in
                selectionViews[index]
                    .shadow(radius: 10, x: 10, y: 10)
                    .padding()
                    .onTapGesture {
                        withAnimation{
                            if let foundIndex = inputViews.firstIndex(where: {$0 == nil}) {
                                inputViews[foundIndex] = selectionViews[index]
                            }
                            selectionViews.remove(at: index)
                            dismiss()
                        }
                    }
            }
        }
    }
}
