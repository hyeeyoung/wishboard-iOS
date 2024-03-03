//
//  NotiTableViewCell.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import UIKit
import Kingfisher

class NotiTableViewCell: UITableViewCell {
    // MARK: - Views
    let itemImage = UIImageView().then{
        $0.backgroundColor = .black_5
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 40
        $0.contentMode = .scaleAspectFill
    }
    let itemName = DefaultLabel().then{
        $0.setTypoStyleWithMultiLine(typoStyle: .SuitD3)
        $0.numberOfLines = 2
    }
    // '재입고 알림'
    let notificationTypeLabel = DefaultLabel().then{
        $0.text = Notification.restock
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitH5)
    }
    let label = DefaultLabel().then{
        $0.text = Notification.notification
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitH5)
    }
    // 읽음 표시
    let viewView = UIView().then{
        $0.backgroundColor = .green_500
        $0.layer.cornerRadius = 4
    }
    let timeLabel = DefaultLabel().then{
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitD3)
        $0.textColor = .gray_200
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
        contentView.addSubview(notificationTypeLabel)
        contentView.addSubview(label)
        contentView.addSubview(viewView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(itemName)
    }
    func setUpConstraint() {
        itemImage.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        notificationTypeLabel.snp.makeConstraints { make in
            make.leading.equalTo(itemImage.snp.trailing).offset(14)
            make.top.equalTo(itemImage)
        }
        label.snp.makeConstraints { make in
            make.leading.equalTo(notificationTypeLabel.snp.trailing)
            make.centerY.equalTo(notificationTypeLabel)
        }
        viewView.snp.makeConstraints { make in
            make.width.height.equalTo(8)
            make.leading.equalTo(label.snp.trailing).offset(5)
            make.centerY.equalTo(notificationTypeLabel)
        }
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.leading.equalTo(notificationTypeLabel.snp.leading)
        }
        itemName.snp.makeConstraints { make in
            make.top.equalTo(notificationTypeLabel.snp.bottom).offset(6)
            make.leading.equalTo(notificationTypeLabel.snp.leading)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
extension NotiTableViewCell {
    // MARK: 알람탭 페이지 조회 API 호출 후
    func setUpData(_ data: NotificationModel) {
        if let image = data.item_img_url {
            let processor = TintImageProcessor(tint: .black_5)
            self.itemImage.kf.setImage(with: URL(string: image), placeholder: UIImage(), options: [.processor(processor), .transition(.fade(0.5))])
        }
        if let notiType = data.item_notification_type {self.notificationTypeLabel.text = notiType}
        if let name = data.item_name {self.itemName.text = name}
        if let time = data.item_notification_date {
            if let dateStr = FormatManager().createdDateToKoreanStr(time) {
                self.timeLabel.text = dateStr
            }
        }
        if let isViewed = data.read_state {
            self.viewView.isHidden = isViewed == 1 ? true : false
        }
    }
}
