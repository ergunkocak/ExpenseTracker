//
//  ExpenseAddPresenter.swift
//  ExpenseTracker
//
//  Created by Ergün on 29.03.20.
//  Copyright © 2020 ergunkocak. All rights reserved.
//

import RxSwift
import RxCocoa

class ExpenseAddPresenter {
    
    var accounts: [AccountRecord] = []
    var incomeCategories: [IncomeCategoryRecord] = []
    var expenseCategories: [ExpenseCategoryRecord] = []

    var selectedAccount: AccountRecord?
    var selectedIncomeCategory: IncomeCategoryRecord?
    var selectedExpenseCategory: ExpenseCategoryRecord?
    var amountRx = BehaviorRelay<Int64>(value: 0)
    
    func addIncome() {
        var income = ExpenseRecord(
            id: nil,
            name: nil,
            accountId: selectedAccount!.id!,
            expenseCategoryId: nil,
            incomeCategoryId: selectedIncomeCategory?.id,
            amount: amountRx.value,
            createdTS: nil
        )
        
        do {
            try dbQueue.write { db in
                do {
                    try income.insert(db)
                } catch {
                    // TODO: display error
                }
            }
        } catch {
            // TODO: display error
        }
    }
    
    func addExpense() {
        var expense = ExpenseRecord(
            id: nil,
            name: nil,
            accountId: selectedAccount!.id!,
            expenseCategoryId: selectedExpenseCategory?.id,
            incomeCategoryId: nil,
            amount: amountRx.value,
            createdTS: nil
        )
        
        do {
            try dbQueue.write { db in
                do {
                    try expense.insert(db)
                } catch {
                    // TODO: display error
                }
            }
        } catch {
            // TODO: display error
        }
    }

}
