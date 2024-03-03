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
    static let shared = ScreenManager()

    private init() {
        
    }
    
    enum Family: String {
        case itemModified
    }
    func goMain() {
        // 첫화면으로 전환
        let tbc = TabBarViewController()
        tbc.selectedIndex = 0
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(tbc, animated: true)
    }
    func goMainPages(_ index: Int) {
        let tbc = TabBarViewController()
        tbc.selectedIndex = index
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(tbc, animated: true)
    }
    // tabBar가 없는 뷰에서 메인으로 이동할 때
    func goMainPages(_ index: Int, _ viewcontroller: UIViewController, family: Family) {
        let tbc = TabBarViewController()
        tbc.selectedIndex = index
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(tbc, animated: true)
        
        switch family {
            case .itemModified:
                SnackBar.shared.showSnackBar(tbc, message: .modifyItem)
            default:
                fatalError()
        }
    }
    // MARK: - 링크 이동
    func linkTo(viewcontroller: UIViewController, _ urlStr: String) {
        guard let url = NSURL(string: urlStr) else {return}
        let linkView: SFSafariViewController = SFSafariViewController(url: url as URL)
        viewcontroller.present(linkView, animated: true, completion: nil)
    }
    // MARK: - 로그아웃 후, Onboarding 화면으로 이동
    func goToOnboarding() {
        // delete UserInfo
        UserManager.removeUserData()
        
        // 온보딩 화면 전환
        let navigationController = UINavigationController(rootViewController: OnBoardingViewController())
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(navigationController, animated: true)
    }
}
