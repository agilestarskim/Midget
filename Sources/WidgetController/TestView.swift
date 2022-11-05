//
//  SwiftUIView.swift
//  
//
//  Created by 김민성 on 2022/11/05.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        NavigationView {
            WidgetController {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.red)
                    .frame(height: 200)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(.orange)
                    .frame(height: 200)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(.green)
                    .frame(height: 200)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(.indigo)
                    .frame(height: 200)
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
