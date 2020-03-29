//
//  Created by Ergün on 29.03.20.
//  Copyright © 2020 ergunkocak. All rights reserved.
//

import RxSwift
import RxCocoa
import GRDB
import RxGRDB

class ExpenseListPresenter {
    
    var expenses: [AccountRecord.ID: [ExpenseRecord]] = [:]
    var reloadRequired = BehaviorRelay<Bool>(value: false)

    private let disposeBag = DisposeBag()
    
    init() {
        let request = ExpenseRecord.all()
        request.rx.changes(in: dbQueue)
            .subscribe(
                onNext: { [weak self] (_) in
                    guard let presenter = self else { return }
                    debugPrint("Expenses have changed.")
                    presenter.load()
                }
        ).disposed(by: disposeBag)
    }

    func load() {
        let observables = accounts.value.map { [weak self] (record: AccountRecord) -> Observable<[ExpenseRecord]> in
            guard let presenter = self else { return Observable.just([]) }
            return presenter.loadExpencesRx(of: record.id!)
        }
        Observable.zip(observables)
            .subscribe(
                onNext: { [weak self] (recordGroups: [[ExpenseRecord]]) in
                    guard let presenter = self else { return }
                    debugPrint(recordGroups)
                    recordGroups.filter({ !$0.isEmpty }).forEach { (expenseGroup: [ExpenseRecord]) in
                        let accountId = expenseGroup.first!.accountId
                        debugPrint("Account Id: \(accountId)")
                        presenter.expenses[accountId] = expenseGroup
                        debugPrint(expenseGroup)
                    }
                    presenter.reloadRequired.accept(true)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func loadExpencesRx(of accountId: Int64) -> Observable<[ExpenseRecord]> {
        return ExpenseRecord
            .filter(Column("accountId") == accountId)
            .limit(10)
            .order(Column("createdTS").desc)
            .rx
            .observeAll(in: dbQueue)
    }
}
