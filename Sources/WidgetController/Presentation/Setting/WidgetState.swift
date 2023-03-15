//
//  File.swift
//  
//
//  Created by 김민성 on 2023/02/06.
//

import Foundation

/// Objects for storing and managing the state of widgets
///
/// The widget's identifier and key must match.
/// Bool value that determines whether to show the widget or not based on the key
///
///     @State private var widgetState = WidgetState(
///         [
///             ("viewA", true),
///             ("viewB", true),
///             ("viewC", true),
///             ("viewD", true),
///             ("viewE", true)
///         ]
///     )
///
public struct WidgetState: Equatable {
    public static func == (lhs: WidgetState, rhs: WidgetState) -> Bool {
        let firstStringArray: [String] = lhs.stateList.map { $0.0 }
        let secondStringArray: [String] = rhs.stateList.map { $0.0 }
        return firstStringArray == secondStringArray
    }
    
    var stateList: [(String, Bool)] {
        didSet {
            saveWidgetStateToUserDefaults(stateList)
        }
    }
    
    let saveKey: String
    
    ///  - Parameters:
    ///     - defaultWidgetState: The tuple array has a key that matches the widget's identifier and a bool value that determines whether to show the widget or not.
    ///     - saveKey: Key string to store the statelist in userDefault
    public init(_ defaultWidgetState: [(String, Bool)], saveKey: String = "widgetStateSaveKey") {
        self.saveKey = saveKey
        let stringDataFromDB = UserDefaults.standard.array(forKey: saveKey) as? [String] ?? []
        if stringDataFromDB.isEmpty {
            self.stateList = defaultWidgetState
        } else {
            self.stateList = stringDataFromDB.decode()
        }
        
    }
    
    func saveWidgetStateToUserDefaults(_ stateList: [(String, Bool)]) {
        UserDefaults.standard.set(stateList.encode(), forKey: self.saveKey)
    }
    
}
