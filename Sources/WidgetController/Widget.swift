//
//  File.swift
//  
//
//  Created by 김민성 on 2022/11/08.
//

import SwiftUI

public struct Widget{
    let view: AnyView
    let id: String
    
    
    public init(view: AnyView, id: String) {
        self.view = AnyView(view.glassBackground())
        self.id = id
    }
    
}
