//
//  TabBarViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit

class TabBarViewController: UITabBarController {
    let seperator = UIView().then{
        $0.backgroundColor = .gray_100
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .white
        
        self.tabBar.addSubview(seperator)
        seperator.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
       // 인스턴스화
        let wishListVC = HomeViewController()
        let folderVC = FolderViewController(btnImage: Image.newFolder)
        let addVC = UploadItemViewController()
        let noticeVC = NotificationViewController()
        let profileVC = MyPageViewController()
        
        wishListVC.tabBarItem.image = Image.wishlistTab
        folderVC.tabBarItem.image = Image.folderTab
        addVC.tabBarItem.image = Image.addTab
        noticeVC.tabBarItem.image = Image.noticeTab
        profileVC.tabBarItem.image = Image.profileTab
        
        addVC.isUploadItem = true
        
        wishListVC.tabBarItem.title = "WISHLIST"
        folderVC.tabBarItem.title = "FOLDER"
        addVC.tabBarItem.title = "ADD"
        noticeVC.tabBarItem.title = "NOTICE"
        profileVC.tabBarItem.title = "MY"
        
        self.tabBar.tintColor = .gray_700
        self.tabBar.unselectedItemTintColor = .gray_150
        let fontAttributes = [NSAttributedString.Key.font: TypoStyle.MontserratD1.font]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        
       // navigationController의 root view 설정
        let nav1 = UINavigationController(rootViewController: wishListVC)
        let nav2 = UINavigationController(rootViewController: folderVC)
        let nav3 = UINavigationController(rootViewController: addVC)
        let nav4 = UINavigationController(rootViewController: noticeVC)
        let nav5 = UINavigationController(rootViewController: profileVC)
    
        setViewControllers([nav1, nav2, nav3, nav4, nav5], animated: false)
    }
}
