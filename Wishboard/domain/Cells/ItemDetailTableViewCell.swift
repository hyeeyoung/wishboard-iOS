//
//  ItemDetailTableViewCell.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit

class ItemDetailTableViewCell: UITableViewCell {
    // MARK: - Properties
    let itemImage = UIImageView().then{
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 32
    }
    let setFolderButton = UIButton().then{
        var config = UIButton.Configuration.plain()
        var attText = AttributedString.init("폴더 지정하기 >")
        
        attText.font = .systemFont(ofSize: 13)
        attText.foregroundColor = UIColor.lightGray
        config.attributedTitle = attText
        
        $0.configuration = config
    }
    let dateLabel = UILabel().then{
        $0.text = "0주 전"
        $0.font = UIFont.Suit(size: 13, family: .Regular)
        $0.textColor = .lightGray
    }
    let itemNameLabel = UILabel().then{
        $0.text = "itemName"
        $0.font = UIFont.Suit(size: 18, family: .Regular)
    }
    let priceLabel = UILabel().then{
        $0.text = "0000"
        $0.font = UIFont.monteserrat(size: 16)
    }
    let won = UILabel().then{
        $0.text = "원"
        $0.font = UIFont.nanumSquare(size: 16)
    }
    let seperatorLine = UIView().then{
        $0.backgroundColor = .separator
    }
    let label = UILabel().then{
        $0.text = "메모"
        $0.font = UIFont.Suit(size: 12, family: .Bold)
    }
    let memoLabel = UILabel().then{
        $0.text = "memo"
        $0.font = UIFont.Suit(size: 12, family: .Regular)
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
        contentView.addSubview(setFolderButton)
        contentView.addSubview(dateLabel)
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(won)
        contentView.addSubview(seperatorLine)
        contentView.addSubview(label)
        contentView.addSubview(memoLabel)
    }
    func setUpConstraint() {
        itemImage.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(468)
            make.top.equalToSuperview()
        }
        setFolderButton.snp.makeConstraints { make in
            make.leading.equalTo(itemImage.snp.leading)
            make.top.equalTo(itemImage.snp.bottom).offset(20)
        }
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(itemImage.snp.trailing)
            make.top.equalTo(itemImage.snp.bottom).offset(20)
        }
        itemNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(itemImage.snp.leading)
            make.top.equalTo(setFolderButton.snp.bottom).offset(10)
        }
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(itemImage.snp.leading)
            make.top.equalTo(itemNameLabel.snp.bottom).offset(24)
        }
        won.snp.makeConstraints { make in
            make.leading.equalTo(priceLabel.snp.trailing)
            make.centerY.equalTo(priceLabel)
        }
        seperatorLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(priceLabel.snp.bottom).offset(20)
        }
        label.snp.makeConstraints { make in
            make.leading.equalTo(priceLabel.snp.leading)
            make.top.equalTo(seperatorLine.snp.bottom).offset(16)
        }
        memoLabel.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.leading)
            make.top.equalTo(label.snp.bottom).offset(10)
        }
    }
}
