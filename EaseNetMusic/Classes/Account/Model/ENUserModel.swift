//
//  ENUserModel.swift
//  EaseNetMusic
//
//  Created by 蒋理智 on 2019/12/9.
//  Copyright © 2019 lizhi. All rights reserved.
//

import Foundation

class ENSaveUitil {
    static func getLoginMark() -> Bool {
        let loginMark = UserDefaults.standard.bool(forKey: "loginMark")
        return loginMark
    }
    
    static func saveLoginMark(_ flag: Bool) {
        UserDefaults.standard.set(flag, forKey: "loginMark")
        UserDefaults.standard.synchronize()
    }
        
    static func saveUserModel(_ user: ENUserProfile?) {
        
        let data = NSMutableData()
        let archive = NSKeyedArchiver(forWritingWith: data)
        archive.encode(user, forKey: "userModelKey")
        archive.finishEncoding()
        UserDefaults.standard.setValue(data, forKey: "userModel")
        UserDefaults.standard.synchronize()
    }
    
    static func getUserModel() -> ENUserProfile? {
        let myEncodedData = UserDefaults.standard.object(forKey: "userModel")
        if let data = myEncodedData as? Data {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            if let user = unarchiver.decodeObject(forKey: "userModelKey") as? ENUserProfile {
                return user
            }
        }
        return nil
    }
}

class ENUserModel: Codable {
    
    var code: Int?
    var message: String?
    
    var loginType: Int?
    var account: ENUserAccount?
    var profile: ENUserProfile?
    var token: String?
    var bindings: [ENUserBindInfo]?
}

class ENUserAccount: Codable {
    var id: Int?
    var userName: String?
    var type: Int?
    
    var status: Int?
    var whitelistAuthority: Int?
    var tokenVersion: Int?
    var ban: Int?
    var createTime: Int?
    var baoyueVersion: Int?
    var donateVersion: Int?
    var salt: String?
    var vipType: Int?
    var viptypeVersion: Int?
    var anonimousUser: Bool?
}

class ENUserProfile: NSObject, Codable, NSCoding {
    var defaultAvatar: Bool?
    var avatarUrl: String?
    var userId: Int?
    var vipType: Int?
    var nickname: String?
    var gender: Int?
    var accountStatus: Int?
    var backgroundUrl: String?
    var detailDescription: String?
    var remarkName: String?
    var expertTags: String?
    var city: Int?
    var userType: Int?
    var province: Int?
    var authStatus: Int?
    var authority: Int?
    var mutual: Bool?
    var followeds: Int?
    var follows: Int?
    var eventCount: Int?
    var playlistCount: Int?
    var playlistBeSubscribedCount: Int?
    var token: String?
    
    
    required init?(coder: NSCoder) {
        self.defaultAvatar = coder.decodeObject(forKey: "defaultAvatar") as? Bool
        self.avatarUrl = coder.decodeObject(forKey: "avatarUrl") as? String
        self.userId = coder.decodeObject(forKey: "userId") as? Int
        self.vipType = coder.decodeObject(forKey: "vipType") as? Int
        self.nickname = coder.decodeObject(forKey: "nickname") as? String
        self.gender = coder.decodeObject(forKey: "gender") as? Int
        self.accountStatus = coder.decodeObject(forKey: "accountStatus") as? Int
        self.backgroundUrl = coder.decodeObject(forKey: "backgroundUrl") as? String
        self.detailDescription = coder.decodeObject(forKey: "detailDescription") as? String
        self.remarkName = coder.decodeObject(forKey: "remarkName") as? String
        self.expertTags = coder.decodeObject(forKey: "expertTags") as? String
        
        self.city = coder.decodeObject(forKey: "city") as? Int
        self.userType = coder.decodeObject(forKey: "userType") as? Int
        self.province = coder.decodeObject(forKey: "province") as? Int
        self.authority = coder.decodeObject(forKey: "authority") as? Int
        self.mutual = coder.decodeObject(forKey: "mutual") as? Bool
        self.followeds = coder.decodeObject(forKey: "followeds") as? Int
        self.eventCount = coder.decodeObject(forKey: "eventCount") as? Int
        self.playlistCount = coder.decodeObject(forKey: "playlistCount") as? Int
        self.playlistBeSubscribedCount = coder.decodeObject(forKey: "playlistBeSubscribedCount") as? Int
        self.token = coder.decodeObject(forKey: "token") as? String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.defaultAvatar, forKey: "defaultAvatar")
        coder.encode(self.avatarUrl, forKey: "avatarUrl")
        coder.encode(self.userId, forKey: "userId")
        coder.encode(self.vipType, forKey: "vipType")
        coder.encode(self.nickname, forKey: "nickname")
        coder.encode(self.gender, forKey: "gender")
        coder.encode(self.accountStatus, forKey: "accountStatus")
        coder.encode(self.backgroundUrl, forKey: "backgroundUrl")
        coder.encode(self.detailDescription, forKey: "detailDescription")
        coder.encode(self.remarkName, forKey: "remarkName")
        coder.encode(self.expertTags, forKey: "expertTags")
        coder.encode(self.city, forKey: "city")
        coder.encode(self.userType, forKey: "userType")
        coder.encode(self.province, forKey: "province")
        coder.encode(self.authStatus, forKey: "authStatus")
        coder.encode(self.authority, forKey: "authority")
        coder.encode(self.mutual, forKey: "mutual")
        coder.encode(self.followeds, forKey: "followeds")
        coder.encode(self.eventCount, forKey: "authority")
        coder.encode(self.playlistCount, forKey: "playlistCount")
        coder.encode(self.playlistBeSubscribedCount, forKey: "playlistBeSubscribedCount")
        coder.encode(self.token, forKey: "token")
    }
}

