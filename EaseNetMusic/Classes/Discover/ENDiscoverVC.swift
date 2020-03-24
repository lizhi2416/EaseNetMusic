//
//  ENDiscoverVC.swift
//  EaseNetMusic
//
//  Created by 蒋理智 on 2019/12/6.
//  Copyright © 2019 lizhi. All rights reserved.
//

import UIKit
import LLCycleScrollView
import Then
import SwiftyJSON

class ENDiscoverVC: ENCustomNavController, UISearchBarDelegate {
    
    weak var playHud: NAKPlaybackIndicatorView!
    
    var bannerJson: JSON?
    var recommentMusicListJson: JSON?
    var newestAlbumJson: JSON?
    var mvListJson: JSON?
    let sectionData: [(String, String)] = [("推荐歌单", "歌单广场"), ("新歌", "更多新歌"), ("云村精选", "获取新内容")]
    
    var loadHud = UIActivityIndicatorView(style: .gray)
    lazy var loadFailBtn: UIButton = {
        let btn = UIButton(type: .custom).then { (btn) in
            btn.setTitle("加载失败，点击重试", for: .normal)
            btn.setTitleColor(UIColor.lightGray, for: .normal)
            btn.addTarget(self, action: #selector(clickFailBtn(_:)), for: .touchUpInside)
        }
        return btn
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    
    
    lazy var toolBtns: [UIControl] = {
        
        var btns = [UIControl]()
        
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
            btn.addTarget(self, action: #selector(clickToolBarBtn(_:)), for: .touchUpInside)
            btn.addSubview(imageView)
            btn.addSubview(titleLabel)
            btns.append(btn)
//            header.addSubview(btn)
        }
        return btns
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(loadHud)
        loadHud.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        
        loadHud.startAnimating()
        self.loadHomeNetData()
    }
// MARK: - private method
    func loadHomeNetData() {
        
        let group = DispatchGroup()
        group.enter()
        ENHttpRuquest.loadJsonData(target: ENApi.getServiceResponse(ENGetRecommendMusicListPath, params: nil), Success: { [weak self] (json) in
            self?.recommentMusicListJson = json
            group.leave()
        }, Failure: { (_) in
            group.leave()
        })
        
        group.enter()
        ENHttpRuquest.loadJsonData(target: ENApi.getServiceResponse(ENGetBannerListPath, params: ["type": 2]), Success: { [weak self] (json) in
            self?.bannerJson = json
            group.leave()
        }, Failure: { (_) in
            group.leave()
        })
        
        group.enter()
        ENHttpRuquest.loadJsonData(target: ENApi.getServiceResponse(ENHomeNewestAlbumList, params: nil), Success: { [weak self] (json) in
            self?.newestAlbumJson = json
            group.leave()
        }, Failure: { (_) in
            group.leave()
        })
        
        group.enter()
        ENHttpRuquest.loadJsonData(target: ENApi.getServiceResponse(ENHomeRecommendMVList, params: nil), Success: { [weak self] (json) in
            self?.mvListJson = json
            group.leave()
        }, Failure: { (_) in
            group.leave()
        })

        group.notify(queue: DispatchQueue.main) { [weak self] in
            ENLog("所有请求完成")
            self?.updateUI()
        }
        
//        group.wait()
    }
    
    func updateUI() {
        collectionView.headerEndRefreshing()
        loadHud.stopAnimating()
        if collectionView.superview == nil {
            if bannerJson == nil && recommentMusicListJson == nil && newestAlbumJson == nil && mvListJson == nil {
                self.view.addSubview(loadFailBtn)
                loadFailBtn.snp.makeConstraints { (make) in
                    make.center.equalToSuperview()
                }
                return
            }
        }
        loadFailBtn.removeSubviews()
        if collectionView.superview == nil {
            collectionView.register(ENDiscoverCVCell.self, forCellWithReuseIdentifier: "ENDiscoverCVCell")
            collectionView.register(ENDiscoverMVListCell.self, forCellWithReuseIdentifier: "ENDiscoverMVListCell")
            collectionView.register(ENDiscoverHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ENDiscoverHeaderReusableView")
            collectionView.register(ENDiscoverTopHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ENDiscoverTopHeaderReusableView")
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.setPullRefreshBlock(pullHeader: { [weak self] in
                self?.loadHomeNetData()
            }, pullFooter: nil)
            self.view.addSubview(collectionView)
            collectionView.snp.makeConstraints { (make) in
                make.top.equalTo(self.navBar.snp.bottom)
                make.leading.trailing.bottom.equalToSuperview()
            }
            
        }
        collectionView.reloadData()
        
    }
// MARK: - click event
    @objc func clickFailBtn(_ btn: UIButton) {
        self.loadHud.startAnimating()
        self.loadHomeNetData()
    }
    func didSelectBanner(index: Int) {
        
    }
    @objc func clickToolBarBtn(_ btn: UIControl) {
        if btn.tag == 100 {
            self.navigationController?.pushViewController(ENDailyRecommendListVC(), animated: true)
        } else if btn.tag == 101 {
            
        } else if btn.tag == 102 {
            
        } else if btn.tag == 103 {
            
        }
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
        
        
        
        return false
    }
    
}

extension ENDiscoverVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
        if self.recommentMusicListJson?["code"].int == 200 {
            if let recommends = self.recommentMusicListJson?["recommend"].array {
                return recommends.count > 6 ? 6 : recommends.count
            }
        }
            return 0
        case 1:
        if self.newestAlbumJson?["code"].int == 200 {
            if let albums = self.newestAlbumJson?["albums"].array {
                return albums.count > 3 ? 3 : albums.count
            }
        }
            return 0
        case 2:
        if self.mvListJson?["code"].int == 200 {
            if let result = self.mvListJson?["result"].array {
                return result.count > 5 ? 5 : result.count
            }
        }
            return 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ENDiscoverCVCell", for: indexPath)
            if let cell = cell as? ENDiscoverCVCell {
                if self.recommentMusicListJson?["code"].int == 200 {
                    if let recommend = self.recommentMusicListJson?["recommend"].array {
                        cell.imageView.kf.setImage(with: URL(string: recommend[indexPath.item]["picUrl"].stringValue.httpsImageUrl), placeholder: UIImage(named: "cm2_default_edit_80"))
                        cell.titleLabel.text = recommend[indexPath.item]["name"].stringValue
                    }
                }
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ENDiscoverCVCell", for: indexPath)
            if let cell = cell as? ENDiscoverCVCell {
                if self.newestAlbumJson?["code"].int == 200 {
                    if let albums = self.newestAlbumJson?["albums"].array {
                        cell.imageView.kf.setImage(with: URL(string: albums[indexPath.item]["picUrl"].stringValue.httpsImageUrl), placeholder: UIImage(named: "cm2_default_edit_80"))
                        cell.titleLabel.text = albums[indexPath.item]["company"].stringValue
                    }
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ENDiscoverMVListCell", for: indexPath)
            if let cell = cell as? ENDiscoverMVListCell {
                if self.mvListJson?["code"].int == 200 {
                    if let result = self.mvListJson?["result"].array {
                        cell.imageView.kf.setImage(with: URL(string: result[indexPath.item]["picUrl"].stringValue.httpsImageUrl), placeholder: UIImage(named: "cm4_tvc_video_default_night"))
                        cell.titleLabel.text = result[indexPath.item]["copywriter"].stringValue
                    }
                }
            }
            return cell
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 0 {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ENDiscoverTopHeaderReusableView", for: indexPath)
            if let reusableHeader = header as? ENDiscoverTopHeaderReusableView {
                // 点击 item 回调
                reusableHeader.bannerView.lldidSelectItemAtIndex = didSelectBanner(index:)
                if let bannerData = bannerJson {
                    if bannerData["code"].int == 200 {
                        var imagePaths = [String]()
                        var imageTitles = [String]()
                        if let banners = bannerData["banners"].array {
                            banners.forEach { (banner) in
                                let imageUrl = banner["pic"].stringValue.httpsImageUrl
                                imageTitles.append(banner["typeTitle"].stringValue)
                                imagePaths.append(imageUrl)
                            }
                        }
                        reusableHeader.bannerView.titles = imageTitles
                        reusableHeader.bannerView.imagePaths = imagePaths
                    }
                }
                
                for toolBtn in reusableHeader.toolBtns {
                    toolBtn.addTarget(self, action: #selector(clickToolBarBtn(_:)), for: .touchUpInside)
                }
                
                reusableHeader.titleLabel.text = sectionData[indexPath.section].0
                reusableHeader.moreBrn.setTitle(sectionData[indexPath.section].1, for: .normal)
                
            }
            return header
        } else {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ENDiscoverHeaderReusableView", for: indexPath)
            if let reusableHeader = header as? ENDiscoverHeaderReusableView {
                reusableHeader.titleLabel.text = sectionData[indexPath.section].0
                reusableHeader.moreBrn.setTitle(sectionData[indexPath.section].1, for: .normal)
            }
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 2 {
            return CGSize(width: kScreenWidth, height: (kScreenWidth-30)/2.0 + 60)
        }
        let itemWidth = (kScreenWidth-30-20)/3.0
        return CGSize(width: itemWidth, height: itemWidth+30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 2 {
            return UIEdgeInsets.zero
        }
        return UIEdgeInsets(top: 0, left: 15.0, bottom: 10.0, right: 15.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section==0 {
            return CGSize(width: kScreenWidth, height: kScreenWidth / 3.0 + 30.0 + 80.0 + 50.0)
        }
        return CGSize(width: kScreenWidth, height: 50)
    }
    
}
