//
//  UploadItemBottomSheetTableViewCell.swift
//  Wishboard
//
//  Created by gomin on 2022/10/21.
//

import UIKit

class UploadItemBottomSheetTableViewCell: UITableViewCell {
    let subTitle = UILabel().then{
        $0.text = Message.shoppingLink
        $0.setTypoStyleWithSingleLine(typoStyle: .SuitD3)
        $0.textColor = .green_700
        $0.isHidden = true
    }
    //MARK: - Life Cycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        subTitle.isHidden = true
        
        self.textLabel?.snp.makeConstraints({ make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-47)
        })
        self.textLabel?.then{
            $0.textAlignment = .left
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        subTitle.isHidden = true
    }
    
    func setBottomSheetCell(isUploadItem: Bool, tag: Int) {
        let arrowImg = UIImageView().then{
            $0.image = Image.arrowRight
        }
        self.contentView.addSubview(arrowImg)
        arrowImg.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        self.textLabel?.setTypoStyleWithSingleLine(typoStyle: .SuitB3)
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
        switch tag {
        case 2:
            // 만약 폴더를 재선택했다면 업데이트
            if let folder = data.folder_name.nilIfEmpty {self.textLabel?.text = folder}
            else {self.textLabel?.text = Title.folder}
        case 3:
            // 만약 알림 날짜를 재설정했다면 업데이트
            if let notiType = data.item_notification_type {
                if let notiDate = data.item_notification_date {
                    guard let notiDateStr = FormatManager().notiDateToKoreanStr(notiDate) else {return}
                    self.textLabel?.text = "[" + notiType + "] " + notiDateStr
                }
            }
            else {self.textLabel?.text = Title.notificationItem}
            
        case 4:
            // 만약 쇼핑몰 링크를 수정했다면 업데이트
            if let link = data.item_url.nilIfEmpty {
                self.textLabel?.text = link
                subTitle.isHidden = true
            } else {
                self.textLabel?.text = Title.shoppingMallLink
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
            self.textLabel?.text = Title.folder
        case 3:
            self.textLabel?.text = Title.notificationItem
        case 4:
            self.textLabel?.text = Title.shoppingMallLink
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
            if let folder = data.folder_name.nilIfEmpty {self.textLabel?.text = folder}
            else {self.textLabel?.text = Title.folder}
        case 3:
            // 만약 알림 날짜를 재설정했다면 업데이트
            if let notiType = data.item_notification_type {
                if let notiDate = data.item_notification_date {
                    self.textLabel?.text = "[" + notiType + "] " + notiDate
                }
            }
            else {self.textLabel?.text = Title.notificationItem}
            
        case 4:
            // 만약 쇼핑몰 링크를 수정했다면 업데이트
            if let link = data.item_url.nilIfEmpty {
                self.textLabel?.text = link
                subTitle.isHidden = true
            } else {
                self.textLabel?.text = Title.shoppingMallLink
                subTitle.isHidden = false
            }
        default:
            fatalError()
        }
    }
}
