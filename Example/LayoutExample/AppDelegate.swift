//
//  AppDelegate.swift
//  LayoutExample
//
//  Created by Vladislav Librecht on 27/07/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.rootViewController = TestViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
}
