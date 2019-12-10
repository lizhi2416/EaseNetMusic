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
        
    static func saveUserModel(_ user: ENUserModel?) {
        var myEncodedObject: Data?
        if let user = user {
            myEncodedObject = NSKeyedArchiver.archivedData(withRootObject: user)
        }
        UserDefaults.standard.setValue(myEncodedObject, forKey: "userModel")
        UserDefaults.standard.synchronize()
    }
    
    func getUserModel() -> ENUserModel? {
        let myEncodedData = UserDefaults.standard.object(forKey: "userModel")
        if let data = myEncodedData as? Data {
            if let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? ENUserModel {
                return user
            }
        }
        return nil
    }
}

@objc class ENUserModel: NSObject, Codable, NSCoding {
    
    var code: Int?
    
    var loginType: Int?
    var account: ENUserAccount?
    var profile: ENUserProfile?
    var token: String?
    var bindings: [ENUserBindInfo]?
    
    required init?(coder: NSCoder) {
        
        super.init()
        
        var count: UInt32 = 0
        let list = class_copyIvarList(ENUserModel.self, &count)
        for i in 0..<Int(count) {
            if let iva = list?[i] {
                if let cName = ivar_getName(iva) {
                    if let name = String(utf8String: cName) {
                        //进行解档取值
                        let value = coder.decodeObject(forKey: name)
                        //利用KVC对属性赋值
                        self.setValue(value, forKey: name)
                    }
                }
            }
        }
        
    }
    
    func encode(with coder: NSCoder) {
        var count: UInt32 = 0
        let list = class_copyIvarList(ENUserModel.self, &count)
        for i in 0..<Int(count) {
            if let iva = list?[i] {
                if let cName = ivar_getName(iva) {
                    if let name = String(utf8String: cName) {
                        //利用KVC取值
                        let value = self.value(forKey: name)
                        coder.encode(value, forKey: name)
                    }
                }
            }
        }
    }
}

@objc class ENUserAccount: NSObject, Codable, NSCoding {
    var id: Int32?
    var userName: String?
    var type: Int?
    
    var status: Int?
    var whitelistAuthority: Int?
    var tokenVersion: Int?
    var ban: Int?
    var createTime: String?
    var baoyueVersion: Int?
    var donateVersion: Int?
    var salt: String?
    var vipType: Int?
    var viptypeVersion: Int?
    var anonimousUser: Bool?
    
    required init?(coder: NSCoder) {
        
        super.init()
        
        var count: UInt32 = 0
        let list = class_copyIvarList(ENUserAccount.self, &count)
        for i in 0..<Int(count) {
            if let iva = list?[i] {
                if let cName = ivar_getName(iva) {
                    if let name = String(utf8String: cName) {
                        //进行解档取值
                        let value = coder.decodeObject(forKey: name)
                        //利用KVC对属性赋值
                        self.setValue(value, forKey: name)
                    }
                }
            }
        }
        
    }
    
    func encode(with coder: NSCoder) {
        var count: UInt32 = 0
        let list = class_copyIvarList(ENUserAccount.self, &count)
        for i in 0..<Int(count) {
            if let iva = list?[i] {
                if let cName = ivar_getName(iva) {
                    if let name = String(utf8String: cName) {
                        //利用KVC取值
                        let value = self.value(forKey: name)
                        coder.encode(value, forKey: name)
                    }
                }
            }
        }
    }
}

@objc class ENUserProfile: NSObject, Codable, NSCoding {
    var defaultAvatar: Bool?
    var avatarUrl: String?
    var userId: Int32?
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
    var province: Bool?
    var authStatus: Int?
    var authority: Int?
    var mutual: Bool?
    var followeds: Int?
    var follows: Int?
    var eventCount: Bool?
    var playlistCount: Int?
    var playlistBeSubscribedCount: Int?
    
    required init?(coder: NSCoder) {
        
        super.init()
        
        var count: UInt32 = 0
        let list = class_copyIvarList(ENUserProfile.self, &count)
        for i in 0..<Int(count) {
            if let iva = list?[i] {
                if let cName = ivar_getName(iva) {
                    if let name = String(utf8String: cName) {
                        //进行解档取值
                        let value = coder.decodeObject(forKey: name)
                        //利用KVC对属性赋值
                        self.setValue(value, forKey: name)
                    }
                }
            }
        }
        
    }
    
    func encode(with coder: NSCoder) {
        var count: UInt32 = 0
        let list = class_copyIvarList(ENUserProfile.self, &count)
        for i in 0..<Int(count) {
            if let iva = list?[i] {
                if let cName = ivar_getName(iva) {
                    if let name = String(utf8String: cName) {
                        //利用KVC取值
                        let value = self.value(forKey: name)
                        coder.encode(value, forKey: name)
                    }
                }
            }
        }
    }
}

@objc class ENUserBindInfo: NSObject, Codable, NSCoding {
    var expired: Bool?
    var url: String?
    var userId: Int32?
    var tokenJsonStr: String?
    var bindingTime: Int32?
    var expiresIn: Int32?
    var refreshTime: Int32?
    var id: Int32?
    var type: Int?
    
    required init?(coder: NSCoder) {
        
        super.init()
        
        var count: UInt32 = 0
        let list = class_copyIvarList(ENUserBindInfo.self, &count)
        for i in 0..<Int(count) {
            if let iva = list?[i] {
                if let cName = ivar_getName(iva) {
                    if let name = String(utf8String: cName) {
                        //进行解档取值
                        let value = coder.decodeObject(forKey: name)
                        //利用KVC对属性赋值
                        self.setValue(value, forKey: name)
                    }
                }
            }
        }
        
    }
    
    func encode(with coder: NSCoder) {
        var count: UInt32 = 0
        let list = class_copyIvarList(ENUserBindInfo.self, &count)
        for i in 0..<Int(count) {
            if let iva = list?[i] {
                if let cName = ivar_getName(iva) {
                    if let name = String(utf8String: cName) {
                        //利用KVC取值
                        let value = self.value(forKey: name)
                        coder.encode(value, forKey: name)
                    }
                }
            }
        }
    }
}
