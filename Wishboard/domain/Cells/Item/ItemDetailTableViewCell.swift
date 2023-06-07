//
//  ItemDetailTableViewCell.swift
//  Wishboard
//
//  Created by gomin on 2022/09/08.
//

import UIKit
import Kingfisher

class ItemDetailTableViewCell: UITableViewCell {
    // MARK: - Properties
    let itemImage = UIImageView().then{
        $0.backgroundColor = .black_5
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 32
        $0.contentMode = .scaleAspectFill
    }
    var setFolderButton = UIButton().then{
        $0.setFolderButton("폴더를 지정해 보세요! > ")
    }
    let dateLabel = UILabel().then{
        $0.font = UIFont.Suit(size: 12, family: .Regular)
        $0.textColor = .gray
    }
    let itemNameLabel = UILabel().then{
        $0.font = UIFont.Suit(size: 16, family: .Regular)
        $0.numberOfLines = 0
        $0.setTextWithLineHeight()
    }
    let priceLabel = UILabel().then{
        $0.text = Item.zero
        $0.font = UIFont.monteserrat(size: 18, family: .Bold)
    }
    let won = UILabel().then{
        $0.text = Item.won
        $0.font = UIFont.Suit(size: 14, family: .Regular)
    }
    let stack = UIStackView().then{
        $0.axis = .vertical
        $0.spacing = 16
    }
    let seperatorLine1 = UIView().then{
        $0.backgroundColor = .wishboardDisabledGray
    }
    let linkLabel = UILabel().then{
        $0.textColor = .gray_200
        $0.font = UIFont.Suit(size: 12, family: .Regular)
        $0.setTextWithLineHeight()
    }
    let seperatorLine2 = UIView().then{
        $0.backgroundColor = .wishboardDisabledGray
    }
    let memoTitlelabel = UILabel().then{
        $0.font = UIFont.Suit(size: 12, family: .Bold)
    }
    let memoContentLabel = UILabel().then{
        $0.font = UIFont.Suit(size: 12, family: .Regular)
        $0.numberOfLines = 0
        $0.setTextWithLineHeight()
    }
    // 재입고 초록색
    let restockLabel = PaddingLabel().then{
        $0.textColor = .gray_700
        $0.font = UIFont.Suit(size: 12, family: .Bold)
        $0.backgroundColor = .green_500
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
    }
    let restockDateLabel = PaddingLabel().then{
        $0.textColor = .gray_700
        $0.font = UIFont.Suit(size: 12, family: .Bold)
        $0.backgroundColor = .green_500
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
        contentView.addSubview(stack)
        
        stack.addArrangedSubview(seperatorLine1)
        stack.addArrangedSubview(linkLabel)
        stack.addArrangedSubview(seperatorLine2)
        stack.addArrangedSubview(memoTitlelabel)
        stack.addArrangedSubview(memoContentLabel)
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
            make.height.equalTo(0.5)
        }
        stack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(priceLabel.snp.bottom).offset(16)
            if UIDevice.current.hasNotch {make.bottom.equalToSuperview().offset(-78)}
            else {make.bottom.equalToSuperview().offset(-44)}
        }
        seperatorLine2.snp.makeConstraints { make in
            make.height.equalTo(0.5)
        }
    }
    // After API success
    func setUpData(_ data: WishListModel) {
        if let url = data.item_img_url {
            let processor = TintImageProcessor(tint: .black_5)
            self.itemImage.kf.setImage(with: URL(string: url), placeholder: UIImage(), options: [.processor(processor), .transition(.fade(0.5))])
        }
        if let notificationType = data.item_notification_type {
            if let notificationDate = data.item_notification_date {
                self.restockLabel.isHidden = false
                self.restockDateLabel.isHidden = false
                let notiDateStr = FormatManager().showNotificationDateInItemDetail(notificationDate)
//                let notiDateStr = FormatManager().notiDateToKoreanStr(notificationDate)
                self.restockLabel.text = notificationType
                self.restockDateLabel.text = notiDateStr
            }
        } else {
            self.restockLabel.isHidden = true
            self.restockDateLabel.isHidden = true
        }
        if let folderName = data.folder_name.nilIfEmpty {
            self.setFolderButton.setFolderButton(folderName)
        }
        
        if let createdDate = data.create_at {
            if let dateStr = FormatManager().createdDateToKoreanStr(createdDate) {
                self.dateLabel.text = dateStr
            }
        }
        if let itemName = data.item_name {self.itemNameLabel.text = itemName}
        if let itemPrice = data.item_price {self.priceLabel.text = FormatManager().strToPrice(numStr: itemPrice)}
        if let link = data.item_url.nilIfEmpty {
            // link 도메인만 보이게
            var url = URL(string: link)
            var domain = url?.host
            
            self.linkLabel.isHidden = false
            self.seperatorLine1.isHidden = false
            self.linkLabel.text = domain
        } else {
            self.linkLabel.isHidden = true
            self.seperatorLine1.isHidden = true
        }
        if let memo = data.item_memo.nilIfEmpty {
            self.seperatorLine2.isHidden = false
            self.memoTitlelabel.isHidden = false
            self.memoContentLabel.isHidden = false
            self.memoContentLabel.text = memo
        } else {
            self.seperatorLine2.isHidden = true
            self.memoTitlelabel.isHidden = true
            self.memoContentLabel.isHidden = true
        }
    }
}
