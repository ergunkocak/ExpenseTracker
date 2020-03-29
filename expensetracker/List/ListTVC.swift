//
//  ListTVC.swift
//  ExpenseTracker
//
//  Created by Ergün on 29.03.20.
//  Copyright © 2020 ergunkocak. All rights reserved.
//

import UIKit
import RxSwift

class ListTVC: UITableViewController {
    
    let presenter = ListPresenter()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupBindings()
        presenter.load()
    }
    
    func setupTable() {
        tableView.allowsMultipleSelection = false
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func setupBindings() {
        presenter
            .accountsRx
            .subscribeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] (records: [AccountRecord]) in
                    guard let vc = self else { return }
                    vc.tableView.reloadData()
                }
            )
            .disposed(by: disposeBag)
    }
    
    // MARK: Table Delegates
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.accountsRx.value.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        presenter.accountsRx.value[safe: section]?.name ?? "???"
    }
}
