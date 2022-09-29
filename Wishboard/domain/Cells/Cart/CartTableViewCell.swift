//
//  CartTableViewCell.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    let itemImage = UIImageView().then{
        $0.backgroundColor = .systemGray6
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    let itemName = UILabel().then{
        $0.text = "itemName"
        $0.font = UIFont.Suit(size: 12.5, family: .Regular)
        $0.numberOfLines = 0
    }
    let deleteButton = UIButton().then{
        $0.setImage(UIImage(named: "x"), for: .normal)
    }
    let minusButton = UIButton().then{
        $0.setImage(UIImage(named: "ic_cart_minus"), for: .normal)
    }
    let plusButton = UIButton().then{
        $0.setImage(UIImage(named: "ic_cart_plus"), for: .normal)
    }
    let countLabel = UILabel().then{
        $0.text = "1"
        $0.font = UIFont.Suit(size: 14.58, family: .Regular)
    }
    let priceLabel = UILabel().then{
        $0.text = "1111"
        $0.font = UIFont.monteserrat(size: 18.75, family: .Bold)
    }
    let won = UILabel().then{
        $0.text = "원"
        $0.font = UIFont.Suit(size: 14.58, family: .Regular)
    }
    //MARK: - Life Cycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpView()
        setUpConstraint()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Functions
    func setUpView() {
        contentView.addSubview(itemImage)
        contentView.addSubview(deleteButton)
        contentView.addSubview(itemName)
        contentView.addSubview(minusButton)
        contentView.addSubview(plusButton)
        contentView.addSubview(countLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(won)
    }
    func setUpConstraint() {
        itemImage.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        deleteButton.snp.makeConstraints { make in
            make.width.height.equalTo(15)
            make.top.equalTo(itemImage.snp.top)
            make.trailing.equalToSuperview().offset(-19)
        }
        itemName.snp.makeConstraints { make in
            make.top.equalTo(itemImage.snp.top)
            make.leading.equalTo(itemImage.snp.trailing).offset(10)
            make.trailing.equalTo(deleteButton.snp.leading).offset(-10)
        }
        minusButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.bottom.equalTo(itemImage.snp.bottom)
            make.leading.equalTo(itemImage.snp.trailing).offset(10)
        }
        countLabel.snp.makeConstraints { make in
            make.centerY.equalTo(minusButton)
            make.leading.equalTo(minusButton.snp.trailing).offset(10)
        }
        plusButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalTo(countLabel)
            make.leading.equalTo(countLabel.snp.trailing).offset(10)
        }
        won.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalTo(plusButton)
        }
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(won.snp.leading).offset(-2)
            make.centerY.equalTo(won)
        }
    }
}
extension CartTableViewCell {
    func setUpData(_ data: CartListModel) {
        if let image = data.wishItem?.item_img {
            self.itemImage.kf.setImage(with: URL(string: image), placeholder: UIImage())
        }
        if let name = data.wishItem?.item_name {self.itemName.text = name}
        guard let count = data.cartItemInfo?.item_count else {return}
        guard let price = data.wishItem?.item_price else {return}
        
        self.countLabel.text = String(count)
        self.priceLabel.text = FormatManager().strToPrice(numStr: String(count * Int(price)!))
        
    }
}
