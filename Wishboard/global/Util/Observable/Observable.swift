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

// MARK: - 유저 관련 Observer Pattern
protocol Observer {
    func update(_ newValue: Any)
}

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

/// 아이템 정보를 파싱해 불러올 때의 Observer
/// 아이템 정보를 불러오지 않고 그냥 페이지를 나가는 exit 의 경우
/// 아이템 파싱에 실패한 fail 의 경우
/// 아이템 파싱에 성공한 경우
/// 위 세 가지 경우 다 페이지가 닫힘과 동시에 이전 화면에 영향을 준다.
final class ItemLinkObserver {
    static let shared = ItemLinkObserver()
    private var observers: [Observer] = [Observer]()
    
    private init() {}
    
    // 옵저버 등록
    func bind(_ observer: Observer) {
        observers.append(observer)
    }
    
    // 옵저버 알림
    func notify(_ data: ItemParseData?) {
        for observer in observers {
            observer.update(data)
        }
    }
}
/// ShoppingLink 뷰컨에서 이전 페이지로 넘기는 데이터
/// 아이템 모델과 유스케이스
struct ItemParseData {
    let itemModel: ItemParseModel?
    let usecase: ObserverUseCase
}

struct ItemParseModel {
    let link: String
    let imageURL: String?
    let itemName: String?
    let itemPrice: String?
}
