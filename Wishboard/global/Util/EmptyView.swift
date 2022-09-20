//
//  EmptyView.swift
//  Wishboard
//
//  Created by gomin on 2022/09/21.
//

import Foundation
import UIKit

class EmptyView {
    // Collectionview
    func setEmptyView(_ message: String, _ collectionView: UICollectionView) {
        let messageLabel = UILabel().then{
            $0.font = UIFont.Suit(size: 14, family: .Regular)
            $0.textColor = .wishboardGray
            $0.textAlignment = .center
            $0.text = message
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
    func doNotSetEmptyView(_ collectionView: UICollectionView) {
        collectionView.backgroundView?.isHidden = true
    }
    // Tableview
    func setEmptyView(_ message: String, _ tableview: UITableView) {
        let messageLabel = UILabel().then{
            $0.font = UIFont.Suit(size: 14, family: .Regular)
            $0.textColor = .wishboardGray
            $0.textAlignment = .center
            $0.text = message
            $0.numberOfLines = 0
            $0.sizeToFit()
        }
        let backgroudView = UIView(frame: CGRect(x: 0, y: 0, width: tableview.bounds.width, height: tableview.bounds.height))
        backgroudView.addSubview(messageLabel)
        
        messageLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        tableview.backgroundView = backgroudView
    }
    func doNotSetEmptyView(_ tableview: UITableView) {
        tableview.backgroundView?.isHidden = true
    }
}
