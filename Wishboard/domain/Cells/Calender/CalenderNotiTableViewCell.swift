//
//  CalenderNotiTableViewCell.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import UIKit
import Kingfisher

class CalenderNotiTableViewCell: UITableViewCell {
    // MARK: - Views
    // 뒷배경 뷰 추가
    let grayView = UIView().then{
        $0.backgroundColor = .gray_50
        $0.layer.cornerRadius = 24
    }
    let itemImage = UIImageView().then{
        $0.backgroundColor = .black_5
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 40
        $0.contentMode = .scaleAspectFill
    }
    let itemName = UILabel().then{
        $0.font = UIFont.Suit(size: 12, family: .Regular)
        $0.numberOfLines = 2
    }
    // '재입고 알림'
    let notificationTypeLabel = UILabel().then{
        $0.text = Notification.restock
        $0.font = UIFont.Suit(size: 13, family: .Bold)
    }
    let label = UILabel().then{
        $0.text = Notification.notification
        $0.font = UIFont.Suit(size: 13, family: .Bold)
    }
    let timeLabel = UILabel().then{
        $0.font = UIFont.Suit(size: 12, family: .Regular)
        $0.textColor = .gray
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
        contentView.addSubview(grayView)
        
        grayView.addSubview(itemImage)
        grayView.addSubview(notificationTypeLabel)
        grayView.addSubview(label)
        grayView.addSubview(timeLabel)
        grayView.addSubview(itemName)
    }
    func setUpConstraint() {
        grayView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-3)
            make.top.equalToSuperview().offset(3)
            make.height.equalTo(104)
        }
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
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.leading.equalTo(notificationTypeLabel.snp.leading)
        }
        itemName.snp.makeConstraints { make in
            make.top.equalTo(notificationTypeLabel.snp.bottom).offset(8)
            make.leading.equalTo(notificationTypeLabel.snp.leading)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
extension CalenderNotiTableViewCell {
    // MARK: 캘린더 알림 조회 API 호출 후
    func setCalenderNotiCell(_ data: NotificationModel) {
        if let image = data.item_img_url {
            let processor = TintImageProcessor(tint: .black_5)
            self.itemImage.kf.setImage(with: URL(string: image), placeholder: UIImage(), options: [.processor(processor), .transition(.fade(0.5))])
        }
        if let notiType = data.item_notification_type {self.notificationTypeLabel.text = notiType}
        if let name = data.item_name {self.itemName.text = name}
        
        // 알람 시간 파싱 ('오전 0시 0분')
        let dateStr = data.item_notification_date
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "a h시 mm분" // 2020년 08월 13일 오후 04시 30분
        myDateFormatter.locale = Locale(identifier:"ko_KR")
        let notificationTimeStr = myDateFormatter.string(from: (dateStr?.toCreatedDate()!)!)
        
        // 00분인지, 30분인지 구분
        let minute = notificationTimeStr[notificationTimeStr.index(notificationTimeStr.endIndex, offsetBy: -3)]
        var notificationTime = notificationTimeStr
        if minute != "3" {notificationTime = String(notificationTimeStr.dropLast(3))}
        self.timeLabel.text = notificationTime
    }
}
