//
//  AppDelegate.swift
//  Wishboard
//
//  Created by gomin on 2022/09/05.
//

import UIKit
import Kingfisher

@UIApplicationMain
//@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: LaunchScreen
        sleep(2)
        
        // MARK: Network check
        NetworkCheck.shared.startMonitoring()
        
        //MARK: UserDefaults
        UserDefaults.standard.set("http://3.39.165.250:3000", forKey: "url")
        // MARK: UserDefaults for Share Extension
        let defaults = UserDefaults(suiteName: "group.gomin.Wishboard.Share")
        defaults?.set("http://3.39.165.250:3000", forKey: "url")
        defaults?.synchronize()
        
        // MARK: Clean Cache
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

