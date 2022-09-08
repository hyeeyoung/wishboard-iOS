//
//  WishListCollectionViewCell.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit
import Kingfisher

class WishListCollectionViewCell: UICollectionViewCell {
    static let identifier = "WishListCollectionViewCell"
    
    let itemImage = UIImageView().then{
        $0.backgroundColor = .lightGray
    }
    let itemName = UILabel().then{
        $0.text = "itemName"
        $0.font = UIFont.nanumSquare(size: 15)
        $0.numberOfLines = 0
    }
    let itemPrice = UILabel().then{
        $0.text = "000,000"
        $0.font = UIFont.monteserrat(size: 12)
    }
    let won = UILabel().then{
        $0.text = "원"
        $0.font = UIFont.nanumSquare(size: 12)
    }
    let cartButton = UIButton().then{
        $0.cartButton(.white)
    }
    
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setUpView()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        contentView.addSubview(itemImage)
        contentView.addSubview(itemName)
        contentView.addSubview(itemPrice)
        contentView.addSubview(won)
        contentView.addSubview(cartButton)
    }
    func setUpConstraint() {
        itemImage.snp.makeConstraints { make in
            make.width.height.equalTo(180)
            make.leading.top.trailing.equalToSuperview()
        }
        itemName.snp.makeConstraints { make in
            make.top.equalTo(itemImage.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().offset(10)
        }
        itemPrice.snp.makeConstraints { make in
            make.top.equalTo(itemName.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        won.snp.makeConstraints { make in
            make.centerY.equalTo(itemPrice)
            make.leading.equalTo(itemPrice.snp.trailing).offset(2)
        }
        cartButton.snp.makeConstraints { make in
            make.width.height.equalTo(41)
            make.bottom.trailing.equalTo(itemImage).inset(10)
        }
    }
    
    func setUpData(_ data: WishListModel) {
        if let image = data.itemImage {
            self.itemImage.kf.setImage(with: URL(string: image), placeholder: UIImage())
        }
        if let name = data.itemName {self.itemName.text = name}
        if let price = data.itemPrice {self.itemPrice.text = String(price)}
        if let isCart = data.isCart {
            if isCart {self.cartButton.cartButton(UIColor(named: "WishBoardColor")!)}
            else {self.cartButton.cartButton(.white)}
        }
    }
}
