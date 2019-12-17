//
//  ENDiscoverCVCell.swift
//  EaseNetMusic
//
//  Created by 蒋理智 on 2019/12/17.
//  Copyright © 2019 lizhi. All rights reserved.
//

import UIKit

class ENDiscoverCVCell: UICollectionViewCell {
    
    var imageView: UIImageView = UIImageView()
    var titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 3.0
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "cm2_default_edit_80")
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.numberOfLines = 2
        titleLabel.text = "渴望找到时光隧道，重回年少简单的生活"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
