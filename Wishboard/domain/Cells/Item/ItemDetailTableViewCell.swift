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
        $0.backgroundColor = .systemGray6
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 32
    }
    var setFolderButton = UIButton().then{
        $0.setFolderButton("폴더 지정하기 >")
    }
    let dateLabel = UILabel().then{
        $0.text = "0주 전"
        $0.font = UIFont.Suit(size: 13, family: .Regular)
        $0.textColor = .gray
    }
    let itemNameLabel = UILabel().then{
        $0.text = "itemName"
        $0.font = UIFont.Suit(size: 18, family: .Regular)
        $0.numberOfLines = 0
    }
    let priceLabel = UILabel().then{
        $0.text = "0"
        $0.font = UIFont.monteserrat(size: 18, family: .Bold)
    }
    let won = UILabel().then{
        $0.text = "원"
        $0.font = UIFont.Suit(size: 14, family: .Regular)
    }
    let seperatorLine1 = UIView().then{
        $0.backgroundColor = .separator
    }
    let linkLabel = UILabel().then{
        $0.text = "w.musinsa.com"
        $0.textColor = .wishboardGray
        $0.font = UIFont.Suit(size: 12, family: .Regular)
    }
    let seperatorLine2 = UIView().then{
        $0.backgroundColor = .separator
    }
    let label = UILabel().then{
        $0.text = "메모"
        $0.font = UIFont.Suit(size: 12, family: .Bold)
    }
    let memoLabel = UILabel().then{
        $0.text = "memo"
        $0.font = UIFont.Suit(size: 12, family: .Regular)
        $0.numberOfLines = 0
    }
    // 재입고 초록색
    let restockLabel = PaddingLabel().then{
        $0.text = "재입고"
        $0.textColor = .black
        $0.font = UIFont.Suit(size: 12, family: .Bold)
        $0.backgroundColor = .wishboardGreen
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
    }
    let restockDateLabel = PaddingLabel().then{
        $0.text = "21년 4월 26일"
        $0.textColor = .black
        $0.font = UIFont.Suit(size: 12, family: .Bold)
        $0.backgroundColor = .wishboardGreen
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
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
        itemImage.addSubview(restockLabel)
        itemImage.addSubview(restockDateLabel)
        contentView.addSubview(setFolderButton)
        contentView.addSubview(dateLabel)
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(won)
        contentView.addSubview(seperatorLine1)
        contentView.addSubview(linkLabel)
        contentView.addSubview(seperatorLine2)
        contentView.addSubview(label)
        contentView.addSubview(memoLabel)
    }
    func setUpConstraint() {
        itemImage.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(468)
            make.top.equalToSuperview()
        }
        restockLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(16)
        }
        restockDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(restockLabel)
            make.leading.equalTo(restockLabel.snp.trailing).offset(9)
        }
        setFolderButton.snp.makeConstraints { make in
            make.leading.equalTo(itemImage)
            make.top.equalTo(itemImage.snp.bottom).offset(20)
        }
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(itemImage.snp.trailing)
            make.centerY.equalTo(setFolderButton)
        }
        itemNameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(itemImage)
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
        seperatorLine1.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(priceLabel.snp.bottom).offset(20)
        }
        linkLabel.snp.makeConstraints { make in
            make.leading.equalTo(priceLabel)
            make.top.equalTo(seperatorLine1.snp.bottom).offset(16)
        }
        seperatorLine2.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(linkLabel.snp.bottom).offset(16)
        }
        label.snp.makeConstraints { make in
            make.leading.equalTo(priceLabel.snp.leading)
            make.top.equalTo(seperatorLine2.snp.bottom).offset(16)
        }
        memoLabel.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.leading)
            make.top.equalTo(label.snp.bottom).offset(10)
            if CheckNotch().hasNotch() {make.bottom.equalToSuperview().offset(-78)}
            else {make.bottom.equalToSuperview().offset(-44)}
        }
    }
    // After API success
    func setUpData(_ data: WishListModel) {
        if let url = data.item_img_url {
            self.itemImage.kf.setImage(with: URL(string: url), placeholder: UIImage())
        }
        if let notificationType = data.item_notification_type {
            if let notificationDate = data.item_notification_date {
                let notiDateStr = FormatManager().notiDateToKoreanStr(notificationDate)
                self.restockLabel.text = notificationType
                self.restockDateLabel.text = notiDateStr
            }
        } else {
            self.restockLabel.isHidden = true
            self.restockDateLabel.isHidden = true
        }
        if let folderName = data.folder_name {self.setFolderButton.setFolderButton(folderName)}
        if let createdDate = data.create_at {
            if let dateStr = FormatManager().createdDateToKoreanStr(createdDate) {
                self.dateLabel.text = dateStr
            }
        }
        if let itemName = data.item_name {self.itemNameLabel.text = itemName}
        if let itemPrice = data.item_price {self.priceLabel.text = FormatManager().strToPrice(numStr: itemPrice)}
        if let link = data.item_url {self.linkLabel.text = link}
        if let memo = data.item_memo {self.memoLabel.text = memo}
    }
}
