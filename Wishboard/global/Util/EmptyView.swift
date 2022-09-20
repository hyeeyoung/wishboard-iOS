//
//  EmptyView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/21.
//

import Foundation
import UIKit

class EmptyView {
    var message: String!
    
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
    // Collectionview
    func showEmptyView(_ collectionView: UICollectionView) {
        let messageLabel = UILabel().then{
            $0.font = UIFont.Suit(size: 14, family: .Regular)
            $0.textColor = .wishboardGray
            $0.textAlignment = .center
            $0.text = self.message
            $0.numberOfLines = 0
            $0.sizeToFit()
        }
        let backgroudView = UIView(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height))
        backgroudView.addSubview(messageLabel)
        
        messageLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        collectionView.backgroundView = backgroudView
    }
    func hideEmptyView(_ collectionView: UICollectionView) {
        collectionView.backgroundView?.isHidden = true
    }
    // Tableview
    func showEmptyView(_ tableView: UITableView) {
        let messageLabel = UILabel().then{
            $0.font = UIFont.Suit(size: 14, family: .Regular)
            $0.textColor = .wishboardGray
            $0.textAlignment = .center
            $0.text = self.message
            $0.numberOfLines = 0
            $0.sizeToFit()
        }
        let backgroudView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        backgroudView.addSubview(messageLabel)
        
        messageLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        tableView.backgroundView = backgroudView
    }
    func hideEmptyView(_ tableView: UITableView) {
        tableView.backgroundView?.isHidden = true
    }
}
