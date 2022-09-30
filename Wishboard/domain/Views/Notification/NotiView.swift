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
    let navigationView = UIView()
    let titleLabel = UILabel().then{
        $0.text = "알림"
        $0.font = UIFont.Suit(size: 22, family: .Bold)
    }
    let emptyMessage = "앗, 알림이 없어요!"
    // MARK: - Life Cycles
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
        addSubview(navigationView)
        navigationView.addSubview(titleLabel)
        
        addSubview(notificationTableView)
    }
    func setUpConstraint() {
        setUpNavigationConstraint()
        
        notificationTableView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom)
        }
    }
    func setUpNavigationConstraint() {
        navigationView.snp.makeConstraints { make in
            if CheckNotch().hasNotch() {make.top.equalToSuperview().offset(50)}
            else {make.top.equalToSuperview().offset(20)}
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
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
        tableView.deselectRow(at: indexPath, animated: true)
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
}
