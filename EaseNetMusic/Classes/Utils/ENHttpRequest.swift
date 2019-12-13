//
//  CTHttpRequest.swift
//  Cartoon-Swift
//
//  Created by 蒋理智 on 2019/9/12.
//  Copyright © 2019 lizhi. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

let hudPlugin = NetworkActivityPlugin { (type, _) in
    switch type {
    case .began:
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    case .ended:
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

let timeoutClosure = {(endpoint: Endpoint, closure: MoyaProvider<ENApi>.RequestResultClosure) -> Void in
    
    if var urlRequest = try? endpoint.urlRequest() {
        ENLog("请求连接参数为:\(urlRequest.debugDescription)")
        urlRequest.timeoutInterval = 20
        closure(.success(urlRequest))
    } else {
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}
/// 网络请求类
public class ENHttpRuquest {
    //方式一：返回Data数据流便于Codable解析数据
    class func loadData<T: TargetType>(target: T, Success: @escaping ((Data) -> Void), Failure: ((Error) -> Void)? ) {
        
        let provider = MoyaProvider<T>(
            requestClosure: timeoutClosure,
            plugins: [hudPlugin])
        
        provider.request(target) { (result) in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                
                Success(data)
            case let .failure(error):
                Failure?(error)
            }
        }
        
    }
    //方式二：返回JSON数据适用于数据简单直接操作的场景
    class func loadJsonData<T: TargetType>(target: T, Success: @escaping ((JSON) -> Void), Failure: ((Error) -> Void)? ) {
        
        let provider = MoyaProvider<T>(
            requestClosure: timeoutClosure,
            plugins: [hudPlugin])
        
        provider.request(target) { (result) in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                
                guard let json = try? JSON(data: data) else {
                    let error = MoyaError.jsonMapping(moyaResponse)
                    Failure?(error)
                    return
                }
                
                Success(json)
            case let .failure(error):
                Failure?(error)
            }
        }
    }
}
