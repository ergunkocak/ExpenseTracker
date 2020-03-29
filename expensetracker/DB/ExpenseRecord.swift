//
//  AccountRecord.swift
//  ExpenseTracker
//
//  Created by Ergün on 29.03.20.
//  Copyright © 2020 ergunkocak. All rights reserved.
//

import GRDB

// A plain Player struct
struct ExpenseRecord {
    // Prefer Int64 for auto-incremented database ids
    var id: Int64?
    var accountId: Int64
    var expenseCategoryId: Int64?
    var incomeCategoryId: Int64?
    var amount: Int64
    var createdTS: TimeInterval?
}

// Hashable conformance supports tableView diffing
extension ExpenseRecord: Hashable { }

// MARK: - Persistence
// Turn Player into a Codable Record.
// See https://github.com/groue/GRDB.swift/blob/master/README.md#records
extension ExpenseRecord: Codable, FetchableRecord, MutablePersistableRecord {
    
    static var databaseTableName: String = "Expense"

    // Define database columns from CodingKeys
    private enum Columns {
        static let id = Column(CodingKeys.id)
        static let accountId = Column(CodingKeys.accountId)
        static let expenseCategoryId = Column(CodingKeys.expenseCategoryId)
        static let incomeCategoryId = Column(CodingKeys.incomeCategoryId)
        static let amount = Column(CodingKeys.amount)
        static let createdTS = Column(CodingKeys.createdTS)
    }
    
    // Update a player id after it has been inserted in the database.
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
        createdTS = Date().timeIntervalSince1970
    }
}
