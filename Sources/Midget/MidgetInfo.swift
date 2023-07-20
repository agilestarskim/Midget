//
//  File.swift
//  
//
//  Created by 김민성 on 2023/03/28.
//

import SwiftUI

struct MidgetInfo: Equatable {
    static func == (lhs: MidgetInfo, rhs: MidgetInfo) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    let identifier: String
    var isVisible: Bool
    var view: AnyView
    var frame: CGRect?
    let onTouch: () -> Void
    
    
    init(identifier: String, isVisible: Bool, view: AnyView, frame: CGRect? = nil, onTouch: @escaping () -> Void) {
        self.identifier = identifier
        self.isVisible = isVisible
        self.view = view
        self.frame = frame
        self.onTouch = onTouch        
    }
}
