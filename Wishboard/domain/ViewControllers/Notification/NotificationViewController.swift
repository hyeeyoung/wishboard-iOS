//
//  NotificationViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import UIKit

class NotificationViewController: UIViewController {
    var notiView: NotiView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        notiView = NotiView()
        self.view.addSubview(notiView)
        
        notiView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        // DATA
        NotificationDataManager().getNotificationListDataManager(self.notiView)
    }
    override func viewDidAppear(_ animated: Bool) {
        // DATA
        NotificationDataManager().getNotificationListDataManager(self.notiView)
    }
}