class ENUserBindInfo: Codable {
    var expired: Bool?
    var url: String?
    var userId: Int?
    var tokenJsonStr: String?
    var bindingTime: Int?
    var expiresIn: Int?
    var refreshTime: Int?
    var id: Int?
    var type: Int?
}

// MARK: - 利用runtimef归档解档要求属性都是OC类型，比较麻烦就不用了
//class Person: NSObject, NSCoding {
//
//    // MARK: - 自定义属性
//    @objc var age: NSInteger = 0                    //年龄
//    @objc var name: NSString?                       //姓名
//    @objc var height: CGFloat = 0.0                 //性别
//
//    // MARK: - 系统回调函数
//    override init() {
//        super.init()
//    }
//
//    // MARK: - 归档与解档
////    归档
//    func encode(with aCoder: NSCoder) {
//        let a: JSONSerialization = <#value#>
//
////        1.获取所有属性
////        1.1.创建保存属性个数的变量
//        var count: UInt32 = 0
////        1.2.获取变量的指针
//        let outCount: UnsafeMutablePointer<UInt32> = withUnsafeMutablePointer(to: &count) { (outCount: UnsafeMutablePointer<UInt32>) -> UnsafeMutablePointer<UInt32> in
//            return outCount
//        }
////        1.3.获取属性数组
//        let ivars = class_copyIvarList(Person.self, outCount)
//        for i in 0..<outCount.pointee {
////            2.获取键值对
////            2.1.获取ivars中的值
//            let ivar = ivars![Int(i)];
////            2.2.获取键
//            let ivarKey = String(cString: ivar_getName(ivar)!)
////            2.3.获取值
//            let ivarValue = value(forKey: ivarKey)
//
////            3.归档
//            aCoder.encode(ivarValue, forKey: ivarKey)
//        }
//
////        4.释放内存
//        free(ivars)
//    }
//
////    解档
//    required init?(coder aDecoder: NSCoder) {
//        super.init()
//
////        1.获取所有属性
////        1.1.创建保存属性个数的变量
//        var count: UInt32 = 0
////        1.2.获取变量的指针
//        let outCount = withUnsafeMutablePointer(to: &count) { (outCount: UnsafeMutablePointer<UInt32>) -> UnsafeMutablePointer<UInt32> in
//            return outCount
//        }
////        1.3.获取属性数组
//        let ivars = class_copyIvarList(Person.self, outCount)
//        for i in 0..<count {
////            2.获取键值对
////            2.1.获取ivars中的值
//            let ivar = ivars![Int(i)]
////            2.2.获取键
//            let ivarKey = String(cString: ivar_getName(ivar)!)
////            2.3.获取值
//            let ivarValue = aDecoder.decodeObject(forKey: ivarKey)
//
////            3.设置属性的值
//            setValue(ivarValue, forKey: ivarKey)
//        }
//
////        4.释放内存
//        free(ivars)
//    }
//
