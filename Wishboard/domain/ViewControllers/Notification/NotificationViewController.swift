//
//  NotificationViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import UIKit

class NotificationViewController: TitleLeftViewController {
    var notiView: NotiView!
    var refreshControl = UIRefreshControl()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        super.navigationTitle.text = "알림"
        
        notiView = NotiView()
        self.view.addSubview(notiView)
        
        notiView.preVC = self
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        notiView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
            make.bottom.equalToSuperview().offset(-tabBarHeight)
        }
        // DATA
        NotificationDataManager().getNotificationListDataManager(self.notiView)
        refreshControl.endRefreshing()
        // Refresh
        initRefresh()
    }
    override func viewDidAppear(_ animated: Bool) {
        // DATA
        NotificationDataManager().getNotificationListDataManager(self.notiView)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}
extension NotificationViewController {
    func initRefresh() {
        refreshControl.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        
        refreshControl.backgroundColor = .white
        refreshControl.tintColor = .black
        
        self.notiView.notificationTableView.refreshControl = refreshControl
    }
    
    @objc func refreshTable(refresh: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // DATA reload
            NotificationDataManager().getNotificationListDataManager(self.notiView)
            refresh.endRefreshing()
        }
    }
}
