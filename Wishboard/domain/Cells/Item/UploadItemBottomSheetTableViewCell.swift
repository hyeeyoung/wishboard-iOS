//
//  UploadItemBottomSheetTableViewCell.swift
//  Wishboard
//
//  Created by gomin on 2022/10/21.
//

import UIKit

class UploadItemBottomSheetTableViewCell: UITableViewCell {
    let subTitle = UILabel().then{
        $0.text = "복사한 링크로 아이템 정보를 불러올 수 있어요!"
        $0.font = UIFont.Suit(size: 10, family: .Regular)
        $0.textColor = .wishboardGreen
        $0.setTextWithLineHeight()
    }
    //MARK: - Life Cycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        subTitle.isHidden = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBottomSheetCell(isUploadItem: Bool, tag: Int) {
        let arrowImg = UIImageView().then{
            $0.image = UIImage(named: "arrow_right")
        }
        self.contentView.addSubview(arrowImg)
        arrowImg.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        self.textLabel?.font = UIFont.Suit(size: 14, family: .Regular)
        if tag == 4 {
            subTitle.isHidden = false
            self.contentView.addSubview(subTitle)
            subTitle.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalTo(arrowImg.snp.leading)
            }
        }
    }

    func setUpData(isUploadItem: Bool, tag: Int, data: WishListModel) {
        print("data:", isUploadItem, tag, data)
        switch tag {
        case 2:
            // 만약 폴더를 재선택했다면 업데이트
            if let folder = data.folder_name {self.textLabel?.text = folder}
            else {self.textLabel?.text = "폴더"}
        case 3:
            // 만약 알림 날짜를 재설정했다면 업데이트
            if let notiType = data.item_notification_type {
                if let notiDate = data.item_notification_date {
//                    print("이전 날짜:",notiDate)
//                    print("이후 날짜:", FormatManager().notiDateToKoreanStr(notiDate))
                    guard let notiDateStr = FormatManager().notiDateToKoreanStr(notiDate) else {return}
                    self.textLabel?.text = "[" + notiType + "] " + notiDateStr
                }
            }
            else {self.textLabel?.text = "상품 일정 알림"}
            
        case 4:
            // 만약 쇼핑몰 링크를 수정했다면 업데이트
            if let link = data.item_url {
                if link != "" {
                    self.textLabel?.text = link
                    subTitle.isHidden = true
                } else {
                    self.textLabel?.text = "쇼핑몰 링크"
                    subTitle.isHidden = false
                }
            } else {
                self.textLabel?.text = "쇼핑몰 링크"
                subTitle.isHidden = false
            }
        default:
            fatalError()
        }
    }
    func isUploadingItem(tag: Int, data: WishListModel) {
        // 만약 아이템 추가라면
        switch tag {
        case 2:
            self.textLabel?.text = "폴더"
        case 3:
            self.textLabel?.text = "상품 일정 알림"
        case 4:
            self.textLabel?.text = "쇼핑몰 링크"
            subTitle.isHidden = false
        default:
            fatalError()
        }
    }
    func isModifyingItem(tag: Int, data: WishListModel) {
        // 만약 아이템 수정이라면
        switch tag {
        case 2:
            // 만약 폴더를 재선택했다면 업데이트
            if let folder = data.folder_name {self.textLabel?.text = folder}
            else {self.textLabel?.text = "폴더"}
        case 3:
            // 만약 알림 날짜를 재설정했다면 업데이트
            if let notiType = data.item_notification_type {
                if let notiDate = data.item_notification_date {
                    self.textLabel?.text = "[" + notiType + "] " + notiDate
                }
            }
            else {self.textLabel?.text = "상품 일정 알림"}
            
        case 4:
            // 만약 쇼핑몰 링크를 수정했다면 업데이트
            if let link = data.item_url {
                if link != "" {
                    self.textLabel?.text = link
                    subTitle.isHidden = true
                } else {
                    self.textLabel?.text = "쇼핑몰 링크"
                    subTitle.isHidden = false
                }
            } else {
                self.textLabel?.text = "쇼핑몰 링크"
                subTitle.isHidden = false
            }
        default:
            fatalError()
        }
    }
}
