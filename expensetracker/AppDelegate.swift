//
//  AppDelegate.swift
//  ExpenseTracker
//
//  Created by Ergün on 29.03.20.
//  Copyright © 2020 ergunkocak. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        bootstrap()
        return true
    }
    
    func bootstrap() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainTBC = MainTBC()
        mainTBC.viewControllers = [
            ListRouter.generateListVC(),
            ReportRouter.generateMainVC()
        ]
        let tabHome = mainTBC.tabBar.items![0]
        tabHome.title = "tab-list".localized()
//        tabHome.selectedImage = UIImage(named: "icon_home.png") // select image
//        tabHome.titlePositionAdjustment.vertical = tabHome.titlePositionAdjustment.vertical-4 // title position change

        let tabReport = mainTBC.tabBar.items![1]
        tabReport.title = "tab-report".localized()

        window?.rootViewController = mainTBC
        window?.makeKeyAndVisible()
    }

}
