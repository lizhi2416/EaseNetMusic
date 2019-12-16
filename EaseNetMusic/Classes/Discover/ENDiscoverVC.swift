//
//  ENDiscoverVC.swift
//  EaseNetMusic
//
//  Created by 蒋理智 on 2019/12/6.
//  Copyright © 2019 lizhi. All rights reserved.
//

import UIKit

class ENDiscoverVC: ENCustomNavController, UISearchBarDelegate {
    
    weak var playHud: NAKPlaybackIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
// MARK: - override super
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func navigationBar(_ navigationBar: ENCustomNavBar, customLeftButton leftButton: UIButton?) -> Bool {
        leftButton?.setImage(UIImage(named: "mic_listen_music_icon"), for: .normal)
        return true
    }

    override func rightViewForNavigationBar(_ navigationBar: ENCustomNavBar) -> UIView? {
        let style = NAKPlaybackIndicatorViewStyle(barCount: 4, barWidth: 2.0, maxBarSpacing: 5.0, idleBarHeight: 12.0, minPeakBarHeight: 8.0, maxPeakBarHeight: 26.0)
        let rightView = NAKPlaybackIndicatorView.init(frame: CGRect(x: 0, y: 0, width: 50, height: 44), style: style)
        rightView?.tintColor = UIColor.black
        rightView?.hidesWhenStopped = false
        rightView?.state = .playing
        playHud = rightView
        return rightView
    }
    
    override func titleViewForNavigationBar(_ navigationBar: ENCustomNavBar) -> UIView? {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: kScreenWidth-100, height: 32))
        searchBar.delegate = self
        searchBar.placeholder = "搜索音乐"
        searchBar.backgroundColor = UIColor.clear
        searchBar.textField?.font = UIFont.systemFont(ofSize: 14)
//        searchBar.barTintColor = [UIColor lightGrayColor];
//        searchBar.tintColor = JWOrangeColor;
        searchBar.backgroundImage = UIImage()
        let searchFieldBackImg = UIImage(named: "searchbar_bg_icon")?.resizableImage(withCapInsets: UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0), resizingMode: .stretch)
        searchBar.setSearchFieldBackgroundImage(searchFieldBackImg, for: .normal)
        searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 3.0, vertical: 0)
        
        let offsetX: CGFloat = (kScreenWidth - 100 - 90) / 2.0
        searchBar.setPositionAdjustment(UIOffset(horizontal: offsetX, vertical: 0), for: .search)
        let searchImg = UIImage(named: "cm2_topbar_icn_search")?.withRenderingMode(.alwaysOriginal)
        searchBar.setImage(searchImg, for: .search, state: .normal)
        
        return searchBar
    }
// MARK: - UISearchBarDelegate
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        var stateValue: Int = playHud.state.rawValue + 1
        if stateValue > 2 {
            stateValue = 0
        }
        playHud.state = NAKPlaybackIndicatorViewState(rawValue: stateValue)!
        
        ENHttpRuquest.loadJsonData(target: ENApi.getServiceResponse(ENGetRecommendMusicListPath, params: nil), Success: { (json) in
            
        }, Failure: { (error) in
            
        })
        
        return false
    }
    
}
