//
//  ENCustomNavController.swift
//  EaseNetMusic
//
//  Created by 蒋理智 on 2019/12/10.
//  Copyright © 2019 lizhi. All rights reserved.
//

import UIKit

class ENCustomNavController: ENBaseController, ENNavigationBarDataSource, ENNavigationBarDelegate {
    
    public var showNavBackBtn = false
    
    var navBar: ENCustomNavBar = ENCustomNavBar(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavgationHeight))

    override func viewDidLoad() {
        
        navBar.dataSource = self
        navBar.delegate = self
        self.view.addSubview(navBar)
        
        super.viewDidLoad()
        
    }
    
    override var title: String? {
        didSet {
            if let title = title {
                let attTitle = NSMutableAttributedString(string: title)
                attTitle.setAttributes([.foregroundColor: UIColor.black, .font: UIFont.boldSystemFont(ofSize: 18)], range: NSRange(location: 0, length: title.count))
                self.navBar.title = attTitle
            }
            
        }
    }
    
// MARK: - ENNavigationBarDataSource, ENNavigationBarDelegate
    func titleForNavigationBar(_ navigationBar: ENCustomNavBar) -> NSMutableAttributedString? {
        return nil
    }
    
    func backgroundImageForNavigationBar(_ navigationBar: ENCustomNavBar) -> UIImage? {
        return nil
    }
    
    func backgroundColorForNavigationBar(_ navigationBar: ENCustomNavBar) -> UIColor? {
        return nil
    }
    
    func navigationIsHideBottomLine(_ navigationBar: ENCustomNavBar) -> Bool {
        return true
    }
    
    func navigationHeight(_ navigationBar: ENCustomNavBar) -> CGFloat? {
        return nil
    }
    
    func leftViewForNavigationBar(_ navigationBar: ENCustomNavBar) -> UIView? {
        return nil
    }
    
    func rightViewForNavigationBar(_ navigationBar: ENCustomNavBar) -> UIView? {
        return nil
    }
    
    func titleViewForNavigationBar(_ navigationBar: ENCustomNavBar) -> UIView? {
        return nil
    }
    
    func navigationBar(_ navigationBar: ENCustomNavBar, customLeftButton leftButton: UIButton?) -> Bool {
        if let btn = leftButton {
            btn.setImage(UIImage(named: "nav_back_icon"), for: .normal)
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        }
        return showNavBackBtn
    }
    
    func navigationBar(_ navigationBar: ENCustomNavBar, customRightButton rightButton: UIButton?) -> Bool {
        return false
    }
    
    func navigationBar(_ navigationBar: ENCustomNavBar, leftButtonEvent sender: UIButton) {
        ENLog("点击了导航栏左边按钮")
        self.navigationController?.popViewController(animated: true)
    }
    
    func navigationBar(_ navigationBar: ENCustomNavBar, rightButtonEvent sender: UIButton) {
        ENLog("点击了导航栏右边按钮")
    }
    
    func navigationBar(_ navigationBar: ENCustomNavBar, titleClickEvent sender: UILabel) {
        ENLog("点击了导航栏标题按钮")
    }
    
}
