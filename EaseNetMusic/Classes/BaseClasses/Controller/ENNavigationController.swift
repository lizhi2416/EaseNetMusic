//
//  ENNavigationController.swift
//  EaseNetMusic
//
//  Created by 蒋理智 on 2019/12/6.
//  Copyright © 2019 lizhi. All rights reserved.
//

import UIKit

class ENNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
