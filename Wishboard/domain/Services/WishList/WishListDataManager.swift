//
//  WishListDataManager.swift
//  Wishboard
//
//  Created by gomin on 2022/09/27.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

class WishListDataManager {
    static let shared = WishListDataManager()
    
    private init() { }
    
    // MARK: 홈화면 위시리스트 조회
    func getWishListDataManager() -> Observable<Any>  {
        let url = Storage().BaseURL + "/item"
        let request = AlamofireBaseService.shared.requestWithParameter(url, .get, nil)
        
        return Observable.create { observer in
            AlamofireBaseService.shared.responseWithErrorException(request, [WishListModel].self) { result in
                if let response = result as? [WishListModel] {
                    // 응답 성공 시 데이터를 onNext로 전달
                    observer.onNext(response)
                    observer.onCompleted()
                } else if let errorCode = result as? Int {
                    // 실패 시 에러코드를 전달
                    observer.onNext(errorCode)
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
}
