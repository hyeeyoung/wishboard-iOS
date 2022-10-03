//
//  NotificationViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import UIKit

class NotificationViewController: TitleLeftViewController {
    var notiView: NotiView!
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        super.navigationTitle.text = "알림"
        
        notiView = NotiView()
        self.view.addSubview(notiView)
        
        notiView.preVC = self
        notiView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
        // DATA
        NotificationDataManager().getNotificationListDataManager(self.notiView)
    }
    override func viewDidAppear(_ animated: Bool) {
        // DATA
        NotificationDataManager().getNotificationListDataManager(self.notiView)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}
