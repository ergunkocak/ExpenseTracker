//
//  Config.swift
//  ExpenseTracker
//
//  Created by Ergün on 29.03.20.
//  Copyright © 2020 ergunkocak. All rights reserved.
//

import Foundation

class Config {
    
    class Database {
        let versionLatest: Int = 1
        
        var versionCurrent: Int {
            get {
                return UserDefaults.standard.integer(forKey: "database_version")
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "database_version")
                UserDefaults.standard.synchronize()
            }
        }

    }
    
    
}
