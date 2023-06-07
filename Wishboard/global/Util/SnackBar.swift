//
//  SnackBar.swift
//  Wishboard
//
//  Created by gomin on 2022/09/23.
//

import Foundation
import UIKit

class SnackBar {
    // MARK: - Views
    let backgroundView = UIView().then{
        $0.backgroundColor = .gray_700
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
    }
    var title = UILabel().then{
        $0.textColor = .white
        $0.font = UIFont.Suit(size: 14, family: .Regular)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    // MARK: - Life Cycles
    var titleMessage: String!
    init(_ originView: UIViewController, message: SnackBarMessage) {
        title.text = message.rawValue
        backgroundView.addSubview(title)
        
        // 만약 하단바가 존재할 때
        if (originView.tabBarController?.tabBar.isHidden == false) {
            print("만약 하단바가 존재할 때")
            originView.tabBarController?.tabBar.addSubview(backgroundView)
        } else {
            print("만약 하단바가 존재하지 않을 때")
            originView.view.addSubview(backgroundView)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(47)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(47)
        }
        title.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        // MARK: Animation
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.backgroundView.transform = CGAffineTransform(translationX: 0, y: -81)
            } completion: { finished in
                UIView.animate(withDuration: 0.5, delay: 2.5) {
                    self.backgroundView.transform = .identity
                } completion: { finish in
                    if (originView.extensionContext != nil) && (message == .addItem) {
                        originView.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
                    }
                }
            }
        }
    }
}

// MARK: - Enum
extension SnackBar {
    enum SnackBarMessage: String {
        case login = "아이디 또는 비밀번호를 다시 확인해 주세요."
        case networkCheck = "네트워크 연결 상태를 확인해 주세요."
        case addFolder = "폴더를 추가했어요!😉"
        case modifyFolder = "폴더명을 수정했어요!📁"
        case deleteFolder = "폴더를 삭제했어요!🗑"
        case deleteCartItem = "장바구니에서 아이템을 삭제했어요! 🗑"
        case addItem = "아이템을 위시리스트에 추가했어요!👜"
        case modifyItem = "아이템을 수정했어요!✍️️"
        case deleteItem = "아이템을 위시리스트에서 삭제했어요!🗑"
        case modifyProfile = "프로필이 수정되었어요!👩‍🎤"
        case modifyPassword = "비밀번호가 변경되었어요!👩‍🎤"
        case deleteUser = "탈퇴 완료되었어요. 이용해주셔서 감사합니다!☺️"
        case ShoppingLink = "쇼핑몰 링크를 등록해 주세요!🛍️️"
        case failShoppingLink = "앗, 아이템 정보를 불러오지 못했어요🥲"
        case emptyItemContent = "앗, 상품명과 가격을 입력해 주세요😁"
        case errorMessage = "예상하지 못한 오류가 발생했어요!\n잠시후 다시 시도해주세요."
    }
}
class ErrorBar {
    // MARK: - Views
    let backgroundView = UIView().then{
        $0.backgroundColor = .gray_700
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
    }
    var title = UILabel().then{
        $0.textColor = .white
        $0.font = UIFont.Suit(size: 14, family: .Regular)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    // MARK: - Life Cycles
    // Error SnackBar (두 줄)
    init(_ originView: UIViewController) {
        title.text = ErrorMessage.fiveHundredError
        title.setTextWithLineHeight()
        title.textAlignment = .center
        
        backgroundView.layer.cornerRadius = 35
        backgroundView.addSubview(title)
        
        // 만약 하단바가 존재할 때
        if (originView.tabBarController?.tabBar.isHidden == false) {
            originView.tabBarController?.tabBar.addSubview(backgroundView)
        } else {
            originView.view.addSubview(backgroundView)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(47)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(72)
        }
        title.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        // MARK: Animation
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.backgroundView.transform = CGAffineTransform(translationX: 0, y: -81)
            } completion: { finished in
                UIView.animate(withDuration: 0.5, delay: 2.5) {
                    self.backgroundView.transform = CGAffineTransform(translationX: 0, y: 81)
                } completion: { finish in
                    if originView.extensionContext != nil {
                        originView.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
                    }
                }
            }
        }
    }
}
