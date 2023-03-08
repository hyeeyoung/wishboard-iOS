//
//  EmptyView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/21.
//

import Foundation
import UIKit

class EmptyView {
    // MARK: - Views
    var message: String!
    let messageLabel = UILabel().then{
        $0.font = UIFont.Suit(size: 14, family: .Regular)
        $0.textColor = .wishboardGray
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    // MARK: - Methods
    func setEmptyView(_ message: String, _ collectionView: UICollectionView, _ count: Int) {
        self.message = message
        
        if count == 0 {showEmptyView(collectionView)}
        else {hideEmptyView(collectionView)}
    }
    func setEmptyView(_ message: String, _ tableView: UITableView, _ count: Int) {
        self.message = message
        
        if count == 0 {showEmptyView(tableView)}
        else {hideEmptyView(tableView)}
    }
    func setNotificationEmptyView(_ tableView: UITableView, _ count: Int, _ isCalender: Bool) {
        self.message = "앗, 일정이 없어요!\n상품 일정을 지정하고 알림을 받아보세요!"
        
        if count == 0 {showNotificationEmptyView(tableView, isCalender)}
        else {hideEmptyView(tableView)}
    }
    // MARK: - Layout
    func hierachy(_ collectionView: UICollectionView) {
        let backgroudView = UIView(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height))
        backgroudView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        collectionView.backgroundView = backgroudView
    }
    func hierachy(_ tableView: UITableView) {
        let backgroudView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        backgroudView.addSubview(messageLabel)
        
        messageLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        tableView.backgroundView = backgroudView
    }
    
    // MARK: - Show/Hide Methods
    // Collectionview
    func showEmptyView(_ collectionView: UICollectionView) {
        messageLabel.text = self.message
        
        hierachy(collectionView)
    }
    func hideEmptyView(_ collectionView: UICollectionView) {
        collectionView.backgroundView?.isHidden = true
    }
    // Tableview
    func showEmptyView(_ tableView: UITableView) {
        messageLabel.text = self.message
        
        hierachy(tableView)
    }
    func hideEmptyView(_ tableView: UITableView) {
        tableView.backgroundView?.isHidden = true
    }
    // MARK: - Notification Page Empty View
    // Notification Table View
    func showNotificationEmptyView(_ tableView: UITableView, _ isCalender: Bool) {
        let backgroudView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        
        let messageLabel = UILabel().then{
            $0.font = UIFont.Suit(size: 14, family: .Regular)
            $0.textColor = .wishboardGray
            $0.textAlignment = .center
            $0.text = self.message
            $0.numberOfLines = 0
            $0.sizeToFit()
        }
        let backView = UIView()
        let notiImage = UIImageView().then{
            $0.image = Image.notiLarge
        }
        
        backgroudView.addSubview(backView)
        backView.addSubview(notiImage)
        backView.addSubview(messageLabel)
        
        notiImage.snp.makeConstraints { make in
            make.width.equalTo(74)
            make.height.equalTo(75)
            make.top.centerX.equalToSuperview()
        }
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(notiImage.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
        backView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(131)
            make.width.greaterThanOrEqualTo(226)
            make.centerX.equalToSuperview()
            if isCalender {make.bottom.equalToSuperview().offset(-135)}
            else {make.centerY.equalToSuperview()}
            
        }
        
        tableView.backgroundView = backgroudView
    }
    // MARK: - Folder Set Tableview Empty View
    func showFolderTableViewEmptyView(_ tableView: UITableView, _ message: String, _ count: Int) {
        messageLabel.text = message
        
        let backgroudView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        backgroudView.addSubview(messageLabel)
        
        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(317/2))
        }
        
        tableView.backgroundView = backgroudView
        
        if count != 0 {hideEmptyView(tableView)}
    }
}
