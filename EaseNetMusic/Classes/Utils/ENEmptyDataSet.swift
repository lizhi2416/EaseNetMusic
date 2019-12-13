//
//  CTEmptyDataSet.swift
//  Cartoon-Swift
//
//  Created by 蒋理智 on 2019/9/18.
//  Copyright © 2019 lizhi. All rights reserved.
//

import Foundation
import EmptyDataSet_Swift

extension UIScrollView {
    private struct AssociatedKeys {
        static var enemptyKey: Void?
        static var enemptySetedKey: Void?
    }
    
    var emptyIsSeted: Bool? {
        get {
            if let seted = objc_getAssociatedObject(self, &AssociatedKeys.enemptySetedKey) as? NSNumber {
                return seted.boolValue
            }
            return nil
        }
        
        set {
            if let new = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.enemptySetedKey, NSNumber(value: new), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                objc_setAssociatedObject(self, &AssociatedKeys.enemptySetedKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    //方式一,可以通过改变allowShow来设置是否展示
    var enempty: ENEmptyView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.enemptyKey) as? ENEmptyView
        }
        
        set {
            self.emptyDataSetDelegate = newValue
            self.emptyDataSetSource = newValue
            objc_setAssociatedObject(self, &AssociatedKeys.enemptyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    //方式一，因为emptyDataSetView是private私有属性所以不可更改shouldDisplay字段，所以只能等网络请求成功后设置这个,但是这样就需要保证只设置一次
    func setEmptyData(image: String = "nodata", verticalOffset: CGFloat = 0, tapClosure: (() -> Void)?) {
        
        if let seted = self.emptyIsSeted {
            if seted {
                return
            }
        }
        
        self.emptyIsSeted = true
        
        self.emptyDataSetView { (view) in
            view.image(UIImage(named: image))
            .isScrollAllowed(true)
                .verticalOffset(verticalOffset)
            .shouldDisplay(true)//默认显示，网络请求后显示
            if tapClosure != nil {
                view.didTapContentView(tapClosure!)
            }
        }
    }
    
}

class ENEmptyView: EmptyDataSetSource, EmptyDataSetDelegate {
    
    var image: UIImage?
    
    var allowShow: Bool = false
    var verticalOffset: CGFloat = 0
    
    
    private var tapClosure: (() -> Void)?
    
    init(image: UIImage? = UIImage(named: "nodata"), verticalOffset: CGFloat = 0, tapClosure: (() -> Void)?) {
        self.image = image
        self.verticalOffset = verticalOffset
        self.tapClosure = tapClosure
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return verticalOffset
    }
    
    internal func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return image
    }
    
    internal func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return allowShow
    }
    
    internal func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        guard let tapClosure = tapClosure else { return }
        tapClosure()
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}
