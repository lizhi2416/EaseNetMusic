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
    var hotWallJson: JSON?
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
    
    lazy var bannerView: LLCycleScrollView = {
        let cycleScrollView = LLCycleScrollView().then({ (cycleScrollView) in
            cycleScrollView.backgroundColor = UIColor.background
            cycleScrollView.autoScrollTimeInterval = 5
            cycleScrollView.placeHolderImage = UIImage(named: "cm4_tvc_video_default_night")
//            bannerView.coverImage = UIImage()
            cycleScrollView.pageControlPosition = .center
            cycleScrollView.pageControlBottom = 20
            // 点击 item 回调
            cycleScrollView.lldidSelectItemAtIndex = didSelectBanner(index:)
        })
        return cycleScrollView
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
        ENHttpRuquest.loadJsonData(target: ENApi.getServiceResponse(ENHomeHotwallList, params: nil), Success: { [weak self] (json) in
            self?.hotWallJson = json
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
            if bannerJson == nil && recommentMusicListJson == nil && newestAlbumJson == nil && hotWallJson == nil {
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
            collectionView.register(ENDiscoverHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ENDiscoverHeaderReusableView")
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.setPullRefreshBlock(pullHeader: { [weak self] in
                self?.loadHomeNetData()
            }, pullFooter: {
                
            })
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
            return 6
        case 1:
            return 3
        case 2:
            return 5
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ENDiscoverCVCell", for: indexPath)
        if let cell = cell as? ENDiscoverCVCell {
            if indexPath.section == 0 {
                if self.recommentMusicListJson?["code"].int == 200 {
                    if let recommend = self.recommentMusicListJson?["recommend"].array {
                        cell.imageView.kf.setImage(with: URL(string: recommend[indexPath.item]["picUrl"].stringValue.httpsImageUrl), placeholder: UIImage(named: "cm2_default_edit_80"))
                        cell.titleLabel.text = recommend[indexPath.item]["name"].stringValue
                    }
                }
                
            } else if indexPath.section == 1 {
                if self.newestAlbumJson?["code"].int == 200 {
                    if let albums = self.newestAlbumJson?["albums"].array {
                        cell.imageView.kf.setImage(with: URL(string: albums[indexPath.item]["picUrl"].stringValue.httpsImageUrl), placeholder: UIImage(named: "cm2_default_edit_80"))
                        cell.titleLabel.text = albums[indexPath.item]["company"].stringValue
                    }
                }
            }
        }
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ENDiscoverHeaderReusableView", for: indexPath)
        if let reusableHeader = header as? ENDiscoverHeaderReusableView {
            if indexPath.section == 0 {
                self.bannerView.frame = CGRect(x: 0, y: 15, width: kScreenWidth, height: kScreenWidth * 7.0 / 18.0)
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
                        self.bannerView.titles = imageTitles
                        self.bannerView.imagePaths = imagePaths
                    }
                }
                header.addSubview(self.bannerView)
            }
            reusableHeader.titleLabel.text = sectionData[indexPath.section].0
            reusableHeader.moreBrn.setTitle(sectionData[indexPath.section].1, for: .normal)
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
            return CGSize(width: kScreenWidth, height: kScreenWidth * 7.0 / 18.0 + 30.0 + 100.0)
        }
        return CGSize(width: kScreenWidth, height: 50)
    }
    
}
