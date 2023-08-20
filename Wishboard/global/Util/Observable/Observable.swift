//
//  Observable.swift
//  Wishboard
//
//  Created by gomin on 2022/09/06.
//

import Foundation

final class Observable<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}


protocol Observer {
    func update(_ newValue: Any)
}

class UserObserver {
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
