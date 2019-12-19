
//
//  ENMusicInfo.swift
//  EaseNetMusic
//
//  Created by 蒋理智 on 2019/12/19.
//  Copyright © 2019 lizhi. All rights reserved.
//

import Foundation

struct ENDailyRecommendMusicData: Decodable {
    var code: Int?
    var message: String?
    var recommend: [ENMusicItem]?
}

struct ENMusicItem: Decodable {
    var starred: Bool?
    var mp3Url: String?
    var mvid: Int?
    var score: Int?
    var status: Int?
    var rtUrls: [String]?
    var copyrightId: Int?
    var copyFrom: String?
    var rurl: String?
    var artists: [ENMusicArtistItem]?
}

struct ENMusicArtistItem: Decodable {
    var imglv1Id: UInt64?
    var imglv1Url: String?
    var picUrl: String?
    var name: String?
    var id: Int?
}
