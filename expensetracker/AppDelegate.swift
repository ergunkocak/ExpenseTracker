//
//  AppDelegate.swift
//  ExpenseTracker
//
//  Created by Ergün on 29.03.20.
//  Copyright © 2020 ergunkocak. All rights reserved.
//

import UIKit
import GRDB

// The shared database queue
var dbQueue: DatabaseQueue!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        try! setupDatabase(application)
        bootstrap()
        return true
    }
    
    private func setupDatabase(_ application: UIApplication) throws {
        let databaseURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("db.sqlite")
        dbQueue = try AppDatabase.openDatabase(atPath: databaseURL.path)
    }
    
    func bootstrap() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = generateTabBarVC()
        window?.makeKeyAndVisible()
    }
    
    func generateTabBarVC() -> MainTBC {
        let mainTBC = MainTBC()
        mainTBC.viewControllers = [
            ListRouter.generateListVC(),
            ReportRouter.generateMainVC()
        ]
        let tabHome = mainTBC.tabBar.items![0]
        tabHome.title = "tab-list".localized()
        tabHome.image = UIImage(named: "list")
        tabHome.selectedImage = UIImage(named: "list")

        let tabReport = mainTBC.tabBar.items![1]
        tabReport.title = "tab-report".localized()
        tabReport.image = UIImage(named: "report_passive")
        tabReport.selectedImage = UIImage(named: "report_active")

        return mainTBC
    }

}
