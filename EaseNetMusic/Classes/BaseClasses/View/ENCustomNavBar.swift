//
//  ENCustomNavBar.swift
//  EaseNetMusic
//
//  Created by 蒋理智 on 2019/12/10.
//  Copyright © 2019 lizhi. All rights reserved.
//

import UIKit

class ENCustomNavBar: UIView {
    
// MARK: - setter, getter
    lazy var bottomBlackLineView: UIView = {
        
        let onePointHeight = 1.0/UIScreen.main.scale
        
        let sepLine = UIView()
        sepLine.backgroundColor = UIColor.lightGray
        self.addSubview(sepLine)
        sepLine.snp.makeConstraints { (make) in
            make.height.equalTo(onePointHeight)
            make.leading.trailing.bottom.equalToSuperview()
        }
        return sepLine
    }()
    
    var titleView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            
            if let newTitle = titleView {
                self.addSubview(newTitle)
                
                var isHaveTapGes = false
                if let gestures = newTitle.gestureRecognizers {
                    for gesture in gestures where gesture is UITapGestureRecognizer {
                        isHaveTapGes = true
                        break
                    }
                }
                if !isHaveTapGes {
                    let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(titleClick(_:)))
                    newTitle.addGestureRecognizer(tapGes)
                }
            }
            
            self.layoutIfNeeded()
        }
    }
    
// MARK: - event
    @objc func titleClick(_ sender: AnyClass) {
        
    }
    
// MARK: - 初始化部分
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNavBarUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupNavBarUI()
    }
    
    func setupNavBarUI() {
        self.backgroundColor = UIColor.white
    }
    
    
}
