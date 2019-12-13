//
//  CTGlobal.swift
//  Cartoon-Swift
//
//  Created by 蒋理智 on 2019/9/4.
//  Copyright © 2019 lizhi. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height

var isXIphone: Bool {
    return UI_USER_INTERFACE_IDIOM() == .phone && (max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 812 || max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 896)
}

let kNavgationHeight: CGFloat = isXIphone ? 88.0 : 64.0

let kNavgationBarHeight: CGFloat = 44.0

let kTopLayoutSafeHeight: CGFloat = isXIphone ? 44.0: 20.0

let kBottomLayoutSafeHeight: CGFloat = isXIphone ? 34.0 : 0.0


//获取当前显示的控制器包含模态出来的
var topVC: UIViewController? {
    var resultVC: UIViewController?
    resultVC = getTopVC(UIApplication.shared.keyWindow?.rootViewController)
    while resultVC?.presentedViewController != nil {
        resultVC = getTopVC(resultVC?.presentedViewController)
    }
    return resultVC
}

private func getTopVC(_ currentVC: UIViewController?) -> UIViewController? {
    if currentVC is UINavigationController {
        return getTopVC((currentVC as? UINavigationController)?.topViewController)
    } else if currentVC is UITabBarController {
        return getTopVC((currentVC as? UITabBarController)?.selectedViewController)
    } else {
        return currentVC
    }
}

/// 直接打印出内容
///
/// - Parameter message: <#message description#>
func ENLog<T>(_ message: T) {
    #if DEBUG
    print(message)
    #endif
}

/// 打印内容，并包含类名和打印所在行数
///
/// - Parameters:
///   - message: 打印消息
///   - file: 打印所属类
///   - lineNumber: 打印语句所在行数
func ENLogLine<T>(_ message: T, file: String = #file, lineNumber: Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("[\(fileName):line:\(lineNumber)]- \(message)")
    #endif
}

extension DispatchQueue {
    static func dispatchInMainThread(callback: @escaping () -> Void) {
        if Thread.isMainThread {
            callback()
        } else {
            DispatchQueue.main.async(execute: callback)
        }
    }
}

extension UIColor {
    class var background: UIColor {
        return UIColor.white
    }
    
    class var theme: UIColor {
        return UIColor(red: 209/255.0, green: 60/255.0, blue: 55/255.0, alpha: 1.0)
    }
    
    class var randomColor: UIColor {
        let red = CGFloat(arc4random()%256)/255.0
        let green = CGFloat(arc4random()%256)/255.0
        let blue = CGFloat(arc4random()%256)/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}




