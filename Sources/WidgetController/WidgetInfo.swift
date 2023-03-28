//
//  File.swift
//  
//
//  Created by 김민성 on 2023/03/28.
//

import SwiftUI

struct WidgetInfo: Equatable {
    static func == (lhs: WidgetInfo, rhs: WidgetInfo) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    let identifier: String
    var isVisible: Bool
    var frame: CGRect
    var view: AnyView
}
