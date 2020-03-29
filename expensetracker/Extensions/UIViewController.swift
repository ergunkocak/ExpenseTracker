//
//  UIViewController.swift
//  ExpenseTracker
//
//  Created by Ergün on 29.03.20.
//  Copyright © 2020 ergunkocak. All rights reserved.
//

import UIKit
extension UIViewController {
    
    func alertError(from: UIViewController, message: String) {
        let alert = UIAlertController(
            title: "alert-error-title".localized(),
            message: message,
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(
            title: "alert-error-ok".localized(),
            style: .default,
            handler: nil)

        alert.addAction(okAction)
        
        from.present(alert, animated: true, completion: nil)
    }
    
}
