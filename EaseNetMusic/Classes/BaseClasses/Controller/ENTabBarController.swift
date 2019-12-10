//
//  ENTabBarController.swift
//  EaseNetMusic
//
//  Created by 蒋理智 on 2019/12/6.
//  Copyright © 2019 lizhi. All rights reserved.
//

import UIKit

class ENTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor.white
        self.delegate = self
//        tabBar.isTranslucent = false
        self.setupLayout()
    }
    
    func setupLayout() {
        let discoverVC = ENDiscoverVC()
        self.addChildVC(discoverVC, title: "发现", image: "cm4_btm_icn_discovery", selectedImage: "cm4_btm_icn_discovery_prs")

        let videoVC = ENVideoVC()
        self.addChildVC(videoVC, title: "视频", image: "cm4_btm_icn_video_new", selectedImage: "cm4_btm_icn_video_new_prs")

        let mineVC = ENMineVC()
        self.addChildVC(mineVC, title: "我的", image: "cm4_btm_icn_music_new", selectedImage: "cm4_btm_icn_music_new_prs")
        
        let moreVC = ENMoreVC()
        self.addChildVC(moreVC, title: "更多", image: "cm4_btm_icn_friend", selectedImage: "cm4_btm_icn_friend_prs")
        
        let accountVC = ENAccountVC()
        self.addChildVC(accountVC, title: "账号", image: "cm4_btm_icn_account", selectedImage: "cm4_btm_icn_account_prs")
        
    }
    
    func addChildVC(_ childVC: UIViewController, title:String?, image:String, selectedImage:String) {
        
        childVC.title = title
        childVC.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.theme], for: .selected)
        childVC.tabBarItem.title = title
        childVC.tabBarItem.image = UIImage(named: image)
        childVC.tabBarItem.selectedImage = UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal)
        addChild(ENNavigationController(rootViewController: childVC))
    }
    
// MARK: - 让当前显示的控制器控制statubar的样式和隐藏
    override var prefersStatusBarHidden: Bool {
        guard let selectVC = selectedViewController else {
            return false
        }
        return selectVC.prefersStatusBarHidden
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let selectVC = selectedViewController else { return .lightContent }
        return selectVC.preferredStatusBarStyle
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if self.selectedViewController == viewController {
            
        }
        
        if let nvc = (viewController as? UINavigationController) {
            if nvc.viewControllers.first is ENAccountVC {
                if !ENSaveUitil.getLoginMark() {
                    if let currentNvc = self.selectedViewController as? UINavigationController {
                        currentNvc.pushViewController(ENLoginVC(), animated: false)
                        return false
                    }
                }
            }
        }
        return true
    }

}
