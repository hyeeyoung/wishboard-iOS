//
//  NotiView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import Foundation
import UIKit

class NotiView: UIView {
    // MARK: - View
    let emptyMessage = "앗, 알림이 없어요!"
    // MARK: - Life Cycles
    var preVC: NotificationViewController!
    var notificationTableView: UITableView!
    var notiData: [NotificationModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTableView()
        setUpView()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setTableView() {
        notificationTableView = UITableView()
        notificationTableView.then{
            $0.delegate = self
            $0.dataSource = self
            $0.register(NotiTableViewCell.self, forCellReuseIdentifier: "NotiTableViewCell")
            
            // autoHeight
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.showsVerticalScrollIndicator = false
        }
    }
    func setUpView() {
        
        addSubview(notificationTableView)
    }
    func setUpConstraint() {
        
        notificationTableView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
}
// MARK: - Main TableView delegate
extension NotiView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.notiData.count ?? 0
        EmptyView().setEmptyView(self.emptyMessage, self.notificationTableView, count)
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotiTableViewCell", for: indexPath) as? NotiTableViewCell else { return UITableViewCell() }
        let itemIdx = indexPath.item
        cell.setUpData(self.notiData[itemIdx])
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.item
        // 쇼핑몰 이동
        if let urlStr = self.notiData[index].item_url {
            if urlStr != "" {
                ScreenManager().linkTo(viewcontroller: preVC, urlStr)
            } else {
                DispatchQueue.main.async {
                    SnackBar(self.preVC, message: .ShoppingLink)
                }
            }
        } else {
            DispatchQueue.main.async {
                SnackBar(self.preVC, message: .ShoppingLink)
            }
        }
        // 읽음 처리
        DispatchQueue.main.async {
            if let itemId = self.notiData[index].item_id {
                NotificationDataManager().readNotificationListDataManager(itemId, self)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
// MARK: - API Success
extension NotiView {
    // MARK: 알림 조회 API
    func getNotificationListAPISuccess(_ result: [NotificationModel]) {
        self.notiData = result
        // reload data with animation
        UIView.transition(with: notificationTableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
                              self.notificationTableView.reloadData()},
                          completion: nil);
        
    }
    func getNotificationListAPIFail() {
        NotificationDataManager().getNotificationListDataManager(self)
    }
    // MARK: 알림 읽음 처리 API
    func readNotificationAPISuccess(_ result: APIModel<ResultModel>) {
        NotificationDataManager().getNotificationListDataManager(self)
        print(result.message)
    }
}
