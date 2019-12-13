//
//  ENCustomNavBar.swift
//  EaseNetMusic
//
//  Created by 蒋理智 on 2019/12/10.
//  Copyright © 2019 lizhi. All rights reserved.
//

import UIKit
import SwifterSwift

let ENNavgationItemWidth: CGFloat = 60.0


protocol ENNavigationBarDataSource: AnyObject {
    /// 头部标题
    func titleForNavigationBar(_ navigationBar: ENCustomNavBar) -> NSMutableAttributedString?
    /// 背景图片
    func backgroundImageForNavigationBar(_ navigationBar: ENCustomNavBar) -> UIImage?
    /// 背景色
    func backgroundColorForNavigationBar(_ navigationBar: ENCustomNavBar) -> UIColor?
    /// 是否显示底部黑线
    func navigationIsHideBottomLine(_ navigationBar: ENCustomNavBar) -> Bool
    /// 导航条的高度
    func navigationHeight(_ navigationBar: ENCustomNavBar) -> CGFloat?
    /// 导航条的左边的 view
    func leftViewForNavigationBar(_ navigationBar: ENCustomNavBar) -> UIView?
    /// 导航条右边的 view
    func rightViewForNavigationBar(_ navigationBar: ENCustomNavBar) -> UIView?
    /// 导航条中间的 View
    func titleViewForNavigationBar(_ navigationBar: ENCustomNavBar) -> UIView?
    /// 导航条左边的按钮
    @discardableResult
    func navigationBar(_ navigationBar: ENCustomNavBar, customLeftButton leftButton: UIButton?) -> Bool
    /// 导航条右边的按钮
    @discardableResult
    func navigationBar(_ navigationBar: ENCustomNavBar, customRightButton rightButton: UIButton?) -> Bool
}

protocol ENNavigationBarDelegate: AnyObject {
    /// 左边的按钮的点击
    func navigationBar(_ navigationBar: ENCustomNavBar, leftButtonEvent sender: UIButton)
    /// 右边的按钮的点击
    func navigationBar(_ navigationBar: ENCustomNavBar, rightButtonEvent sender: UIButton)
    /// 中间如果是 label 就会有点击
    func navigationBar(_ navigationBar: ENCustomNavBar, titleClickEvent sender: UILabel)
}

class ENCustomNavBar: UIView {
    
// MARK: - setter, getter
    
    weak var dataSource: ENNavigationBarDataSource? {
        didSet {
            /// 导航条的高度
            if let height = dataSource?.navigationHeight(self) {
                self.height = height
            } else {
                self.height = kNavgationHeight
            }
            
            /// 是否显示底部黑线
            if let hiddenLine = dataSource?.navigationIsHideBottomLine(self) {
                self.bottomBlackLineView.isHidden = hiddenLine
            }
            
            /// 背景图片
            if let barImage = dataSource?.backgroundImageForNavigationBar(self) {
                self.layer.contents = barImage
            }
            
            /// 背景色
            if let backgroundColor = dataSource?.backgroundColorForNavigationBar(self) {
                self.backgroundColor = backgroundColor
            }
            
            /// 导航条中间的 View
            if let titleView = dataSource?.titleViewForNavigationBar(self) {
                self.titleView = titleView
            } else {
                if let barTitle = dataSource?.titleForNavigationBar(self) {
                    self.title = barTitle
                }
            }
            
            /// 导航条的左边的 view
            if let leftView = dataSource?.leftViewForNavigationBar(self) {
                self.leftView = leftView
            } else {
                if let needCustom = dataSource?.navigationBar(self, customLeftButton: nil), needCustom {
                    let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: ENNavgationItemWidth, height: kNavgationBarHeight))
                    leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                    leftButton.setTitleColor(UIColor.black, for: .normal)
                    dataSource?.navigationBar(self, customLeftButton: leftButton)
                    self.leftView = leftButton
                }
            }
            
            /// 导航条的右边的 view
            if let rightView = dataSource?.rightViewForNavigationBar(self) {
                self.rightView = rightView
            } else {
                if let needCustom = dataSource?.navigationBar(self, customRightButton: nil), needCustom {
                    let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: ENNavgationItemWidth, height: kNavgationBarHeight))
                    rightButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
                    rightButton.setTitleColor(UIColor.black, for: .normal)
                    dataSource?.navigationBar(self, customRightButton: rightButton)
                    self.rightView = rightButton
                }
            }
        }
    }
    
    weak var delegate: ENNavigationBarDelegate?
    
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
    
    var leftView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            
            if let leftView = leftView {
                self.addSubview(leftView)
                
                if let leftBtn = leftView as? UIButton {
                    leftBtn.addTarget(self, action: #selector(leftBtnClick(_:)), for: .touchUpInside)
                }
                
                self.layoutIfNeeded()
            }
        }
    }
    
    var rightView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            
            if let rightView = rightView {
                self.addSubview(rightView)
                if let rightBtn = rightView as? UIButton {
                    rightBtn.addTarget(self, action: #selector(rightBtnClick(_:)), for: .touchUpInside)
                }
                
                self.layoutIfNeeded()
            }
        }
    }
    
    var title: NSMutableAttributedString? {
        didSet {
            if dataSource?.titleForNavigationBar(self) != nil {
                return
            }
            /// 头部标题
            let navTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth/2.0, height: kNavgationBarHeight))
            /// 可能出现多行的标题
            navTitleLabel.numberOfLines = 0
            navTitleLabel.attributedText = title
            navTitleLabel.textAlignment = .center
            navTitleLabel.isUserInteractionEnabled = true
            navTitleLabel.lineBreakMode = .byClipping
            
            self.titleView = navTitleLabel
        }
    }
    
    
    
// MARK: - event
    @objc func titleClick(_ sender: UILabel) {
        delegate?.navigationBar(self, titleClickEvent: sender)
    }
    
    @objc func leftBtnClick(_ btn: UIButton) {
        delegate?.navigationBar(self, leftButtonEvent: btn)
    }
    
    @objc func rightBtnClick(_ btn: UIButton) {
        delegate?.navigationBar(self, rightButtonEvent: btn)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.superview?.bringSubviewToFront(self)
        if let leftView = self.leftView {
            leftView.x = 0
            leftView.y = kTopLayoutSafeHeight
        }
        
        if let rightView = self.rightView {
            rightView.x = self.width - rightView.width
            rightView.y = kTopLayoutSafeHeight
        }
        
        if let titleView = self.titleView {
            titleView.x = self.width * 0.5 - titleView.width  * 0.5
            titleView.y = kTopLayoutSafeHeight + (self.height - kTopLayoutSafeHeight - titleView.height) / 2.0
        }
    }
    
// MARK: - 私有方法
    func setupNavBarUI() {
        self.backgroundColor = UIColor.white
    }
    
    
}
