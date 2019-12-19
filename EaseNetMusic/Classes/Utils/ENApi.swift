//
//  CTAPI.swift
//  Cartoon-Swift
//
//  Created by 蒋理智 on 2019/9/11.
//  Copyright © 2019 lizhi. All rights reserved.
//

import Foundation
import Moya

let ENLoginApiPath = "login/cellphone"
/// ?type=2
let ENGetBannerListPath = "banner"
/// 需要登录
let ENGetRecommendMusicListPath = "recommend/resource"
/// 首页新碟数据
let ENHomeNewestAlbumList = "album/newest"
/// ?type=96全部:0华语:7欧美:96日本:8韩国:16
let ENHomeNewSongRecommendList = "top/song"
/// 云村
let ENHomeHotwallList = "comment/hotwall/list"
/// MV
let ENHomeRecommendMVList = "personalized/mv"
/// 每日推荐歌曲需要登录
let ENDailyRecommendMusicSongs = "recommend/songs"


enum ENApi {
    /// 所有get请求
    case getServiceResponse(_ path: String, params: [String: Any]?)
    /// 所有post请求
    case postServiceResponse(_ path: String, params: [String: Any]?)
}

extension ENApi: TargetType {
    
    /// http://localhost:3000
    var baseURL: URL { return URL(string: "http://192.168.1.164:3000")! }
    
    var path: String {
        switch self {
        case .getServiceResponse(let path, _): return path
        case .postServiceResponse(let path,  _): return path
        }
    }
    /// 如果有其他请求类型再添加即可
    var method: Moya.Method {
        switch self {
        case .getServiceResponse:
            return .get
        case .postServiceResponse:
            return .post
        }
    }
        
    var task: Task {
//        timestamp=1503019930000
        var parmeters: [String: Any] = ["timestamp": Date().timeIntervalSince1970]
        switch self {
        case .getServiceResponse(_, let params):
            if let params = params {
                for (key, value) in params {
                    parmeters[key] = value
                }
            }
        case .postServiceResponse(_, let params):
            if let params = params {
                for (key, value) in params {
                    parmeters[key] = value
                }
            }
        }
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
    
    var sampleData: Data { return "".data(using: String.Encoding.utf8)! }
    var headers: [String: String]? { return nil }
}

