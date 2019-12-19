//
//  ENDailyRecommendListVC.swift
//  EaseNetMusic
//
//  Created by 蒋理智 on 2019/12/19.
//  Copyright © 2019 lizhi. All rights reserved.
//

import UIKit

class ENDailyRecommendListCell: UITableViewCell {
    
    var coverImgV: UIImageView = UIImageView()
    var nameLabel: UILabel = UILabel()
    var infoLabel = UILabel()
    
    var musicItem: ENMusicItem? {
        didSet {
            coverImgV.kf.setImage(with: URL(string: musicItem?.artists?.first?.picUrl?.httpsImageUrl ?? ""), placeholder: UIImage(named: "cm2_default_edit_80"))
            nameLabel.text = musicItem?.artists?.first?.name
            infoLabel.text = "歌曲信息"
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        coverImgV.clipsToBounds = true
        coverImgV.layer.cornerRadius = 4.0
        coverImgV.contentMode = .scaleAspectFill
        self.contentView.addSubview(coverImgV)
        
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.textColor = UIColor.black
        self.contentView.addSubview(nameLabel)
        
        infoLabel.font = UIFont.systemFont(ofSize: 12)
        infoLabel.textColor = UIColor.lightGray
        self.contentView.addSubview(infoLabel)
        
        coverImgV.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15.0)
            make.top.equalToSuperview().offset(10.0)
            make.width.height.equalTo(40.0)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(coverImgV.snp.trailing).offset(10)
            make.top.equalTo(coverImgV)
            make.height.equalTo(24.0)
        }
        
        infoLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel)
            make.bottom.equalTo(coverImgV)
            make.height.equalTo(16.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ENDailyRecommendListVC: ENCustomNavController {
    
    var loadHud: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    var musicLists = [ENMusicItem]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.rowHeight = 60.0
        tableView.estimatedRowHeight = 0
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "每日推荐"
        
        tableView.register(ENDailyRecommendListCell.self, forCellReuseIdentifier: "ENDailyRecommendListCell")
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
        }
        
        view.addSubview(loadHud)
        loadHud.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        getDailyMusicData()
    }
    
    func getDailyMusicData() {
        
        loadHud.startAnimating()
        
        ENHttpRuquest.loadData(target: ENApi.getServiceResponse(ENDailyRecommendMusicSongs, params: nil), Success: { [weak self] (data) in
                  
            if let recommendData = try? JSONDecoder().decode(ENDailyRecommendMusicData.self, from: data) {
                if recommendData.code == 200 {
                    if let recommend = recommendData.recommend {
                        self?.musicLists.append(contentsOf: recommend)
                    }
                }
            }
            
            self?.setupEmptyShow()
            
        }) { [weak self] (error) in
            self?.view.makeToast(error.localizedDescription)
            self?.setupEmptyShow()
        }
    }
    
    func setupEmptyShow() {
        loadHud.stopAnimating()
        tableView.setEmptyData(image: "cm4_my_empty_pic", verticalOffset: -50) { [weak self] in
            self?.getDailyMusicData()
        }
        tableView.reloadData()
    }

}

extension ENDailyRecommendListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ENDailyRecommendListCell")
        if let cell = cell as? ENDailyRecommendListCell {
            cell.musicItem = musicLists[indexPath.row]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
