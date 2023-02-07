//
//  File.swift
//  
//
//  Created by 김민성 on 2023/02/06.
//

import Foundation


public class WidgetState {
    var stateList: [(String, Bool)] {
        didSet {
            saveWidgetStateToUserDefaults(stateList)
        }
    }
    let saveKey: String
    
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
