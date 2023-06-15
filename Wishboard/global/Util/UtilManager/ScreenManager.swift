//
//  ScreenManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/23.
//

import Foundation
import UIKit
import SafariServices

class ScreenManager {
    enum Family: String {
        case itemDeleted, profileModified, passwordModified, itemUpload, itemModified
    }
    func goMain(_ viewcontroller: UIViewController) {
        // 첫화면으로 전환
        guard let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarViewController") as? UITabBarController else {return}
        viewcontroller.navigationController?.pushViewController(tabBarController, animated: true)
//        viewcontroller.view.window?.windowScene?.keyWindow?.rootViewController = tabBarController
    }
    func goMainPages(_ index: Int, _ viewcontroller: UIViewController) {
        guard let tabBarController = viewcontroller.tabBarController else {return}
        tabBarController.selectedIndex = index
        tabBarController.modalPresentationStyle = .fullScreen
        viewcontroller.view.window?.windowScene?.keyWindow?.rootViewController = tabBarController
    }
    // tabBar가 없는 뷰에서 메인으로 이동할 때
    func goMainPages(_ index: Int, _ viewcontroller: UIViewController, family: Family) {
        guard let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarViewController") as? UITabBarController else {return}
        tabBarController.selectedIndex = index
        tabBarController.modalPresentationStyle = .fullScreen
        viewcontroller.view.window?.windowScene?.keyWindow?.rootViewController = tabBarController
        
        switch family {
            case .itemDeleted:
                SnackBar(tabBarController, message: .deleteItem)
            case .profileModified:
                SnackBar(tabBarController, message: .modifyProfile)
            case .passwordModified:
                SnackBar(tabBarController, message: .modifyPassword)
            case .itemUpload:
                SnackBar(tabBarController, message: .addItem)
            case .itemModified:
                SnackBar(tabBarController, message: .modifyItem)
            default:
                viewcontroller.view.window?.windowScene?.keyWindow?.rootViewController = tabBarController
        }
    }
    // MARK: - 링크 이동
    func linkTo(viewcontroller: UIViewController, _ urlStr: String) {
        guard let url = NSURL(string: urlStr) else {return}
        let linkView: SFSafariViewController = SFSafariViewController(url: url as URL)
        viewcontroller.present(linkView, animated: true, completion: nil)
    }
    // MARK: - 로그아웃 후, Onboarding 화면으로 이동
    func goToOnboarding(_ viewcontroller: UIViewController) {
        // delete UserInfo
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.set(false, forKey: "isFirstLogin")
        UserDefaults(suiteName: "group.gomin.Wishboard.Share")?.removeObject(forKey: "accessToken")
        
        // 화면 전환
        let onboardingVC = OnBoardingViewController()
        viewcontroller.navigationController?.pushViewController(onboardingVC, animated: true)
    }
}
