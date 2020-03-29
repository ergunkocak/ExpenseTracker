//
//  Created by Ergün on 29.03.20.
//  Copyright © 2020 ergunkocak. All rights reserved.
//

import UIKit
import RxSwift

class ExpenseListTVC: UITableViewController {
    
    var presenter: ExpenseListPresenter!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "list-page-title".localized()
        setupNavigation()
        setupTable()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.load()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Apple UI Hack
        tableView.reloadData()
    }
    
    func setupNavigation() {
        let buttonPlus = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(addNew))
        navigationItem.rightBarButtonItem  = buttonPlus
    }
    
    func setupTable() {
        tableView.allowsMultipleSelection = false
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(ExpenseListCell.self, forCellReuseIdentifier: ExpenseListCell.reuseIdentifier)
        tableView.rowHeight = 80
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
        return accounts.value.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount(for: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseListCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? ExpenseListCell {
            cell.layout()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ExpenseListCell else { return }
        let account = accounts.value[indexPath.section]
        guard let expense = presenter.expenses[account.id!]?[indexPath.row] else { return }
        cell.expense = expense
    }
    
    // TODO: replace this . Section total needs to be displayed in title
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let account = accounts.value[section]
        if rowCount(for: section) > 0 {
            return account.name
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: display expense detail
    }
    
    private func rowCount(for section: Int) -> Int {
        return presenter.expenses[accounts.value[section].id!]?.count ?? 0
    }
}
