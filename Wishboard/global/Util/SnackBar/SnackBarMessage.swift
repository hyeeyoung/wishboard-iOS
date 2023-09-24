//
//  SnackBarMessage.swift
//  Wishboard
//
//  Created by gomin on 2023/09/24.
//

import Foundation

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
