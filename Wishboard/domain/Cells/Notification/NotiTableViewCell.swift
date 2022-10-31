//
//  NotiTableViewCell.swift
//  Wishboard
//
//  Created by gomin on 2022/09/09.
//

import UIKit

class NotiTableViewCell: UITableViewCell {
    // MARK: - Views
    let itemImage = UIImageView().then{
        $0.backgroundColor = .systemGray6
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 40
        $0.contentMode = .scaleAspectFill
    }
    let itemName = UILabel().then{
        $0.text = "itemName"
        $0.font = UIFont.Suit(size: 12, family: .Regular)
        $0.numberOfLines = 2
    }
    // '재입고 알림'
    let notificationTypeLabel = UILabel().then{
        $0.text = "재입고"
        $0.font = UIFont.Suit(size: 13, family: .Bold)
    }
    let label = UILabel().then{
        $0.text = " 알림"
        $0.font = UIFont.Suit(size: 13, family: .Bold)
    }
    // 읽음 표시
    let viewView = UIView().then{
        $0.backgroundColor = .wishboardGreen
        $0.layer.cornerRadius = 4
    }
    let timeLabel = UILabel().then{
        $0.text = ""
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
            make.top.equalTo(notificationTypeLabel.snp.bottom).offset(8)
            make.leading.equalTo(notificationTypeLabel.snp.leading)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
extension NotiTableViewCell {
    // MARK: 알람탭 페이지 조회 API 호출 후
    func setUpData(_ data: NotificationModel) {
        if let image = data.item_img_url {
            self.itemImage.kf.setImage(with: URL(string: image), placeholder: UIImage())
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
    // MARK: 캘린더 알림 조회 API 호출 후
    func setCalenderNotiCell(_ data: NotificationModel) {
        if let image = data.item_img_url {
            self.itemImage.kf.setImage(with: URL(string: image), placeholder: UIImage())
        }
        if let notiType = data.item_notification_type {self.notificationTypeLabel.text = notiType}
        if let name = data.item_name {self.itemName.text = name}
        // 뒷배경 뷰 추가
        let grayView = UIView().then{
            $0.backgroundColor = .notificationBackgroundGray
            $0.layer.cornerRadius = 24
        }
        contentView.insertSubview(grayView, at: 0)
        grayView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-3)
            make.top.equalToSuperview().offset(3)
            make.height.equalTo(104)
        }
        // 초록 동그라미는 보여주지 않는다.
        self.viewView.isHidden = true
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
