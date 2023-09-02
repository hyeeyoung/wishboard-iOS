//
//  WishListObserver.swift
//  Wishboard
//
//  Created by gomin on 2023/09/02.
//

import Foundation

enum WishListUseCase {
    case upload
    case delete
}

final class WishListObserver {
    static let shared = WishListObserver()
    private var observers: [Observer] = [Observer]()
    
    private init() {}
    
    // 옵저버 등록
    func bind(_ observer: Observer) {
        observers.append(observer)
        // TODO: 중복 제거
    }
    
    // 옵저버 알림
    func notify(_ usecase: WishListUseCase) {
        for observer in observers {
            observer.update(usecase)
        }
    }
}
