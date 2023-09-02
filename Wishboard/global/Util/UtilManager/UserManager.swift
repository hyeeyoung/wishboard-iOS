//
//  UserManager.swift
//  Wishboard
//
//  Created by gomin on 2023/09/02.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    let storage: UserDefaults
    
    var wrappedValue: T {
        get { self.storage.object(forKey: self.key) as? T ?? self.defaultValue }
        set { self.storage.set(newValue, forKey: self.key) }
    }
    
    init(key: String, defaultValue: T, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
}

class UserManager {
    @UserDefault(key: UserDefaultKey.accessToken, defaultValue: nil)
    static var accessToken: String?
    
    @UserDefault(key: UserDefaultKey.refreshToken, defaultValue: nil)
    static var refreshToken: String?
    
    @UserDefault(key: UserDefaultKey.url, defaultValue: nil)
    static var url: String?
    
    @UserDefault(key: UserDefaultKey.deviceModel, defaultValue: nil)
    static var deviceModel: String?
    
    @UserDefault(key: UserDefaultKey.OSVersion, defaultValue: nil)
    static var OSVersion: String?
    
    @UserDefault(key: UserDefaultKey.appVersion, defaultValue: nil)
    static var appVersion: String?
    
    @UserDefault(key: UserDefaultKey.appBuildVersion, defaultValue: nil)
    static var appBuildVersion: String?
    
    @UserDefault(key: UserDefaultKey.deviceToken, defaultValue: nil)
    static var deviceToken: String?
    
    @UserDefault(key: UserDefaultKey.email, defaultValue: nil)
    static var email: String?
    
    @UserDefault(key: UserDefaultKey.password, defaultValue: nil)
    static var password: String?
    
    @UserDefault(key: UserDefaultKey.isFirstLogin, defaultValue: nil)
    static var isFirstLogin: Bool?
    
    @UserDefault(key: UserDefaultKey.tempNickname, defaultValue: nil)
    static var tempNickname: String?
    
    
    
    static func removeUserData() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.set(false, forKey: "isFirstLogin")
        UserDefaults(suiteName: "group.gomin.Wishboard.Share")?.removeObject(forKey: "accessToken")
        UserDefaults(suiteName: "group.gomin.Wishboard.Share")?.removeObject(forKey: "refreshToken")
    }
}

struct UserDefaultKey {
    static let accessToken = "accessToken"
    static let refreshToken = "refreshToken"
    
    static let url = "url"
    
    static let deviceModel = "deviceModel"
    static let OSVersion = "OSVersion"
    static let appVersion = "appVersion"
    static let appBuildVersion = "appBuildVersion"
    static let deviceToken = "deviceToken"
    
    static let email = "email"
    static let password = "password"
    static let isFirstLogin = "isFirstLogin"
    static let tempNickname = "tempNickname"
    
}
