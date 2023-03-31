//
//  EquatableProxy.swift
//  
//
//  Created by 김민성 on 2023/03/31.
//

import SwiftUI

extension GeometryProxy: Equatable {
    public static func == (lhs: GeometryProxy, rhs: GeometryProxy) -> Bool {
        return lhs.size == rhs.size &&
        lhs.frame(in: .global).midX == rhs.frame(in: .global).midX &&
        lhs.frame(in: .global).midY == rhs.frame(in: .global).midY
    }
}
