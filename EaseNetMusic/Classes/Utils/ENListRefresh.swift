//
//  CTRefresh.swift
//  Cartoon-Swift
//
//  Created by 蒋理智 on 2019/9/12.
//  Copyright © 2019 lizhi. All rights reserved.
//

import Foundation
import MJRefresh

public extension UIScrollView {
    /// 设置上下拉刷新
    func setPullRefreshBlock(pullHeader header: (() -> Void)?, pullFooter footer: (() -> Void)?) {
        
        if let header = header {
            let mjHeader = MJRefreshNormalHeader.init(refreshingBlock: header)
            mjHeader.lastUpdatedTimeLabel?.isHidden = true
            self.mj_header = mjHeader
        }
        
        if let footer = footer {
            let mjFooter = MJRefreshAutoNormalFooter.init(refreshingBlock: footer)
            mjFooter.setTitle("没有更多了哦~", for: .noMoreData)
            self.mj_footer = mjFooter
        }
        
    }
    /// 下拉刷新是否进行中
    func headerIsRefreshing() -> Bool {
        if let header = mj_header {
            return header.isRefreshing
        }
        return false
    }
    /// 上拉刷新是否进行中
    func footerIsRefreshing() -> Bool {
        if let footer = mj_footer {
            return footer.isRefreshing
        }
        return false
    }
    /// 下拉刷新开始
    func headerBeginRefreshing() {
        mj_header?.beginRefreshing()
    }
    /// 上拉刷新开始
    func footerBeginRefreshing() {
        mj_footer?.beginRefreshing()
    }
    /// 下拉刷新结束
    func headerEndRefreshing() {
        mj_header?.endRefreshing()
    }
    /// 上拉刷新结束
    func footerEndRefreshing() {
        mj_footer?.endRefreshing()
    }
    /// 上拉刷新结束不再可以上拉
    func footerEndRefreshNoMoreData() {
        mj_footer?.endRefreshingWithNoMoreData()
    }
    /// 上拉刷新空间隐藏
    func hideFooter(_ hide: Bool) {
        self.mj_footer?.isHidden = hide
    }
}
