//
//  AppDelegate.swift
//  EaseNetMusic
//
//  Created by 蒋理智 on 2019/12/5.
//  Copyright © 2019 lizhi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Thread.sleep(forTimeInterval: 3)
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = ENTabBarController()
        window?.makeKeyAndVisible()
        return true
    }

}

