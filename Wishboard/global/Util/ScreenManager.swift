//
//  ScreenManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/23.
//

import Foundation
import UIKit

class ScreenManager {
    enum Family: String {
        case itemDeleted, profileModified
    }
    func goMain(_ viewcontroller: UIViewController) {
        // 첫화면으로 전환
        guard let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarViewController") as? UITabBarController else {return}
        tabBarController.modalPresentationStyle = .fullScreen
        viewcontroller.view.window?.windowScene?.keyWindow?.rootViewController = tabBarController
    }
    func goMainPages(_ index: Int, _ viewcontroller: UIViewController) {
        guard let tabBarController = viewcontroller.tabBarController else {return}
        tabBarController.selectedIndex = index
        tabBarController.viewDidLoad()
        tabBarController.modalPresentationStyle = .fullScreen
        viewcontroller.view.window?.windowScene?.keyWindow?.rootViewController = tabBarController
    }
    // tabBar가 없는 뷰에서 메인으로 이동할 때
    func goMainPages(_ index: Int, _ viewcontroller: UIViewController, family: Family) {
        guard let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarViewController") as? UITabBarController else {return}
        tabBarController.selectedIndex = index
        tabBarController.viewDidLoad()
        tabBarController.modalPresentationStyle = .fullScreen
        viewcontroller.view.window?.windowScene?.keyWindow?.rootViewController = tabBarController
        
        switch family {
        case .itemDeleted:
            SnackBar(tabBarController, "아이템을 위시리스트에서 삭제했어요!🗑")
        case .profileModified:
            SnackBar(tabBarController, "프로필이 수정되었어요!👩‍🎤")
        default:
            viewcontroller.view.window?.windowScene?.keyWindow?.rootViewController = tabBarController
        }
    }
}
