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
        nav.viewControllers = [tvc]
        return nav
    }
    
    static func showAddNew(from: UIViewController) {
        let nav = UINavigationController()
        let vc = ExpenseAddVC()
        nav.viewControllers = [vc]
        nav.modalPresentationStyle = .overFullScreen
        from.present(nav, animated: true) {
            //
        }
    }
    
}
