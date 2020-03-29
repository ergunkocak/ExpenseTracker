//
//  Created by Ergün on 29.03.20.
//  Copyright © 2020 ergunkocak. All rights reserved.
//

import RxSwift
import RxCocoa
import GRDB
import RxGRDB

class ExpenseListPresenter {
    
    var accounts: [AccountRecord] = [] // used to keep order
    var expenseCategories: [ExpenseCategoryRecord] = []
    var expenses: [AccountRecord.ID: [ExpenseRecord]] = [:]
    var reloadRequired = BehaviorRelay<Bool>(value: false)

    private let disposeBag = DisposeBag()

    func load() {
        let observables = accounts.map { [weak self] (record: AccountRecord) -> Observable<[ExpenseRecord]> in
            guard let presenter = self else { return Observable.just([]) }
            presenter.accounts = accounts
            return presenter.loadExpencesRx(of: record.id!)
        }
        Observable.zip(observables)
            .subscribe(
                onNext: { [weak self] (recordGroups: [[ExpenseRecord]]) in
                    guard let presenter = self else { return }
                    debugPrint(recordGroups)
                    recordGroups.filter({ !$0.isEmpty }).forEach { (expenseGroup: [ExpenseRecord]) in
                        let accountId = expenseGroup.first!.accountId
                        presenter.expenses[accountId] = expenseGroup
                    }
                    presenter.reloadRequired.accept(true)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func loadExpencesRx(of accountId: Int64) -> Observable<[ExpenseRecord]> {
        return ExpenseRecord
            .limit(10)
            .order(Column("createdTS").desc)
            .rx
            .observeAll(in: dbQueue)
    }
}
