//
//  FolderCollectionViewCell.swift
//  Share Extension
//
//  Created by gomin on 2022/09/25.
//

import UIKit

class FolderCollectionViewCell: UICollectionViewCell {
    static let identifier = "FolderCollectionViewCell"
    
    let folderImage = UIImageView().then{
        $0.backgroundColor = .lightGray
    }
    let folderName = UILabel().then{
        $0.text = "folderName"
        $0.textColor = .white
        $0.font = UIFont.Suit(size: 10, family: .Regular)
        $0.numberOfLines = 1
    }
    let selectedView = UIView().then{
        $0.backgroundColor = .folderSelectedBackground
    }
    let selectedIcon = UIImageView().then{
        $0.image = UIImage(named: "check_white")
    }
    
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setUpView()
        setUpConstraint()
        
        self.selectedView.isHidden = true
        self.selectedIcon.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setUpView() {
        contentView.addSubview(folderImage)
        contentView.addSubview(folderName)
        contentView.addSubview(selectedView)
        contentView.addSubview(selectedIcon)
    }
    func setUpConstraint() {
        folderImage.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        folderName.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-6)
            make.centerX.equalToSuperview()
        }
        selectedView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        selectedIcon.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
//    func setUpData(_ data: WishListModel) {
//        if let image = data.itemImage {
//            self.itemImage.kf.setImage(with: URL(string: image), placeholder: UIImage())
//        }
//        if let name = data.itemName {self.itemName.text = name}
//        if let price = data.itemPrice {self.itemPrice.text = String(price)}
//        if let isCart = data.isCart {
//            if isCart {self.cartButton.cartButton(.wishboardGreen)}
//            else {self.cartButton.cartButton(.white)}
//        }
//    }
}
