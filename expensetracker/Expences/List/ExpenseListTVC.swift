//
//  Created by Ergün on 29.03.20.
//  Copyright © 2020 ergunkocak. All rights reserved.
//

import UIKit
import RxSwift

class ExpenseListTVC: UITableViewController {
    
    let presenter = ExpenseListPresenter()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "list-page-title".localized()
        setupNavigation()
        setupTable()
        setupBindings()
        presenter.load()
    }
    
    func setupNavigation() {
        let buttonPlus = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(addNew))
        navigationItem.rightBarButtonItem  = buttonPlus
    }
    
    func setupTable() {
        tableView.allowsMultipleSelection = false
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func setupBindings() {
        presenter
            .reloadRequired
            .filter({ $0 })
            .subscribeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] (_) in
                    guard let vc = self else { return }
                    vc.tableView.reloadData()
                }
            )
            .disposed(by: disposeBag)
    }
    
    @objc func addNew() {
        ExpenseListRouter.showAddNew(from: self)
    }
    
    // MARK: Table Delegates
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.accounts.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount(for: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let account = presenter.accounts[safe: section] else { return "???" }
        if rowCount(for: section) > 0 {
            return account.name
        } else {
            return nil
        }
    }
    
    private func rowCount(for section: Int) -> Int {
        guard let account = presenter.accounts[safe: section] else { return 0 }
        return presenter.expenses[account.id!]?.count ?? 0
    }
}
