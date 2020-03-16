//
//  AppDelegate.swift
//  NewsReader
//
//  Created by Const. on 12.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.makeKeyAndVisible()
        
        navigationController = UINavigationController(rootViewController: AllNewsController())
        window?.rootViewController = navigationController
        
        return true
    }


}

