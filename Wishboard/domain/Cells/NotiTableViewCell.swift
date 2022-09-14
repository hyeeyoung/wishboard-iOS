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
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 40
    }
    let itemName = UILabel().then{
        $0.text = "itemName"
        $0.font = UIFont.Suit(size: 14, family: .Regular)
        $0.numberOfLines = 2
    }
    // '재입고 알림'
    let label = UILabel().then{
        $0.text = "재입고 알림"
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
        label.snp.makeConstraints { make in
            make.leading.equalTo(itemImage.snp.trailing).offset(14)
            make.top.equalTo(itemImage)
        }
        viewView.snp.makeConstraints { make in
            make.width.height.equalTo(8)
            make.leading.equalTo(label.snp.trailing).offset(5)
            make.centerY.equalTo(label)
        }
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.leading.equalTo(label.snp.leading)
        }
        itemName.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.leading.equalTo(label.snp.leading)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
extension NotiTableViewCell {
    func setUpData(_ data: NotiData) {
        if let image = data.itemImage {
            self.itemImage.kf.setImage(with: URL(string: image), placeholder: UIImage())
        }
        if let name = data.itemName {self.itemName.text = name}
        if let time = data.time {self.timeLabel.text = time}
        if let isViewed = data.isViewed {
            self.viewView.isHidden = isViewed ? true : false
        }
    }
    func setCalenderNotiCell() {
        let grayView = UIView().then{
            $0.backgroundColor = .systemGray6
            $0.layer.cornerRadius = 24
        }
        contentView.insertSubview(grayView, at: 0)
        grayView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-3)
            make.top.equalToSuperview().offset(3)
        }
    }
}
