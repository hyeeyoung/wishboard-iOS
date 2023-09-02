//
//  UserObserver.swift
//  Wishboard
//
//  Created by gomin on 2023/09/02.
//

import Foundation

final class UserObserver {
    static let shared = UserObserver()
    private var observers: [Observer] = [Observer]()
    
    private init() {}
    
    // 옵저버 등록
    func bind(_ observer: Observer) {
        observers.append(observer)
    }
    
    // 옵저버 알림
    func notify(_ usecase: ObserverUseCase?) {
        for observer in observers {
            observer.update(usecase)
        }
    }
}
