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
    let itemName = DefaultLabel().then{
        $0.setTypoStyleWithMultiLine(typoStyle: .SuitD2)
        $0.numberOfLines = 2
        $0.isUserInteractionEnabled = true
    }
    let deleteButton = UIButton().then{
        var config = UIButton.Configuration.plain()
        config.image = Image.quit
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        $0.configuration = config
    }
    let cartCountStack = UIStackView().then {
        $0.axis = .horizontal
    }
    let minusButton = UIButton().then{
        var config = UIButton.Configuration.plain()
        config.image = Image.cartMinus
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        $0.configuration = config
    }
    let plusButton = UIButton().then{
        var config = UIButton.Configuration.plain()
        config.image = Image.cartPlus
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        $0.configuration = config
    }
    let countLabel = DefaultLabel().then{
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitD2)
        $0.textAlignment = .center
    }
    let priceLabel = DefaultLabel().then{
        $0.setTypoStyleWithSingleLine(typoStyle: .MontserratH2)
    }
    let won = DefaultLabel().then{
        $0.text = Item.won
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitD2)
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
        
        contentView.addSubview(cartCountStack)
        cartCountStack.addArrangedSubview(minusButton)
        cartCountStack.addArrangedSubview(countLabel)
        cartCountStack.addArrangedSubview(plusButton)
        
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
            make.top.equalToSuperview().offset(6)
            make.trailing.equalToSuperview().offset(-2)
        }
        cartCountStack.snp.makeConstraints { make in
            make.leading.equalTo(itemImage.snp.trailing)
            make.bottom.equalTo(itemImage.snp.bottom).offset(10)
        }
        minusButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
        }
        countLabel.snp.makeConstraints { make in
            make.width.equalTo(20)
        }
        plusButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
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
            make.top.equalTo(itemImage.snp.top)
            make.leading.equalTo(itemImage.snp.trailing).offset(10)
            make.trailing.equalTo(deleteButton.snp.leading)
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
