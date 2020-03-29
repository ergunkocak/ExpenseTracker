//
//  ListRouter.swift
//  ExpenseTracker
//
//  Created by Ergün on 29.03.20.
//  Copyright © 2020 ergunkocak. All rights reserved.
//

import UIKit

class ExpenseListRouter {
    
    static func generateListVC() -> UINavigationController {
        let nav = UINavigationController()
        let tvc = ExpenseListTVC()
        let presenter = ExpenseListPresenter()
        tvc.presenter = presenter
        nav.viewControllers = [tvc]
        return nav
    }
    
    static func showAddNew(from: UIViewController) {
        let nav = UINavigationController()
        let vc = ExpenseAddVC()
        let presenter = ExpenseAddPresenter()
        vc.presenter = presenter
        presenter.view = vc
        nav.viewControllers = [vc]
        nav.modalPresentationStyle = .overFullScreen
        from.present(nav, animated: true) {
            //
        }
    }
    
}
