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
        
        self.loadCookies()
        
        UITextField.appearance().tintColor = UIColor.theme
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = ENTabBarController()
        window?.makeKeyAndVisible()
        
//        Thread.sleep(forTimeInterval: 3)
        
        return true
    }
    /// 如果已经登录，则获取上次保存的cookies重新加载
    func loadCookies() {
        if let cookiesData = UserDefaults.standard.value(forKey: "loginCookiesData") as? Data {
            if let cookies = NSKeyedUnarchiver.unarchiveObject(with: cookiesData) as? [HTTPCookie] {
                cookies.forEach { HTTPCookieStorage.shared.setCookie($0) }
            }
            
        }
    }

}

