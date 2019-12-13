//
//  ENProgressHud.swift
//  Cartoon-Swift
//
//  Created by 蒋理智 on 2019/9/11.
//  Copyright © 2019 lizhi. All rights reserved.
//

import Foundation
import MBProgressHUD

private let defaultLoadingText = "加载中.."

private let defaultHideTime = 2.0


class ENProgressHud {
    
    //swift单例
    static let sharedHud = ENProgressHud()
    
    private init() {
        
    }
    
    var hud: MBProgressHUD?
    
// MARK: - normal loading
    static func showLoading(_ view: UIView? = UIApplication.shared.keyWindow, title: String? = nil, detailText: String? = nil, enable: Bool = true) {
        ENProgressHud.sharedHud.showLoading(view: view, title: title, detailText: detailText, enable: enable)
    }
        
    @discardableResult
    func showLoading(view: UIView? = UIApplication.shared.keyWindow, title: String? = defaultLoadingText, detailText: String? = nil, enable: Bool = true) -> MBProgressHUD? {
        
        guard let superView = view ?? UIApplication.shared.keyWindow else {
            return nil
        }
        
        let hud = MBProgressHUD.showAdded(to: superView, animated: true)
        hud.removeFromSuperViewOnHide = true
        
        //仿SVProgressHud放在window上的hud只存在一个
        if superView == UIApplication.shared.keyWindow {
            if self.hud != nil {
                self.hud?.hide(animated: false)
                self.hud = nil
            }
            
            self.hud = hud
        }
        
        //4\4s屏幕避免键盘存在时遮挡
        if (kScreenHeight == 480) {
            superView.endEditing(true)
        }
        
//        if superView == UIApplication.shared.keyWindow {
//            self.hud?.backgroundView.style = .solidColor
//            self.hud?.backgroundView.backgroundColor = UIColor.init(white: 0.1, alpha: 0.1)
//        }
//
//        self.hud?.bezelView.style = .solidColor
//        self.hud?.bezelView.backgroundColor = UIColor.black
//        self.hud?.contentColor = UIColor.white
        
        if let title = title {
            hud.label.text = title
        }
        
        if let detail = detailText {
            hud.detailsLabel.text = detail
        }
        
        if enable == false {
            hud.isUserInteractionEnabled = false
        }
        
        return hud
    }
    
// MARK: - dismiss
    static func dismiss(_ view: UIView? = UIApplication.shared.keyWindow) {
        if let supView = view {
            DispatchQueue.dispatchInMainThread {
                MBProgressHUD.hide(for: supView, animated: true)
                if supView == UIApplication.shared.keyWindow {
                    ENProgressHud.sharedHud.hud = nil
                }
            }
        }
    }
    
// MARK: - only text toast
    static func showToast(view: UIView? = UIApplication.shared.keyWindow, _ title: String, showTime: Double = defaultHideTime, Bottom: Bool = false) {
        
        guard let superView = view ?? UIApplication.shared.keyWindow else {
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: superView, animated: true)
        hud.mode = .text
        hud.margin = 12.0
        if Bottom {
            hud.offset = CGPoint(x: 0.0, y: MBProgressMaxOffset)
        }
        hud.removeFromSuperViewOnHide = true
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 16.0)
        hud.detailsLabel.text = title
        hud.isUserInteractionEnabled = false
        hud.hide(animated: true, afterDelay: showTime)
    }
}

extension UIView {
    func makeToast(_ title: String, showTime: Double = defaultHideTime, Bottom: Bool = false) {
        ENProgressHud.showToast(view: self, title, showTime: showTime, Bottom: Bottom)
    }
}
