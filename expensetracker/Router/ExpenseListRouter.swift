//
//  ListRouter.swift
//  ExpenseTracker
//
//  Created by Ergün on 29.03.20.
//  Copyright © 2020 ergunkocak. All rights reserved.
//

import UIKit

class ExpenseListRouter {
    
    static func generateListVC(accounts: [AccountRecord], expenseCategories: [ExpenseCategoryRecord]) -> UINavigationController {
        let nav = UINavigationController()
        let tvc = ExpenseListTVC()
        let presenter = ExpenseListPresenter()
        presenter.accounts = accounts
        presenter.expenseCategories = expenseCategories
        tvc.presenter = presenter
        nav.viewControllers = [tvc]
        return nav
    }
    
    static func showAddNew(from: UIViewController, accounts: [AccountRecord], expenseCategories: [ExpenseCategoryRecord]) {
        let nav = UINavigationController()
        let vc = ExpenseAddVC()
        let presenter = ExpenseAddPresenter()
        presenter.accounts = accounts
        presenter.expenseCategories = expenseCategories
        vc.presenter = presenter
        nav.viewControllers = [vc]
        nav.modalPresentationStyle = .overFullScreen
        from.present(nav, animated: true) {
            //
        }
    }
    
}
