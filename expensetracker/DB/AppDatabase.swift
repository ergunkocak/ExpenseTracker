//
//  AppDatabase.swift
//  ExpenseTracker
//
//  Created by Ergün on 29.03.20.
//  Copyright © 2020 ergunkocak. All rights reserved.
//

import RxSwift
import GRDB
import RxGRDB

/// A type responsible for initializing the application database.
///
/// See AppDelegate.setupDatabase()
struct AppDatabase {
    
    /// Creates a fully initialized database at path
    static func openDatabase(atPath path: String) throws -> DatabaseQueue {
        // Connect to the database
        // See https://github.com/groue/GRDB.swift/blob/master/README.md#database-connections
        let dbQueue = try DatabaseQueue(path: path)
        
        debugPrint("DB Path: \(path)")
        
        // Define the database schema
        try migrator.migrate(dbQueue)
        
        return dbQueue
    }
    
    /// The DatabaseMigrator that defines the database schema.
    ///
    /// See https://github.com/groue/GRDB.swift/blob/master/README.md#migrations
    static var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("v0_Account") { db in
            // Create a table
            try db.create(table: AccountRecord.databaseTableName) { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("name", .text).notNull()
            }
            // Populate inital data
            let records: [String] = ["Cash", "Credit Card", "Back account"]
            try records.forEach({ (name) in
                var record = AccountRecord(id: nil, name: name)
                try record.insert(db)
            })
        }
        
        migrator.registerMigration("v0_IncomeCategory") { db in
            // Create a table
            try db.create(table: IncomeCategoryRecord.databaseTableName) { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("name", .text).notNull()
            }
            // Populate inital data
            let records: [String] = ["Salary", "Dividents"]
            try records.forEach({ (name) in
                var record = IncomeCategoryRecord(id: nil, name: name)
                try record.insert(db)
            })
        }
        
        migrator.registerMigration("v0_ExpenseCategory") { db in
            // Create a table
            try db.create(table: ExpenseCategoryRecord.databaseTableName) { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("name", .text).notNull()
            }
            // Populate inital data
            let records: [String] = ["Tax", "Grocery", "Entertainment", "Gym", "Health"]
            try records.forEach({ (name) in
                var record = ExpenseCategoryRecord(id: nil, name: name)
                try record.insert(db)
            })
        }
        
        migrator.registerMigration("v0_Expense") { db in
            // Create a table
            try db.create(table: ExpenseRecord.databaseTableName) { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("accountId", .integer).notNull()
                t.column("expenseCategoryId", .integer)
                t.column("incomeCategoryId", .integer)
                t.column("amount", .integer).notNull()
                t.column("createdTS", .integer)
            }
        }

//        // Migrations for future application versions will be inserted here:
//        migrator.registerMigration(...) { db in
//            ...
//        }
        
        return migrator
    }
    
    static func loadAccountsRx() -> Observable<[AccountRecord]> {
        return AccountRecord
            .all()
            .rx
            .observeAll(in: dbQueue)
    }
    
    static func loadIncomeCategoriesRx() -> Observable<[IncomeCategoryRecord]> {
        return IncomeCategoryRecord
            .all()
            .rx
            .observeAll(in: dbQueue)
    }
    
    static func loadExpenseCategoriesRx() -> Observable<[ExpenseCategoryRecord]> {
        return ExpenseCategoryRecord
            .all()
            .rx
            .observeAll(in: dbQueue)
    }

}
