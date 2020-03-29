//
//  ExpenseAddPresenter.swift
//  ExpenseTracker
//
//  Created by Ergün on 29.03.20.
//  Copyright © 2020 ergunkocak. All rights reserved.
//

import RxSwift
import RxCocoa
import RxGRDB

class ExpenseAddPresenter {
    
    var accounts: [AccountRecord] = []
    var incomeCategories: [IncomeCategoryRecord] = []
    var expenseCategories: [ExpenseCategoryRecord] = []

    var selectedAccount: AccountRecord?
    var selectedIncomeCategory: IncomeCategoryRecord?
    var selectedExpenseCategory: ExpenseCategoryRecord?
    var amountRx = BehaviorRelay<Int64>(value: 0)

    var view: ExpenseAddProtocol?
    
    private let disposeBag = DisposeBag()
    
    init() {
        let request = ExpenseRecord.all()
        request.rx.changes(in: dbQueue)
            .subscribe(
                onNext: { [weak self] (_) in
                    guard let presenter = self else { return }
                    debugPrint("Expenses have changed.")
                    presenter.view?.dismiss()
                }
        ).disposed(by: disposeBag)
    }
    
    func addIncome() {
        var income = ExpenseRecord(
            id: nil,
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
                    debugPrint(error)
                }
            }
        } catch {
            // TODO: display error
            debugPrint(error)
        }
    }
    
    func addExpense() {
        var expense = ExpenseRecord(
            id: nil,
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
                    debugPrint(error)
                }
            }
        } catch {
            // TODO: display error
            debugPrint(error)
        }
    }

}
