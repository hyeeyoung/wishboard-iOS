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
        
        notiView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
        // DATA
        NotificationDataManager().getNotificationListDataManager(self.notiView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goCalenderDidTap(sender:)))
        super.navigationView.addGestureRecognizer(tapGesture)
    }
    override func viewDidAppear(_ animated: Bool) {
        // DATA
        NotificationDataManager().getNotificationListDataManager(self.notiView)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    // MARK: - Actions
    @objc func goCalenderDidTap(sender: UITapGestureRecognizer) {
        let calenderVC = CalenderViewController()
        calenderVC.modalPresentationStyle = .fullScreen
        self.present(calenderVC, animated: true, completion: nil)
    }
}
