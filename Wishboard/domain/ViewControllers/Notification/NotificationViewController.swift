//
//  NotificationViewController.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import UIKit

class NotificationViewController: UIViewController {
    var notiView: NotiView!
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        notiView = NotiView()
        self.view.addSubview(notiView)
        
        notiView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        // DATA
        NotificationDataManager().getNotificationListDataManager(self.notiView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goCalenderDidTap(sender:)))
        notiView.navigationView.addGestureRecognizer(tapGesture)
    }
    override func viewDidAppear(_ animated: Bool) {
        // DATA
        NotificationDataManager().getNotificationListDataManager(self.notiView)
    }
    // MARK: - Actions
    @objc func goCalenderDidTap(sender: UITapGestureRecognizer) {
        let calenderVC = CalenderViewController()
        calenderVC.modalPresentationStyle = .fullScreen
        self.present(calenderVC, animated: true, completion: nil)
    }
}
