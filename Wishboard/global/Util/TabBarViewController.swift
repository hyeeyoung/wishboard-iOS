//
//  TabBarViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .white
        
       // 인스턴스화
        let wishListVC = HomeViewController()
        let folderVC = HomeViewController()
        let addVC = HomeViewController()
        let noticeVC = HomeViewController()
        let profileVC = HomeViewController()
        
        wishListVC.tabBarItem.image = UIImage.init(named: "wishlist")
        folderVC.tabBarItem.image = UIImage.init(named: "folder")
        addVC.tabBarItem.image = UIImage.init(named: "add")
        noticeVC.tabBarItem.image = UIImage.init(named: "notice")
        profileVC.tabBarItem.image = UIImage.init(named: "profile")
        
        wishListVC.tabBarItem.title = "WISHLIST"
        folderVC.tabBarItem.title = "FOLDER"
        addVC.tabBarItem.title = "ADD"
        noticeVC.tabBarItem.title = "NOTICE"
        profileVC.tabBarItem.title = "MY"
        
        self.tabBar.tintColor = .black
//        let fontAttributes = [NSAttributedString.Key.font: UIFont.monteserrat(size: 9)]
//        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        
       // navigationController의 root view 설정
        let nav1 = UINavigationController(rootViewController: wishListVC)
        let nav2 = UINavigationController(rootViewController: folderVC)
        let nav3 = UINavigationController(rootViewController: addVC)
        let nav4 = UINavigationController(rootViewController: noticeVC)
        let nav5 = UINavigationController(rootViewController: profileVC)
    
        setViewControllers([nav1, nav2, nav3, nav4, nav5], animated: false)
    }
}
