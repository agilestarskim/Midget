//
//  WidgetState.swift
//  
//
//  Created by 김민성 on 2023/03/28.
//

import Foundation

public struct WidgetState: Equatable {
    let id: String
    let isVisible: Bool
    
    public init(_ id: String, _ isVisible: Bool) {
        self.id = id
        self.isVisible = isVisible
    }
}
