//
//  AccountRecord.swift
//  ExpenseTracker
//
//  Created by Ergün on 29.03.20.
//  Copyright © 2020 ergunkocak. All rights reserved.
//

import GRDB

// A plain Player struct
struct IncomeCategoryRecord {
    // Prefer Int64 for auto-incremented database ids
    var id: Int64?
    var name: String
}

// Hashable conformance supports tableView diffing
extension IncomeCategoryRecord: Hashable { }

// MARK: - Persistence
// Turn Player into a Codable Record.
// See https://github.com/groue/GRDB.swift/blob/master/README.md#records
extension IncomeCategoryRecord: Codable, FetchableRecord, MutablePersistableRecord {
    
    static var databaseTableName: String = "IncomeCategory"

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
