//
//  AccountRecord.swift
//  ExpenseTracker
//
//  Created by Ergün on 29.03.20.
//  Copyright © 2020 ergunkocak. All rights reserved.
//

import GRDB

// A plain Player struct
struct AccountRecord {
    
    typealias ID = Int64
    
    // Prefer Int64 for auto-incremented database ids
    var id: ID?
    var name: String
}

// Hashable conformance supports tableView diffing
extension AccountRecord: Hashable { }

// MARK: - Persistence
// Turn Player into a Codable Record.
// See https://github.com/groue/GRDB.swift/blob/master/README.md#records
extension AccountRecord: Codable, FetchableRecord, MutablePersistableRecord {
    
    static var databaseTableName: String = "Account"

    // Define database columns from CodingKeys
    private enum Columns {
        static let id = Column(CodingKeys.id)
        static let name = Column(CodingKeys.name)
    }
    
    // Update a player id after it has been inserted in the database.
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}
