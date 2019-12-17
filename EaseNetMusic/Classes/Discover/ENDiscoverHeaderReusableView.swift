//
//  ENDiscoverHeaderReusableView.swift
//  EaseNetMusic
//
//  Created by 蒋理智 on 2019/12/17.
//  Copyright © 2019 lizhi. All rights reserved.
//

import UIKit

class ENDiscoverHeaderReusableView: UICollectionReusableView {
    
    var titleLabel = UILabel()
    var moreBrn = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15.0)
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        
        moreBrn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        moreBrn.setTitleColor(UIColor.lightGray, for: .normal)
        moreBrn.layer.cornerRadius = 12.0
        moreBrn.layer.masksToBounds = true
        moreBrn.layer.borderWidth = 0.7
        moreBrn.layer.borderColor = UIColor.lightGray.cgColor
        self.addSubview(moreBrn)
        moreBrn.snp.makeConstraints { (make) in
            make.height.equalTo(24)
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-15.0)
            make.width.equalTo(80)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
