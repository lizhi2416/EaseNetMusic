//
//  ENAccountVC.swift
//  EaseNetMusic
//
//  Created by 蒋理智 on 2019/12/6.
//  Copyright © 2019 lizhi. All rights reserved.
//

import UIKit

class ENAccountVC: ENCustomNavController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel(frame: CGRect(x: 100, y: 100, width: 200, height: 30))
        label.backgroundColor = UIColor.theme
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "已登录，待编写界面代码..."
        self.view.addSubview(label)
    }
    

    

}
