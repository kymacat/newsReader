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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: AllNewsController())
        
        return true
    }


}

