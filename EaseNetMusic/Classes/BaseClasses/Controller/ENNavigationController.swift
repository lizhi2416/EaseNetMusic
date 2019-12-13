//
//  ENNavigationController.swift
//  EaseNetMusic
//
//  Created by 蒋理智 on 2019/12/6.
//  Copyright © 2019 lizhi. All rights reserved.
//

import UIKit

class ENPanGestureRecognizer: UIPanGestureRecognizer {
    
}

class ENNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNavigationBarHidden = true
        
        guard let interactivePopGes = self.interactivePopGestureRecognizer else { return }
        guard let gesView = interactivePopGes.view else { return }
        guard let internalTargets = interactivePopGes.value(forKey: "targets") as? [NSObject] else { return }
        guard let internalTarget = internalTargets.first?.value(forKey: "target") else { return  }
        let internalAction = Selector(("handleNavigationTransition:"))
        let panGestureRecognizer = ENPanGestureRecognizer(target: internalTarget, action: internalAction)
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.delegate = self
        gesView.addGestureRecognizer(panGestureRecognizer)
        
        interactivePopGes.isEnabled = false
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
    

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !self.viewControllers.isEmpty {
            if let vc = viewController as? ENCustomNavController {
                vc.showNavBackBtn = true
            }
        }
        
        super.pushViewController(viewController, animated: animated)
    }

}

extension ENNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        // Ignore when no view controller is pushed into the navigation stack.
        if viewControllers.count <= 1 {
            return false
        }
        
        // Disable when the active view controller doesn't allow interactive pop.这里就先不用runtime添加属性了，放在基类里也ok
        if let topViewController = viewControllers.last {
            if let currentVC = topViewController as? ENBaseController {
                if currentVC.en_interactivePopDisabled {
                    return false
                }
                if currentVC.en_interactivePopGesZone > 0 {
                    //还可以扩展手势是全屏返回还是某些固定区域返回
                    if gestureRecognizer.location(in: gestureRecognizer.view).x > currentVC.en_interactivePopGesZone {
                        return false
                    }
                }
            }
        }
        
        // Ignore pan gesture when the navigation controller is currently in transition.
        if let isTransitioning = self.value(forKey: "_isTransitioning") as? NSNumber {
            if isTransitioning.boolValue {
                return false
            }
        }
        
        // Prevent calling the handler when the gesture begins in an opposite direction.
        if let panGes = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGes.translation(in: panGes.view)
            if translation.x <= 0 {
                return false
            }
        }
        
        return true
    }
}

