//
//  CartTableViewCell.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit
import Kingfisher

class CartTableViewCell: UITableViewCell {
    lazy var itemImage = UIImageView().then{
        $0.backgroundColor = .black_5
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.isUserInteractionEnabled = true
        $0.contentMode = .scaleAspectFill
    }
    let itemName = UILabel().then{
        $0.text = "itemName"
        $0.font = UIFont.Suit(size: 12.5, family: .Regular)
        $0.numberOfLines = 2
        $0.isUserInteractionEnabled = true
    }
    let deleteButton = UIButton().then{
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "x")
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        $0.configuration = config
    }
    let minusButton = UIButton().then{
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "ic_cart_minus")
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        $0.configuration = config
    }
    let plusButton = UIButton().then{
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "ic_cart_plus")
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        $0.configuration = config
    }
    let countLabel = UILabel().then{
        $0.text = "1"
        $0.textAlignment = .center
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
        contentView.addSubview(minusButton)
        contentView.addSubview(plusButton)
        contentView.addSubview(countLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(won)
        contentView.addSubview(itemName)
    }
    func setUpConstraint() {
        itemImage.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        deleteButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.top.equalTo(itemImage.snp.top).offset(-10)
            make.trailing.equalToSuperview().offset(-9)
        }
        minusButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.bottom.equalTo(itemImage.snp.bottom).offset(10)
            make.leading.equalTo(itemImage.snp.trailing)
        }
        countLabel.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.centerY.equalTo(minusButton)
            make.leading.equalTo(minusButton.snp.trailing)
        }
        plusButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.centerY.equalTo(countLabel)
            make.leading.equalTo(countLabel.snp.trailing)
        }
        won.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalTo(plusButton)
        }
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(won.snp.leading).offset(-2)
            make.centerY.equalTo(won)
        }
        itemName.snp.makeConstraints { make in
            make.top.equalTo(itemImage.snp.top).offset(5)
            make.leading.equalTo(itemImage.snp.trailing).offset(10)
            make.trailing.equalTo(deleteButton.snp.leading)
//            make.bottom.lessThanOrEqualTo(minusButton.snp.top).offset(-10)
        }
    }
}
extension CartTableViewCell {
    func setUpData(_ data: CartListModel) {
        if let image = data.wishItem?.item_img {
            let processor = TintImageProcessor(tint: .black_5)
            self.itemImage.kf.setImage(with: URL(string: image), placeholder: UIImage(), options: [.processor(processor), .transition(.fade(0.5))])
        }
        if let name = data.wishItem?.item_name {self.itemName.text = name}
        guard let count = data.cartItemInfo?.item_count else {return}
        guard let price = data.wishItem?.item_price else {return}
        
        self.countLabel.text = String(count)
        self.priceLabel.text = FormatManager().strToPrice(numStr: String(count * Int(price)!))
        
    }
}
