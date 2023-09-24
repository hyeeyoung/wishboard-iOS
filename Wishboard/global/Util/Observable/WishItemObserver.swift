//
//  WishListObserver.swift
//  Wishboard
//
//  Created by gomin on 2023/09/02.
//

import Foundation

enum WishItemUseCase {
    case upload
    case delete
    case modify
    case cartItemDelete
}

final class WishItemObserver {
    static let shared = WishItemObserver()
    private var observers: [Observer] = [Observer]()
    
    private init() {}
    
    // 옵저버 등록
    func bind(_ observer: Observer) {
        observers.append(observer)
        // TODO: 중복 제거
    }
    
    // 옵저버 알림
    func notify(_ usecase: WishItemUseCase) {
        for observer in observers {
            observer.update(usecase)
        }
    }
}
