//
//  WidgetState.swift
//  
//
//  Created by 김민성 on 2023/03/28.
//

import Foundation

public struct MidgetState: Equatable {
    public let id: String
    public let isVisible: Bool
    
    public init(_ id: String, _ isVisible: Bool) {
        self.id = id
        self.isVisible = isVisible
    }
}
