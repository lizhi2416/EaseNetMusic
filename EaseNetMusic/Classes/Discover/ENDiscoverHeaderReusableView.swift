//
//  ENDiscoverHeaderReusableView.swift
//  EaseNetMusic
//
//  Created by 蒋理智 on 2019/12/17.
//  Copyright © 2019 lizhi. All rights reserved.
//

import UIKit
import LLCycleScrollView

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


class ENDiscoverTopHeaderReusableView: ENDiscoverHeaderReusableView {
    
    lazy var bannerView: LLCycleScrollView = {
        let cycleScrollView = LLCycleScrollView().then({ (cycleScrollView) in
            cycleScrollView.backgroundColor = UIColor.background
            cycleScrollView.autoScrollTimeInterval = 5
            cycleScrollView.placeHolderImage = UIImage(named: "cm4_tvc_video_default_night")
//            bannerView.coverImage = UIImage()
            cycleScrollView.pageControlPosition = .center
            cycleScrollView.pageControlBottom = 20
            
        })
        return cycleScrollView
    }()
    
    lazy var toolBtns = [UIControl]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bannerView.frame = CGRect(x: 0, y: 15, width: kScreenWidth, height: kScreenWidth / 3.0)
        self.addSubview(self.bannerView)
        
        let toolTitles = ["每日推荐", "歌单", "排行榜", "电台", "直播"]
        for (index, title) in toolTitles.enumerated() {
            let btn = UIControl(frame: CGRect(x: CGFloat(index) * kScreenWidth / 5.0, y: kScreenWidth / 3.0 + 30.0, width: kScreenWidth / 5.0, height: 80))
            btn.tag = 100 + index
            let imageView = UIImageView(frame: CGRect(x: (kScreenWidth / 5.0 - 50)/2.0, y: 5.0, width: 50, height: 50))
            imageView.image = UIImage(named: "cm5_set_icn_miniapp_pri_fm")
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 55, width: kScreenWidth / 5.0, height: 25))
            titleLabel.text = title
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 10)
            titleLabel.textColor = UIColor.lightGray
//                btn.addTarget(self, action: #selector(clickToolBarBtn(_:)), for: .touchUpInside)
            btn.addSubview(imageView)
            btn.addSubview(titleLabel)
            self.addSubview(btn)
            
            self.toolBtns.append(btn)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
