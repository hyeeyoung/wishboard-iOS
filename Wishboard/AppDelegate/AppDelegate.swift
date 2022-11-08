//
//  AppDelegate.swift
//  Wishboard
//
//  Created by gomin on 2022/09/05.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseMessaging
import FirebaseCore
import UserNotifications

@UIApplicationMain
//@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: LaunchScreen
        sleep(2)
        
        // MARK: Network check
//        NetworkCheck.shared.startMonitoring()
        
        //MARK: UserDefaults
        UserDefaults.standard.set(Storage().BaseURL, forKey: "url")
        // MARK: UserDefaults for Share Extension
        let defaults = UserDefaults(suiteName: Storage().ShareExtension)
        defaults?.set(Storage().BaseURL, forKey: "url")
        defaults?.synchronize()
        
        // MARK: Clean Cache
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        
        // MARK: Device Model
        // device model
        let deviceModel = UIDevice.modelName
        UserDefaults.standard.set(deviceModel, forKey: "deviceModel")
        // OS version
        var systemVersion = UIDevice.current.systemVersion
        UserDefaults.standard.set(systemVersion, forKey: "OSVersion")
        // App version
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            UserDefaults.standard.set(appVersion, forKey: "appVersion")
        }
        
        // MARK: Firebase
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if granted {
                print("알림 등록이 완료되었습니다.")
            }
        }
        application.registerForRemoteNotifications()
        
        return true
    }

    // MARK: 세로방향 고정
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.portrait
    }
//    // MARK: Device Token
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
//        print("device token:", deviceTokenString)
//        UserDefaults.standard.set(deviceTokenString, forKey: "deviceToken")
//    }
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

extension AppDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("파이어베이스 토큰: \(fcmToken)")
        
        // 디바이스가 변경되었을 때에만 (기존의 디바이스 토큰과 지금 얻은 디바이스 토큰값이 다를 때에만)
        let preDeviceToken = UserDefaults.standard.string(forKey: "deviceToken") ?? ""
        print("이전 토큰:", preDeviceToken)
        if preDeviceToken != fcmToken {
            print("다르다!")
            DispatchQueue.main.async {
                UserDefaults.standard.set(fcmToken, forKey: "deviceToken")
            }
        } else {print("같다")}
        
    }
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print("Received data message: \(remoteMessage.appData)")
//    }
}
extension AppDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,didReceive response: UNNotificationResponse,withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
