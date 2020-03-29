//
//  ListPresenter.swift
//  ExpenseTracker
//
//  Created by Ergün on 29.03.20.
//  Copyright © 2020 ergunkocak. All rights reserved.
//

import RxSwift
import RxCocoa
import GRDB
import RxGRDB

class ListPresenter {
    
    var accountsRx = BehaviorRelay<[AccountRecord]>(value: [])

    private let disposeBag = DisposeBag()

    func load() {
        loadAccountsRx()
            .subscribe(
                onNext: { [weak self] (accounts: [AccountRecord]) in
                    guard let presenter = self else { return }
                    presenter.accountsRx.accept(accounts)
                }
            )
            .disposed(by: disposeBag)
//        let request: SQLRequest<Int> = "SELECT MAX(score) FROM player"
//        request.rx
//            .observeFirst(in: dbQueue)
//            .subscribe(onNext: { (score: Int?) in
//                print("Fresh maximum score: \(score)")
//            })
//            .disposed(by: disposeBag)
    }
    
    func loadAccountsRx() -> Observable<[AccountRecord]> {
        return AccountRecord
            .all()
            .rx
            .observeAll(in: dbQueue)
    }
    
    func loadExpencesRx(of accountId: Int) -> Observable<[ExpenseRecord]> {
        return ExpenseRecord
            .limit(10)
            .order(Column("createdTS").desc)
            .rx
            .observeAll(in: dbQueue)
    }
}
